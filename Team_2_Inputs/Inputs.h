#ifndef INPUTS_H
#define INPUTS_H

#include "../Shared/System_Types.h"

/*
 * ============================================================================
 * TEAM 2 PUBLIC INTERFACE - INPUTS, SENSORS, DISPLAY & BUZZER
 * ============================================================================
 * Hardware Responsibilities:
 *   - 3x3 Matrix Keypad (Rows RE0-RE2, Cols RB0-RB2)
 *   - 4 External Landing Call Pushbuttons (RA2-RA5)
 *   - 4 Hall Effect Floor Detection Sensors (RC3-RC6)
 *   - Alphanumeric 16x2 LCD in 4-bit mode (RD2-RD7)
 *   - Audio Buzzer with NPN transistor driver (RC7)
 *
 * Contract Rules:
 *   - Inputs_GetNewFloorRequest: Returns 1 if a debounced button press was detected
 *     and writes floor index (FLOOR_0 to FLOOR_3) into *floor. Returns 0 if none.
 *   - Inputs_GetCurrentFloor: Returns FLOOR_0..FLOOR_3 if exactly one valid Hall
 *     sensor is triggered. Returns NO_FLOOR if cabin is in-flight / between floors.
 *   - Inputs_IsFloorSensorFault: Returns 1 if multiple Hall sensors are triggered
 *     simultaneously or electrical invalidity is detected; otherwise returns 0.
 *   - Inputs_DisplayStatus: Updates LCD with current state, floors, and weight.
 *   - Inputs_Buzzer: Triggers non-blocking audio pattern based on event_code.
 * ============================================================================
 */

/* Initialize GPIOs, LCD, Keypad scanning, Hall sensor inputs, and Buzzer */
void Inputs_Init(void);

/* Periodic non-blocking scan & debouncing update (called every 10 ms) */
void Inputs_Update(void);

/* Poll for pending floor call from keypad or external landing buttons */
unsigned char Inputs_GetNewFloorRequest(unsigned char *floor);

/* Read current cabin position from Hall effect sensors (FLOOR_0..3 or NO_FLOOR) */
unsigned char Inputs_GetCurrentFloor(void);

/* Check if multiple Hall sensors are tripped simultaneously (sensor fault) */
unsigned char Inputs_IsFloorSensorFault(void);

/* Refresh 16x2 LCD with real-time operational status */
void Inputs_DisplayStatus(
    unsigned char current_floor,
    unsigned char target_floor,
    unsigned char controller_state,
    unsigned long weight_grams
);

/* Trigger audio alert pattern (BUZZER_ARRIVAL, BUZZER_OVERLOAD, etc.) */
void Inputs_Buzzer(unsigned char event_code);

#endif /* INPUTS_H */
