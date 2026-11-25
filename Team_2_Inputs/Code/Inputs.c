/*
 * ============================================================================
 * TEAM 2 IMPLEMENTATION - INPUTS, SENSORS, DISPLAY & BUZZER
 * ============================================================================
 * File:            Team_2_Inputs/Code/Inputs.c
 * Microcontroller: PIC16F877A @ 20.0 MHz (HS)
 * Toolchain:       mikroC PRO for PIC / ANSI C (C89)
 *
 * Hardware Managed:
 *   - 3x3 Matrix Keypad: Rows RE0-RE2 (Active LOW), Cols RB0-RB2 (Pull-ups)
 *   - 4 Landing Call Pushbuttons: RA2-RA5 (Active LOW, Floor 0..3)
 *   - 4 Hall Effect Floor Sensors: RC3-RC6 (Active LOW, Floor 0..3)
 *   - 16x2 Alphanumeric LCD (HD44780, 4-bit mode): RD2-RD7
 *   - Audio Piezo Buzzer (NPN driver): RC7 (Active HIGH)
 *
 * Execution Model:
 *   - Inputs_Update() MUST be called every 10 ms (CONTROLLER_TICK_MS).
 *   - Strictly non-blocking during runtime (no multi-millisecond delays in
 *     Inputs_Update() or Inputs_Buzzer()).
 *   - LCD lines are cached so bus writes occur only when displayed text changes.
 *   - Only Team 2 pin bits are touched on shared ports (PORTA, PORTC, PORTD)
 *     so Team 1 peripherals (HX711, PWM, Servo, H-Bridge) are never disturbed.
 * ============================================================================
 */

#include "../Inputs.h"
#include "../Keypad_Config.h"

/* ----------------------------------------------------------------------------
 * TUNING CONSTANTS (1 tick = CONTROLLER_TICK_MS = 10 ms)
 * ----------------------------------------------------------------------------
 */
#define INPUT_DEBOUNCE_TICKS        3   /* 30 ms debounce for keypad & buttons */
#define HALL_DEBOUNCE_TICKS         2   /* 20 ms debounce for Hall sensors     */
#define REQ_QUEUE_SIZE              4   /* Internal FIFO buffer for key events */

/* Buzzer timing constants (in 10 ms ticks) */
#define BZ_ARRIVAL_TICKS            15  /* 150 ms single arrival chime         */
#define BZ_STARTUP_TICKS            10  /* 100 ms power-on chirp               */
#define BZ_OVERLOAD_ON_TICKS        10  /* 100 ms ON                           */
#define BZ_OVERLOAD_PERIOD_TICKS    20  /* 200 ms period (100 ms ON / 100 OFF) */
#define BZ_FAULT_PERIOD_TICKS       60  /* 600 ms alternating long-short cycle */

/* Internal scan codes (0 = no key/button pressed) */
#define SCAN_CODE_NONE              0
#define SCAN_CODE_LANDING_BASE      1   /* 1..4  -> Landing Floor 0..3         */
#define SCAN_CODE_KEYPAD_BASE       10  /* 11..19 -> Matrix position 1..9      */

/* ----------------------------------------------------------------------------
 * INTERNAL MODULE STATE
 * ----------------------------------------------------------------------------
 */
/* Keypad & landing button debouncer + FIFO queue */
static unsigned char req_last_code;
static unsigned char req_stable_cnt;
static unsigned char req_queue[REQ_QUEUE_SIZE];
static unsigned char req_head;
static unsigned char req_tail;
static unsigned char req_count;

/* Hall sensor debouncer: bit n = 1 when Floor n sensor is active (pin LOW) */
static unsigned char hall_last_raw;
static unsigned char hall_stable_cnt;
static unsigned char hall_stable_mask;

/* Non-blocking buzzer pattern state */
static unsigned char bz_active_event;
static unsigned char bz_tick_cnt;

/* 16x2 LCD differential line buffers (RAM) */
static char lcd_cache[2][17];
static char lcd_line_buf[17];

/* ============================================================================
 * 1. HD44780 16x2 LCD DRIVER (4-BIT MODE, SELF-CONTAINED)
 * ============================================================================
 */
static void lcd_write_nibble(unsigned char nibble) {
    LCD_D4_PIN = (nibble & 0x01) ? 1 : 0;
    LCD_D5_PIN = (nibble & 0x02) ? 1 : 0;
    LCD_D6_PIN = (nibble & 0x04) ? 1 : 0;
    LCD_D7_PIN = (nibble & 0x08) ? 1 : 0;

    Delay_us(1);
    LCD_EN_PIN = 1;
    Delay_us(5);
    LCD_EN_PIN = 0;
    Delay_us(5);
}

static void lcd_send_byte(unsigned char value, unsigned char is_data) {
    LCD_RS_PIN = is_data ? 1 : 0;
    lcd_write_nibble((unsigned char)(value >> 4));
    lcd_write_nibble((unsigned char)(value & 0x0F));
    Delay_us(50);
}

static void lcd_hw_init(void) {
    /* Configure only LCD pins (RD2..RD7) as outputs; preserve RD0..RD1 (Team 1) */
    LCD_RS_TRIS = 0;
    LCD_EN_TRIS = 0;
    LCD_D4_TRIS = 0;
    LCD_D5_TRIS = 0;
    LCD_D6_TRIS = 0;
    LCD_D7_TRIS = 0;

    LCD_RS_PIN = 0;
    LCD_EN_PIN = 0;
    LCD_D4_PIN = 0;
    LCD_D5_PIN = 0;
    LCD_D6_PIN = 0;
    LCD_D7_PIN = 0;

    /* HD44780 power-up & 4-bit mode synchronization sequence */
    Delay_ms(40);
    lcd_write_nibble(0x03);
    Delay_ms(5);
    lcd_write_nibble(0x03);
    Delay_us(200);
    lcd_write_nibble(0x03);
    Delay_us(200);
    lcd_write_nibble(0x02);         /* Switch to 4-bit interface */
    Delay_us(200);

    lcd_send_byte(0x28, 0);         /* Function set: 4-bit, 2 lines, 5x8 font */
    lcd_send_byte(0x0C, 0);         /* Display ON, cursor OFF, blink OFF      */
    lcd_send_byte(0x01, 0);         /* Clear display                          */
    Delay_ms(2);                    /* Clear command requires >= 1.52 ms      */
    lcd_send_byte(0x06, 0);         /* Entry mode: increment, no display shift*/
}

/* Writes a 16-character RAM buffer to LCD row 0 or row 1 */
static void lcd_write_line(unsigned char row, char *ram_text) {
    unsigned char i;

    lcd_send_byte(row ? 0xC0 : 0x80, 0);
    for (i = 0; i < 16; i++) {
        lcd_send_byte((unsigned char)ram_text[i], 1);
    }
}

/* ============================================================================
 * 2. LIGHTWEIGHT STRING FORMATTERS (No sprintf; ROM/RAM-safe on PIC16)
 * ============================================================================
 */
static unsigned char buf_put_const_str(char *buf, unsigned char pos, const char *s) {
    while (*s != 0 && pos < 16) {
        buf[pos++] = *s++;
    }
    return pos;
}

static unsigned char buf_put_ulong(char *buf, unsigned char pos, unsigned long value) {
    char digits[6];
    unsigned char count = 0;
    unsigned char i;

    if (value > 99999UL) {
        value = 99999UL;
    }

    do {
        digits[count++] = (char)('0' + (unsigned char)(value % 10UL));
        value /= 10UL;
    } while (value != 0UL);

    for (i = count; i > 0; i--) {
        if (pos < 16) {
            buf[pos++] = digits[i - 1];
        }
    }
    return pos;
}

static char floor_to_char(unsigned char floor) {
    return IS_VALID_FLOOR(floor) ? (char)('0' + floor) : '-';
}

static unsigned char buf_put_state(char *buf, unsigned char pos, unsigned char state) {
    switch (state) {
        case STATE_WAIT_FOR_FLOOR: return buf_put_const_str(buf, pos, "WAIT");
        case STATE_IDLE:           return buf_put_const_str(buf, pos, "IDLE");
        case STATE_BRAKE_RELEASE:  return buf_put_const_str(buf, pos, "BRK-");
        case STATE_MOVING_UP:      return buf_put_const_str(buf, pos, "UP");
        case STATE_MOVING_DOWN:    return buf_put_const_str(buf, pos, "DOWN");
        case STATE_STOPPING:       return buf_put_const_str(buf, pos, "STOP");
        case STATE_BRAKE_ENGAGE:   return buf_put_const_str(buf, pos, "BRK+");
        case STATE_OVERLOAD:       return buf_put_const_str(buf, pos, "OVRLOAD");
        case STATE_SENSOR_FAULT:   return buf_put_const_str(buf, pos, "FAULT");
        default:                   return buf_put_const_str(buf, pos, "???");
    }
}

static void buf_pad_line(char *buf, unsigned char pos) {
    while (pos < 16) {
        buf[pos++] = ' ';
    }
    buf[16] = 0;
}

static void lcd_flush_if_changed(unsigned char row) {
    unsigned char i;
    unsigned char changed = 0;

    for (i = 0; i < 16; i++) {
        if (lcd_cache[row][i] != lcd_line_buf[i]) {
            changed = 1;
            break;
        }
    }

    if (changed) {
        for (i = 0; i < 17; i++) {
            lcd_cache[row][i] = lcd_line_buf[i];
        }
        lcd_write_line(row, lcd_line_buf);
    }
}

/* ============================================================================
 * 3. MATRIX KEYPAD & EXTERNAL LANDING BUTTON SCANNER
 * ============================================================================
 */
static void keypad_rows_idle(void) {
    KEYPAD_ROW1_PIN = 1;
    KEYPAD_ROW2_PIN = 1;
    KEYPAD_ROW3_PIN = 1;
}

/*
 * Scans the 3x3 matrix using active-LOW row drive and internal PORTB pull-ups.
 * Returns 0 if no key is pressed, otherwise key position 1..9:
 *   Row 1 (RE0): 1='1', 2='2', 3='3'
 *   Row 2 (RE1): 4='4', 5='5', 6='6'
 *   Row 3 (RE2): 7='*', 8='0', 9='#' (wired to Row 4 of 4x3 keypad per guide)
 */
static unsigned char keypad_scan_raw(void) {
    unsigned char row;
    unsigned char key = 0;

    for (row = 0; row < 3 && key == 0; row++) {
        keypad_rows_idle();

        if (row == 0) {
            KEYPAD_ROW1_PIN = 0;
        }
        else if (row == 1) {
            KEYPAD_ROW2_PIN = 0;
        }
        else {
            KEYPAD_ROW3_PIN = 0;
        }

        Delay_us(10);   /* Allow column pull-up capacitance to settle */

        if (KEYPAD_COL1_PIN == 0) {
            key = (unsigned char)(row * 3 + 1);
        }
        else if (KEYPAD_COL2_PIN == 0) {
            key = (unsigned char)(row * 3 + 2);
        }
        else if (KEYPAD_COL3_PIN == 0) {
            key = (unsigned char)(row * 3 + 3);
        }
    }

    keypad_rows_idle();
    return key;
}

/*
 * Produces a unified raw input code. Landing buttons are checked first
 * (active LOW), followed by the internal cabin matrix keypad.
 */
static unsigned char scan_all_inputs_raw(void) {
    unsigned char key;

    if (BTN_FLOOR_0_PIN == 0) return (unsigned char)(SCAN_CODE_LANDING_BASE + FLOOR_0);
    if (BTN_FLOOR_1_PIN == 0) return (unsigned char)(SCAN_CODE_LANDING_BASE + FLOOR_1);
    if (BTN_FLOOR_2_PIN == 0) return (unsigned char)(SCAN_CODE_LANDING_BASE + FLOOR_2);
    if (BTN_FLOOR_3_PIN == 0) return (unsigned char)(SCAN_CODE_LANDING_BASE + FLOOR_3);

    key = keypad_scan_raw();
    if (key != 0) {
        return (unsigned char)(SCAN_CODE_KEYPAD_BASE + key);
    }

    return SCAN_CODE_NONE;
}

static void request_queue_push(unsigned char floor) {
    if (!IS_VALID_FLOOR(floor)) {
        return;
    }
    if (req_count >= REQ_QUEUE_SIZE) {
        return;     /* Buffer full: drop safely without memory corruption */
    }

    req_queue[req_tail] = floor;
    req_tail++;
    if (req_tail >= REQ_QUEUE_SIZE) {
        req_tail = 0;
    }
    req_count++;
}

/* Maps a debounced scan code to a valid floor index and enqueues it */
static void handle_debounced_press(unsigned char scan_code) {
    unsigned char key;

    if (scan_code >= SCAN_CODE_LANDING_BASE &&
        scan_code < (unsigned char)(SCAN_CODE_LANDING_BASE + FLOOR_COUNT)) {
        request_queue_push((unsigned char)(scan_code - SCAN_CODE_LANDING_BASE));
        return;
    }

    if (scan_code > SCAN_CODE_KEYPAD_BASE) {
        key = (unsigned char)(scan_code - SCAN_CODE_KEYPAD_BASE);
        switch (key) {
            case 8:     /* Row 3 (RE2), Col 2 (RB1): Key '0' -> Ground Floor */
                request_queue_push(FLOOR_0);
                break;
            case 1:     /* Row 1 (RE0), Col 1 (RB0): Key '1' -> Floor 1 */
                request_queue_push(FLOOR_1);
                break;
            case 2:     /* Row 1 (RE0), Col 2 (RB1): Key '2' -> Floor 2 */
                request_queue_push(FLOOR_2);
                break;
            case 3:     /* Row 1 (RE0), Col 3 (RB2): Key '3' -> Floor 3 */
                request_queue_push(FLOOR_3);
                break;
            default:    /* Keys '4'..'6', '*', '#' reserved for diagnostics */
                break;
        }
    }
}

/* ============================================================================
 * 4. HALL EFFECT FLOOR SENSORS
 * ============================================================================
 */
static unsigned char hall_read_raw_mask(void) {
    unsigned char mask = 0;

    if (HALL_FLOOR_0_PIN == 0) mask |= 0x01;
    if (HALL_FLOOR_1_PIN == 0) mask |= 0x02;
    if (HALL_FLOOR_2_PIN == 0) mask |= 0x04;
    if (HALL_FLOOR_3_PIN == 0) mask |= 0x08;

    return mask;
}

/* ============================================================================
 * 5. NON-BLOCKING AUDIO BUZZER SERVICE
 * ============================================================================
 */
static void buzzer_service_tick(void) {
    unsigned char output_on = 0;
    unsigned char period = 0;

    switch (bz_active_event) {
        case BUZZER_ARRIVAL:
            /* Single pleasant 150 ms arrival beep */
            if (bz_tick_cnt < BZ_ARRIVAL_TICKS) {
                output_on = 1;
            }
            else {
                bz_active_event = 0;
            }
            break;

        case BUZZER_STARTUP:
            /* Short 100 ms power-on confirmation chirp */
            if (bz_tick_cnt < BZ_STARTUP_TICKS) {
                output_on = 1;
            }
            else {
                bz_active_event = 0;
            }
            break;

        case BUZZER_OVERLOAD:
            /* Rapid warning pulses: 100 ms ON / 100 ms OFF */
            period = BZ_OVERLOAD_PERIOD_TICKS;
            output_on = (bz_tick_cnt < BZ_OVERLOAD_ON_TICKS) ? 1 : 0;
            break;

        case BUZZER_SENSOR_FAULT:
            /* Alternating alarm pattern: 250 ms ON, 100 ms OFF, 100 ms ON, 150 ms OFF */
            period = BZ_FAULT_PERIOD_TICKS;
            if ((bz_tick_cnt < 25) || (bz_tick_cnt >= 35 && bz_tick_cnt < 45)) {
                output_on = 1;
            }
            break;

        default:
            bz_active_event = 0;
            output_on = 0;
            break;
    }

    if (bz_active_event != 0) {
        bz_tick_cnt++;
        if (period != 0 && bz_tick_cnt >= period) {
            bz_tick_cnt = 0;
        }
    }

    BUZZER_PIN = output_on;
}

/* ============================================================================
 * 6. PUBLIC INTERFACE IMPLEMENTATION (Team_2_Inputs/Inputs.h)
 * ============================================================================
 */
void Inputs_Init(void) {
    unsigned char pos;

    /* --- Mandatory PIC16F877A peripheral configuration --- */
    ADCON1        = 0x06;       /* Configure PORTA & PORTE as pure digital I/O */
    CMCON         = 0x07;       /* Ensure analog comparators are disabled      */
    TRISE.F4      = 0;          /* PSPMODE = 0: PORTE as general-purpose I/O   */
    OPTION_REG.F7 = 0;          /* NOT_RBPU = 0: Enable PORTB weak pull-ups    */

    /* --- 3x3 Matrix Keypad GPIOs --- */
    KEYPAD_ROW1_TRIS = 0;
    KEYPAD_ROW2_TRIS = 0;
    KEYPAD_ROW3_TRIS = 0;
    KEYPAD_COL1_TRIS = 1;
    KEYPAD_COL2_TRIS = 1;
    KEYPAD_COL3_TRIS = 1;
    keypad_rows_idle();

    /* --- External Landing Call Buttons (RA2-RA5 inputs) --- */
    BTN_FLOOR_0_TRIS = 1;
    BTN_FLOOR_1_TRIS = 1;
    BTN_FLOOR_2_TRIS = 1;
    BTN_FLOOR_3_TRIS = 1;

    /* --- Hall Effect Floor Sensors (RC3-RC6 inputs) --- */
    HALL_FLOOR_0_TRIS = 1;
    HALL_FLOOR_1_TRIS = 1;
    HALL_FLOOR_2_TRIS = 1;
    HALL_FLOOR_3_TRIS = 1;

    /* --- Audio Buzzer Output (RC7 output, initially silent) --- */
    BUZZER_TRIS = 0;
    BUZZER_PIN  = 0;

    /* --- Reset internal software state --- */
    req_last_code  = SCAN_CODE_NONE;
    req_stable_cnt = 0;
    req_head       = 0;
    req_tail       = 0;
    req_count      = 0;

    hall_stable_mask = hall_read_raw_mask();
    hall_last_raw    = hall_stable_mask;
    hall_stable_cnt  = 0;

    bz_active_event = 0;
    bz_tick_cnt     = 0;

    /* --- Initialize 16x2 LCD and display startup banner --- */
    lcd_hw_init();
    lcd_cache[0][0] = 0;
    lcd_cache[1][0] = 0;

    pos = buf_put_const_str(lcd_line_buf, 0, "  MINI ELEVATOR ");
    buf_pad_line(lcd_line_buf, pos);
    lcd_write_line(0, lcd_line_buf);

    pos = buf_put_const_str(lcd_line_buf, 0, "   Starting...  ");
    buf_pad_line(lcd_line_buf, pos);
    lcd_write_line(1, lcd_line_buf);
}

void Inputs_Update(void) {
    unsigned char raw_code;
    unsigned char raw_hall;

    /* 1. Scan & debounce keypad + landing buttons (30 ms, single event per press) */
    raw_code = scan_all_inputs_raw();
    if (raw_code != req_last_code) {
        req_last_code  = raw_code;
        req_stable_cnt = 0;
    }
    else if (req_stable_cnt < INPUT_DEBOUNCE_TICKS) {
        req_stable_cnt++;
        if (req_stable_cnt == INPUT_DEBOUNCE_TICKS && raw_code != SCAN_CODE_NONE) {
            handle_debounced_press(raw_code);
        }
    }

    /* 2. Sample & debounce Hall effect floor sensors (20 ms filter) */
    raw_hall = hall_read_raw_mask();
    if (raw_hall != hall_last_raw) {
        hall_last_raw   = raw_hall;
        hall_stable_cnt = 0;
    }
    else if (hall_stable_cnt < HALL_DEBOUNCE_TICKS) {
        hall_stable_cnt++;
        if (hall_stable_cnt == HALL_DEBOUNCE_TICKS) {
            hall_stable_mask = raw_hall;
        }
    }

    /* 3. Advance non-blocking audio buzzer pattern */
    buzzer_service_tick();
}

unsigned char Inputs_GetNewFloorRequest(unsigned char *floor) {
    if (floor == 0 || req_count == 0) {
        return 0;
    }

    *floor = req_queue[req_head];
    req_head++;
    if (req_head >= REQ_QUEUE_SIZE) {
        req_head = 0;
    }
    req_count--;
    return 1;
}

unsigned char Inputs_GetCurrentFloor(void) {
    switch (hall_stable_mask) {
        case 0x01: return FLOOR_0;
        case 0x02: return FLOOR_1;
        case 0x04: return FLOOR_2;
        case 0x08: return FLOOR_3;
        default:   return NO_FLOOR;     /* Between floors (0) or sensor conflict */
    }
}

unsigned char Inputs_IsFloorSensorFault(void) {
    /* Fault if two or more Hall sensors are active simultaneously */
    return ((hall_stable_mask & (unsigned char)(hall_stable_mask - 1)) != 0) ? 1 : 0;
}

void Inputs_DisplayStatus(
    unsigned char current_floor,
    unsigned char target_floor,
    unsigned char controller_state,
    unsigned long weight_grams
) {
    unsigned char pos;

    /* Auto-silence continuous alarms once Controller exits the alarm state */
    if (bz_active_event == BUZZER_OVERLOAD && controller_state != STATE_OVERLOAD) {
        bz_active_event = 0;
        BUZZER_PIN = 0;
    }
    else if (bz_active_event == BUZZER_SENSOR_FAULT && controller_state != STATE_SENSOR_FAULT) {
        bz_active_event = 0;
        BUZZER_PIN = 0;
    }

    /* ---- Line 1: F:0->2 [UP] ---- */
    pos = 0;
    lcd_line_buf[pos++] = 'F';
    lcd_line_buf[pos++] = ':';
    lcd_line_buf[pos++] = floor_to_char(current_floor);
    lcd_line_buf[pos++] = '-';
    lcd_line_buf[pos++] = '>';
    lcd_line_buf[pos++] = floor_to_char(target_floor);
    lcd_line_buf[pos++] = ' ';
    lcd_line_buf[pos++] = '[';
    pos = buf_put_state(lcd_line_buf, pos, controller_state);
    if (pos < 16) {
        lcd_line_buf[pos++] = ']';
    }
    buf_pad_line(lcd_line_buf, pos);
    lcd_flush_if_changed(0);

    /* ---- Line 2: W: 450g OK ---- */
    pos = buf_put_const_str(lcd_line_buf, 0, "W: ");
    pos = buf_put_ulong(lcd_line_buf, pos, weight_grams);
    if (pos < 16) {
        lcd_line_buf[pos++] = 'g';
    }
    if (pos < 16) {
        lcd_line_buf[pos++] = ' ';
    }
    if (weight_grams > MAX_ALLOWED_WEIGHT_GRAMS || controller_state == STATE_OVERLOAD) {
        pos = buf_put_const_str(lcd_line_buf, pos, "OVER");
    }
    else {
        pos = buf_put_const_str(lcd_line_buf, pos, "OK");
    }
    buf_pad_line(lcd_line_buf, pos);
    lcd_flush_if_changed(1);
}

void Inputs_Buzzer(unsigned char event_code) {
    switch (event_code) {
        case BUZZER_ARRIVAL:
        case BUZZER_STARTUP:
            /* Do not allow one-shot chimes to override active safety alarms */
            if (bz_active_event == BUZZER_OVERLOAD ||
                bz_active_event == BUZZER_SENSOR_FAULT) {
                return;
            }
            bz_active_event = event_code;
            bz_tick_cnt     = 0;
            break;

        case BUZZER_OVERLOAD:
            /* Sensor fault retains highest priority */
            if (bz_active_event == BUZZER_SENSOR_FAULT) {
                return;
            }
            if (bz_active_event != BUZZER_OVERLOAD) {
                bz_active_event = BUZZER_OVERLOAD;
                bz_tick_cnt     = 0;
            }
            break;

        case BUZZER_SENSOR_FAULT:
            if (bz_active_event != BUZZER_SENSOR_FAULT) {
                bz_active_event = BUZZER_SENSOR_FAULT;
                bz_tick_cnt     = 0;
            }
            break;

        default:    /* 0 or unknown event: silence immediately */
            bz_active_event = 0;
            bz_tick_cnt     = 0;
            BUZZER_PIN      = 0;
            break;
    }
}
