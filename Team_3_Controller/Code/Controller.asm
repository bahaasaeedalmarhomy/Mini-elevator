
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
L_Controller_Controller_ReadRequests0:
	MOVLW      Controller_Controller_ReadRequests_requested_floor_L0+0
	MOVWF      FARG_Inputs_GetNewFloorRequest_floor+0
	CALL       _Inputs_GetNewFloorRequest+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Controller_ReadRequests1
	MOVF       Controller_Controller_ReadRequests_requested_floor_L0+0, 0
	SUBLW      3
	BTFSS      STATUS+0, 0
	GOTO       L_Controller_Controller_ReadRequests2
	MOVF       Controller_Controller_ReadRequests_requested_floor_L0+0, 0
	MOVWF      FARG_RequestHandler_Add_floor+0
	CALL       _RequestHandler_Add+0
L_Controller_Controller_ReadRequests2:
	GOTO       L_Controller_Controller_ReadRequests0
L_Controller_Controller_ReadRequests1:
L_end_Controller_ReadRequests:
	RETURN
; end of Controller_Controller_ReadRequests

Controller_Controller_UpdateCurrentFloor:

	CALL       _Inputs_GetCurrentFloor+0
	MOVF       R0+0, 0
	MOVWF      Controller_current_floor+0
	MOVF       R0+0, 0
	SUBLW      3
	BTFSS      STATUS+0, 0
	GOTO       L_Controller_Controller_UpdateCurrentFloor3
	MOVF       Controller_current_floor+0, 0
	MOVWF      Controller_last_known_floor+0
L_Controller_Controller_UpdateCurrentFloor3:
L_end_Controller_UpdateCurrentFloor:
	RETURN
; end of Controller_Controller_UpdateCurrentFloor

_Controller_Init:

	CLRF       Controller_controller_state+0
	MOVLW      255
	MOVWF      Controller_current_floor+0
	MOVLW      255
	MOVWF      Controller_last_known_floor+0
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
	GOTO       L__Controller_Update126
	MOVLW      255
	SUBWF      Controller_state_ticks+0, 0
L__Controller_Update126:
	BTFSC      STATUS+0, 0
	GOTO       L_Controller_Update4
	INCF       Controller_state_ticks+0, 1
	BTFSC      STATUS+0, 2
	INCF       Controller_state_ticks+1, 1
L_Controller_Update4:
	MOVLW      255
	SUBWF      Controller_startup_ticks+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Controller_Update127
	MOVLW      255
	SUBWF      Controller_startup_ticks+0, 0
L__Controller_Update127:
	BTFSC      STATUS+0, 0
	GOTO       L_Controller_Update5
	INCF       Controller_startup_ticks+0, 1
	BTFSC      STATUS+0, 2
	INCF       Controller_startup_ticks+1, 1
L_Controller_Update5:
	MOVF       Controller_controller_state+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L__Controller_Update120
	MOVF       Controller_controller_state+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L__Controller_Update120
	MOVF       Controller_controller_state+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L__Controller_Update120
	GOTO       L_Controller_Update8
L__Controller_Update120:
	CALL       _Inputs_IsFloorSensorFault+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update9
	CALL       _Motor_Stop+0
	CALL       _Brake_Engage+0
	MOVLW      3
	MOVWF      FARG_Inputs_Buzzer_event_code+0
	CALL       _Inputs_Buzzer+0
	MOVLW      8
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
	GOTO       L_Controller_Update10
L_Controller_Update9:
	CALL       _Weight_IsOverload+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update11
	CALL       _Motor_Stop+0
	CALL       _Brake_Engage+0
	MOVLW      2
	MOVWF      FARG_Inputs_Buzzer_event_code+0
	CALL       _Inputs_Buzzer+0
	MOVLW      7
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
L_Controller_Update11:
L_Controller_Update10:
L_Controller_Update8:
	GOTO       L_Controller_Update12
L_Controller_Update14:
	CALL       _Motor_Stop+0
	CALL       _Brake_Engage+0
	CALL       _Inputs_IsFloorSensorFault+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update15
	MOVLW      3
	MOVWF      FARG_Inputs_Buzzer_event_code+0
	CALL       _Inputs_Buzzer+0
	MOVLW      8
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
	GOTO       L_Controller_Update16
L_Controller_Update15:
	MOVF       Controller_current_floor+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update17
	MOVLW      1
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
	GOTO       L_Controller_Update18
L_Controller_Update17:
	MOVLW      1
	SUBWF      Controller_startup_ticks+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Controller_Update128
	MOVLW      244
	SUBWF      Controller_startup_ticks+0, 0
L__Controller_Update128:
	BTFSS      STATUS+0, 0
	GOTO       L_Controller_Update19
	MOVLW      3
	MOVWF      FARG_Inputs_Buzzer_event_code+0
	CALL       _Inputs_Buzzer+0
	MOVLW      8
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
L_Controller_Update19:
L_Controller_Update18:
L_Controller_Update16:
	GOTO       L_Controller_Update13
L_Controller_Update20:
	CALL       _Motor_Stop+0
	CALL       _Brake_Engage+0
	CALL       _Inputs_IsFloorSensorFault+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update21
	MOVLW      3
	MOVWF      FARG_Inputs_Buzzer_event_code+0
	CALL       _Inputs_Buzzer+0
	MOVLW      8
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
	GOTO       L_Controller_Update13
L_Controller_Update21:
	CALL       _Weight_IsOverload+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update22
	MOVLW      2
	MOVWF      FARG_Inputs_Buzzer_event_code+0
	CALL       _Inputs_Buzzer+0
	MOVLW      7
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
	GOTO       L_Controller_Update13
L_Controller_Update22:
	CALL       _RequestHandler_HasRequests+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update23
	MOVF       Controller_current_floor+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update24
	MOVF       Controller_current_floor+0, 0
	MOVWF      ?FLOC___Controller_UpdateT21+0
	GOTO       L_Controller_Update25
L_Controller_Update24:
	MOVF       Controller_last_known_floor+0, 0
	MOVWF      ?FLOC___Controller_UpdateT21+0
L_Controller_Update25:
	MOVF       ?FLOC___Controller_UpdateT21+0, 0
	MOVWF      Controller_Update_ref_floor_L0+0
	MOVF       ?FLOC___Controller_UpdateT21+0, 0
	MOVWF      FARG_RequestHandler_GetNextOptimal_current_floor+0
	MOVF       Controller_last_direction+0, 0
	MOVWF      FARG_RequestHandler_GetNextOptimal_direction+0
	CALL       _RequestHandler_GetNextOptimal+0
	MOVF       R0+0, 0
	MOVWF      Controller_target_floor+0
	MOVF       R0+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L_Controller_Update26
	GOTO       L_Controller_Update13
L_Controller_Update26:
	MOVF       Controller_current_floor+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update29
	MOVF       Controller_target_floor+0, 0
	XORWF      Controller_current_floor+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_Controller_Update29
L__Controller_Update119:
	MOVF       Controller_target_floor+0, 0
	MOVWF      FARG_RequestHandler_Remove_floor+0
	CALL       _RequestHandler_Remove+0
	MOVLW      1
	MOVWF      FARG_Inputs_Buzzer_event_code+0
	CALL       _Inputs_Buzzer+0
	MOVLW      255
	MOVWF      Controller_target_floor+0
	CLRF       Controller_direction+0
	CALL       _RequestHandler_HasRequests+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_Controller_Update30
	CLRF       Controller_last_direction+0
L_Controller_Update30:
	GOTO       L_Controller_Update31
L_Controller_Update29:
	MOVF       Controller_Update_ref_floor_L0+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update34
	MOVF       Controller_target_floor+0, 0
	SUBWF      Controller_Update_ref_floor_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Controller_Update34
L__Controller_Update118:
	MOVLW      1
	MOVWF      Controller_direction+0
	MOVLW      1
	MOVWF      Controller_last_direction+0
	CALL       _Brake_Release+0
	MOVLW      2
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
	GOTO       L_Controller_Update35
L_Controller_Update34:
	MOVF       Controller_Update_ref_floor_L0+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update38
	MOVF       Controller_Update_ref_floor_L0+0, 0
	SUBWF      Controller_target_floor+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Controller_Update38
L__Controller_Update117:
	MOVLW      255
	MOVWF      Controller_direction+0
	MOVLW      255
	MOVWF      Controller_last_direction+0
	CALL       _Brake_Release+0
	MOVLW      2
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
	GOTO       L_Controller_Update39
L_Controller_Update38:
	MOVF       Controller_current_floor+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L_Controller_Update42
	MOVF       Controller_Update_ref_floor_L0+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update42
	MOVF       Controller_target_floor+0, 0
	XORWF      Controller_Update_ref_floor_L0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_Controller_Update42
L__Controller_Update116:
	MOVF       Controller_last_direction+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_Controller_Update43
	MOVLW      255
	MOVWF      ?FLOC___Controller_UpdateT38+0
	GOTO       L_Controller_Update44
L_Controller_Update43:
	MOVLW      1
	MOVWF      ?FLOC___Controller_UpdateT38+0
L_Controller_Update44:
	MOVF       ?FLOC___Controller_UpdateT38+0, 0
	MOVWF      Controller_direction+0
	MOVF       ?FLOC___Controller_UpdateT38+0, 0
	MOVWF      Controller_last_direction+0
	CALL       _Brake_Release+0
	MOVLW      2
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
L_Controller_Update42:
L_Controller_Update39:
L_Controller_Update35:
L_Controller_Update31:
	GOTO       L_Controller_Update45
L_Controller_Update23:
	CLRF       Controller_last_direction+0
L_Controller_Update45:
	GOTO       L_Controller_Update13
L_Controller_Update46:
	MOVF       Controller_current_floor+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update49
	MOVF       Controller_direction+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update49
L__Controller_Update115:
	MOVF       Controller_current_floor+0, 0
	MOVWF      FARG_RequestHandler_GetNextOptimal_current_floor+0
	MOVF       Controller_direction+0, 0
	MOVWF      FARG_RequestHandler_GetNextOptimal_direction+0
	CALL       _RequestHandler_GetNextOptimal+0
	MOVF       R0+0, 0
	MOVWF      Controller_Update_optimal_L0+0
	MOVF       R0+0, 0
	XORWF      Controller_current_floor+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_Controller_Update50
	MOVF       Controller_current_floor+0, 0
	MOVWF      FARG_RequestHandler_Remove_floor+0
	CALL       _RequestHandler_Remove+0
	MOVLW      1
	MOVWF      FARG_Inputs_Buzzer_event_code+0
	CALL       _Inputs_Buzzer+0
	CALL       _Brake_Engage+0
	MOVLW      255
	MOVWF      Controller_target_floor+0
	CLRF       Controller_direction+0
	MOVLW      1
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
	GOTO       L_Controller_Update13
L_Controller_Update50:
	MOVF       Controller_Update_optimal_L0+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update52
	MOVF       Controller_Update_optimal_L0+0, 0
	MOVWF      Controller_target_floor+0
L_Controller_Update52:
L_Controller_Update49:
	MOVLW      0
	SUBWF      Controller_state_ticks+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Controller_Update129
	MOVLW      30
	SUBWF      Controller_state_ticks+0, 0
L__Controller_Update129:
	BTFSS      STATUS+0, 0
	GOTO       L_Controller_Update53
	CLRF       Controller_travel_ticks+0
	CLRF       Controller_travel_ticks+1
	MOVF       Controller_direction+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_Controller_Update54
	MOVLW      1
	MOVWF      FARG_Motor_Set_direction+0
	MOVLW      65
	MOVWF      FARG_Motor_Set_speed_percent+0
	CALL       _Motor_Set+0
	MOVLW      3
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
	GOTO       L_Controller_Update55
L_Controller_Update54:
	MOVF       Controller_direction+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L_Controller_Update56
	MOVLW      255
	MOVWF      FARG_Motor_Set_direction+0
	MOVLW      65
	MOVWF      FARG_Motor_Set_speed_percent+0
	CALL       _Motor_Set+0
	MOVLW      4
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
	GOTO       L_Controller_Update57
L_Controller_Update56:
	CALL       _Motor_Stop+0
	CALL       _Brake_Engage+0
	MOVLW      1
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
L_Controller_Update57:
L_Controller_Update55:
L_Controller_Update53:
	GOTO       L_Controller_Update13
L_Controller_Update58:
	MOVLW      1
	MOVWF      FARG_Motor_Set_direction+0
	MOVLW      65
	MOVWF      FARG_Motor_Set_speed_percent+0
	CALL       _Motor_Set+0
	MOVF       Controller_last_known_floor+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update61
	MOVF       Controller_target_floor+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update61
L__Controller_Update114:
	MOVF       Controller_last_known_floor+0, 0
	MOVWF      FARG_RequestHandler_GetNextOptimal_current_floor+0
	MOVLW      1
	MOVWF      FARG_RequestHandler_GetNextOptimal_direction+0
	CALL       _RequestHandler_GetNextOptimal+0
	MOVF       R0+0, 0
	MOVWF      Controller_Update_optimal_L0+0
	MOVF       R0+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update64
	MOVF       Controller_Update_optimal_L0+0, 0
	SUBWF      Controller_last_known_floor+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Controller_Update64
	MOVF       Controller_target_floor+0, 0
	SUBWF      Controller_Update_optimal_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Controller_Update64
L__Controller_Update113:
	MOVF       Controller_Update_optimal_L0+0, 0
	MOVWF      Controller_target_floor+0
L_Controller_Update64:
L_Controller_Update61:
	MOVLW      255
	SUBWF      Controller_travel_ticks+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Controller_Update130
	MOVLW      255
	SUBWF      Controller_travel_ticks+0, 0
L__Controller_Update130:
	BTFSC      STATUS+0, 0
	GOTO       L_Controller_Update65
	INCF       Controller_travel_ticks+0, 1
	BTFSC      STATUS+0, 2
	INCF       Controller_travel_ticks+1, 1
L_Controller_Update65:
	MOVLW      11
	SUBWF      Controller_travel_ticks+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Controller_Update131
	MOVLW      184
	SUBWF      Controller_travel_ticks+0, 0
L__Controller_Update131:
	BTFSS      STATUS+0, 0
	GOTO       L_Controller_Update66
	CALL       _Motor_Stop+0
	CALL       _Brake_Engage+0
	MOVLW      3
	MOVWF      FARG_Inputs_Buzzer_event_code+0
	CALL       _Inputs_Buzzer+0
	MOVLW      8
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
	GOTO       L_Controller_Update13
L_Controller_Update66:
	MOVF       Controller_current_floor+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update71
	MOVF       Controller_current_floor+0, 0
	XORWF      Controller_target_floor+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L__Controller_Update112
	MOVF       Controller_current_floor+0, 0
	MOVWF      FARG_RequestHandler_Contains_floor+0
	CALL       _RequestHandler_Contains+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__Controller_Update112
	GOTO       L_Controller_Update71
L__Controller_Update112:
L__Controller_Update111:
	MOVF       Controller_current_floor+0, 0
	MOVWF      Controller_target_floor+0
	CALL       _Motor_Stop+0
	MOVLW      5
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
L_Controller_Update71:
	GOTO       L_Controller_Update13
L_Controller_Update72:
	MOVLW      255
	MOVWF      FARG_Motor_Set_direction+0
	MOVLW      65
	MOVWF      FARG_Motor_Set_speed_percent+0
	CALL       _Motor_Set+0
	MOVF       Controller_last_known_floor+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update75
	MOVF       Controller_target_floor+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update75
L__Controller_Update110:
	MOVF       Controller_last_known_floor+0, 0
	MOVWF      FARG_RequestHandler_GetNextOptimal_current_floor+0
	MOVLW      255
	MOVWF      FARG_RequestHandler_GetNextOptimal_direction+0
	CALL       _RequestHandler_GetNextOptimal+0
	MOVF       R0+0, 0
	MOVWF      Controller_Update_optimal_L0+0
	MOVF       R0+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update78
	MOVF       Controller_last_known_floor+0, 0
	SUBWF      Controller_Update_optimal_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Controller_Update78
	MOVF       Controller_Update_optimal_L0+0, 0
	SUBWF      Controller_target_floor+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Controller_Update78
L__Controller_Update109:
	MOVF       Controller_Update_optimal_L0+0, 0
	MOVWF      Controller_target_floor+0
L_Controller_Update78:
L_Controller_Update75:
	MOVLW      255
	SUBWF      Controller_travel_ticks+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Controller_Update132
	MOVLW      255
	SUBWF      Controller_travel_ticks+0, 0
L__Controller_Update132:
	BTFSC      STATUS+0, 0
	GOTO       L_Controller_Update79
	INCF       Controller_travel_ticks+0, 1
	BTFSC      STATUS+0, 2
	INCF       Controller_travel_ticks+1, 1
L_Controller_Update79:
	MOVLW      11
	SUBWF      Controller_travel_ticks+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Controller_Update133
	MOVLW      184
	SUBWF      Controller_travel_ticks+0, 0
L__Controller_Update133:
	BTFSS      STATUS+0, 0
	GOTO       L_Controller_Update80
	CALL       _Motor_Stop+0
	CALL       _Brake_Engage+0
	MOVLW      3
	MOVWF      FARG_Inputs_Buzzer_event_code+0
	CALL       _Inputs_Buzzer+0
	MOVLW      8
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
	GOTO       L_Controller_Update13
L_Controller_Update80:
	MOVF       Controller_current_floor+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update85
	MOVF       Controller_current_floor+0, 0
	XORWF      Controller_target_floor+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L__Controller_Update108
	MOVF       Controller_current_floor+0, 0
	MOVWF      FARG_RequestHandler_Contains_floor+0
	CALL       _RequestHandler_Contains+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__Controller_Update108
	GOTO       L_Controller_Update85
L__Controller_Update108:
L__Controller_Update107:
	MOVF       Controller_current_floor+0, 0
	MOVWF      Controller_target_floor+0
	CALL       _Motor_Stop+0
	MOVLW      5
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
L_Controller_Update85:
	GOTO       L_Controller_Update13
L_Controller_Update86:
	CALL       _Motor_Stop+0
	MOVLW      0
	SUBWF      Controller_state_ticks+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Controller_Update134
	MOVLW      5
	SUBWF      Controller_state_ticks+0, 0
L__Controller_Update134:
	BTFSS      STATUS+0, 0
	GOTO       L_Controller_Update87
	CALL       _Brake_Engage+0
	MOVLW      6
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
L_Controller_Update87:
	GOTO       L_Controller_Update13
L_Controller_Update88:
	CALL       _Motor_Stop+0
	MOVLW      0
	SUBWF      Controller_state_ticks+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Controller_Update135
	MOVLW      30
	SUBWF      Controller_state_ticks+0, 0
L__Controller_Update135:
	BTFSS      STATUS+0, 0
	GOTO       L_Controller_Update89
	MOVF       Controller_current_floor+0, 0
	XORWF      Controller_target_floor+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_Controller_Update92
	MOVF       Controller_target_floor+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update92
L__Controller_Update106:
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
	GOTO       L_Controller_Update93
L_Controller_Update92:
	MOVLW      1
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
L_Controller_Update93:
L_Controller_Update89:
	GOTO       L_Controller_Update13
L_Controller_Update94:
	CALL       _Motor_Stop+0
	CALL       _Brake_Engage+0
	CALL       _Weight_IsOverload+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_Controller_Update95
	MOVLW      1
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
L_Controller_Update95:
	GOTO       L_Controller_Update13
L_Controller_Update96:
	CALL       _Motor_Stop+0
	CALL       _Brake_Engage+0
	CALL       _Inputs_IsFloorSensorFault+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_Controller_Update99
	MOVF       Controller_current_floor+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update99
L__Controller_Update105:
	CLRF       Controller_startup_ticks+0
	CLRF       Controller_startup_ticks+1
	CLRF       Controller_travel_ticks+0
	CLRF       Controller_travel_ticks+1
	MOVLW      1
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
L_Controller_Update99:
	GOTO       L_Controller_Update13
L_Controller_Update100:
	CALL       _Motor_Stop+0
	CALL       _Brake_Engage+0
	MOVLW      8
	MOVWF      FARG_Controller_Controller_EnterState_new_state+0
	CALL       Controller_Controller_EnterState+0
	GOTO       L_Controller_Update13
L_Controller_Update12:
	MOVF       Controller_controller_state+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update14
	MOVF       Controller_controller_state+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update20
	MOVF       Controller_controller_state+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update46
	MOVF       Controller_controller_state+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update58
	MOVF       Controller_controller_state+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update72
	MOVF       Controller_controller_state+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update86
	MOVF       Controller_controller_state+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update88
	MOVF       Controller_controller_state+0, 0
	XORLW      7
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update94
	MOVF       Controller_controller_state+0, 0
	XORLW      8
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update96
	GOTO       L_Controller_Update100
L_Controller_Update13:
	MOVF       Controller_current_floor+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update101
	MOVF       Controller_current_floor+0, 0
	MOVWF      ?FLOC___Controller_UpdateT96+0
	GOTO       L_Controller_Update102
L_Controller_Update101:
	MOVF       Controller_last_known_floor+0, 0
	MOVWF      ?FLOC___Controller_UpdateT96+0
L_Controller_Update102:
	MOVF       ?FLOC___Controller_UpdateT96+0, 0
	MOVWF      Controller_Update_ref_floor_L0+0
	MOVF       Controller_target_floor+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L_Controller_Update103
	MOVF       Controller_target_floor+0, 0
	MOVWF      ?FLOC___Controller_UpdateT98+0
	GOTO       L_Controller_Update104
L_Controller_Update103:
	MOVF       Controller_Update_ref_floor_L0+0, 0
	MOVWF      FARG_RequestHandler_GetNextOptimal_current_floor+0
	MOVF       Controller_last_direction+0, 0
	MOVWF      FARG_RequestHandler_GetNextOptimal_direction+0
	CALL       _RequestHandler_GetNextOptimal+0
	MOVF       R0+0, 0
	MOVWF      ?FLOC___Controller_UpdateT98+0
L_Controller_Update104:
	MOVF       ?FLOC___Controller_UpdateT98+0, 0
	MOVWF      Controller_Update_display_target_L0+0
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
	MOVF       Controller_Update_display_target_L0+0, 0
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
