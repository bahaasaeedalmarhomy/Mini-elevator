#ifndef KEYPAD_CONFIG_H
#define KEYPAD_CONFIG_H

#include "../Shared/System_Types.h"

/*
 * ============================================================================
 * TEAM 2 HARDWARE CONFIGURATION & PIN MAPPING SPECIFICATION
 * ============================================================================
 * Microcontroller: Microchip PIC16F877A (40-Pin DIP package)
 * Core Frequency:  20.0 MHz High-Speed Crystal (HS mode)
 * Operating VDD:   +5.0V DC regulated logic supply
 *
 * This configuration file documents all pin allocations for Team 2 (Inputs,
 * Keypad, Hall Sensors, LCD, Buzzer) and cross-references Team 1 pins to
 * ensure zero pin collisions across the entire chip.
 * ============================================================================
 */

/* ----------------------------------------------------------------------------
 * 1. 3x3 MATRIX KEYPAD CONFIGURATION
 * ----------------------------------------------------------------------------
 * Physical Matrix Layout:
 *               COL 1 (RB0)      COL 2 (RB1)      COL 3 (RB2)
 *   ROW 1 (RE0)     '1'              '2'              '3'
 *   ROW 2 (RE1)     '4'              '5'              '6'
 *   ROW 3 (RE2)     '7'              '8'              '9'
 *   (Optional 4th row if standard 4x3 keypad hardware is used:
 *    ROW 4          '*'              '0'              '#' )
 *
 * Operational Key-to-Floor Logic Mapping:
 *   - Key '0' -> Calls FLOOR_0 (Ground Floor)
 *   - Key '1' -> Calls FLOOR_1 (First Floor)
 *   - Key '2' -> Calls FLOOR_2 (Second Floor)
 *   - Key '3' -> Calls FLOOR_3 (Third Floor)
 *   - Keys '4'..'9', '*', '#' -> Reserved for test diagnostics & maintenance
 *
 * Scanning Methodology:
 *   - Active LOW Row Drive: Microcontroller drives one row LOW at a time.
 *   - Columns configured as inputs with internal weak pull-ups (OPTION_REG.NOT_RBPU = 0).
 *   - When key is pressed, column reads LOW (0V).
 */

/* Keypad Row Pins (Outputs, Driven Active Low) */
#define KEYPAD_ROW1_PIN             PORTE.F0    /* DIP Pin 8  - RE0/AN5 */
#define KEYPAD_ROW2_PIN             PORTE.F1    /* DIP Pin 9  - RE1/AN6 */
#define KEYPAD_ROW3_PIN             PORTE.F2    /* DIP Pin 10 - RE2/AN7 */

#define KEYPAD_ROW1_TRIS            TRISE.F0    /* 0 = Output */
#define KEYPAD_ROW2_TRIS            TRISE.F1    /* 0 = Output */
#define KEYPAD_ROW3_TRIS            TRISE.F2    /* 0 = Output */

/* Keypad Column Pins (Inputs, Active Low, Weak Pull-ups) */
#define KEYPAD_COL1_PIN             PORTB.F0    /* DIP Pin 33 - RB0/INT */
#define KEYPAD_COL2_PIN             PORTB.F1    /* DIP Pin 34 - RB1 */
#define KEYPAD_COL3_PIN             PORTB.F2    /* DIP Pin 35 - RB2 */

#define KEYPAD_COL1_TRIS            TRISB.F0    /* 1 = Input */
#define KEYPAD_COL2_TRIS            TRISB.F1    /* 1 = Input */
#define KEYPAD_COL3_TRIS            TRISB.F2    /* 1 = Input */

/* ----------------------------------------------------------------------------
 * 2. EXTERNAL LANDING CALL BUTTONS
 * ----------------------------------------------------------------------------
 * Stationed at each floor hoistway entrance.
 * Normally Open tactile switches tied to ground when pressed (Active LOW).
 */
#define BTN_FLOOR_0_PIN             PORTA.F2    /* DIP Pin 4 - RA2/AN2 (Requires 10k pull-up) */
#define BTN_FLOOR_1_PIN             PORTA.F3    /* DIP Pin 5 - RA3/AN3 (Requires 10k pull-up) */
#define BTN_FLOOR_2_PIN             PORTA.F4    /* DIP Pin 6 - RA4/T0CKI (Open Drain! 4.7k pull-up) */
#define BTN_FLOOR_3_PIN             PORTA.F5    /* DIP Pin 7 - RA5/AN4 (Requires 10k pull-up) */

#define BTN_FLOOR_0_TRIS            TRISA.F2    /* 1 = Input */
#define BTN_FLOOR_1_TRIS            TRISA.F3    /* 1 = Input */
#define BTN_FLOOR_2_TRIS            TRISA.F4    /* 1 = Input */
#define BTN_FLOOR_3_TRIS            TRISA.F5    /* 1 = Input */

/* ----------------------------------------------------------------------------
 * 3. HALL EFFECT FLOOR POSITION SENSORS
 * ----------------------------------------------------------------------------
 * Stationed at each floor landing. Detects permanent magnet mounted on cabin.
 * Active LOW output (NPN open-collector with 10k pull-up to +5V).
 */
#define HALL_FLOOR_0_PIN            PORTC.F3    /* DIP Pin 18 - RC3 */
#define HALL_FLOOR_1_PIN            PORTC.F4    /* DIP Pin 23 - RC4 */
#define HALL_FLOOR_2_PIN            PORTC.F5    /* DIP Pin 24 - RC5 */
#define HALL_FLOOR_3_PIN            PORTC.F6    /* DIP Pin 25 - RC6 */

#define HALL_FLOOR_0_TRIS           TRISC.F3    /* 1 = Input */
#define HALL_FLOOR_1_TRIS           TRISC.F4    /* 1 = Input */
#define HALL_FLOOR_2_TRIS           TRISC.F5    /* 1 = Input */
#define HALL_FLOOR_3_TRIS           TRISC.F6    /* 1 = Input */

/* ----------------------------------------------------------------------------
 * 4. 16x2 ALPHANUMERIC LCD (HD44780 COMPATIBLE - 4-BIT MODE)
 * ----------------------------------------------------------------------------
 */
#define LCD_RS_PIN                  PORTD.F2    /* DIP Pin 21 - RD2 */
#define LCD_EN_PIN                  PORTD.F3    /* DIP Pin 22 - RD3 */
#define LCD_D4_PIN                  PORTD.F4    /* DIP Pin 27 - RD4 */
#define LCD_D5_PIN                  PORTD.F5    /* DIP Pin 28 - RD5 */
#define LCD_D6_PIN                  PORTD.F6    /* DIP Pin 29 - RD6 */
#define LCD_D7_PIN                  PORTD.F7    /* DIP Pin 30 - RD7 */

#define LCD_RS_TRIS                 TRISD.F2    /* 0 = Output */
#define LCD_EN_TRIS                 TRISD.F3    /* 0 = Output */
#define LCD_D4_TRIS                 TRISD.F4    /* 0 = Output */
#define LCD_D5_TRIS                 TRISD.F5    /* 0 = Output */
#define LCD_D6_TRIS                 TRISD.F6    /* 0 = Output */
#define LCD_D7_TRIS                 TRISD.F7    /* 0 = Output */

/* ----------------------------------------------------------------------------
 * 5. AUDIO BUZZER OUTPUT
 * ----------------------------------------------------------------------------
 * Active HIGH drive signal to 2N2222 NPN transistor base via 1k resistor.
 */
#define BUZZER_PIN                  PORTC.F7    /* DIP Pin 26 - RC7 */
#define BUZZER_TRIS                 TRISC.F7    /* 0 = Output */

/* ----------------------------------------------------------------------------
 * 6. CRITICAL PIC16F877A HARDWARE & REGISTER INITIALIZATION RULES
 * ----------------------------------------------------------------------------
 * 1. ADCON1 (A/D Control Register 1):
 *    - PORTA and PORTE pins default to ANALOG INPUT mode on power-up!
 *    - Team 2 uses RA2, RA3, RA4, RA5 and RE0, RE1, RE2 for digital I/O.
 *    - Team 1 uses RA0 (HX711 DT) and RA1 (HX711 SCK) for digital I/O.
 *    - Setting ADCON1 = 0x06 (or 0x07) is MANDATORY to configure ALL PORTA
 *      and PORTE pins as pure digital I/O.
 *
 * 2. RA4/T0CKI SPECIAL HARDWARE CHARACTERISTIC:
 *    - Pin 6 (RA4) has an OPEN-DRAIN output structure and a Schmitt Trigger input.
 *    - When used as an input (Floor 2 call button), an EXTERNAL PULL-UP RESISTOR
 *      (4.7k to +5V) IS MANDATORY. It will never read HIGH without a pull-up!
 *
 * 3. PORTE PARALLEL SLAVE PORT (PSPMODE):
 *    - TRISE.PSPMODE (bit 4 of TRISE) must be cleared to 0.
 *    - If left set, PORTE acts as a microprocessor bus slave and corrupts RE0-RE2!
 *
 * 4. PORTB WEAK PULL-UPS:
 *    - OPTION_REG.NOT_RBPU (bit 7) must be cleared to 0 to enable the on-chip
 *      weak pull-up resistors on RB0, RB1, RB2 for keypad column reading.
 * ============================================================================
 */

#endif /* KEYPAD_CONFIG_H */
