/*
 * ============================================================================
 * TEAM 3 MAIN ELEVATOR CONTROLLER IMPLEMENTATION
 * ============================================================================
 * Microcontroller: PIC16F877A
 * Architecture: Non-blocking deterministic Finite State Machine (FSM)
 * Periodic Rate: 10 ms per tick (called from main loop)
 *
 * Adheres strictly to the inter-team contracts defined in:
 *   - Shared/System_Types.h
 *   - Team_1_Motor/Motor.h
 *   - Team_2_Inputs/Inputs.h
 *   - Team_3_Controller/Controller.h
 *   - Team_3_Controller/RequestHandler.h
 * ============================================================================
 */

#include "../../Shared/System_Types.h"
#include "../../Team_1_Motor/Motor.h"
#include "../../Team_2_Inputs/Inputs.h"
#include "../Controller.h"
#include "../RequestHandler.h"

/* ----------------------------------------------------------------------------
 * INTERNAL CONTROLLER STATE VARIABLES
 * ----------------------------------------------------------------------------
 */
static unsigned char controller_state = STATE_WAIT_FOR_FLOOR;
static unsigned char current_floor    = NO_FLOOR;
static unsigned char target_floor     = NO_FLOOR;
static signed char   direction        = DIR_STOP;
static signed char   last_direction   = DIR_STOP;

/* Internal millisecond/tick counters for timing states */
static unsigned int state_ticks       = 0;
static unsigned int startup_ticks     = 0;
static unsigned int travel_ticks      = 0;

/*
 * Helper: Transition to a new controller state and reset state timer.
 */
static void Controller_EnterState(unsigned char new_state) {
    controller_state = new_state;
    state_ticks = 0;
}

/*
 * Helper: Poll for incoming landing button or keypad requests and enqueue them.
 */
static void Controller_ReadRequests(void) {
    unsigned char requested_floor = NO_FLOOR;

    if (Inputs_GetNewFloorRequest(&requested_floor) != 0) {
        if (IS_VALID_FLOOR(requested_floor)) {
            RequestHandler_Add(requested_floor);
        }
    }
}

/*
 * Helper: Read position feedback from Team 2 Hall Effect sensors.
 */
static void Controller_UpdateCurrentFloor(void) {
    current_floor = Inputs_GetCurrentFloor();
}

/*
 * Initialize the elevator controller.
 * Puts system into a fail-safe state: motor stopped, brake engaged,
 * request queue cleared, startup sound triggered.
 */
void Controller_Init(void) {
    controller_state = STATE_WAIT_FOR_FLOOR;
    current_floor    = NO_FLOOR;
    target_floor     = NO_FLOOR;
    direction        = DIR_STOP;
    last_direction   = DIR_STOP;

    state_ticks      = 0;
    startup_ticks    = 0;
    travel_ticks     = 0;

    RequestHandler_Init();

    /* Enforce fail-safe hardware state on boot */
    Motor_Stop();
    Brake_Engage();

    /* Sound startup confirmation alert */
    Inputs_Buzzer(BUZZER_STARTUP);
}

/*
 * Main periodic controller update routine (executed every 10 ms).
 * Evaluates inputs, advances timers, executes FSM, and updates display.
 */
void Controller_Update(void) {
    /* 1. Ingest inputs from Team 2 */
    Controller_ReadRequests();
    Controller_UpdateCurrentFloor();

    /* 2. Increment 16-bit tick timers without overflowing */
    if (state_ticks < 65535u) {
        state_ticks++;
    }
    if (startup_ticks < 65535u) {
        startup_ticks++;
    }

    /* 3. Global safety supervision during active transit phases */
    if (controller_state == STATE_MOVING_UP ||
        controller_state == STATE_MOVING_DOWN ||
        controller_state == STATE_BRAKE_RELEASE) {

        /* Check for Hall sensor conflict / fault */
        if (Inputs_IsFloorSensorFault() != 0) {
            Motor_Stop();
            Brake_Engage();
            Inputs_Buzzer(BUZZER_SENSOR_FAULT);
            Controller_EnterState(STATE_SENSOR_FAULT);
        }
        /* Check for weight overload */
        else if (Weight_IsOverload() != 0) {
            Motor_Stop();
            Brake_Engage();
            Inputs_Buzzer(BUZZER_OVERLOAD);
            Controller_EnterState(STATE_OVERLOAD);
        }
    }

    /* 4. Finite State Machine Execution */
    switch (controller_state) {

        /* --------------------------------------------------------------------
         * STATE_WAIT_FOR_FLOOR:
         * Microcontroller has booted; cabin must identify initial position.
         * -------------------------------------------------------------------- */
        case STATE_WAIT_FOR_FLOOR:
            Motor_Stop();
            Brake_Engage();

            if (Inputs_IsFloorSensorFault() != 0) {
                Inputs_Buzzer(BUZZER_SENSOR_FAULT);
                Controller_EnterState(STATE_SENSOR_FAULT);
            }
            else if (current_floor != NO_FLOOR) {
                /* Confirmed cabin position at a valid floor landing */
                Controller_EnterState(STATE_IDLE);
            }
            else if (startup_ticks >= FLOOR_DETECT_TIMEOUT_TICKS) {
                /* Cabin not parked at any valid Hall sensor after startup timeout */
                Inputs_Buzzer(BUZZER_SENSOR_FAULT);
                Controller_EnterState(STATE_SENSOR_FAULT);
            }
            break;

        /* --------------------------------------------------------------------
         * STATE_IDLE:
         * Cabin is stationary at a floor, brake engaged, awaiting calls.
         * -------------------------------------------------------------------- */
        case STATE_IDLE:
            Motor_Stop();
            Brake_Engage();

            /* Static safety monitoring while parked */
            if (Inputs_IsFloorSensorFault() != 0) {
                Inputs_Buzzer(BUZZER_SENSOR_FAULT);
                Controller_EnterState(STATE_SENSOR_FAULT);
                break;
            }

            if (Weight_IsOverload() != 0) {
                Inputs_Buzzer(BUZZER_OVERLOAD);
                Controller_EnterState(STATE_OVERLOAD);
                break;
            }

            /* Service next queued request if present */
            if (RequestHandler_HasRequests() != 0) {
                target_floor = RequestHandler_GetNextOptimal(current_floor, last_direction);

                if (target_floor == NO_FLOOR) {
                    break;
                }

                /* Scenario: Requested floor is the floor where cabin is already parked */
                if (target_floor == current_floor) {
                    RequestHandler_Remove(target_floor);
                    Inputs_Buzzer(BUZZER_ARRIVAL);
                    target_floor = NO_FLOOR;
                    direction = DIR_STOP;
                    last_direction = DIR_STOP;
                }
                /* Scenario: Target is above current floor */
                else if (target_floor > current_floor) {
                    direction = DIR_UP;
                    last_direction = DIR_UP;
                    Brake_Release();
                    Controller_EnterState(STATE_BRAKE_RELEASE);
                }
                /* Scenario: Target is below current floor */
                else if (target_floor < current_floor) {
                    direction = DIR_DOWN;
                    last_direction = DIR_DOWN;
                    Brake_Release();
                    Controller_EnterState(STATE_BRAKE_RELEASE);
                }
            }
            else {
                last_direction = DIR_STOP;
            }
            break;

        /* --------------------------------------------------------------------
         * STATE_BRAKE_RELEASE:
         * Servo commanded to release mechanical brake; wait settling period.
         * -------------------------------------------------------------------- */
        case STATE_BRAKE_RELEASE:
            /* If a closer floor along the path of travel was requested while releasing brake, optimize target */
            if (current_floor != NO_FLOOR && direction != DIR_STOP) {
                unsigned char optimal = RequestHandler_GetNextOptimal(current_floor, direction);
                if (optimal != NO_FLOOR) {
                    target_floor = optimal;
                }
            }

            if (state_ticks >= BRAKE_RELEASE_TICKS) {
                travel_ticks = 0;
                if (direction == DIR_UP) {
                    Motor_Set(DIR_UP, MOTOR_SPEED_PERCENT);
                    Controller_EnterState(STATE_MOVING_UP);
                }
                else if (direction == DIR_DOWN) {
                    Motor_Set(DIR_DOWN, MOTOR_SPEED_PERCENT);
                    Controller_EnterState(STATE_MOVING_DOWN);
                }
                else {
                    /* Direction safety fallback */
                    Motor_Stop();
                    Brake_Engage();
                    Controller_EnterState(STATE_IDLE);
                }
            }
            break;

        /* --------------------------------------------------------------------
         * STATE_MOVING_UP:
         * Hoisting cabin upward toward target floor.
         * -------------------------------------------------------------------- */
        case STATE_MOVING_UP:
            Motor_Set(DIR_UP, MOTOR_SPEED_PERCENT);

            if (travel_ticks < 65535u) {
                travel_ticks++;
            }

            /* Travel timeout check (stall / mechanical blockage / rope slip) */
            if (travel_ticks >= MAX_TRAVEL_TICKS) {
                Motor_Stop();
                Brake_Engage();
                Inputs_Buzzer(BUZZER_SENSOR_FAULT);
                Controller_EnterState(STATE_SENSOR_FAULT);
                break;
            }

            /* Check if target floor reached OR intermediate requested floor reached */
            if (current_floor != NO_FLOOR &&
               (current_floor == target_floor || RequestHandler_Contains(current_floor) != 0)) {
                target_floor = current_floor;
                Motor_Stop();
                Controller_EnterState(STATE_STOPPING);
            }
            break;

        /* --------------------------------------------------------------------
         * STATE_MOVING_DOWN:
         * Lowering cabin downward toward target floor.
         * -------------------------------------------------------------------- */
        case STATE_MOVING_DOWN:
            Motor_Set(DIR_DOWN, MOTOR_SPEED_PERCENT);

            if (travel_ticks < 65535u) {
                travel_ticks++;
            }

            /* Travel timeout check */
            if (travel_ticks >= MAX_TRAVEL_TICKS) {
                Motor_Stop();
                Brake_Engage();
                Inputs_Buzzer(BUZZER_SENSOR_FAULT);
                Controller_EnterState(STATE_SENSOR_FAULT);
                break;
            }

            /* Check if target floor reached OR intermediate requested floor reached */
            if (current_floor != NO_FLOOR &&
               (current_floor == target_floor || RequestHandler_Contains(current_floor) != 0)) {
                target_floor = current_floor;
                Motor_Stop();
                Controller_EnterState(STATE_STOPPING);
            }
            break;

        /* --------------------------------------------------------------------
         * STATE_STOPPING:
         * Motor PWM stopped; wait brief mechanical deceleration settle.
         * -------------------------------------------------------------------- */
        case STATE_STOPPING:
            Motor_Stop();

            if (state_ticks >= STOP_SETTLE_TICKS) {
                Brake_Engage();
                Controller_EnterState(STATE_BRAKE_ENGAGE);
            }
            break;

        /* --------------------------------------------------------------------
         * STATE_BRAKE_ENGAGE:
         * Servo commanded to clamp brake; wait settling period before idle.
         * -------------------------------------------------------------------- */
        case STATE_BRAKE_ENGAGE:
            Motor_Stop();

            if (state_ticks >= BRAKE_ENGAGE_TICKS) {
                if (current_floor == target_floor && target_floor != NO_FLOOR) {
                    RequestHandler_Remove(target_floor);
                    Inputs_Buzzer(BUZZER_ARRIVAL);
                    target_floor = NO_FLOOR;
                    last_direction = direction;
                    direction = DIR_STOP;
                    Controller_EnterState(STATE_IDLE);
                }
                else {
                    Controller_EnterState(STATE_IDLE);
                }
            }
            break;

        /* --------------------------------------------------------------------
         * STATE_OVERLOAD:
         * Overweight detected. Inhibit movement. Clear when weight normalizes.
         * -------------------------------------------------------------------- */
        case STATE_OVERLOAD:
            Motor_Stop();
            Brake_Engage();

            if (Weight_IsOverload() == 0) {
                /* Overload cleared by removing excess cabin mass. Retain calls. */
                Controller_EnterState(STATE_IDLE);
            }
            break;

        /* --------------------------------------------------------------------
         * STATE_SENSOR_FAULT:
         * Sensor error or stall timeout. Maintain brake clamped.
         * -------------------------------------------------------------------- */
        case STATE_SENSOR_FAULT:
            Motor_Stop();
            Brake_Engage();

            /* Automatic recovery only when sensors return to a confirmed single floor */
            if (Inputs_IsFloorSensorFault() == 0 && current_floor != NO_FLOOR) {
                startup_ticks = 0;
                travel_ticks = 0;
                Controller_EnterState(STATE_IDLE);
            }
            break;

        default:
            Motor_Stop();
            Brake_Engage();
            Controller_EnterState(STATE_SENSOR_FAULT);
            break;
    }

    /* 5. Synchronize 16x2 LCD status display */
    Inputs_DisplayStatus(current_floor,
                         target_floor,
                         controller_state,
                         Weight_GetGrams());
}

/*
 * Returns current controller FSM state.
 */
unsigned char Controller_GetState(void) {
    return controller_state;
}

/*
 * Returns current confirmed floor index.
 */
unsigned char Controller_GetCurrentFloor(void) {
    return current_floor;
}

/*
 * Returns current target floor index.
 */
unsigned char Controller_GetTargetFloor(void) {
    return target_floor;
}
