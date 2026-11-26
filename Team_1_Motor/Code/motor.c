/*
 * ============================================================================
 *  Team_1_Motor/Code/Motor.c
 *  TEAM 1 - Motor drive, HX711 weight measurement, servo mechanical brake
 *  Target : PIC16F877A @ 20 MHz (HS)      Compiler : mikroC PRO for PIC
 * ============================================================================
 *  Structure (same style as Team 3's Controller.c):
 *    - Motor_Update() runs every 10 ms, increments state_ticks, runs one
 *      switch() over a small motor state machine.
 *    - Motor_EnterState() changes state and resets state_ticks.
 *    - NO blocking delays anywhere (no Delay_ms / Delay_us).
 *
 *  Motor states (private to this file):
 *    TARE      boot: measuring the zero point of the load cell; motor locked out
 *    IDLE      motor off; waits MOTOR_REVERSE_DEAD_TICKS after a stop before
 *              applying a new direction
 *    RUNNING   direction applied, speed ramping toward the commanded value
 *    REVERSING direction change requested while moving: ramp down to 0 first
 *
 *  Resources owned by Team 1 (nobody else may touch them):
 *    Timer2 + CCP1 (RC2)  -> hardware PWM for the hoist motor, ~1.22 kHz
 *    Timer1 + CCP2 (RC1)  -> 50 Hz brake-servo pulse train (ISR, see below)
 *    RA0 / RA1            -> HX711 DT / SCK
 *    RD0 / RD1            -> H-bridge IN1 / IN2
 *    RC0                  -> aux servo (reserved, driven low)
 *
 *  INTERRUPT: this file defines the project's ONLY interrupt() routine
 *  (CCP2 compare, fires twice per 20 ms, ~10 us each). mikroC allows exactly
 *  one interrupt() per project, so Team 2 / Team 3 must not define another.
 *  Today no other module uses interrupts or Timer1/Timer2/CCP.
 *
 *  Servo pulse: CCP2 runs in "software interrupt on match" mode (CCP2M=1010,
 *  pin unaffected). Each match the ISR toggles RC1 and schedules the next
 *  match: high phase = 1.0 ms (engage) or 2.0 ms (release), low phase = the
 *  rest of the 20 ms period. A 1-2 ms pulse is far shorter than a 10 ms tick,
 *  so this is the one place that is hardware-timed instead of tick-counted.
 *
 *  !!! CALIBRATION REQUIRED - see HX711_COUNTS_PER_GRAM below !!!
 * ============================================================================
 */

#include "../../Shared/System_Types.h"
#include "../Motor.h"

/* ---- Pin mapping --------------------------------------------------------- */
sbit HX711_DT              at RA0_bit;
sbit HX711_DT_Direction    at TRISA0_bit;
sbit HX711_SCK             at RA1_bit;
sbit HX711_SCK_Direction   at TRISA1_bit;

sbit MOTOR_IN1             at RD0_bit;
sbit MOTOR_IN1_Direction   at TRISD0_bit;
sbit MOTOR_IN2             at RD1_bit;
sbit MOTOR_IN2_Direction   at TRISD1_bit;

sbit AUX_SERVO             at RC0_bit;
sbit AUX_SERVO_Direction   at TRISC0_bit;
sbit BRAKE_SERVO           at RC1_bit;
sbit BRAKE_SERVO_Direction at TRISC1_bit;
sbit MOTOR_PWM_Direction   at TRISC2_bit;

/* ---- Motor state machine ------------------------------------------------- */
#define MOTOR_STATE_TARE          0
#define MOTOR_STATE_IDLE          1
#define MOTOR_STATE_RUNNING       2
#define MOTOR_STATE_REVERSING     3

/* ---- Tunable parameters (all times in 10 ms ticks) ----------------------- */

/* Motor */
#define MOTOR_RAMP_STEP_PERCENT   5     /* % change per tick (soft start/stop)       */
#define MOTOR_REVERSE_DEAD_TICKS  10    /* 100 ms of rest after a stop before moving */

/* Servo (Timer1: 20 MHz/4 = 5 MHz, prescaler 1:8 -> 1.6 us per timer count) */
#define SERVO_TICKS_ENGAGE        625   /* 1.0 ms (timer counts, not 10 ms ticks) */
#define SERVO_TICKS_RELEASE       1250  /* 2.0 ms */
#define SERVO_PERIOD_TICKS        12500 /* 20 ms  */

/* Weight / HX711 (channel A, gain 128 -> 25 clock pulses per read) */
#define HX711_COUNTS_PER_GRAM     215L  /* Calibrated for 10kg TAL220 (1mV/V); recalibrate on hardware */
#define HX711_INVERT              0     /* 1 = load cell wired so counts DEcrease with load */
#define AUTO_TARE_ON_BOOT         1     /* 1 = tare at power-up (cabin must be EMPTY) */
#define HX711_OFFSET_DEFAULT      0L    /* used only if boot-time tare fails          */
#define TARE_DISCARD_SAMPLES      4     /* HX711 settling after power-up (~400 ms)    */
#define TARE_SAMPLES              8     /* samples averaged to get the zero point     */
#define TARE_TIMEOUT_TICKS        300   /* 3.0 s: give up if HX711 never answers      */
#define WEIGHT_AVG_N              2     /* moving average length (small = faster overload reaction) */
#define OVERLOAD_DEBOUNCE_SAMPLES 1     /* consecutive averaged samples over the limit */
#define OVERLOAD_HYSTERESIS_G     50    /* overload clears below (max - this)         */

/* ---- Module state -------------------------------------------------------- */
static unsigned char motor_state;
static unsigned int  state_ticks;              /* 10 ms ticks spent in motor_state */

static signed char   tgt_dir, cur_dir;
static unsigned char tgt_speed, cur_speed;

static volatile unsigned char brake_released;  /* written by main, read by ISR (1 byte = atomic) */
static volatile unsigned char servo_level;     /* ISR only: 1 while RC1 is high */
static volatile unsigned int  servo_width;     /* ISR only: width of current pulse */

static signed long   tare_sum;
static unsigned char tare_count;

static signed long   hx_offset;
static signed long   hx_buf[WEIGHT_AVG_N];
static unsigned char hx_idx;
static unsigned long weight_g;
static unsigned char overload_flag;
static unsigned char overload_cnt;

/* ============================================================================
 *  Interrupt: brake-servo pulse generator (CCP2 compare, software mode)
 * ============================================================================ */
void interrupt()
{
    unsigned int t;

    if (PIR2.F0 && PIE2.F0) {                  /* CCP2IF && CCP2IE */
        PIR2.F0 = 0;
        t = ((unsigned int)CCPR2H << 8) | CCPR2L;      /* time of this match */

        if (servo_level) {                     /* end of pulse -> low phase */
            BRAKE_SERVO = 0;
            servo_level = 0;
            t += (SERVO_PERIOD_TICKS - servo_width);
        } else {                               /* start of pulse -> high phase */
            servo_width = brake_released ? SERVO_TICKS_RELEASE : SERVO_TICKS_ENGAGE;
            BRAKE_SERVO = 1;
            servo_level = 1;
            t += servo_width;
        }
        CCPR2H = (unsigned char)(t >> 8);
        CCPR2L = (unsigned char)(t & 0xFF);
    }
}

/* ============================================================================
 *  Helpers
 * ============================================================================ */

/* Transition to a new motor state and reset the state timer. */
static void Motor_EnterState(unsigned char new_state)
{
    motor_state = new_state;
    state_ticks = 0;
}

static void Pwm_SetPercent(unsigned char percent)
{
    unsigned int duty;                         /* 10-bit duty, period = 1024 counts */
    if (percent > 100) percent = 100;
    duty = (unsigned int)(((unsigned long)percent * 1023UL) / 100UL);
    CCPR1L  = (unsigned char)(duty >> 2);
    CCP1CON = 0x0C | (unsigned char)((duty & 0x03) << 4);   /* PWM mode + 2 LSBs */
}

static void Dir_Apply(signed char dir)
{
    if (dir == DIR_UP)        { MOTOR_IN2 = 0; MOTOR_IN1 = 1; }
    else if (dir == DIR_DOWN) { MOTOR_IN1 = 0; MOTOR_IN2 = 1; }
    else                      { MOTOR_IN1 = 0; MOTOR_IN2 = 0; }
}

/* Move cur_speed one ramp step toward 'target' and update the PWM. */
static void Speed_Ramp(unsigned char target)
{
    if (cur_speed < target) {
        cur_speed += MOTOR_RAMP_STEP_PERCENT;
        if (cur_speed > target) cur_speed = target;
        Pwm_SetPercent(cur_speed);
    }
    else if (cur_speed > target) {
        if (cur_speed - target > MOTOR_RAMP_STEP_PERCENT) cur_speed -= MOTOR_RAMP_STEP_PERCENT;
        else                                              cur_speed = target;
        Pwm_SetPercent(cur_speed);
    }
}

/* ---- HX711 --------------------------------------------------------------- */

static signed long HX711_ReadRaw(void)
{
    unsigned long v = 0;
    unsigned char i;

    /* No delay calls: at 20 MHz one instruction = 0.2 us. The C statements
     * between the clock edges give SCK-high ~4 us and SCK-low ~1 us, inside
     * the HX711 limits (>= 0.2 us, SCK high must stay < 50 us). */
    for (i = 0; i < 24; i++) {
        HX711_SCK = 1;
        v <<= 1;
        if (HX711_DT) v |= 1;
        HX711_SCK = 0;
    }
    /* 25th pulse: selects channel A, gain 128 for the next conversion */
    HX711_SCK = 1;
    Delay_us(1);
    HX711_SCK = 0;

    if (v & 0x00800000UL) v |= 0xFF000000UL;   /* sign-extend 24 -> 32 bit */
    return (signed long)v;
}

/* Finish the boot tare: compute zero point, prefill the averaging buffer. */
static void Tare_Finish(void)
{
    unsigned char i;

    if (tare_count > TARE_DISCARD_SAMPLES)
        hx_offset = tare_sum / (tare_count - TARE_DISCARD_SAMPLES);
    else
        hx_offset = HX711_OFFSET_DEFAULT;

    for (i = 0; i < WEIGHT_AVG_N; i++) hx_buf[i] = hx_offset;
    hx_idx = 0;
    weight_g = 0;
    overload_flag = 0;
    overload_cnt = 0;
}

static void Weight_PushSample(signed long raw)
{
    signed long sum = 0;
    signed long diff;
    unsigned char i;

    hx_buf[hx_idx] = raw;
    if (++hx_idx >= WEIGHT_AVG_N) hx_idx = 0;

    for (i = 0; i < WEIGHT_AVG_N; i++) sum += hx_buf[i];
    sum = sum / WEIGHT_AVG_N;

    diff = sum - hx_offset;
#if HX711_INVERT
    diff = -diff;
#endif
    if (diff <= 0) {
        weight_g = 0;
    } else {
        weight_g = ((unsigned long)diff + (HX711_COUNTS_PER_GRAM / 2)) / HX711_COUNTS_PER_GRAM;
    }

    /* Overload with debounce + hysteresis */
    if (weight_g > MAX_ALLOWED_WEIGHT_GRAMS) {
        if (overload_cnt < 255) overload_cnt++;
        if (overload_cnt >= OVERLOAD_DEBOUNCE_SAMPLES) overload_flag = 1;
    } else if (weight_g + OVERLOAD_HYSTERESIS_G <= MAX_ALLOWED_WEIGHT_GRAMS) {
        overload_cnt  = 0;
        overload_flag = 0;
    }
    /* between (max - hysteresis) and max: keep previous state */
}

/* ============================================================================
 *  Public interface (Motor.h)
 * ============================================================================ */

void Motor_Init(void)
{
    unsigned char i;

    /* All PORTA/PORTE pins digital (same value Team 2 needs) */
    ADCON1 = 0x06;

    /* Directions (bit-level so other teams' TRIS bits are untouched) */
    HX711_DT_Direction    = 1;
    HX711_SCK_Direction   = 0;
    MOTOR_IN1_Direction   = 0;
    MOTOR_IN2_Direction   = 0;
    MOTOR_PWM_Direction   = 0;
    BRAKE_SERVO_Direction = 0;
    AUX_SERVO_Direction   = 0;

    HX711_SCK   = 0;
    AUX_SERVO   = 0;
    BRAKE_SERVO = 0;
    Dir_Apply(DIR_STOP);

    /* Timer2 + CCP1: PWM ~1.22 kHz (PR2 = 255, prescaler 1:16), duty 0 */
    PR2     = 255;
    T2CON   = 0x06;                            /* TMR2 on, 1:16 */
    CCPR1L  = 0;
    CCP1CON = 0x0C;

    /* Motor command state */
    tgt_dir = cur_dir = DIR_STOP;
    tgt_speed = cur_speed = 0;

    /* Brake: power-up state is ENGAGED (safe). Start the servo pulse train. */
    brake_released = 0;
    servo_level    = 0;
    servo_width    = SERVO_TICKS_ENGAGE;

    T1CON   = 0x30;                            /* Timer1 off, 1:8, internal clock */
    TMR1H   = 0;
    TMR1L   = 0;
    CCP2CON = 0x00;
    CCPR2H  = (unsigned char)(3125 >> 8);      /* first pulse starts after 5 ms */
    CCPR2L  = (unsigned char)(3125 & 0xFF);
    PIR2.F0 = 0;                               /* CCP2IF */
    CCP2CON = 0x0A;                            /* compare, software interrupt, pin unaffected */
    PIE2.F0 = 1;                               /* CCP2IE */
    INTCON.F6 = 1;                             /* PEIE   */
    T1CON   = 0x31;                            /* Timer1 on */
    INTCON.F7 = 1;                             /* GIE    */

    /* Weight */
    hx_offset  = HX711_OFFSET_DEFAULT;
    tare_sum   = 0;
    tare_count = 0;
    for (i = 0; i < WEIGHT_AVG_N; i++) hx_buf[i] = hx_offset;
    hx_idx = 0;
    weight_g = 0;
    overload_flag = 0;
    overload_cnt = 0;

#if AUTO_TARE_ON_BOOT
    Motor_EnterState(MOTOR_STATE_TARE);        /* ~1.2 s, runs inside Motor_Update() */
#else
    Motor_EnterState(MOTOR_STATE_IDLE);
#endif
}

void Motor_Update(void)
{
    signed long raw;

    /* 1. Advance the 16-bit state timer without overflowing */
    if (state_ticks < 65535u) {
        state_ticks++;
    }

    /* 2. Weight sampling (the TARE state reads its own samples) */
    if (motor_state != MOTOR_STATE_TARE && HX711_DT == 0) {
        Weight_PushSample(HX711_ReadRaw());    /* sample ready: read it (~100 us) */
    }

    /* 3. Motor finite state machine */
    switch (motor_state) {

        /* --------------------------------------------------------------------
         * TARE: measure the empty-cabin zero point. Motor outputs stay off and
         * any Motor_Set() is remembered but not executed until tare is done.
         * Weight = 0 and overload = 0 until then.
         * -------------------------------------------------------------------- */
        case MOTOR_STATE_TARE:
            if (HX711_DT == 0) {               /* fresh sample available */
                raw = HX711_ReadRaw();
                if (tare_count >= TARE_DISCARD_SAMPLES) {
                    tare_sum += raw;
                }
                tare_count++;

                if (tare_count >= (TARE_DISCARD_SAMPLES + TARE_SAMPLES)) {
                    Tare_Finish();
                    Motor_EnterState(MOTOR_STATE_IDLE);
                    break;
                }
            }
            if (state_ticks >= TARE_TIMEOUT_TICKS) {   /* HX711 missing/slow */
                Tare_Finish();
                Motor_EnterState(MOTOR_STATE_IDLE);
            }
            break;

        /* --------------------------------------------------------------------
         * IDLE: motor off. A new direction is applied only after the motor has
         * rested MOTOR_REVERSE_DEAD_TICKS (protects H-bridge and gearbox).
         * -------------------------------------------------------------------- */
        case MOTOR_STATE_IDLE:
            if (tgt_dir != DIR_STOP && state_ticks >= MOTOR_REVERSE_DEAD_TICKS) {
                cur_dir = tgt_dir;
                Dir_Apply(cur_dir);
                Motor_EnterState(MOTOR_STATE_RUNNING);
            }
            break;

        /* --------------------------------------------------------------------
         * RUNNING: direction applied; ramp speed toward the commanded value.
         * -------------------------------------------------------------------- */
        case MOTOR_STATE_RUNNING:
            if (tgt_dir != cur_dir) {          /* direction change requested */
                Motor_EnterState(MOTOR_STATE_REVERSING);
                break;
            }
            Speed_Ramp(tgt_speed);
            break;

        /* --------------------------------------------------------------------
         * REVERSING: slow to 0, release the direction pins, then rest in IDLE
         * before the new direction is applied.
         * -------------------------------------------------------------------- */
        case MOTOR_STATE_REVERSING:
            if (tgt_dir == cur_dir) {          /* command changed back: keep going */
                Motor_EnterState(MOTOR_STATE_RUNNING);
                break;
            }
            Speed_Ramp(0);
            if (cur_speed == 0) {
                Dir_Apply(DIR_STOP);
                cur_dir = DIR_STOP;
                Motor_EnterState(MOTOR_STATE_IDLE);
            }
            break;

        default:
            Motor_Stop();
            Motor_EnterState(MOTOR_STATE_IDLE);
            break;
    }
}

void Motor_Set(signed char direction, unsigned short speed_percent)
{
    if (direction == DIR_STOP || speed_percent == 0) {
        Motor_Stop();
        return;
    }
    if (speed_percent > 100) speed_percent = 100;
    tgt_dir   = direction;
    tgt_speed = (unsigned char)speed_percent;
}

void Motor_Stop(void)
{
    Pwm_SetPercent(0);                         /* immediate, no ramp */
    Dir_Apply(DIR_STOP);
    tgt_dir = cur_dir = DIR_STOP;
    tgt_speed = cur_speed = 0;

    /* Start the rest period only if the motor was actually driven. Repeated
     * Motor_Stop() calls while already idle (the controller does this every
     * tick) must not keep restarting it; TARE is left untouched. */
    if (motor_state == MOTOR_STATE_RUNNING || motor_state == MOTOR_STATE_REVERSING) {
        Motor_EnterState(MOTOR_STATE_IDLE);
    }
}

void Brake_Release(void)
{
    brake_released = 1;                        /* next pulse (<= 20 ms) is 2.0 ms */
}

void Brake_Engage(void)
{
    brake_released = 0;                        /* next pulse (<= 20 ms) is 1.0 ms */
}

unsigned long Weight_GetGrams(void)
{
    return weight_g;
}

unsigned char Weight_IsOverload(void)
{
    return overload_flag;
}
