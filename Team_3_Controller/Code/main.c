/*
 * ============================================================================
 * MINI ELEVATOR - MASTER INTEGRATION ENTRY POINT
 * ============================================================================
 * Microcontroller: PIC16F877A
 * Oscillator:      20.0 MHz External Crystal (HS Mode)
 * Toolchain:       mikroC PRO for PIC / ANSI C
 * Team:            Team 3 (Main Controller & Master Integration)
 *
 * Execution Model:
 *   - Non-blocking cyclic polling super-loop
 *   - Loop period: 10 ms (CONTROLLER_TICK_MS)
 *   - Each subsystem executes its update routine and returns immediately
 *   - No blocking delays allowed inside subsystem routines
 * ============================================================================
 */

#include "../../Shared/System_Types.h"
#include "../../Team_1_Motor/Motor.h"
#include "../../Team_2_Inputs/Inputs.h"
#include "../Controller.h"

void main() {
    /* ------------------------------------------------------------------------
     * HARDWARE & PERIPHERAL INITIALIZATION
     * ------------------------------------------------------------------------
     * Subsystems are initialized in deterministic sequence:
     *   1. Motor & Brake (ensure motor is stopped and brake clamped first)
     *   2. Inputs, Sensors & Display (configure ADCON1, LCD, sensors, keypad)
     *   3. Master Controller (initialize FSM, request queue, safety timers)
     * ------------------------------------------------------------------------ */
    Motor_Init();
    Inputs_Init();
    Controller_Init();

    /* ------------------------------------------------------------------------
     * MAIN SUPER-LOOP (10 ms Cyclic Polling)
     * ------------------------------------------------------------------------ */
    while (1) {
        /* Team 1: Update PWM generation, load-cell sampling, servo PWM */
        Motor_Update();

        /* Team 2: Scan keypad, debounce landing buttons, read Hall sensors, LCD */
        Inputs_Update();

        /* Team 3: Execute elevator finite state machine and dispatching logic */
        Controller_Update();

        /* Base loop timing: 10 milliseconds */
        Delay_ms(10);
    }
}
