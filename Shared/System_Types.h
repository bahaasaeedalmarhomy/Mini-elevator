#ifndef SYSTEM_TYPES_H
#define SYSTEM_TYPES_H

/*
 * ============================================================================
 * MINI ELEVATOR - SHARED SYSTEM TYPES & CONSTANTS
 * Target Microcontroller: PIC16F877A
 * Toolchain: mikroC PRO for PIC / ANSI C
 * ============================================================================
 * This header defines common data structures, states, events, and constants
 * shared by Team 1 (Motor/Brake/Weight), Team 2 (Inputs/Sensors/Display),
 * and Team 3 (Main Controller).
 *
 * DO NOT modify these values without consulting all teams.
 * ============================================================================
 */

/* ----------------------------------------------------------------------------
 * 1. FLOOR DEFINITIONS
 * ----------------------------------------------------------------------------
 * The elevator serves 4 physical levels indexed 0 to 3:
 *   FLOOR_0 : Ground level (Level 0)
 *   FLOOR_1 : Level 1
 *   FLOOR_2 : Level 2
 *   FLOOR_3 : Level 3
 *
 * NO_FLOOR is defined as 255 (0xFF, matching (unsigned char)-1) to indicate
 * that the cabin is between floors or no valid floor is detected.
 */
#define FLOOR_0                     0
#define FLOOR_1                     1
#define FLOOR_2                     2
#define FLOOR_3                     3
#define FLOOR_COUNT                 4
#define NO_FLOOR                    255

/* Macro to validate if a floor number is within physical hoistway limits */
#define IS_VALID_FLOOR(f)           ((f) <= FLOOR_3)

/* ----------------------------------------------------------------------------
 * 2. MOTOR DIRECTION DEFINITIONS
 * ----------------------------------------------------------------------------
 * Signed char direction indicator for motor drive.
 */
#define DIR_STOP                    0
#define DIR_UP                      1
#define DIR_DOWN                   -1

/* ----------------------------------------------------------------------------
 * 3. CONTROLLER FINITE STATE MACHINE (FSM) STATES
 * ----------------------------------------------------------------------------
 * Standard state identifiers for elevator operation.
 * (Note: No door-related states exist in this system.)
 */
#define STATE_WAIT_FOR_FLOOR        0   /* Startup: awaiting initial valid Hall sensor */
#define STATE_IDLE                  1   /* Stationary at floor, brake engaged, awaiting calls */
#define STATE_BRAKE_RELEASE         2   /* Brake commanded to release; settling before motion */
#define STATE_MOVING_UP             3   /* Hoisting cabin upward toward target floor */
#define STATE_MOVING_DOWN           4   /* Lowering cabin downward toward target floor */
#define STATE_STOPPING              5   /* Target floor reached; motor stopped, settling */
#define STATE_BRAKE_ENGAGE          6   /* Brake commanded to engage; settling after stop */
#define STATE_OVERLOAD              7   /* Overload detected by load cell; motion inhibited */
#define STATE_SENSOR_FAULT          8   /* Sensor error or travel timeout; motion inhibited */

/* ----------------------------------------------------------------------------
 * 4. BUZZER AUDIO ALERT EVENT CODES
 * ----------------------------------------------------------------------------
 * Event triggers sent from Controller to Team 2 Buzzer driver.
 */
#define BUZZER_ARRIVAL              1   /* Chime when cabin arrives at requested floor */
#define BUZZER_OVERLOAD             2   /* Continuous/rapid alarm for weight overload */
#define BUZZER_SENSOR_FAULT         3   /* Alarm pattern for invalid floor sensor or stall */
#define BUZZER_STARTUP              4   /* Confirmation chirp on controller boot */

/* ----------------------------------------------------------------------------
 * 5. SYSTEM TIMING & OPERATIONAL CONFIGURATION
 * ----------------------------------------------------------------------------
 * All update routines run at a deterministic 10 ms cyclic rate.
 * Ticks correspond to 10 ms increments.
 */
#define CONTROLLER_TICK_MS          10   /* Main loop periodicity (10 ms) */

/* Mechanical Settling Timeouts */
#define BRAKE_RELEASE_TICKS         30   /* 300 ms delay for servo to retract brake pads */
#define BRAKE_ENGAGE_TICKS          30   /* 300 ms delay for servo to clamp brake pads */
#define STOP_SETTLE_TICKS           5    /* 50 ms delay after cutting motor PWM before brake */

/* Safety & Operational Timeouts */
#define FLOOR_DETECT_TIMEOUT_TICKS  500  /* 5.0 seconds maximum to find valid floor at startup */
#define MAX_TRAVEL_TICKS            3000 /* 30.0 seconds maximum travel time between floors */

/* Motion & Load Limits */
#define MOTOR_SPEED_PERCENT         65   /* Default PWM duty cycle percentage (0-100) */
#define MAX_ALLOWED_WEIGHT_GRAMS    1500UL /* Overload cutoff threshold in grams */

#endif /* SYSTEM_TYPES_H */
