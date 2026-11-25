#line 1 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/Controller.c"
#line 1 "c:/users/ahmed/desktop/college/project embeded/mini_elevator_compile/team_3_controller/code/../../shared/system_types.h"
#line 1 "c:/users/ahmed/desktop/college/project embeded/mini_elevator_compile/team_3_controller/code/../../team_1_motor/motor.h"
#line 1 "c:/users/ahmed/desktop/college/project embeded/mini_elevator_compile/team_3_controller/code/../../team_1_motor/../shared/system_types.h"
#line 28 "c:/users/ahmed/desktop/college/project embeded/mini_elevator_compile/team_3_controller/code/../../team_1_motor/motor.h"
void Motor_Init(void);


void Motor_Update(void);


void Motor_Set(signed char direction, unsigned short speed_percent);


void Motor_Stop(void);


void Brake_Release(void);


void Brake_Engage(void);


unsigned long Weight_GetGrams(void);


unsigned char Weight_IsOverload(void);
#line 1 "c:/users/ahmed/desktop/college/project embeded/mini_elevator_compile/team_3_controller/code/../../team_2_inputs/inputs.h"
#line 1 "c:/users/ahmed/desktop/college/project embeded/mini_elevator_compile/team_3_controller/code/../../team_2_inputs/../shared/system_types.h"
#line 30 "c:/users/ahmed/desktop/college/project embeded/mini_elevator_compile/team_3_controller/code/../../team_2_inputs/inputs.h"
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
#line 1 "c:/users/ahmed/desktop/college/project embeded/mini_elevator_compile/team_3_controller/code/../controller.h"
#line 1 "c:/users/ahmed/desktop/college/project embeded/mini_elevator_compile/team_3_controller/code/../../shared/system_types.h"
#line 21 "c:/users/ahmed/desktop/college/project embeded/mini_elevator_compile/team_3_controller/code/../controller.h"
void Controller_Init(void);


void Controller_Update(void);


unsigned char Controller_GetState(void);


unsigned char Controller_GetCurrentFloor(void);


unsigned char Controller_GetTargetFloor(void);
#line 1 "c:/users/ahmed/desktop/college/project embeded/mini_elevator_compile/team_3_controller/code/../requesthandler.h"
#line 1 "c:/users/ahmed/desktop/college/project embeded/mini_elevator_compile/team_3_controller/code/../../shared/system_types.h"
#line 21 "c:/users/ahmed/desktop/college/project embeded/mini_elevator_compile/team_3_controller/code/../requesthandler.h"
void RequestHandler_Init(void);


void RequestHandler_Add(unsigned char floor);


unsigned char RequestHandler_HasRequests(void);


unsigned char RequestHandler_Contains(unsigned char floor);


unsigned char RequestHandler_GetNext(void);


unsigned char RequestHandler_GetNextOptimal(unsigned char current_floor, signed char direction);


void RequestHandler_Remove(unsigned char floor);


void RequestHandler_Clear(void);


unsigned char RequestHandler_GetCount(void);
#line 28 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/Controller.c"
static unsigned char controller_state =  0 ;
static unsigned char current_floor =  255 ;
static unsigned char target_floor =  255 ;
static signed char direction =  0 ;
static signed char last_direction =  0 ;


static unsigned int state_ticks = 0;
static unsigned int startup_ticks = 0;
static unsigned int travel_ticks = 0;
#line 42 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/Controller.c"
static void Controller_EnterState(unsigned char new_state) {
 controller_state = new_state;
 state_ticks = 0;
}
#line 50 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/Controller.c"
static void Controller_ReadRequests(void) {
 unsigned char requested_floor =  255 ;

 if (Inputs_GetNewFloorRequest(&requested_floor) != 0) {
 if ( ((requested_floor) <= 3 ) ) {
 RequestHandler_Add(requested_floor);
 }
 }
}
#line 63 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/Controller.c"
static void Controller_UpdateCurrentFloor(void) {
 current_floor = Inputs_GetCurrentFloor();
}
#line 72 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/Controller.c"
void Controller_Init(void) {
 controller_state =  0 ;
 current_floor =  255 ;
 target_floor =  255 ;
 direction =  0 ;
 last_direction =  0 ;

 state_ticks = 0;
 startup_ticks = 0;
 travel_ticks = 0;

 RequestHandler_Init();


 Motor_Stop();
 Brake_Engage();


 Inputs_Buzzer( 4 );
}
#line 97 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/Controller.c"
void Controller_Update(void) {

 Controller_ReadRequests();
 Controller_UpdateCurrentFloor();


 if (state_ticks < 65535u) {
 state_ticks++;
 }
 if (startup_ticks < 65535u) {
 startup_ticks++;
 }


 if (controller_state ==  3  ||
 controller_state ==  4  ||
 controller_state ==  2 ) {


 if (Inputs_IsFloorSensorFault() != 0) {
 Motor_Stop();
 Brake_Engage();
 Inputs_Buzzer( 3 );
 Controller_EnterState( 8 );
 }

 else if (Weight_IsOverload() != 0) {
 Motor_Stop();
 Brake_Engage();
 Inputs_Buzzer( 2 );
 Controller_EnterState( 7 );
 }
 }


 switch (controller_state) {
#line 138 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/Controller.c"
 case  0 :
 Motor_Stop();
 Brake_Engage();

 if (Inputs_IsFloorSensorFault() != 0) {
 Inputs_Buzzer( 3 );
 Controller_EnterState( 8 );
 }
 else if (current_floor !=  255 ) {

 Controller_EnterState( 1 );
 }
 else if (startup_ticks >=  500 ) {

 Inputs_Buzzer( 3 );
 Controller_EnterState( 8 );
 }
 break;
#line 161 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/Controller.c"
 case  1 :
 Motor_Stop();
 Brake_Engage();


 if (Inputs_IsFloorSensorFault() != 0) {
 Inputs_Buzzer( 3 );
 Controller_EnterState( 8 );
 break;
 }

 if (Weight_IsOverload() != 0) {
 Inputs_Buzzer( 2 );
 Controller_EnterState( 7 );
 break;
 }


 if (RequestHandler_HasRequests() != 0) {
 target_floor = RequestHandler_GetNextOptimal(current_floor, last_direction);

 if (target_floor ==  255 ) {
 break;
 }


 if (target_floor == current_floor) {
 RequestHandler_Remove(target_floor);
 Inputs_Buzzer( 1 );
 target_floor =  255 ;
 direction =  0 ;
 last_direction =  0 ;
 }

 else if (target_floor > current_floor) {
 direction =  1 ;
 last_direction =  1 ;
 Brake_Release();
 Controller_EnterState( 2 );
 }

 else if (target_floor < current_floor) {
 direction =  -1 ;
 last_direction =  -1 ;
 Brake_Release();
 Controller_EnterState( 2 );
 }
 }
 else {
 last_direction =  0 ;
 }
 break;
#line 218 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/Controller.c"
 case  2 :

 if (current_floor !=  255  && direction !=  0 ) {
 unsigned char optimal = RequestHandler_GetNextOptimal(current_floor, direction);
 if (optimal !=  255 ) {
 target_floor = optimal;
 }
 }

 if (state_ticks >=  30 ) {
 travel_ticks = 0;
 if (direction ==  1 ) {
 Motor_Set( 1 ,  65 );
 Controller_EnterState( 3 );
 }
 else if (direction ==  -1 ) {
 Motor_Set( -1 ,  65 );
 Controller_EnterState( 4 );
 }
 else {

 Motor_Stop();
 Brake_Engage();
 Controller_EnterState( 1 );
 }
 }
 break;
#line 250 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/Controller.c"
 case  3 :
 Motor_Set( 1 ,  65 );

 if (travel_ticks < 65535u) {
 travel_ticks++;
 }


 if (travel_ticks >=  3000 ) {
 Motor_Stop();
 Brake_Engage();
 Inputs_Buzzer( 3 );
 Controller_EnterState( 8 );
 break;
 }


 if (current_floor !=  255  &&
 (current_floor == target_floor || RequestHandler_Contains(current_floor) != 0)) {
 target_floor = current_floor;
 Motor_Stop();
 Controller_EnterState( 5 );
 }
 break;
#line 279 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/Controller.c"
 case  4 :
 Motor_Set( -1 ,  65 );

 if (travel_ticks < 65535u) {
 travel_ticks++;
 }


 if (travel_ticks >=  3000 ) {
 Motor_Stop();
 Brake_Engage();
 Inputs_Buzzer( 3 );
 Controller_EnterState( 8 );
 break;
 }


 if (current_floor !=  255  &&
 (current_floor == target_floor || RequestHandler_Contains(current_floor) != 0)) {
 target_floor = current_floor;
 Motor_Stop();
 Controller_EnterState( 5 );
 }
 break;
#line 308 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/Controller.c"
 case  5 :
 Motor_Stop();

 if (state_ticks >=  5 ) {
 Brake_Engage();
 Controller_EnterState( 6 );
 }
 break;
#line 321 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/Controller.c"
 case  6 :
 Motor_Stop();

 if (state_ticks >=  30 ) {
 if (current_floor == target_floor && target_floor !=  255 ) {
 RequestHandler_Remove(target_floor);
 Inputs_Buzzer( 1 );
 target_floor =  255 ;
 last_direction = direction;
 direction =  0 ;
 Controller_EnterState( 1 );
 }
 else {
 Controller_EnterState( 1 );
 }
 }
 break;
#line 343 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/Controller.c"
 case  7 :
 Motor_Stop();
 Brake_Engage();

 if (Weight_IsOverload() == 0) {

 Controller_EnterState( 1 );
 }
 break;
#line 357 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/Controller.c"
 case  8 :
 Motor_Stop();
 Brake_Engage();


 if (Inputs_IsFloorSensorFault() == 0 && current_floor !=  255 ) {
 startup_ticks = 0;
 travel_ticks = 0;
 Controller_EnterState( 1 );
 }
 break;

 default:
 Motor_Stop();
 Brake_Engage();
 Controller_EnterState( 8 );
 break;
 }


 Inputs_DisplayStatus(current_floor,
 target_floor,
 controller_state,
 Weight_GetGrams());
}
#line 386 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/Controller.c"
unsigned char Controller_GetState(void) {
 return controller_state;
}
#line 393 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/Controller.c"
unsigned char Controller_GetCurrentFloor(void) {
 return current_floor;
}
#line 400 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/Controller.c"
unsigned char Controller_GetTargetFloor(void) {
 return target_floor;
}
