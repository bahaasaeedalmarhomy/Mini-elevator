#ifndef MOTOR_H
#define MOTOR_H

#include "../Shared/System_Types.h"

/*
 * ============================================================================
 * TEAM 1 PUBLIC INTERFACE - MOTOR, WEIGHT & MECHANICAL BRAKE
 * ============================================================================
 * Hardware Responsibilities:
 *   - DC Hoist Motor control via PWM (CCP1 / RC2) and Direction (RD0, RD1)
 *   - Load Cell transducer & HX711 24-bit ADC (RA0 DT, RA1 SCK)
 *   - Servo-driven mechanical friction brake (RC1 / CCP2)
 *   - Dedicated, galvanically isolated power supply for motor and servo
 *
 * Contract Rules:
 *   - Motor_Set: direction must be DIR_UP, DIR_DOWN, or DIR_STOP.
 *                speed_percent is 0 to 100%.
 *   - Brake_Release / Brake_Engage: Command RC servo (1.0ms = engage, 2.0ms = release).
 *     IMPORTANT: No physical brake feedback sensor exists; commands actuate the servo.
 *   - Weight_GetGrams: Returns current calibrated mass in grams.
 *   - Weight_IsOverload: Returns 1 if measured weight > MAX_ALLOWED_WEIGHT_GRAMS, else 0.
 *   - All update functions must remain short and strictly non-blocking.
 * ============================================================================
 */

/* Initialize motor PWM, direction GPIOs, ADC interface, and servo brake */
void Motor_Init(void);

/* Periodic update routine (called every 10 ms from main loop) */
void Motor_Update(void);

/* Command motor direction and PWM speed percentage (0-100%) */
void Motor_Set(signed char direction, unsigned short speed_percent);

/* Immediately stop motor drive (cut PWM duty to 0 and neutral direction) */
void Motor_Stop(void);

/* Actuate servo to release mechanical brake pads */
void Brake_Release(void);

/* Actuate servo to engage mechanical brake pads */
void Brake_Engage(void);

/* Get current calibrated payload weight in grams */
unsigned long Weight_GetGrams(void);

/* Returns 1 if payload exceeds overload threshold, 0 if normal */
unsigned char Weight_IsOverload(void);

#endif /* MOTOR_H */
