#line 1 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_1_Motor/Code/motor.c"
#line 1 "c:/users/ahmed/desktop/college/project embeded/mini_elevator_compile/team_1_motor/code/../../shared/system_types.h"
#line 1 "c:/users/ahmed/desktop/college/project embeded/mini_elevator_compile/team_1_motor/code/../motor.h"
#line 1 "c:/users/ahmed/desktop/college/project embeded/mini_elevator_compile/team_1_motor/code/../../shared/system_types.h"
#line 28 "c:/users/ahmed/desktop/college/project embeded/mini_elevator_compile/team_1_motor/code/../motor.h"
void Motor_Init(void);


void Motor_Update(void);


void Motor_Set(signed char direction, unsigned short speed_percent);


void Motor_Stop(void);


void Brake_Release(void);


void Brake_Engage(void);


unsigned long Weight_GetGrams(void);


unsigned char Weight_IsOverload(void);
#line 46 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_1_Motor/Code/motor.c"
sbit HX711_DT at RA0_bit;
sbit HX711_DT_Direction at TRISA0_bit;
sbit HX711_SCK at RA1_bit;
sbit HX711_SCK_Direction at TRISA1_bit;

sbit MOTOR_IN1 at RD0_bit;
sbit MOTOR_IN1_Direction at TRISD0_bit;
sbit MOTOR_IN2 at RD1_bit;
sbit MOTOR_IN2_Direction at TRISD1_bit;

sbit AUX_SERVO at RC0_bit;
sbit AUX_SERVO_Direction at TRISC0_bit;
sbit BRAKE_SERVO at RC1_bit;
sbit BRAKE_SERVO_Direction at TRISC1_bit;
sbit MOTOR_PWM_Direction at TRISC2_bit;
#line 92 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_1_Motor/Code/motor.c"
static unsigned char motor_state;
static unsigned int state_ticks;

static signed char tgt_dir, cur_dir;
static unsigned char tgt_speed, cur_speed;

static volatile unsigned char brake_released;
static volatile unsigned char servo_level;
static volatile unsigned int servo_width;

static signed long tare_sum;
static unsigned char tare_count;

static signed long hx_offset;
static signed long hx_buf[ 2 ];
static unsigned char hx_idx;
static unsigned long weight_g;
static unsigned char overload_flag;
static unsigned char overload_cnt;
#line 115 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_1_Motor/Code/motor.c"
void interrupt()
{
 unsigned int t;

 if (PIR2.F0 && PIE2.F0) {
 PIR2.F0 = 0;
 t = ((unsigned int)CCPR2H << 8) | CCPR2L;

 if (servo_level) {
 BRAKE_SERVO = 0;
 servo_level = 0;
 t += ( 12500  - servo_width);
 } else {
 servo_width = brake_released ?  1250  :  625 ;
 BRAKE_SERVO = 1;
 servo_level = 1;
 t += servo_width;
 }
 CCPR2H = (unsigned char)(t >> 8);
 CCPR2L = (unsigned char)(t & 0xFF);
 }
}
#line 143 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_1_Motor/Code/motor.c"
static void Motor_EnterState(unsigned char new_state)
{
 motor_state = new_state;
 state_ticks = 0;
}

static void Pwm_SetPercent(unsigned char percent)
{
 unsigned int duty;
 if (percent > 100) percent = 100;
 duty = (unsigned int)(((unsigned long)percent * 1023UL) / 100UL);
 CCPR1L = (unsigned char)(duty >> 2);
 CCP1CON = 0x0C | (unsigned char)((duty & 0x03) << 4);
}

static void Dir_Apply(signed char dir)
{
 if (dir ==  1 ) { MOTOR_IN2 = 0; MOTOR_IN1 = 1; }
 else if (dir ==  -1 ) { MOTOR_IN1 = 0; MOTOR_IN2 = 1; }
 else { MOTOR_IN1 = 0; MOTOR_IN2 = 0; }
}


static void Speed_Ramp(unsigned char target)
{
 if (cur_speed < target) {
 cur_speed +=  5 ;
 if (cur_speed > target) cur_speed = target;
 Pwm_SetPercent(cur_speed);
 }
 else if (cur_speed > target) {
 if (cur_speed - target >  5 ) cur_speed -=  5 ;
 else cur_speed = target;
 Pwm_SetPercent(cur_speed);
 }
}



static signed long HX711_ReadRaw(void)
{
 unsigned long v = 0;
 unsigned char i;
#line 190 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_1_Motor/Code/motor.c"
 for (i = 0; i < 24; i++) {
 HX711_SCK = 1;
 v <<= 1;
 if (HX711_DT) v |= 1;
 HX711_SCK = 0;
 }

 HX711_SCK = 1;
 Delay_us(1);
 HX711_SCK = 0;

 if (v & 0x00800000UL) v |= 0xFF000000UL;
 return (signed long)v;
}


static void Tare_Finish(void)
{
 unsigned char i;

 if (tare_count >  4 )
 hx_offset = tare_sum / (tare_count -  4 );
 else
 hx_offset =  0L ;

 for (i = 0; i <  2 ; i++) hx_buf[i] = hx_offset;
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
 if (++hx_idx >=  2 ) hx_idx = 0;

 for (i = 0; i <  2 ; i++) sum += hx_buf[i];
 sum = sum /  2 ;

 diff = sum - hx_offset;
#line 238 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_1_Motor/Code/motor.c"
 if (diff <= 0) {
 weight_g = 0;
 } else {
 weight_g = ((unsigned long)diff + ( 215L  / 2)) /  215L ;
 }


 if (weight_g >  1500UL ) {
 if (overload_cnt < 255) overload_cnt++;
 if (overload_cnt >=  1 ) overload_flag = 1;
 } else if (weight_g +  50  <=  1500UL ) {
 overload_cnt = 0;
 overload_flag = 0;
 }

}
#line 259 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_1_Motor/Code/motor.c"
void Motor_Init(void)
{
 unsigned char i;


 ADCON1 = 0x06;


 HX711_DT_Direction = 1;
 HX711_SCK_Direction = 0;
 MOTOR_IN1_Direction = 0;
 MOTOR_IN2_Direction = 0;
 MOTOR_PWM_Direction = 0;
 BRAKE_SERVO_Direction = 0;
 AUX_SERVO_Direction = 0;

 HX711_SCK = 0;
 AUX_SERVO = 0;
 BRAKE_SERVO = 0;
 Dir_Apply( 0 );


 PR2 = 255;
 T2CON = 0x06;
 CCPR1L = 0;
 CCP1CON = 0x0C;


 tgt_dir = cur_dir =  0 ;
 tgt_speed = cur_speed = 0;


 brake_released = 0;
 servo_level = 0;
 servo_width =  625 ;

 T1CON = 0x30;
 TMR1H = 0;
 TMR1L = 0;
 CCP2CON = 0x00;
 CCPR2H = (unsigned char)(3125 >> 8);
 CCPR2L = (unsigned char)(3125 & 0xFF);
 PIR2.F0 = 0;
 CCP2CON = 0x0A;
 PIE2.F0 = 1;
 INTCON.F6 = 1;
 T1CON = 0x31;
 INTCON.F7 = 1;


 hx_offset =  0L ;
 tare_sum = 0;
 tare_count = 0;
 for (i = 0; i <  2 ; i++) hx_buf[i] = hx_offset;
 hx_idx = 0;
 weight_g = 0;
 overload_flag = 0;
 overload_cnt = 0;


 Motor_EnterState( 0 );
#line 323 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_1_Motor/Code/motor.c"
}

void Motor_Update(void)
{
 signed long raw;


 if (state_ticks < 65535u) {
 state_ticks++;
 }


 if (motor_state !=  0  && HX711_DT == 0) {
 Weight_PushSample(HX711_ReadRaw());
 }


 switch (motor_state) {
#line 347 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_1_Motor/Code/motor.c"
 case  0 :
 if (HX711_DT == 0) {
 raw = HX711_ReadRaw();
 if (tare_count >=  4 ) {
 tare_sum += raw;
 }
 tare_count++;

 if (tare_count >= ( 4  +  8 )) {
 Tare_Finish();
 Motor_EnterState( 1 );
 break;
 }
 }
 if (state_ticks >=  300 ) {
 Tare_Finish();
 Motor_EnterState( 1 );
 }
 break;
#line 371 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_1_Motor/Code/motor.c"
 case  1 :
 if (tgt_dir !=  0  && state_ticks >=  10 ) {
 cur_dir = tgt_dir;
 Dir_Apply(cur_dir);
 Motor_EnterState( 2 );
 }
 break;
#line 382 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_1_Motor/Code/motor.c"
 case  2 :
 if (tgt_dir != cur_dir) {
 Motor_EnterState( 3 );
 break;
 }
 Speed_Ramp(tgt_speed);
 break;
#line 394 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_1_Motor/Code/motor.c"
 case  3 :
 if (tgt_dir == cur_dir) {
 Motor_EnterState( 2 );
 break;
 }
 Speed_Ramp(0);
 if (cur_speed == 0) {
 Dir_Apply( 0 );
 cur_dir =  0 ;
 Motor_EnterState( 1 );
 }
 break;

 default:
 Motor_Stop();
 Motor_EnterState( 1 );
 break;
 }
}

void Motor_Set(signed char direction, unsigned short speed_percent)
{
 if (direction ==  0  || speed_percent == 0) {
 Motor_Stop();
 return;
 }
 if (speed_percent > 100) speed_percent = 100;
 tgt_dir = direction;
 tgt_speed = (unsigned char)speed_percent;
}

void Motor_Stop(void)
{
 Pwm_SetPercent(0);
 Dir_Apply( 0 );
 tgt_dir = cur_dir =  0 ;
 tgt_speed = cur_speed = 0;
#line 435 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_1_Motor/Code/motor.c"
 if (motor_state ==  2  || motor_state ==  3 ) {
 Motor_EnterState( 1 );
 }
}

void Brake_Release(void)
{
 brake_released = 1;
}

void Brake_Engage(void)
{
 brake_released = 0;
}

unsigned long Weight_GetGrams(void)
{
 return weight_g;
}

unsigned char Weight_IsOverload(void)
{
 return overload_flag;
}
