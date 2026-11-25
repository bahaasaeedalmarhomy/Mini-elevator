
Controller_Controller_EnterState:

	MOVF       FARG_Controller_Controller_EnterState_new_state+0, 0
	MOVWF      Controller_controller_state+0
	CLRF       Controller_state_ticks+0
	CLRF       Controller_state_ticks+1
L_end_Controller_EnterState:
	RETURN
; end of Controller_Controller_EnterState

Controller_Controller_ReadRequests:

	MOVLW      255
	MOVWF      Controller_Controller_ReadRequests_requested_floor_L0+0
	MOVLW      Controller_Controller_ReadRequests_requested_floor_L0+0
	MOVWF      FARG_Inputs_GetNewFloorRequest_floor+0
	CALL       _Inputs_GetNewFloorRequest+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Controller_ReadRequests0
	MOVF       Controller_Controller_ReadRequests_requested_floor_L0+0, 0
	SUBLW      3
	BTFSS      STATUS+0, 0
	GOTO       L_Controller_Controller_ReadRequests1
	MOVF       Controller_Controller_ReadRequests_requested_floor_L0+0, 0
	MOVWF      FARG_RequestHandler_Add_floor+0
	CALL       _RequestHandler_Add+0
L_Controller_Controller_ReadRequests1:
L_Controller_Controller_ReadRequests0:
L_end_Controller_ReadRequests:
	RETURN
; end of Controller_Controller_ReadRequests

Controller_Controller_UpdateCurrentFloor:

	CALL       _Inputs_GetCurrentFloor+0
	MOVF       R0+0, 0
	MOVWF      Controller_current_floor+0
L_end_Controller_UpdateCurrentFloor:
	RETURN
; end of Controller_Controller_UpdateCurrentFloor

_Controller_Init:

	CLRF       Controller_controller_state+0
	MOVLW      255
	MOVWF      Controller_current_floor+0
	MOVLW      255
	MOVWF      Controller_target_floor+0
	CLRF       Controller_direction+0
	CLRF       Controller_last_direction+0
	CLRF       Controller_state_ticks+0
	CLRF       Controller_state_ticks+1
	CLRF       Controller_startup_ticks+0
	CLRF       Controller_startup_ticks+1
	CLRF       Controller_travel_ticks+0
	CLRF       Controller_travel_ticks+1
	CALL       _RequestHandler_Init+0
	CALL       _Motor_Stop+0
	CALL       _Brake_Engage+0
	MOVLW      4
	MOVWF      FARG_Inputs_Buzzer_event_code+0
	CALL       _Inputs_Buzzer+0
L_end_Controller_Init:
	RETURN
; end of _Controller_Init

_Controller_Update:

	CALL       Controller_Controller_ReadRequests+0
	CALL       Controller_Controller_UpdateCurrentFloor+0
	MOVLW      255
	SUBWF      Controller_state_ticks+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Controller_Update83
	MOVLW      255
	SUBWF      Controller_state_ticks+0, 0
L__Controller_Update83:
	BTFSC      STATUS+0, 0
	GOTO       L_Controller_Update2
	INCF       Controller_state_ticks+0, 1
	BTFSC      STATUS+0, 2
	INCF       Controller_state_ticks+1, 1
L_Controller_Update2:
	MOVLW      255
	SUBWF      Controller_startup_ticks+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Controller_Update84
	MOVLW      255
	SUBWF      Controller_startup_ticks+0, 0
L__Controller_Update84:
	BTFSC      STATUS+0, 0
	GOTO       L_Controller_Update3
	INCF       Controller_startup_ticks+0, 1
	BTFSC      STATUS+0, 2
	INCF       Controller_startup_ticks+1, 1
L_Controller_Update3:
	MOVF       Controller_controller_state+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L__Controller_Update77
	MOVF       Controller_controller_state+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L__Controller_Update77
	MOVF       Controller_controller_state+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L__Controller_Update77
	GOTO       L_Controller_Update6
L__Controller_Update77:
	CALL       _Inputs_IsFloorSensorFault+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update7
	CALL       _Motor_Stop+0
	CALL       _Brake_Engage+0
	MOVLW      3
	MOVWF      FARG_Inputs_Buzzer_event_code+0
	CALL       _Inputs_Buzzer+0
	MOVLW      8
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
	GOTO       L_Controller_Update8
L_Controller_Update7:
	CALL       _Weight_IsOverload+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update9
	CALL       _Motor_Stop+0
	CALL       _Brake_Engage+0
	MOVLW      2
	MOVWF      FARG_Inputs_Buzzer_event_code+0
	CALL       _Inputs_Buzzer+0
	MOVLW      7
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
L_Controller_Update9:
L_Controller_Update8:
L_Controller_Update6:
	GOTO       L_Controller_Update10
L_Controller_Update12:
	CALL       _Motor_Stop+0
	CALL       _Brake_Engage+0
	CALL       _Inputs_IsFloorSensorFault+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update13
	MOVLW      3
	MOVWF      FARG_Inputs_Buzzer_event_code+0
	CALL       _Inputs_Buzzer+0
	MOVLW      8
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
	GOTO       L_Controller_Update14
L_Controller_Update13:
	MOVF       Controller_current_floor+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update15
	MOVLW      1
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
	GOTO       L_Controller_Update16
L_Controller_Update15:
	MOVLW      1
	SUBWF      Controller_startup_ticks+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Controller_Update85
	MOVLW      244
	SUBWF      Controller_startup_ticks+0, 0
L__Controller_Update85:
	BTFSS      STATUS+0, 0
	GOTO       L_Controller_Update17
	MOVLW      3
	MOVWF      FARG_Inputs_Buzzer_event_code+0
	CALL       _Inputs_Buzzer+0
	MOVLW      8
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
L_Controller_Update17:
L_Controller_Update16:
L_Controller_Update14:
	GOTO       L_Controller_Update11
L_Controller_Update18:
	CALL       _Motor_Stop+0
	CALL       _Brake_Engage+0
	CALL       _Inputs_IsFloorSensorFault+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update19
	MOVLW      3
	MOVWF      FARG_Inputs_Buzzer_event_code+0
	CALL       _Inputs_Buzzer+0
	MOVLW      8
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
	GOTO       L_Controller_Update11
L_Controller_Update19:
	CALL       _Weight_IsOverload+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update20
	MOVLW      2
	MOVWF      FARG_Inputs_Buzzer_event_code+0
	CALL       _Inputs_Buzzer+0
	MOVLW      7
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
	GOTO       L_Controller_Update11
L_Controller_Update20:
	CALL       _RequestHandler_HasRequests+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update21
	MOVF       Controller_current_floor+0, 0
	MOVWF      FARG_RequestHandler_GetNextOptimal_current_floor+0
	MOVF       Controller_last_direction+0, 0
	MOVWF      FARG_RequestHandler_GetNextOptimal_direction+0
	CALL       _RequestHandler_GetNextOptimal+0
	MOVF       R0+0, 0
	MOVWF      Controller_target_floor+0
	MOVF       R0+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L_Controller_Update22
	GOTO       L_Controller_Update11
L_Controller_Update22:
	MOVF       Controller_target_floor+0, 0
	XORWF      Controller_current_floor+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_Controller_Update23
	MOVF       Controller_target_floor+0, 0
	MOVWF      FARG_RequestHandler_Remove_floor+0
	CALL       _RequestHandler_Remove+0
	MOVLW      1
	MOVWF      FARG_Inputs_Buzzer_event_code+0
	CALL       _Inputs_Buzzer+0
	MOVLW      255
	MOVWF      Controller_target_floor+0
	CLRF       Controller_direction+0
	CLRF       Controller_last_direction+0
	GOTO       L_Controller_Update24
L_Controller_Update23:
	MOVF       Controller_target_floor+0, 0
	SUBWF      Controller_current_floor+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Controller_Update25
	MOVLW      1
	MOVWF      Controller_direction+0
	MOVLW      1
	MOVWF      Controller_last_direction+0
	CALL       _Brake_Release+0
	MOVLW      2
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
	GOTO       L_Controller_Update26
L_Controller_Update25:
	MOVF       Controller_current_floor+0, 0
	SUBWF      Controller_target_floor+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Controller_Update27
	MOVLW      255
	MOVWF      Controller_direction+0
	MOVLW      255
	MOVWF      Controller_last_direction+0
	CALL       _Brake_Release+0
	MOVLW      2
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
L_Controller_Update27:
L_Controller_Update26:
L_Controller_Update24:
	GOTO       L_Controller_Update28
L_Controller_Update21:
	CLRF       Controller_last_direction+0
L_Controller_Update28:
	GOTO       L_Controller_Update11
L_Controller_Update29:
	MOVF       Controller_current_floor+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update32
	MOVF       Controller_direction+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update32
L__Controller_Update76:
	MOVF       Controller_current_floor+0, 0
	MOVWF      FARG_RequestHandler_GetNextOptimal_current_floor+0
	MOVF       Controller_direction+0, 0
	MOVWF      FARG_RequestHandler_GetNextOptimal_direction+0
	CALL       _RequestHandler_GetNextOptimal+0
	MOVF       R0+0, 0
	MOVWF      Controller_Update_optimal_L2+0
	MOVF       R0+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update33
	MOVF       Controller_Update_optimal_L2+0, 0
	MOVWF      Controller_target_floor+0
L_Controller_Update33:
L_Controller_Update32:
	MOVLW      0
	SUBWF      Controller_state_ticks+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Controller_Update86
	MOVLW      30
	SUBWF      Controller_state_ticks+0, 0
L__Controller_Update86:
	BTFSS      STATUS+0, 0
	GOTO       L_Controller_Update34
	CLRF       Controller_travel_ticks+0
	CLRF       Controller_travel_ticks+1
	MOVF       Controller_direction+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_Controller_Update35
	MOVLW      1
	MOVWF      FARG_Motor_Set_direction+0
	MOVLW      65
	MOVWF      FARG_Motor_Set_speed_percent+0
	CALL       _Motor_Set+0
	MOVLW      3
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
	GOTO       L_Controller_Update36
L_Controller_Update35:
	MOVF       Controller_direction+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L_Controller_Update37
	MOVLW      255
	MOVWF      FARG_Motor_Set_direction+0
	MOVLW      65
	MOVWF      FARG_Motor_Set_speed_percent+0
	CALL       _Motor_Set+0
	MOVLW      4
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
	GOTO       L_Controller_Update38
L_Controller_Update37:
	CALL       _Motor_Stop+0
	CALL       _Brake_Engage+0
	MOVLW      1
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
L_Controller_Update38:
L_Controller_Update36:
L_Controller_Update34:
	GOTO       L_Controller_Update11
L_Controller_Update39:
	MOVLW      1
	MOVWF      FARG_Motor_Set_direction+0
	MOVLW      65
	MOVWF      FARG_Motor_Set_speed_percent+0
	CALL       _Motor_Set+0
	MOVLW      255
	SUBWF      Controller_travel_ticks+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Controller_Update87
	MOVLW      255
	SUBWF      Controller_travel_ticks+0, 0
L__Controller_Update87:
	BTFSC      STATUS+0, 0
	GOTO       L_Controller_Update40
	INCF       Controller_travel_ticks+0, 1
	BTFSC      STATUS+0, 2
	INCF       Controller_travel_ticks+1, 1
L_Controller_Update40:
	MOVLW      11
	SUBWF      Controller_travel_ticks+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Controller_Update88
	MOVLW      184
	SUBWF      Controller_travel_ticks+0, 0
L__Controller_Update88:
	BTFSS      STATUS+0, 0
	GOTO       L_Controller_Update41
	CALL       _Motor_Stop+0
	CALL       _Brake_Engage+0
	MOVLW      3
	MOVWF      FARG_Inputs_Buzzer_event_code+0
	CALL       _Inputs_Buzzer+0
	MOVLW      8
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
	GOTO       L_Controller_Update11
L_Controller_Update41:
	MOVF       Controller_current_floor+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update46
	MOVF       Controller_current_floor+0, 0
	XORWF      Controller_target_floor+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L__Controller_Update75
	MOVF       Controller_current_floor+0, 0
	MOVWF      FARG_RequestHandler_Contains_floor+0
	CALL       _RequestHandler_Contains+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__Controller_Update75
	GOTO       L_Controller_Update46
L__Controller_Update75:
L__Controller_Update74:
	MOVF       Controller_current_floor+0, 0
	MOVWF      Controller_target_floor+0
	CALL       _Motor_Stop+0
	MOVLW      5
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
L_Controller_Update46:
	GOTO       L_Controller_Update11
L_Controller_Update47:
	MOVLW      255
	MOVWF      FARG_Motor_Set_direction+0
	MOVLW      65
	MOVWF      FARG_Motor_Set_speed_percent+0
	CALL       _Motor_Set+0
	MOVLW      255
	SUBWF      Controller_travel_ticks+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Controller_Update89
	MOVLW      255
	SUBWF      Controller_travel_ticks+0, 0
L__Controller_Update89:
	BTFSC      STATUS+0, 0
	GOTO       L_Controller_Update48
	INCF       Controller_travel_ticks+0, 1
	BTFSC      STATUS+0, 2
	INCF       Controller_travel_ticks+1, 1
L_Controller_Update48:
	MOVLW      11
	SUBWF      Controller_travel_ticks+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Controller_Update90
	MOVLW      184
	SUBWF      Controller_travel_ticks+0, 0
L__Controller_Update90:
	BTFSS      STATUS+0, 0
	GOTO       L_Controller_Update49
	CALL       _Motor_Stop+0
	CALL       _Brake_Engage+0
	MOVLW      3
	MOVWF      FARG_Inputs_Buzzer_event_code+0
	CALL       _Inputs_Buzzer+0
	MOVLW      8
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
	GOTO       L_Controller_Update11
L_Controller_Update49:
	MOVF       Controller_current_floor+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update54
	MOVF       Controller_current_floor+0, 0
	XORWF      Controller_target_floor+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L__Controller_Update73
	MOVF       Controller_current_floor+0, 0
	MOVWF      FARG_RequestHandler_Contains_floor+0
	CALL       _RequestHandler_Contains+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__Controller_Update73
	GOTO       L_Controller_Update54
L__Controller_Update73:
L__Controller_Update72:
	MOVF       Controller_current_floor+0, 0
	MOVWF      Controller_target_floor+0
	CALL       _Motor_Stop+0
	MOVLW      5
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
L_Controller_Update54:
	GOTO       L_Controller_Update11
L_Controller_Update55:
	CALL       _Motor_Stop+0
	MOVLW      0
	SUBWF      Controller_state_ticks+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Controller_Update91
	MOVLW      5
	SUBWF      Controller_state_ticks+0, 0
L__Controller_Update91:
	BTFSS      STATUS+0, 0
	GOTO       L_Controller_Update56
	CALL       _Brake_Engage+0
	MOVLW      6
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
L_Controller_Update56:
	GOTO       L_Controller_Update11
L_Controller_Update57:
	CALL       _Motor_Stop+0
	MOVLW      0
	SUBWF      Controller_state_ticks+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Controller_Update92
	MOVLW      30
	SUBWF      Controller_state_ticks+0, 0
L__Controller_Update92:
	BTFSS      STATUS+0, 0
	GOTO       L_Controller_Update58
	MOVF       Controller_current_floor+0, 0
	XORWF      Controller_target_floor+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_Controller_Update61
	MOVF       Controller_target_floor+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update61
L__Controller_Update71:
	MOVF       Controller_target_floor+0, 0
	MOVWF      FARG_RequestHandler_Remove_floor+0
	CALL       _RequestHandler_Remove+0
	MOVLW      1
	MOVWF      FARG_Inputs_Buzzer_event_code+0
	CALL       _Inputs_Buzzer+0
	MOVLW      255
	MOVWF      Controller_target_floor+0
	MOVF       Controller_direction+0, 0
	MOVWF      Controller_last_direction+0
	CLRF       Controller_direction+0
	MOVLW      1
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
	GOTO       L_Controller_Update62
L_Controller_Update61:
	MOVLW      1
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
L_Controller_Update62:
L_Controller_Update58:
	GOTO       L_Controller_Update11
L_Controller_Update63:
	CALL       _Motor_Stop+0
	CALL       _Brake_Engage+0
	CALL       _Weight_IsOverload+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_Controller_Update64
	MOVLW      1
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
L_Controller_Update64:
	GOTO       L_Controller_Update11
L_Controller_Update65:
	CALL       _Motor_Stop+0
	CALL       _Brake_Engage+0
	CALL       _Inputs_IsFloorSensorFault+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_Controller_Update68
	MOVF       Controller_current_floor+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update68
L__Controller_Update70:
	CLRF       Controller_startup_ticks+0
	CLRF       Controller_startup_ticks+1
	CLRF       Controller_travel_ticks+0
	CLRF       Controller_travel_ticks+1
	MOVLW      1
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
L_Controller_Update68:
	GOTO       L_Controller_Update11
L_Controller_Update69:
	CALL       _Motor_Stop+0
	CALL       _Brake_Engage+0
	MOVLW      8
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
	GOTO       L_Controller_Update11
L_Controller_Update10:
	MOVF       Controller_controller_state+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update12
	MOVF       Controller_controller_state+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update18
	MOVF       Controller_controller_state+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update29
	MOVF       Controller_controller_state+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update39
	MOVF       Controller_controller_state+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update47
	MOVF       Controller_controller_state+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update55
	MOVF       Controller_controller_state+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update57
	MOVF       Controller_controller_state+0, 0
	XORLW      7
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update63
	MOVF       Controller_controller_state+0, 0
	XORLW      8
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update65
	GOTO       L_Controller_Update69
L_Controller_Update11:
	CALL       _Weight_GetGrams+0
	MOVF       R0+0, 0
	MOVWF      FARG_Inputs_DisplayStatus_weight_grams+0
	MOVF       R0+1, 0
	MOVWF      FARG_Inputs_DisplayStatus_weight_grams+1
	MOVF       R0+2, 0
	MOVWF      FARG_Inputs_DisplayStatus_weight_grams+2
	MOVF       R0+3, 0
	MOVWF      FARG_Inputs_DisplayStatus_weight_grams+3
	MOVF       Controller_current_floor+0, 0
	MOVWF      FARG_Inputs_DisplayStatus_current_floor+0
	MOVF       Controller_target_floor+0, 0
	MOVWF      FARG_Inputs_DisplayStatus_target_floor+0
	MOVF       Controller_controller_state+0, 0
	MOVWF      FARG_Inputs_DisplayStatus_controller_state+0
	CALL       _Inputs_DisplayStatus+0
L_end_Controller_Update:
	RETURN
; end of _Controller_Update

_Controller_GetState:

	MOVF       Controller_controller_state+0, 0
	MOVWF      R0+0
L_end_Controller_GetState:
	RETURN
; end of _Controller_GetState

_Controller_GetCurrentFloor:

	MOVF       Controller_current_floor+0, 0
	MOVWF      R0+0
L_end_Controller_GetCurrentFloor:
	RETURN
; end of _Controller_GetCurrentFloor

_Controller_GetTargetFloor:

	MOVF       Controller_target_floor+0, 0
	MOVWF      R0+0
L_end_Controller_GetTargetFloor:
	RETURN
; end of _Controller_GetTargetFloor
