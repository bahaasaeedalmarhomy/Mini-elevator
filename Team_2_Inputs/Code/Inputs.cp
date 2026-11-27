#line 1 "D:/Programming Projects/embedded_project/Mini-elevator/Team_2_Inputs/Code/Inputs.c"
#line 1 "d:/programming projects/embedded_project/mini-elevator/team_2_inputs/code/../inputs.h"
#line 1 "d:/programming projects/embedded_project/mini-elevator/team_2_inputs/code/../../shared/system_types.h"
#line 30 "d:/programming projects/embedded_project/mini-elevator/team_2_inputs/code/../inputs.h"
void Inputs_Init(void);


void Inputs_Update(void);


unsigned char Inputs_GetNewFloorRequest(unsigned char *floor);


unsigned char Inputs_GetCurrentFloor(void);


unsigned char Inputs_IsFloorSensorFault(void);


void Inputs_DisplayStatus(
 unsigned char current_floor,
 unsigned char target_floor,
 unsigned char controller_state,
 unsigned long weight_grams
);


void Inputs_Buzzer(unsigned char event_code);
#line 1 "d:/programming projects/embedded_project/mini-elevator/team_2_inputs/code/../keypad_config.h"
#line 1 "d:/programming projects/embedded_project/mini-elevator/team_2_inputs/code/../../shared/system_types.h"
#line 51 "D:/Programming Projects/embedded_project/Mini-elevator/Team_2_Inputs/Code/Inputs.c"
static unsigned char kp_last_key;
static unsigned char kp_stable_cnt;
static unsigned char btn_last_mask;
static unsigned char btn_stable_cnt;
static unsigned char btn_stable_mask;
static unsigned char req_queue[ 8 ];
static unsigned char req_head;
static unsigned char req_tail;
static unsigned char req_count;


static unsigned char hall_last_raw;
static unsigned char hall_stable_cnt;
static unsigned char hall_stable_mask;


static unsigned char bz_active_event;
static unsigned char bz_tick_cnt;


static char lcd_cache[2][17];
static char lcd_line_buf[17];
#line 78 "D:/Programming Projects/embedded_project/Mini-elevator/Team_2_Inputs/Code/Inputs.c"
static void lcd_write_nibble(unsigned char nibble) {

 PORTD = (unsigned char)((PORTD & 0x07) | ((nibble & 0x0F) << 4));

 Delay_us(1);
  PORTD.F3  = 1;
 Delay_us(5);
  PORTD.F3  = 0;
 Delay_us(5);
}

static void lcd_send_byte(unsigned char value, unsigned char is_data) {
  PORTD.F2  = is_data ? 1 : 0;
 lcd_write_nibble((unsigned char)(value >> 4));
 lcd_write_nibble((unsigned char)(value & 0x0F));
 Delay_us(50);
}

static void lcd_hw_init(void) {

  TRISD.F2  = 0;
  TRISD.F3  = 0;
  TRISD.F4  = 0;
  TRISD.F5  = 0;
  TRISD.F6  = 0;
  TRISD.F7  = 0;

  PORTD.F2  = 0;
  PORTD.F3  = 0;
  PORTD.F4  = 0;
  PORTD.F5  = 0;
  PORTD.F6  = 0;
  PORTD.F7  = 0;


 Delay_ms(40);
 lcd_write_nibble(0x03);
 Delay_ms(5);
 lcd_write_nibble(0x03);
 Delay_us(200);
 lcd_write_nibble(0x03);
 Delay_us(200);
 lcd_write_nibble(0x02);
 Delay_us(200);

 lcd_send_byte(0x28, 0);
 lcd_send_byte(0x0C, 0);
 lcd_send_byte(0x01, 0);
 Delay_ms(2);
 lcd_send_byte(0x06, 0);
}


static void lcd_write_line(unsigned char row, char *ram_text) {
 unsigned char i;

 lcd_send_byte(row ? 0xC0 : 0x80, 0);
 for (i = 0; i < 16; i++) {
 lcd_send_byte((unsigned char)ram_text[i], 1);
 }
}
#line 144 "D:/Programming Projects/embedded_project/Mini-elevator/Team_2_Inputs/Code/Inputs.c"
static unsigned char buf_put_const_str(char *buf, unsigned char pos, const char *s) {
 while (*s != 0 && pos < 16) {
 buf[pos++] = *s++;
 }
 return pos;
}

static unsigned char buf_put_ulong(char *buf, unsigned char pos, unsigned long value) {
 unsigned char started = 0;
 unsigned char d;
 unsigned int v16;

 if (value > 65000UL) {
 value = 65000UL;
 }
 v16 = (unsigned int)value;

 d = 0;
 while (v16 >= 10000u) { v16 -= 10000u; d++; }
 if (d != 0) {
 started = 1;
 if (pos < 16) buf[pos++] = (char)('0' + d);
 }

 d = 0;
 while (v16 >= 1000u) { v16 -= 1000u; d++; }
 if (d != 0 || started) {
 started = 1;
 if (pos < 16) buf[pos++] = (char)('0' + d);
 }

 d = 0;
 while (v16 >= 100u) { v16 -= 100u; d++; }
 if (d != 0 || started) {
 started = 1;
 if (pos < 16) buf[pos++] = (char)('0' + d);
 }

 d = 0;
 while (v16 >= 10u) { v16 -= 10u; d++; }
 if (d != 0 || started) {
 started = 1;
 if (pos < 16) buf[pos++] = (char)('0' + d);
 }

 if (pos < 16) {
 buf[pos++] = (char)('0' + (unsigned char)v16);
 }
 return pos;
}

static char floor_to_char(unsigned char floor) {
 return  ((floor) <= 3 )  ? (char)('0' + floor) : '-';
}

static unsigned char buf_put_state(char *buf, unsigned char pos, unsigned char state) {
 switch (state) {
 case  0 : return buf_put_const_str(buf, pos, "WAIT");
 case  1 : return buf_put_const_str(buf, pos, "IDLE");
 case  2 : return buf_put_const_str(buf, pos, "BRK-");
 case  3 : return buf_put_const_str(buf, pos, "UP");
 case  4 : return buf_put_const_str(buf, pos, "DOWN");
 case  5 : return buf_put_const_str(buf, pos, "STOP");
 case  6 : return buf_put_const_str(buf, pos, "BRK+");
 case  7 : return buf_put_const_str(buf, pos, "OVRLOAD");
 case  8 : return buf_put_const_str(buf, pos, "FAULT");
 default: return buf_put_const_str(buf, pos, "???");
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
#line 244 "D:/Programming Projects/embedded_project/Mini-elevator/Team_2_Inputs/Code/Inputs.c"
static void keypad_rows_idle(void) {
#line 248 "D:/Programming Projects/embedded_project/Mini-elevator/Team_2_Inputs/Code/Inputs.c"
 PORTB = 0xFF;
}
#line 260 "D:/Programming Projects/embedded_project/Mini-elevator/Team_2_Inputs/Code/Inputs.c"
static unsigned char keypad_scan_raw(void) {
 unsigned char row;
 unsigned char key = 0;

 for (row = 0; row < 4 && key == 0; row++) {
 if (row == 0) {
 PORTB = 0xEF;
 }
 else if (row == 1) {
 PORTB = 0xDF;
 }
 else if (row == 2) {
 PORTB = 0xBF;
 }
 else {
 PORTB = 0x7F;
 }

 Delay_us(20);

 if ( PORTB.F0  == 0) {
 key = (unsigned char)(row * 4 + 1);
 }
 else if ( PORTB.F1  == 0) {
 key = (unsigned char)(row * 4 + 2);
 }
 else if ( PORTB.F2  == 0) {
 key = (unsigned char)(row * 4 + 3);
 }
 else if ( PORTB.F3  == 0) {
 key = (unsigned char)(row * 4 + 4);
 }
 }

 keypad_rows_idle();
 return key;
}


static unsigned char landing_buttons_read_raw_mask(void) {
 unsigned char mask = 0;

 if ( PORTA.F2  ==  1 ) mask |= 0x01;
 if ( PORTA.F3  ==  1 ) mask |= 0x02;
 if ( PORTA.F4  ==  1 ) mask |= 0x04;
 if ( PORTA.F5  ==  1 ) mask |= 0x08;

 return mask;
}

static void request_queue_push(unsigned char floor) {
 if (! ((floor) <= 3 ) ) {
 return;
 }
 if (req_count >=  8 ) {
 return;
 }

 req_queue[req_tail] = floor;
 req_tail++;
 if (req_tail >=  8 ) {
 req_tail = 0;
 }
 req_count++;
}


static void handle_debounced_keypad(unsigned char key) {
 switch (key) {
 case 14:
 request_queue_push( 0 );
 break;
 case 9:
 request_queue_push( 1 );
 break;
 case 10:
 request_queue_push( 2 );
 break;
 case 11:
 request_queue_push( 3 );
 break;
 default:
 break;
 }
}
#line 350 "D:/Programming Projects/embedded_project/Mini-elevator/Team_2_Inputs/Code/Inputs.c"
static unsigned char hall_read_raw_mask(void) {
 unsigned char mask = 0;

 if ( PORTC.F3  ==  1 ) mask |= 0x01;
 if ( PORTC.F4  ==  1 ) mask |= 0x02;
 if ( PORTC.F5  ==  1 ) mask |= 0x04;
 if ( PORTC.F6  ==  1 ) mask |= 0x08;

 return mask;
}
#line 365 "D:/Programming Projects/embedded_project/Mini-elevator/Team_2_Inputs/Code/Inputs.c"
static void buzzer_service_tick(void) {
 unsigned char output_on = 0;
 unsigned char period = 0;

 switch (bz_active_event) {
 case  1 :

 if (bz_tick_cnt <  15 ) {
 output_on = 1;
 }
 else {
 bz_active_event = 0;
 }
 break;

 case  4 :

 if (bz_tick_cnt <  10 ) {
 output_on = 1;
 }
 else {
 bz_active_event = 0;
 }
 break;

 case  2 :

 period =  20 ;
 output_on = (bz_tick_cnt <  10 ) ? 1 : 0;
 break;

 case  3 :

 period =  60 ;
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

  PORTC.F7  = output_on;
}
#line 424 "D:/Programming Projects/embedded_project/Mini-elevator/Team_2_Inputs/Code/Inputs.c"
void Inputs_Init(void) {
 unsigned char pos;


 ADCON1 = 0x06;
 CMCON = 0x07;
 TRISE.F4 = 0;
 OPTION_REG.F7 = 0;


  TRISB.F4  = 0;
  TRISB.F5  = 0;
  TRISB.F6  = 0;
  TRISB.F7  = 0;
  TRISB.F0  = 1;
  TRISB.F1  = 1;
  TRISB.F2  = 1;
  TRISB.F3  = 1;
 keypad_rows_idle();


  TRISA.F2  = 1;
  TRISA.F3  = 1;
  TRISA.F4  = 1;
  TRISA.F5  = 1;


  TRISC.F3  = 1;
  TRISC.F4  = 1;
  TRISC.F5  = 1;
  TRISC.F6  = 1;


  TRISC.F7  = 0;
  PORTC.F7  = 0;


 kp_last_key = 0;
 kp_stable_cnt = 0;
 btn_stable_mask = landing_buttons_read_raw_mask();
 btn_last_mask = btn_stable_mask;
 btn_stable_cnt = 0;
 req_head = 0;
 req_tail = 0;
 req_count = 0;

 hall_stable_mask = hall_read_raw_mask();
 hall_last_raw = hall_stable_mask;
 hall_stable_cnt = 0;

 bz_active_event = 0;
 bz_tick_cnt = 0;


 lcd_hw_init();
 for (pos = 0; pos < 17; pos++) {
 lcd_cache[0][pos] = 0;
 lcd_cache[1][pos] = 0;
 }

 pos = buf_put_const_str(lcd_line_buf, 0, "  MINI ELEVATOR ");
 buf_pad_line(lcd_line_buf, pos);
 lcd_write_line(0, lcd_line_buf);

 pos = buf_put_const_str(lcd_line_buf, 0, "   Starting...  ");
 buf_pad_line(lcd_line_buf, pos);
 lcd_write_line(1, lcd_line_buf);
}

void Inputs_Update(void) {
 unsigned char raw_key;
 unsigned char raw_btn;
 unsigned char pressed_edges;
 unsigned char raw_hall;


 raw_key = keypad_scan_raw();
 if (raw_key != kp_last_key) {
 kp_last_key = raw_key;
 kp_stable_cnt = 0;
 }
 else if (kp_stable_cnt <  2 ) {
 kp_stable_cnt++;
 if (kp_stable_cnt ==  2  && raw_key != 0) {
 handle_debounced_keypad(raw_key);
 }
 }


 raw_btn = landing_buttons_read_raw_mask();
 if (raw_btn != btn_last_mask) {
 btn_last_mask = raw_btn;
 btn_stable_cnt = 0;
 }
 else if (btn_stable_cnt <  2 ) {
 btn_stable_cnt++;
 if (btn_stable_cnt ==  2 ) {
 pressed_edges = (unsigned char)(raw_btn & (unsigned char)(~btn_stable_mask));
 btn_stable_mask = raw_btn;
 if (pressed_edges & 0x01) request_queue_push( 0 );
 if (pressed_edges & 0x02) request_queue_push( 1 );
 if (pressed_edges & 0x04) request_queue_push( 2 );
 if (pressed_edges & 0x08) request_queue_push( 3 );
 }
 }


 raw_hall = hall_read_raw_mask();
 if (raw_hall != hall_last_raw) {
 hall_last_raw = raw_hall;
 hall_stable_cnt = 0;
 }
 else if (hall_stable_cnt <  2 ) {
 hall_stable_cnt++;
 if (hall_stable_cnt ==  2 ) {
 hall_stable_mask = raw_hall;
 }
 }


 buzzer_service_tick();
}

unsigned char Inputs_GetNewFloorRequest(unsigned char *floor) {
 if (floor == 0 || req_count == 0) {
 return 0;
 }

 *floor = req_queue[req_head];
 req_head++;
 if (req_head >=  8 ) {
 req_head = 0;
 }
 req_count--;
 return 1;
}

unsigned char Inputs_GetCurrentFloor(void) {
 switch (hall_stable_mask) {
 case 0x01: return  0 ;
 case 0x02: return  1 ;
 case 0x04: return  2 ;
 case 0x08: return  3 ;
 default: return  255 ;
 }
}

unsigned char Inputs_IsFloorSensorFault(void) {

 return ((hall_stable_mask & (unsigned char)(hall_stable_mask - 1)) != 0) ? 1 : 0;
}

void Inputs_DisplayStatus(
 unsigned char current_floor,
 unsigned char target_floor,
 unsigned char controller_state,
 unsigned long weight_grams
) {
 unsigned char pos;


 if (bz_active_event ==  2  && controller_state !=  7 ) {
 bz_active_event = 0;
  PORTC.F7  = 0;
 }
 else if (bz_active_event ==  3  && controller_state !=  8 ) {
 bz_active_event = 0;
  PORTC.F7  = 0;
 }


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


 pos = buf_put_const_str(lcd_line_buf, 0, "W: ");
 pos = buf_put_ulong(lcd_line_buf, pos, weight_grams);
 if (pos < 16) {
 lcd_line_buf[pos++] = 'g';
 }
 if (pos < 16) {
 lcd_line_buf[pos++] = ' ';
 }
 if (weight_grams >  1500UL  || controller_state ==  7 ) {
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
 case  1 :
 case  4 :

 if (bz_active_event ==  2  ||
 bz_active_event ==  3 ) {
 return;
 }
 bz_active_event = event_code;
 bz_tick_cnt = 0;
 break;

 case  2 :

 if (bz_active_event ==  3 ) {
 return;
 }
 if (bz_active_event !=  2 ) {
 bz_active_event =  2 ;
 bz_tick_cnt = 0;
 }
 break;

 case  3 :
 if (bz_active_event !=  3 ) {
 bz_active_event =  3 ;
 bz_tick_cnt = 0;
 }
 break;

 default:
 bz_active_event = 0;
 bz_tick_cnt = 0;
  PORTC.F7  = 0;
 break;
 }
}
