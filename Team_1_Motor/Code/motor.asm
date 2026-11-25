
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

	BTFSS      PIR2+0, 0
	GOTO       L_interrupt2
	BTFSS      PIE2+0, 0
	GOTO       L_interrupt2
L__interrupt70:
	BCF        PIR2+0, 0
	MOVF       CCPR2H+0, 0
	MOVWF      R5+0
	CLRF       R5+1
	MOVF       R5+0, 0
	MOVWF      R5+1
	CLRF       R5+0
	MOVF       CCPR2L+0, 0
	IORWF      R5+0, 1
	MOVLW      0
	IORWF      R5+1, 1
	MOVF       motor_servo_level+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt3
	BCF        RC1_bit+0, BitPos(RC1_bit+0)
	CLRF       motor_servo_level+0
	MOVF       motor_servo_width+0, 0
	SUBLW      212
	MOVWF      R0+0
	MOVF       motor_servo_width+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBLW      48
	MOVWF      R0+1
	MOVF       R0+0, 0
	ADDWF      R5+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R5+1, 1
	GOTO       L_interrupt4
L_interrupt3:
	MOVF       motor_brake_released+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt5
	MOVLW      226
	MOVWF      R3+0
	MOVLW      4
	MOVWF      R3+1
	GOTO       L_interrupt6
L_interrupt5:
	MOVLW      113
	MOVWF      R3+0
	MOVLW      2
	MOVWF      R3+1
L_interrupt6:
	MOVF       R3+0, 0
	MOVWF      motor_servo_width+0
	MOVF       R3+1, 0
	MOVWF      motor_servo_width+1
	BSF        RC1_bit+0, BitPos(RC1_bit+0)
	MOVLW      1
	MOVWF      motor_servo_level+0
	MOVF       motor_servo_width+0, 0
	ADDWF      R5+0, 1
	MOVF       motor_servo_width+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R5+1, 1
L_interrupt4:
	MOVF       R5+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      CCPR2H+0
	MOVLW      255
	ANDWF      R5+0, 0
	MOVWF      CCPR2L+0
L_interrupt2:
L_end_interrupt:
L__interrupt76:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

motor_Motor_EnterState:

	MOVF       FARG_motor_Motor_EnterState_new_state+0, 0
	MOVWF      motor_motor_state+0
	CLRF       motor_state_ticks+0
	CLRF       motor_state_ticks+1
L_end_Motor_EnterState:
	RETURN
; end of motor_Motor_EnterState

motor_Pwm_SetPercent:

	MOVF       FARG_motor_Pwm_SetPercent_percent+0, 0
	SUBLW      100
	BTFSC      STATUS+0, 0
	GOTO       L_motor_Pwm_SetPercent7
	MOVLW      100
	MOVWF      FARG_motor_Pwm_SetPercent_percent+0
L_motor_Pwm_SetPercent7:
	MOVF       FARG_motor_Pwm_SetPercent_percent+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	CLRF       R0+2
	CLRF       R0+3
	MOVLW      255
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	MOVLW      0
	MOVWF      R4+2
	MOVLW      0
	MOVWF      R4+3
	CALL       _Mul_32x32_U+0
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      0
	MOVWF      R4+2
	MOVLW      0
	MOVWF      R4+3
	CALL       _Div_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      R4+0
	MOVF       R0+1, 0
	MOVWF      R4+1
	RRF        R4+1, 1
	RRF        R4+0, 1
	BCF        R4+1, 7
	RRF        R4+1, 1
	RRF        R4+0, 1
	BCF        R4+1, 7
	MOVF       R4+0, 0
	MOVWF      CCPR1L+0
	MOVLW      3
	ANDWF      R0+0, 0
	MOVWF      R2+0
	MOVF       R2+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVLW      12
	IORWF      R0+0, 0
	MOVWF      CCP1CON+0
L_end_Pwm_SetPercent:
	RETURN
; end of motor_Pwm_SetPercent

motor_Dir_Apply:

	MOVF       FARG_motor_Dir_Apply_dir+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_motor_Dir_Apply8
	BCF        RD1_bit+0, BitPos(RD1_bit+0)
	BSF        RD0_bit+0, BitPos(RD0_bit+0)
	GOTO       L_motor_Dir_Apply9
L_motor_Dir_Apply8:
	MOVF       FARG_motor_Dir_Apply_dir+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L_motor_Dir_Apply10
	BCF        RD0_bit+0, BitPos(RD0_bit+0)
	BSF        RD1_bit+0, BitPos(RD1_bit+0)
	GOTO       L_motor_Dir_Apply11
L_motor_Dir_Apply10:
	BCF        RD0_bit+0, BitPos(RD0_bit+0)
	BCF        RD1_bit+0, BitPos(RD1_bit+0)
L_motor_Dir_Apply11:
L_motor_Dir_Apply9:
L_end_Dir_Apply:
	RETURN
; end of motor_Dir_Apply

motor_Speed_Ramp:

	MOVF       FARG_motor_Speed_Ramp_target+0, 0
	SUBWF      motor_cur_speed+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_motor_Speed_Ramp12
	MOVLW      5
	ADDWF      motor_cur_speed+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      motor_cur_speed+0
	MOVF       R1+0, 0
	SUBWF      FARG_motor_Speed_Ramp_target+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_motor_Speed_Ramp13
	MOVF       FARG_motor_Speed_Ramp_target+0, 0
	MOVWF      motor_cur_speed+0
L_motor_Speed_Ramp13:
	MOVF       motor_cur_speed+0, 0
	MOVWF      FARG_motor_Pwm_SetPercent_percent+0
	CALL       motor_Pwm_SetPercent+0
	GOTO       L_motor_Speed_Ramp14
L_motor_Speed_Ramp12:
	MOVF       motor_cur_speed+0, 0
	SUBWF      FARG_motor_Speed_Ramp_target+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_motor_Speed_Ramp15
	MOVF       FARG_motor_Speed_Ramp_target+0, 0
	SUBWF      motor_cur_speed+0, 0
	MOVWF      R1+0
	CLRF       R1+1
	BTFSS      STATUS+0, 0
	DECF       R1+1, 1
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      R1+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_motor_Speed_Ramp81
	MOVF       R1+0, 0
	SUBLW      5
L_motor_Speed_Ramp81:
	BTFSC      STATUS+0, 0
	GOTO       L_motor_Speed_Ramp16
	MOVLW      5
	SUBWF      motor_cur_speed+0, 1
	GOTO       L_motor_Speed_Ramp17
L_motor_Speed_Ramp16:
	MOVF       FARG_motor_Speed_Ramp_target+0, 0
	MOVWF      motor_cur_speed+0
L_motor_Speed_Ramp17:
	MOVF       motor_cur_speed+0, 0
	MOVWF      FARG_motor_Pwm_SetPercent_percent+0
	CALL       motor_Pwm_SetPercent+0
L_motor_Speed_Ramp15:
L_motor_Speed_Ramp14:
L_end_Speed_Ramp:
	RETURN
; end of motor_Speed_Ramp

motor_HX711_ReadRaw:

	CLRF       motor_HX711_ReadRaw_v_L0+0
	CLRF       motor_HX711_ReadRaw_v_L0+1
	CLRF       motor_HX711_ReadRaw_v_L0+2
	CLRF       motor_HX711_ReadRaw_v_L0+3
	CLRF       R4+0
L_motor_HX711_ReadRaw18:
	MOVLW      24
	SUBWF      R4+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_motor_HX711_ReadRaw19
	BSF        RA1_bit+0, BitPos(RA1_bit+0)
	RLF        motor_HX711_ReadRaw_v_L0+0, 1
	RLF        motor_HX711_ReadRaw_v_L0+1, 1
	RLF        motor_HX711_ReadRaw_v_L0+2, 1
	RLF        motor_HX711_ReadRaw_v_L0+3, 1
	BCF        motor_HX711_ReadRaw_v_L0+0, 0
	BTFSS      RA0_bit+0, BitPos(RA0_bit+0)
	GOTO       L_motor_HX711_ReadRaw21
	BSF        motor_HX711_ReadRaw_v_L0+0, 0
L_motor_HX711_ReadRaw21:
	BCF        RA1_bit+0, BitPos(RA1_bit+0)
	INCF       R4+0, 1
	GOTO       L_motor_HX711_ReadRaw18
L_motor_HX711_ReadRaw19:
	BSF        RA1_bit+0, BitPos(RA1_bit+0)
	BCF        RA1_bit+0, BitPos(RA1_bit+0)
	BTFSS      motor_HX711_ReadRaw_v_L0+2, 7
	GOTO       L_motor_HX711_ReadRaw22
	MOVLW      0
	IORWF      motor_HX711_ReadRaw_v_L0+0, 1
	MOVLW      0
	IORWF      motor_HX711_ReadRaw_v_L0+1, 1
	MOVLW      0
	IORWF      motor_HX711_ReadRaw_v_L0+2, 1
	MOVLW      255
	IORWF      motor_HX711_ReadRaw_v_L0+3, 1
L_motor_HX711_ReadRaw22:
	MOVF       motor_HX711_ReadRaw_v_L0+0, 0
	MOVWF      R0+0
	MOVF       motor_HX711_ReadRaw_v_L0+1, 0
	MOVWF      R0+1
	MOVF       motor_HX711_ReadRaw_v_L0+2, 0
	MOVWF      R0+2
	MOVF       motor_HX711_ReadRaw_v_L0+3, 0
	MOVWF      R0+3
L_end_HX711_ReadRaw:
	RETURN
; end of motor_HX711_ReadRaw

motor_Tare_Finish:

	MOVF       motor_tare_count+0, 0
	SUBLW      4
	BTFSC      STATUS+0, 0
	GOTO       L_motor_Tare_Finish23
	MOVLW      4
	SUBWF      motor_tare_count+0, 0
	MOVWF      R4+0
	CLRF       R4+1
	BTFSS      STATUS+0, 0
	DECF       R4+1, 1
	MOVLW      0
	BTFSC      R4+1, 7
	MOVLW      255
	MOVWF      R4+2
	MOVWF      R4+3
	MOVF       motor_tare_sum+0, 0
	MOVWF      R0+0
	MOVF       motor_tare_sum+1, 0
	MOVWF      R0+1
	MOVF       motor_tare_sum+2, 0
	MOVWF      R0+2
	MOVF       motor_tare_sum+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_S+0
	MOVF       R0+0, 0
	MOVWF      motor_hx_offset+0
	MOVF       R0+1, 0
	MOVWF      motor_hx_offset+1
	MOVF       R0+2, 0
	MOVWF      motor_hx_offset+2
	MOVF       R0+3, 0
	MOVWF      motor_hx_offset+3
	GOTO       L_motor_Tare_Finish24
L_motor_Tare_Finish23:
	CLRF       motor_hx_offset+0
	CLRF       motor_hx_offset+1
	CLRF       motor_hx_offset+2
	CLRF       motor_hx_offset+3
L_motor_Tare_Finish24:
	CLRF       motor_Tare_Finish_i_L0+0
L_motor_Tare_Finish25:
	MOVLW      2
	SUBWF      motor_Tare_Finish_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_motor_Tare_Finish26
	MOVF       motor_Tare_Finish_i_L0+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      motor_hx_buf+0
	MOVWF      FSR
	MOVF       motor_hx_offset+0, 0
	MOVWF      INDF+0
	MOVF       motor_hx_offset+1, 0
	INCF       FSR, 1
	MOVWF      INDF+0
	MOVF       motor_hx_offset+2, 0
	INCF       FSR, 1
	MOVWF      INDF+0
	MOVF       motor_hx_offset+3, 0
	INCF       FSR, 1
	MOVWF      INDF+0
	INCF       motor_Tare_Finish_i_L0+0, 1
	GOTO       L_motor_Tare_Finish25
L_motor_Tare_Finish26:
	CLRF       motor_hx_idx+0
	CLRF       motor_weight_g+0
	CLRF       motor_weight_g+1
	CLRF       motor_weight_g+2
	CLRF       motor_weight_g+3
	CLRF       motor_overload_flag+0
	CLRF       motor_overload_cnt+0
L_end_Tare_Finish:
	RETURN
; end of motor_Tare_Finish

motor_Weight_PushSample:

	CLRF       motor_Weight_PushSample_sum_L0+0
	CLRF       motor_Weight_PushSample_sum_L0+1
	CLRF       motor_Weight_PushSample_sum_L0+2
	CLRF       motor_Weight_PushSample_sum_L0+3
	MOVF       motor_hx_idx+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      motor_hx_buf+0
	MOVWF      FSR
	MOVF       FARG_motor_Weight_PushSample_raw+0, 0
	MOVWF      INDF+0
	MOVF       FARG_motor_Weight_PushSample_raw+1, 0
	INCF       FSR, 1
	MOVWF      INDF+0
	MOVF       FARG_motor_Weight_PushSample_raw+2, 0
	INCF       FSR, 1
	MOVWF      INDF+0
	MOVF       FARG_motor_Weight_PushSample_raw+3, 0
	INCF       FSR, 1
	MOVWF      INDF+0
	INCF       motor_hx_idx+0, 1
	MOVLW      2
	SUBWF      motor_hx_idx+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_motor_Weight_PushSample28
	CLRF       motor_hx_idx+0
L_motor_Weight_PushSample28:
	CLRF       motor_Weight_PushSample_i_L0+0
L_motor_Weight_PushSample29:
	MOVLW      2
	SUBWF      motor_Weight_PushSample_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_motor_Weight_PushSample30
	MOVF       motor_Weight_PushSample_i_L0+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      motor_hx_buf+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	INCF       FSR, 1
	MOVF       INDF+0, 0
	MOVWF      R0+1
	INCF       FSR, 1
	MOVF       INDF+0, 0
	MOVWF      R0+2
	INCF       FSR, 1
	MOVF       INDF+0, 0
	MOVWF      R0+3
	MOVF       R0+0, 0
	ADDWF      motor_Weight_PushSample_sum_L0+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	INCFSZ     R0+1, 0
	ADDWF      motor_Weight_PushSample_sum_L0+1, 1
	MOVF       R0+2, 0
	BTFSC      STATUS+0, 0
	INCFSZ     R0+2, 0
	ADDWF      motor_Weight_PushSample_sum_L0+2, 1
	MOVF       R0+3, 0
	BTFSC      STATUS+0, 0
	INCFSZ     R0+3, 0
	ADDWF      motor_Weight_PushSample_sum_L0+3, 1
	INCF       motor_Weight_PushSample_i_L0+0, 1
	GOTO       L_motor_Weight_PushSample29
L_motor_Weight_PushSample30:
	MOVLW      2
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	MOVF       motor_Weight_PushSample_sum_L0+0, 0
	MOVWF      R0+0
	MOVF       motor_Weight_PushSample_sum_L0+1, 0
	MOVWF      R0+1
	MOVF       motor_Weight_PushSample_sum_L0+2, 0
	MOVWF      R0+2
	MOVF       motor_Weight_PushSample_sum_L0+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_S+0
	MOVF       R0+0, 0
	MOVWF      motor_Weight_PushSample_sum_L0+0
	MOVF       R0+1, 0
	MOVWF      motor_Weight_PushSample_sum_L0+1
	MOVF       R0+2, 0
	MOVWF      motor_Weight_PushSample_sum_L0+2
	MOVF       R0+3, 0
	MOVWF      motor_Weight_PushSample_sum_L0+3
	MOVF       R0+0, 0
	MOVWF      R4+0
	MOVF       R0+1, 0
	MOVWF      R4+1
	MOVF       R0+2, 0
	MOVWF      R4+2
	MOVF       R0+3, 0
	MOVWF      R4+3
	MOVF       motor_hx_offset+0, 0
	SUBWF      R4+0, 1
	MOVF       motor_hx_offset+1, 0
	BTFSS      STATUS+0, 0
	INCFSZ     motor_hx_offset+1, 0
	SUBWF      R4+1, 1
	MOVF       motor_hx_offset+2, 0
	BTFSS      STATUS+0, 0
	INCFSZ     motor_hx_offset+2, 0
	SUBWF      R4+2, 1
	MOVF       motor_hx_offset+3, 0
	BTFSS      STATUS+0, 0
	INCFSZ     motor_hx_offset+3, 0
	SUBWF      R4+3, 1
	MOVF       R4+0, 0
	MOVWF      motor_Weight_PushSample_diff_L0+0
	MOVF       R4+1, 0
	MOVWF      motor_Weight_PushSample_diff_L0+1
	MOVF       R4+2, 0
	MOVWF      motor_Weight_PushSample_diff_L0+2
	MOVF       R4+3, 0
	MOVWF      motor_Weight_PushSample_diff_L0+3
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      R4+3, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_motor_Weight_PushSample85
	MOVF       R4+2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_motor_Weight_PushSample85
	MOVF       R4+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_motor_Weight_PushSample85
	MOVF       R4+0, 0
	SUBLW      0
L_motor_Weight_PushSample85:
	BTFSS      STATUS+0, 0
	GOTO       L_motor_Weight_PushSample32
	CLRF       motor_weight_g+0
	CLRF       motor_weight_g+1
	CLRF       motor_weight_g+2
	CLRF       motor_weight_g+3
	GOTO       L_motor_Weight_PushSample33
L_motor_Weight_PushSample32:
	MOVF       motor_Weight_PushSample_diff_L0+0, 0
	MOVWF      motor_weight_g+0
	MOVF       motor_Weight_PushSample_diff_L0+1, 0
	MOVWF      motor_weight_g+1
	MOVF       motor_Weight_PushSample_diff_L0+2, 0
	MOVWF      motor_weight_g+2
	MOVF       motor_Weight_PushSample_diff_L0+3, 0
	MOVWF      motor_weight_g+3
L_motor_Weight_PushSample33:
	MOVF       motor_weight_g+3, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_motor_Weight_PushSample86
	MOVF       motor_weight_g+2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_motor_Weight_PushSample86
	MOVF       motor_weight_g+1, 0
	SUBLW      5
	BTFSS      STATUS+0, 2
	GOTO       L_motor_Weight_PushSample86
	MOVF       motor_weight_g+0, 0
	SUBLW      220
L_motor_Weight_PushSample86:
	BTFSC      STATUS+0, 0
	GOTO       L_motor_Weight_PushSample34
	MOVLW      255
	SUBWF      motor_overload_cnt+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_motor_Weight_PushSample35
	INCF       motor_overload_cnt+0, 1
L_motor_Weight_PushSample35:
	MOVLW      1
	SUBWF      motor_overload_cnt+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_motor_Weight_PushSample36
	MOVLW      1
	MOVWF      motor_overload_flag+0
L_motor_Weight_PushSample36:
	GOTO       L_motor_Weight_PushSample37
L_motor_Weight_PushSample34:
	MOVLW      50
	MOVWF      R1+0
	CLRF       R1+1
	CLRF       R1+2
	CLRF       R1+3
	MOVF       motor_weight_g+0, 0
	ADDWF      R1+0, 1
	MOVF       motor_weight_g+1, 0
	BTFSC      STATUS+0, 0
	INCFSZ     motor_weight_g+1, 0
	ADDWF      R1+1, 1
	MOVF       motor_weight_g+2, 0
	BTFSC      STATUS+0, 0
	INCFSZ     motor_weight_g+2, 0
	ADDWF      R1+2, 1
	MOVF       motor_weight_g+3, 0
	BTFSC      STATUS+0, 0
	INCFSZ     motor_weight_g+3, 0
	ADDWF      R1+3, 1
	MOVF       R1+3, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_motor_Weight_PushSample87
	MOVF       R1+2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_motor_Weight_PushSample87
	MOVF       R1+1, 0
	SUBLW      5
	BTFSS      STATUS+0, 2
	GOTO       L_motor_Weight_PushSample87
	MOVF       R1+0, 0
	SUBLW      220
L_motor_Weight_PushSample87:
	BTFSS      STATUS+0, 0
	GOTO       L_motor_Weight_PushSample38
	CLRF       motor_overload_cnt+0
	CLRF       motor_overload_flag+0
L_motor_Weight_PushSample38:
L_motor_Weight_PushSample37:
L_end_Weight_PushSample:
	RETURN
; end of motor_Weight_PushSample

_Motor_Init:

	MOVLW      6
	MOVWF      ADCON1+0
	BSF        TRISA0_bit+0, BitPos(TRISA0_bit+0)
	BCF        TRISA1_bit+0, BitPos(TRISA1_bit+0)
	BCF        TRISD0_bit+0, BitPos(TRISD0_bit+0)
	BCF        TRISD1_bit+0, BitPos(TRISD1_bit+0)
	BCF        TRISC2_bit+0, BitPos(TRISC2_bit+0)
	BCF        TRISC1_bit+0, BitPos(TRISC1_bit+0)
	BCF        TRISC0_bit+0, BitPos(TRISC0_bit+0)
	BCF        RA1_bit+0, BitPos(RA1_bit+0)
	BCF        RC0_bit+0, BitPos(RC0_bit+0)
	BCF        RC1_bit+0, BitPos(RC1_bit+0)
	CLRF       FARG_motor_Dir_Apply_dir+0
	CALL       motor_Dir_Apply+0
	MOVLW      255
	MOVWF      PR2+0
	MOVLW      6
	MOVWF      T2CON+0
	CLRF       CCPR1L+0
	MOVLW      12
	MOVWF      CCP1CON+0
	CLRF       motor_cur_dir+0
	CLRF       motor_tgt_dir+0
	CLRF       motor_cur_speed+0
	CLRF       motor_tgt_speed+0
	CLRF       motor_brake_released+0
	CLRF       motor_servo_level+0
	MOVLW      113
	MOVWF      motor_servo_width+0
	MOVLW      2
	MOVWF      motor_servo_width+1
	MOVLW      48
	MOVWF      T1CON+0
	CLRF       TMR1H+0
	CLRF       TMR1L+0
	CLRF       CCP2CON+0
	MOVLW      12
	MOVWF      CCPR2H+0
	MOVLW      53
	MOVWF      CCPR2L+0
	BCF        PIR2+0, 0
	MOVLW      10
	MOVWF      CCP2CON+0
	BSF        PIE2+0, 0
	BSF        INTCON+0, 6
	MOVLW      49
	MOVWF      T1CON+0
	BSF        INTCON+0, 7
	CLRF       motor_hx_offset+0
	CLRF       motor_hx_offset+1
	CLRF       motor_hx_offset+2
	CLRF       motor_hx_offset+3
	CLRF       motor_tare_sum+0
	CLRF       motor_tare_sum+1
	CLRF       motor_tare_sum+2
	CLRF       motor_tare_sum+3
	CLRF       motor_tare_count+0
	CLRF       Motor_Init_i_L0+0
L_Motor_Init39:
	MOVLW      2
	SUBWF      Motor_Init_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Motor_Init40
	MOVF       Motor_Init_i_L0+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      motor_hx_buf+0
	MOVWF      FSR
	MOVF       motor_hx_offset+0, 0
	MOVWF      INDF+0
	MOVF       motor_hx_offset+1, 0
	INCF       FSR, 1
	MOVWF      INDF+0
	MOVF       motor_hx_offset+2, 0
	INCF       FSR, 1
	MOVWF      INDF+0
	MOVF       motor_hx_offset+3, 0
	INCF       FSR, 1
	MOVWF      INDF+0
	INCF       Motor_Init_i_L0+0, 1
	GOTO       L_Motor_Init39
L_Motor_Init40:
	CLRF       motor_hx_idx+0
	CLRF       motor_weight_g+0
	CLRF       motor_weight_g+1
	CLRF       motor_weight_g+2
	CLRF       motor_weight_g+3
	CLRF       motor_overload_flag+0
	CLRF       motor_overload_cnt+0
	CLRF       FARG_motor_Motor_EnterState_new_state+0
	CALL       motor_Motor_EnterState+0
L_end_Motor_Init:
	RETURN
; end of _Motor_Init

_Motor_Update:

	MOVLW      255
	SUBWF      motor_state_ticks+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Motor_Update90
	MOVLW      255
	SUBWF      motor_state_ticks+0, 0
L__Motor_Update90:
	BTFSC      STATUS+0, 0
	GOTO       L_Motor_Update42
	INCF       motor_state_ticks+0, 1
	BTFSC      STATUS+0, 2
	INCF       motor_state_ticks+1, 1
L_Motor_Update42:
	MOVF       motor_motor_state+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Motor_Update45
	BTFSC      RA0_bit+0, BitPos(RA0_bit+0)
	GOTO       L_Motor_Update45
L__Motor_Update72:
	CALL       motor_HX711_ReadRaw+0
	MOVF       R0+0, 0
	MOVWF      FARG_motor_Weight_PushSample_raw+0
	MOVF       R0+1, 0
	MOVWF      FARG_motor_Weight_PushSample_raw+1
	MOVF       R0+2, 0
	MOVWF      FARG_motor_Weight_PushSample_raw+2
	MOVF       R0+3, 0
	MOVWF      FARG_motor_Weight_PushSample_raw+3
	CALL       motor_Weight_PushSample+0
L_Motor_Update45:
	GOTO       L_Motor_Update46
L_Motor_Update48:
	BTFSC      RA0_bit+0, BitPos(RA0_bit+0)
	GOTO       L_Motor_Update49
	CALL       motor_HX711_ReadRaw+0
	MOVF       R0+0, 0
	MOVWF      Motor_Update_raw_L0+0
	MOVF       R0+1, 0
	MOVWF      Motor_Update_raw_L0+1
	MOVF       R0+2, 0
	MOVWF      Motor_Update_raw_L0+2
	MOVF       R0+3, 0
	MOVWF      Motor_Update_raw_L0+3
	MOVLW      4
	SUBWF      motor_tare_count+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_Motor_Update50
	MOVF       Motor_Update_raw_L0+0, 0
	ADDWF      motor_tare_sum+0, 1
	MOVF       Motor_Update_raw_L0+1, 0
	BTFSC      STATUS+0, 0
	INCFSZ     Motor_Update_raw_L0+1, 0
	ADDWF      motor_tare_sum+1, 1
	MOVF       Motor_Update_raw_L0+2, 0
	BTFSC      STATUS+0, 0
	INCFSZ     Motor_Update_raw_L0+2, 0
	ADDWF      motor_tare_sum+2, 1
	MOVF       Motor_Update_raw_L0+3, 0
	BTFSC      STATUS+0, 0
	INCFSZ     Motor_Update_raw_L0+3, 0
	ADDWF      motor_tare_sum+3, 1
L_Motor_Update50:
	INCF       motor_tare_count+0, 1
	MOVLW      12
	SUBWF      motor_tare_count+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_Motor_Update51
	CALL       motor_Tare_Finish+0
	MOVLW      1
	MOVWF      FARG_motor_Motor_EnterState_new_state+0
	CALL       motor_Motor_EnterState+0
	GOTO       L_Motor_Update47
L_Motor_Update51:
L_Motor_Update49:
	MOVLW      1
	SUBWF      motor_state_ticks+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Motor_Update91
	MOVLW      44
	SUBWF      motor_state_ticks+0, 0
L__Motor_Update91:
	BTFSS      STATUS+0, 0
	GOTO       L_Motor_Update52
	CALL       motor_Tare_Finish+0
	MOVLW      1
	MOVWF      FARG_motor_Motor_EnterState_new_state+0
	CALL       motor_Motor_EnterState+0
L_Motor_Update52:
	GOTO       L_Motor_Update47
L_Motor_Update53:
	MOVF       motor_tgt_dir+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Motor_Update56
	MOVLW      0
	SUBWF      motor_state_ticks+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Motor_Update92
	MOVLW      10
	SUBWF      motor_state_ticks+0, 0
L__Motor_Update92:
	BTFSS      STATUS+0, 0
	GOTO       L_Motor_Update56
L__Motor_Update71:
	MOVF       motor_tgt_dir+0, 0
	MOVWF      motor_cur_dir+0
	MOVF       motor_tgt_dir+0, 0
	MOVWF      FARG_motor_Dir_Apply_dir+0
	CALL       motor_Dir_Apply+0
	MOVLW      2
	MOVWF      FARG_motor_Motor_EnterState_new_state+0
	CALL       motor_Motor_EnterState+0
L_Motor_Update56:
	GOTO       L_Motor_Update47
L_Motor_Update57:
	MOVF       motor_tgt_dir+0, 0
	XORWF      motor_cur_dir+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Motor_Update58
	MOVLW      3
	MOVWF      FARG_motor_Motor_EnterState_new_state+0
	CALL       motor_Motor_EnterState+0
	GOTO       L_Motor_Update47
L_Motor_Update58:
	MOVF       motor_tgt_speed+0, 0
	MOVWF      FARG_motor_Speed_Ramp_target+0
	CALL       motor_Speed_Ramp+0
	GOTO       L_Motor_Update47
L_Motor_Update59:
	MOVF       motor_tgt_dir+0, 0
	XORWF      motor_cur_dir+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_Motor_Update60
	MOVLW      2
	MOVWF      FARG_motor_Motor_EnterState_new_state+0
	CALL       motor_Motor_EnterState+0
	GOTO       L_Motor_Update47
L_Motor_Update60:
	CLRF       FARG_motor_Speed_Ramp_target+0
	CALL       motor_Speed_Ramp+0
	MOVF       motor_cur_speed+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_Motor_Update61
	CLRF       FARG_motor_Dir_Apply_dir+0
	CALL       motor_Dir_Apply+0
	CLRF       motor_cur_dir+0
	MOVLW      1
	MOVWF      FARG_motor_Motor_EnterState_new_state+0
	CALL       motor_Motor_EnterState+0
L_Motor_Update61:
	GOTO       L_Motor_Update47
L_Motor_Update62:
	CALL       _Motor_Stop+0
	MOVLW      1
	MOVWF      FARG_motor_Motor_EnterState_new_state+0
	CALL       motor_Motor_EnterState+0
	GOTO       L_Motor_Update47
L_Motor_Update46:
	MOVF       motor_motor_state+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Motor_Update48
	MOVF       motor_motor_state+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_Motor_Update53
	MOVF       motor_motor_state+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_Motor_Update57
	MOVF       motor_motor_state+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_Motor_Update59
	GOTO       L_Motor_Update62
L_Motor_Update47:
L_end_Motor_Update:
	RETURN
; end of _Motor_Update

_Motor_Set:

	MOVF       FARG_Motor_Set_direction+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L__Motor_Set73
	MOVF       FARG_Motor_Set_speed_percent+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L__Motor_Set73
	GOTO       L_Motor_Set65
L__Motor_Set73:
	CALL       _Motor_Stop+0
	GOTO       L_end_Motor_Set
L_Motor_Set65:
	MOVF       FARG_Motor_Set_speed_percent+0, 0
	SUBLW      100
	BTFSC      STATUS+0, 0
	GOTO       L_Motor_Set66
	MOVLW      100
	MOVWF      FARG_Motor_Set_speed_percent+0
L_Motor_Set66:
	MOVF       FARG_Motor_Set_direction+0, 0
	MOVWF      motor_tgt_dir+0
	MOVF       FARG_Motor_Set_speed_percent+0, 0
	MOVWF      motor_tgt_speed+0
L_end_Motor_Set:
	RETURN
; end of _Motor_Set

_Motor_Stop:

	CLRF       FARG_motor_Pwm_SetPercent_percent+0
	CALL       motor_Pwm_SetPercent+0
	CLRF       FARG_motor_Dir_Apply_dir+0
	CALL       motor_Dir_Apply+0
	CLRF       motor_cur_dir+0
	CLRF       motor_tgt_dir+0
	CLRF       motor_cur_speed+0
	CLRF       motor_tgt_speed+0
	MOVF       motor_motor_state+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L__Motor_Stop74
	MOVF       motor_motor_state+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L__Motor_Stop74
	GOTO       L_Motor_Stop69
L__Motor_Stop74:
	MOVLW      1
	MOVWF      FARG_motor_Motor_EnterState_new_state+0
	CALL       motor_Motor_EnterState+0
L_Motor_Stop69:
L_end_Motor_Stop:
	RETURN
; end of _Motor_Stop

_Brake_Release:

	MOVLW      1
	MOVWF      motor_brake_released+0
L_end_Brake_Release:
	RETURN
; end of _Brake_Release

_Brake_Engage:

	CLRF       motor_brake_released+0
L_end_Brake_Engage:
	RETURN
; end of _Brake_Engage

_Weight_GetGrams:

	MOVF       motor_weight_g+0, 0
	MOVWF      R0+0
	MOVF       motor_weight_g+1, 0
	MOVWF      R0+1
	MOVF       motor_weight_g+2, 0
	MOVWF      R0+2
	MOVF       motor_weight_g+3, 0
	MOVWF      R0+3
L_end_Weight_GetGrams:
	RETURN
; end of _Weight_GetGrams

_Weight_IsOverload:

	MOVF       motor_overload_flag+0, 0
	MOVWF      R0+0
L_end_Weight_IsOverload:
	RETURN
; end of _Weight_IsOverload

motor____?ag:

L_end_motor___?ag:
	RETURN
; end of motor____?ag
