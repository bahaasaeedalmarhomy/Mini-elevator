#line 1 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/main.c"
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
#line 23 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/main.c"
void main() {
#line 32 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/main.c"
 Motor_Init();
 Inputs_Init();
 Controller_Init();
#line 39 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/main.c"
 while (1) {

 Motor_Update();


 Inputs_Update();


 Controller_Update();


 Delay_ms(10);
 }
}
