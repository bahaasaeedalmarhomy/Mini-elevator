#line 1 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/RequestHandler.c"
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
#line 15 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/RequestHandler.c"
static unsigned char requests[ 4 ];
static unsigned char request_count = 0;
#line 21 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/RequestHandler.c"
void RequestHandler_Init(void) {
 unsigned char i;
 request_count = 0;
 for (i = 0; i <  4 ; i++) {
 requests[i] =  255 ;
 }
}
#line 33 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/RequestHandler.c"
unsigned char RequestHandler_Contains(unsigned char floor) {
 unsigned char i;
 for (i = 0; i < request_count; i++) {
 if (requests[i] == floor) {
 return 1;
 }
 }
 return 0;
}
#line 47 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/RequestHandler.c"
void RequestHandler_Add(unsigned char floor) {

 if (floor >  3 ) {
 return;
 }


 if (RequestHandler_Contains(floor) != 0) {
 return;
 }


 if (request_count <  4 ) {
 requests[request_count] = floor;
 request_count++;
 }
}
#line 68 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/RequestHandler.c"
unsigned char RequestHandler_HasRequests(void) {
 return (request_count > 0) ? 1 : 0;
}
#line 76 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/RequestHandler.c"
unsigned char RequestHandler_GetNext(void) {
 if (request_count == 0) {
 return  255 ;
 }
 return requests[0];
}
#line 97 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/RequestHandler.c"
unsigned char RequestHandler_GetNextOptimal(unsigned char current_floor, signed char direction) {
 unsigned char f;
 signed char scan_dir = direction;

 if (request_count == 0) {
 return  255 ;
 }

 if (current_floor ==  255  || ! ((current_floor) <= 3 ) ) {
 return requests[0];
 }


 if (RequestHandler_Contains(current_floor) != 0) {
 return current_floor;
 }


 if (scan_dir ==  0 ) {
 if (requests[0] > current_floor) {
 scan_dir =  1 ;
 } else if (requests[0] < current_floor) {
 scan_dir =  -1 ;
 } else {
 return requests[0];
 }
 }

 if (scan_dir ==  1 ) {

 for (f = current_floor + 1; f <  4 ; f++) {
 if (RequestHandler_Contains(f) != 0) {
 return f;
 }
 }

 for (f = current_floor; f > 0; f--) {
 if (RequestHandler_Contains(f - 1) != 0) {
 return f - 1;
 }
 }
 } else if (scan_dir ==  -1 ) {

 for (f = current_floor; f > 0; f--) {
 if (RequestHandler_Contains(f - 1) != 0) {
 return f - 1;
 }
 }

 for (f = current_floor + 1; f <  4 ; f++) {
 if (RequestHandler_Contains(f) != 0) {
 return f;
 }
 }
 }

 return requests[0];
}
#line 160 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/RequestHandler.c"
void RequestHandler_Remove(unsigned char floor) {
 unsigned char i;
 unsigned char j;

 for (i = 0; i < request_count; i++) {
 if (requests[i] == floor) {

 for (j = i; j < (request_count - 1); j++) {
 requests[j] = requests[j + 1];
 }
 request_count--;
 requests[request_count] =  255 ;
 return;
 }
 }
}
#line 180 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/RequestHandler.c"
void RequestHandler_Clear(void) {
 unsigned char i;
 request_count = 0;
 for (i = 0; i <  4 ; i++) {
 requests[i] =  255 ;
 }
}
#line 191 "C:/Users/Ahmed/Desktop/college/project embeded/Mini_Elevator_Compile/Team_3_Controller/Code/RequestHandler.c"
unsigned char RequestHandler_GetCount(void) {
 return request_count;
}
