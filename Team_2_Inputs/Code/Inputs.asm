
Inputs_lcd_write_nibble:

	MOVLW      7
	ANDWF      PORTD+0, 0
	MOVWF      R3+0
	MOVLW      15
	ANDWF      FARG_Inputs_lcd_write_nibble_nibble+0, 0
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
	MOVF       R0+0, 0
	IORWF      R3+0, 0
	MOVWF      PORTD+0
	NOP
	NOP
	NOP
	NOP
	NOP
	BSF        PORTD+0, 3
	MOVLW      8
	MOVWF      R13+0
L_Inputs_lcd_write_nibble0:
	DECFSZ     R13+0, 1
	GOTO       L_Inputs_lcd_write_nibble0
	BCF        PORTD+0, 3
	MOVLW      8
	MOVWF      R13+0
L_Inputs_lcd_write_nibble1:
	DECFSZ     R13+0, 1
	GOTO       L_Inputs_lcd_write_nibble1
L_end_lcd_write_nibble:
	RETURN
; end of Inputs_lcd_write_nibble

Inputs_lcd_send_byte:

	MOVF       FARG_Inputs_lcd_send_byte_is_data+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_lcd_send_byte2
	MOVLW      1
	MOVWF      Inputs_?FLOC__Inputs_lcd_send_byteT10+0
	GOTO       L_Inputs_lcd_send_byte3
L_Inputs_lcd_send_byte2:
	CLRF       Inputs_?FLOC__Inputs_lcd_send_byteT10+0
L_Inputs_lcd_send_byte3:
	BTFSC      Inputs_?FLOC__Inputs_lcd_send_byteT10+0, 0
	GOTO       L_Inputs_lcd_send_byte204
	BCF        PORTD+0, 2
	GOTO       L_Inputs_lcd_send_byte205
L_Inputs_lcd_send_byte204:
	BSF        PORTD+0, 2
L_Inputs_lcd_send_byte205:
	MOVF       FARG_Inputs_lcd_send_byte_value+0, 0
	MOVWF      FARG_Inputs_lcd_write_nibble_nibble+0
	RRF        FARG_Inputs_lcd_write_nibble_nibble+0, 1
	BCF        FARG_Inputs_lcd_write_nibble_nibble+0, 7
	RRF        FARG_Inputs_lcd_write_nibble_nibble+0, 1
	BCF        FARG_Inputs_lcd_write_nibble_nibble+0, 7
	RRF        FARG_Inputs_lcd_write_nibble_nibble+0, 1
	BCF        FARG_Inputs_lcd_write_nibble_nibble+0, 7
	RRF        FARG_Inputs_lcd_write_nibble_nibble+0, 1
	BCF        FARG_Inputs_lcd_write_nibble_nibble+0, 7
	CALL       Inputs_lcd_write_nibble+0
	MOVLW      15
	ANDWF      FARG_Inputs_lcd_send_byte_value+0, 0
	MOVWF      FARG_Inputs_lcd_write_nibble_nibble+0
	CALL       Inputs_lcd_write_nibble+0
	MOVLW      83
	MOVWF      R13+0
L_Inputs_lcd_send_byte4:
	DECFSZ     R13+0, 1
	GOTO       L_Inputs_lcd_send_byte4
L_end_lcd_send_byte:
	RETURN
; end of Inputs_lcd_send_byte

Inputs_lcd_hw_init:

	BCF        TRISD+0, 2
	BCF        TRISD+0, 3
	BCF        TRISD+0, 4
	BCF        TRISD+0, 5
	BCF        TRISD+0, 6
	BCF        TRISD+0, 7
	BCF        PORTD+0, 2
	BCF        PORTD+0, 3
	BCF        PORTD+0, 4
	BCF        PORTD+0, 5
	BCF        PORTD+0, 6
	BCF        PORTD+0, 7
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_Inputs_lcd_hw_init5:
	DECFSZ     R13+0, 1
	GOTO       L_Inputs_lcd_hw_init5
	DECFSZ     R12+0, 1
	GOTO       L_Inputs_lcd_hw_init5
	DECFSZ     R11+0, 1
	GOTO       L_Inputs_lcd_hw_init5
	NOP
	MOVLW      3
	MOVWF      FARG_Inputs_lcd_write_nibble_nibble+0
	CALL       Inputs_lcd_write_nibble+0
	MOVLW      33
	MOVWF      R12+0
	MOVLW      118
	MOVWF      R13+0
L_Inputs_lcd_hw_init6:
	DECFSZ     R13+0, 1
	GOTO       L_Inputs_lcd_hw_init6
	DECFSZ     R12+0, 1
	GOTO       L_Inputs_lcd_hw_init6
	NOP
	MOVLW      3
	MOVWF      FARG_Inputs_lcd_write_nibble_nibble+0
	CALL       Inputs_lcd_write_nibble+0
	MOVLW      2
	MOVWF      R12+0
	MOVLW      75
	MOVWF      R13+0
L_Inputs_lcd_hw_init7:
	DECFSZ     R13+0, 1
	GOTO       L_Inputs_lcd_hw_init7
	DECFSZ     R12+0, 1
	GOTO       L_Inputs_lcd_hw_init7
	MOVLW      3
	MOVWF      FARG_Inputs_lcd_write_nibble_nibble+0
	CALL       Inputs_lcd_write_nibble+0
	MOVLW      2
	MOVWF      R12+0
	MOVLW      75
	MOVWF      R13+0
L_Inputs_lcd_hw_init8:
	DECFSZ     R13+0, 1
	GOTO       L_Inputs_lcd_hw_init8
	DECFSZ     R12+0, 1
	GOTO       L_Inputs_lcd_hw_init8
	MOVLW      2
	MOVWF      FARG_Inputs_lcd_write_nibble_nibble+0
	CALL       Inputs_lcd_write_nibble+0
	MOVLW      2
	MOVWF      R12+0
	MOVLW      75
	MOVWF      R13+0
L_Inputs_lcd_hw_init9:
	DECFSZ     R13+0, 1
	GOTO       L_Inputs_lcd_hw_init9
	DECFSZ     R12+0, 1
	GOTO       L_Inputs_lcd_hw_init9
	MOVLW      40
	MOVWF      FARG_Inputs_lcd_send_byte_value+0
	CLRF       FARG_Inputs_lcd_send_byte_is_data+0
	CALL       Inputs_lcd_send_byte+0
	MOVLW      12
	MOVWF      FARG_Inputs_lcd_send_byte_value+0
	CLRF       FARG_Inputs_lcd_send_byte_is_data+0
	CALL       Inputs_lcd_send_byte+0
	MOVLW      1
	MOVWF      FARG_Inputs_lcd_send_byte_value+0
	CLRF       FARG_Inputs_lcd_send_byte_is_data+0
	CALL       Inputs_lcd_send_byte+0
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_Inputs_lcd_hw_init10:
	DECFSZ     R13+0, 1
	GOTO       L_Inputs_lcd_hw_init10
	DECFSZ     R12+0, 1
	GOTO       L_Inputs_lcd_hw_init10
	NOP
	NOP
	MOVLW      6
	MOVWF      FARG_Inputs_lcd_send_byte_value+0
	CLRF       FARG_Inputs_lcd_send_byte_is_data+0
	CALL       Inputs_lcd_send_byte+0
L_end_lcd_hw_init:
	RETURN
; end of Inputs_lcd_hw_init

Inputs_lcd_write_line:

	MOVF       FARG_Inputs_lcd_write_line_row+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_lcd_write_line11
	MOVLW      192
	MOVWF      Inputs_?FLOC__Inputs_lcd_write_lineT40+0
	GOTO       L_Inputs_lcd_write_line12
L_Inputs_lcd_write_line11:
	MOVLW      128
	MOVWF      Inputs_?FLOC__Inputs_lcd_write_lineT40+0
L_Inputs_lcd_write_line12:
	MOVF       Inputs_?FLOC__Inputs_lcd_write_lineT40+0, 0
	MOVWF      FARG_Inputs_lcd_send_byte_value+0
	CLRF       FARG_Inputs_lcd_send_byte_is_data+0
	CALL       Inputs_lcd_send_byte+0
	CLRF       Inputs_lcd_write_line_i_L0+0
L_Inputs_lcd_write_line13:
	MOVLW      16
	SUBWF      Inputs_lcd_write_line_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_lcd_write_line14
	MOVF       Inputs_lcd_write_line_i_L0+0, 0
	ADDWF      FARG_Inputs_lcd_write_line_ram_text+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_Inputs_lcd_send_byte_value+0
	MOVLW      1
	MOVWF      FARG_Inputs_lcd_send_byte_is_data+0
	CALL       Inputs_lcd_send_byte+0
	INCF       Inputs_lcd_write_line_i_L0+0, 1
	GOTO       L_Inputs_lcd_write_line13
L_Inputs_lcd_write_line14:
L_end_lcd_write_line:
	RETURN
; end of Inputs_lcd_write_line

Inputs_buf_put_const_str:

L_Inputs_buf_put_const_str16:
	MOVF       FARG_Inputs_buf_put_const_str_s+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       FARG_Inputs_buf_put_const_str_s+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buf_put_const_str17
	MOVLW      16
	SUBWF      FARG_Inputs_buf_put_const_str_pos+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_buf_put_const_str17
L_Inputs_buf_put_const_str188:
	MOVF       FARG_Inputs_buf_put_const_str_pos+0, 0
	ADDWF      FARG_Inputs_buf_put_const_str_buf+0, 0
	MOVWF      R1+0
	MOVF       FARG_Inputs_buf_put_const_str_s+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       FARG_Inputs_buf_put_const_str_s+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      R0+0
	MOVF       R1+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
	INCF       FARG_Inputs_buf_put_const_str_pos+0, 1
	INCF       FARG_Inputs_buf_put_const_str_s+0, 1
	BTFSC      STATUS+0, 2
	INCF       FARG_Inputs_buf_put_const_str_s+1, 1
	GOTO       L_Inputs_buf_put_const_str16
L_Inputs_buf_put_const_str17:
	MOVF       FARG_Inputs_buf_put_const_str_pos+0, 0
	MOVWF      R0+0
L_end_buf_put_const_str:
	RETURN
; end of Inputs_buf_put_const_str

Inputs_buf_put_ulong:

	CLRF       Inputs_buf_put_ulong_started_L0+0
	MOVF       FARG_Inputs_buf_put_ulong_value+3, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_buf_put_ulong210
	MOVF       FARG_Inputs_buf_put_ulong_value+2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_buf_put_ulong210
	MOVF       FARG_Inputs_buf_put_ulong_value+1, 0
	SUBLW      253
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_buf_put_ulong210
	MOVF       FARG_Inputs_buf_put_ulong_value+0, 0
	SUBLW      232
L_Inputs_buf_put_ulong210:
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_buf_put_ulong20
	MOVLW      232
	MOVWF      FARG_Inputs_buf_put_ulong_value+0
	MOVLW      253
	MOVWF      FARG_Inputs_buf_put_ulong_value+1
	MOVLW      0
	MOVWF      FARG_Inputs_buf_put_ulong_value+2
	MOVLW      0
	MOVWF      FARG_Inputs_buf_put_ulong_value+3
L_Inputs_buf_put_ulong20:
	MOVF       FARG_Inputs_buf_put_ulong_value+0, 0
	MOVWF      R2+0
	MOVF       FARG_Inputs_buf_put_ulong_value+1, 0
	MOVWF      R2+1
	CLRF       R1+0
L_Inputs_buf_put_ulong21:
	MOVLW      39
	SUBWF      R2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_buf_put_ulong211
	MOVLW      16
	SUBWF      R2+0, 0
L_Inputs_buf_put_ulong211:
	BTFSS      STATUS+0, 0
	GOTO       L_Inputs_buf_put_ulong22
	MOVLW      16
	SUBWF      R2+0, 1
	BTFSS      STATUS+0, 0
	DECF       R2+1, 1
	MOVLW      39
	SUBWF      R2+1, 1
	INCF       R1+0, 1
	GOTO       L_Inputs_buf_put_ulong21
L_Inputs_buf_put_ulong22:
	MOVF       R1+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buf_put_ulong23
	MOVLW      1
	MOVWF      Inputs_buf_put_ulong_started_L0+0
	MOVLW      16
	SUBWF      FARG_Inputs_buf_put_ulong_pos+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_buf_put_ulong24
	MOVF       FARG_Inputs_buf_put_ulong_pos+0, 0
	ADDWF      FARG_Inputs_buf_put_ulong_buf+0, 0
	MOVWF      FSR
	MOVF       R1+0, 0
	ADDLW      48
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      INDF+0
	INCF       FARG_Inputs_buf_put_ulong_pos+0, 1
L_Inputs_buf_put_ulong24:
L_Inputs_buf_put_ulong23:
	CLRF       R1+0
L_Inputs_buf_put_ulong25:
	MOVLW      3
	SUBWF      R2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_buf_put_ulong212
	MOVLW      232
	SUBWF      R2+0, 0
L_Inputs_buf_put_ulong212:
	BTFSS      STATUS+0, 0
	GOTO       L_Inputs_buf_put_ulong26
	MOVLW      232
	SUBWF      R2+0, 1
	BTFSS      STATUS+0, 0
	DECF       R2+1, 1
	MOVLW      3
	SUBWF      R2+1, 1
	INCF       R1+0, 1
	GOTO       L_Inputs_buf_put_ulong25
L_Inputs_buf_put_ulong26:
	MOVF       R1+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_buf_put_ulong191
	MOVF       Inputs_buf_put_ulong_started_L0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_buf_put_ulong191
	GOTO       L_Inputs_buf_put_ulong29
L_Inputs_buf_put_ulong191:
	MOVLW      1
	MOVWF      Inputs_buf_put_ulong_started_L0+0
	MOVLW      16
	SUBWF      FARG_Inputs_buf_put_ulong_pos+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_buf_put_ulong30
	MOVF       FARG_Inputs_buf_put_ulong_pos+0, 0
	ADDWF      FARG_Inputs_buf_put_ulong_buf+0, 0
	MOVWF      FSR
	MOVF       R1+0, 0
	ADDLW      48
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      INDF+0
	INCF       FARG_Inputs_buf_put_ulong_pos+0, 1
L_Inputs_buf_put_ulong30:
L_Inputs_buf_put_ulong29:
	CLRF       R1+0
L_Inputs_buf_put_ulong31:
	MOVLW      0
	SUBWF      R2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_buf_put_ulong213
	MOVLW      100
	SUBWF      R2+0, 0
L_Inputs_buf_put_ulong213:
	BTFSS      STATUS+0, 0
	GOTO       L_Inputs_buf_put_ulong32
	MOVLW      100
	SUBWF      R2+0, 1
	BTFSS      STATUS+0, 0
	DECF       R2+1, 1
	INCF       R1+0, 1
	GOTO       L_Inputs_buf_put_ulong31
L_Inputs_buf_put_ulong32:
	MOVF       R1+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_buf_put_ulong190
	MOVF       Inputs_buf_put_ulong_started_L0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_buf_put_ulong190
	GOTO       L_Inputs_buf_put_ulong35
L_Inputs_buf_put_ulong190:
	MOVLW      1
	MOVWF      Inputs_buf_put_ulong_started_L0+0
	MOVLW      16
	SUBWF      FARG_Inputs_buf_put_ulong_pos+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_buf_put_ulong36
	MOVF       FARG_Inputs_buf_put_ulong_pos+0, 0
	ADDWF      FARG_Inputs_buf_put_ulong_buf+0, 0
	MOVWF      FSR
	MOVF       R1+0, 0
	ADDLW      48
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      INDF+0
	INCF       FARG_Inputs_buf_put_ulong_pos+0, 1
L_Inputs_buf_put_ulong36:
L_Inputs_buf_put_ulong35:
	CLRF       R1+0
L_Inputs_buf_put_ulong37:
	MOVLW      0
	SUBWF      R2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_buf_put_ulong214
	MOVLW      10
	SUBWF      R2+0, 0
L_Inputs_buf_put_ulong214:
	BTFSS      STATUS+0, 0
	GOTO       L_Inputs_buf_put_ulong38
	MOVLW      10
	SUBWF      R2+0, 1
	BTFSS      STATUS+0, 0
	DECF       R2+1, 1
	INCF       R1+0, 1
	GOTO       L_Inputs_buf_put_ulong37
L_Inputs_buf_put_ulong38:
	MOVF       R1+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_buf_put_ulong189
	MOVF       Inputs_buf_put_ulong_started_L0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_buf_put_ulong189
	GOTO       L_Inputs_buf_put_ulong41
L_Inputs_buf_put_ulong189:
	MOVLW      1
	MOVWF      Inputs_buf_put_ulong_started_L0+0
	MOVLW      16
	SUBWF      FARG_Inputs_buf_put_ulong_pos+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_buf_put_ulong42
	MOVF       FARG_Inputs_buf_put_ulong_pos+0, 0
	ADDWF      FARG_Inputs_buf_put_ulong_buf+0, 0
	MOVWF      FSR
	MOVF       R1+0, 0
	ADDLW      48
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      INDF+0
	INCF       FARG_Inputs_buf_put_ulong_pos+0, 1
L_Inputs_buf_put_ulong42:
L_Inputs_buf_put_ulong41:
	MOVLW      16
	SUBWF      FARG_Inputs_buf_put_ulong_pos+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_buf_put_ulong43
	MOVF       FARG_Inputs_buf_put_ulong_pos+0, 0
	ADDWF      FARG_Inputs_buf_put_ulong_buf+0, 0
	MOVWF      FSR
	MOVF       R2+0, 0
	ADDLW      48
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      INDF+0
	INCF       FARG_Inputs_buf_put_ulong_pos+0, 1
L_Inputs_buf_put_ulong43:
	MOVF       FARG_Inputs_buf_put_ulong_pos+0, 0
	MOVWF      R0+0
L_end_buf_put_ulong:
	RETURN
; end of Inputs_buf_put_ulong

Inputs_floor_to_char:

	MOVF       FARG_Inputs_floor_to_char_floor+0, 0
	SUBLW      3
	BTFSS      STATUS+0, 0
	GOTO       L_Inputs_floor_to_char44
	MOVF       FARG_Inputs_floor_to_char_floor+0, 0
	ADDLW      48
	MOVWF      R1+0
	GOTO       L_Inputs_floor_to_char45
L_Inputs_floor_to_char44:
	MOVLW      45
	MOVWF      R1+0
L_Inputs_floor_to_char45:
	MOVF       R1+0, 0
	MOVWF      R0+0
L_end_floor_to_char:
	RETURN
; end of Inputs_floor_to_char

Inputs_buf_put_state:

	GOTO       L_Inputs_buf_put_state46
L_Inputs_buf_put_state48:
	MOVF       FARG_Inputs_buf_put_state_buf+0, 0
	MOVWF      FARG_Inputs_buf_put_const_str_buf+0
	MOVF       FARG_Inputs_buf_put_state_pos+0, 0
	MOVWF      FARG_Inputs_buf_put_const_str_pos+0
	MOVLW      ?lstr_1_Inputs+0
	MOVWF      FARG_Inputs_buf_put_const_str_s+0
	MOVLW      hi_addr(?lstr_1_Inputs+0)
	MOVWF      FARG_Inputs_buf_put_const_str_s+1
	CALL       Inputs_buf_put_const_str+0
	GOTO       L_end_buf_put_state
L_Inputs_buf_put_state49:
	MOVF       FARG_Inputs_buf_put_state_buf+0, 0
	MOVWF      FARG_Inputs_buf_put_const_str_buf+0
	MOVF       FARG_Inputs_buf_put_state_pos+0, 0
	MOVWF      FARG_Inputs_buf_put_const_str_pos+0
	MOVLW      ?lstr_2_Inputs+0
	MOVWF      FARG_Inputs_buf_put_const_str_s+0
	MOVLW      hi_addr(?lstr_2_Inputs+0)
	MOVWF      FARG_Inputs_buf_put_const_str_s+1
	CALL       Inputs_buf_put_const_str+0
	GOTO       L_end_buf_put_state
L_Inputs_buf_put_state50:
	MOVF       FARG_Inputs_buf_put_state_buf+0, 0
	MOVWF      FARG_Inputs_buf_put_const_str_buf+0
	MOVF       FARG_Inputs_buf_put_state_pos+0, 0
	MOVWF      FARG_Inputs_buf_put_const_str_pos+0
	MOVLW      ?lstr_3_Inputs+0
	MOVWF      FARG_Inputs_buf_put_const_str_s+0
	MOVLW      hi_addr(?lstr_3_Inputs+0)
	MOVWF      FARG_Inputs_buf_put_const_str_s+1
	CALL       Inputs_buf_put_const_str+0
	GOTO       L_end_buf_put_state
L_Inputs_buf_put_state51:
	MOVF       FARG_Inputs_buf_put_state_buf+0, 0
	MOVWF      FARG_Inputs_buf_put_const_str_buf+0
	MOVF       FARG_Inputs_buf_put_state_pos+0, 0
	MOVWF      FARG_Inputs_buf_put_const_str_pos+0
	MOVLW      ?lstr_4_Inputs+0
	MOVWF      FARG_Inputs_buf_put_const_str_s+0
	MOVLW      hi_addr(?lstr_4_Inputs+0)
	MOVWF      FARG_Inputs_buf_put_const_str_s+1
	CALL       Inputs_buf_put_const_str+0
	GOTO       L_end_buf_put_state
L_Inputs_buf_put_state52:
	MOVF       FARG_Inputs_buf_put_state_buf+0, 0
	MOVWF      FARG_Inputs_buf_put_const_str_buf+0
	MOVF       FARG_Inputs_buf_put_state_pos+0, 0
	MOVWF      FARG_Inputs_buf_put_const_str_pos+0
	MOVLW      ?lstr_5_Inputs+0
	MOVWF      FARG_Inputs_buf_put_const_str_s+0
	MOVLW      hi_addr(?lstr_5_Inputs+0)
	MOVWF      FARG_Inputs_buf_put_const_str_s+1
	CALL       Inputs_buf_put_const_str+0
	GOTO       L_end_buf_put_state
L_Inputs_buf_put_state53:
	MOVF       FARG_Inputs_buf_put_state_buf+0, 0
	MOVWF      FARG_Inputs_buf_put_const_str_buf+0
	MOVF       FARG_Inputs_buf_put_state_pos+0, 0
	MOVWF      FARG_Inputs_buf_put_const_str_pos+0
	MOVLW      ?lstr_6_Inputs+0
	MOVWF      FARG_Inputs_buf_put_const_str_s+0
	MOVLW      hi_addr(?lstr_6_Inputs+0)
	MOVWF      FARG_Inputs_buf_put_const_str_s+1
	CALL       Inputs_buf_put_const_str+0
	GOTO       L_end_buf_put_state
L_Inputs_buf_put_state54:
	MOVF       FARG_Inputs_buf_put_state_buf+0, 0
	MOVWF      FARG_Inputs_buf_put_const_str_buf+0
	MOVF       FARG_Inputs_buf_put_state_pos+0, 0
	MOVWF      FARG_Inputs_buf_put_const_str_pos+0
	MOVLW      ?lstr_7_Inputs+0
	MOVWF      FARG_Inputs_buf_put_const_str_s+0
	MOVLW      hi_addr(?lstr_7_Inputs+0)
	MOVWF      FARG_Inputs_buf_put_const_str_s+1
	CALL       Inputs_buf_put_const_str+0
	GOTO       L_end_buf_put_state
L_Inputs_buf_put_state55:
	MOVF       FARG_Inputs_buf_put_state_buf+0, 0
	MOVWF      FARG_Inputs_buf_put_const_str_buf+0
	MOVF       FARG_Inputs_buf_put_state_pos+0, 0
	MOVWF      FARG_Inputs_buf_put_const_str_pos+0
	MOVLW      ?lstr_8_Inputs+0
	MOVWF      FARG_Inputs_buf_put_const_str_s+0
	MOVLW      hi_addr(?lstr_8_Inputs+0)
	MOVWF      FARG_Inputs_buf_put_const_str_s+1
	CALL       Inputs_buf_put_const_str+0
	GOTO       L_end_buf_put_state
L_Inputs_buf_put_state56:
	MOVF       FARG_Inputs_buf_put_state_buf+0, 0
	MOVWF      FARG_Inputs_buf_put_const_str_buf+0
	MOVF       FARG_Inputs_buf_put_state_pos+0, 0
	MOVWF      FARG_Inputs_buf_put_const_str_pos+0
	MOVLW      ?lstr_9_Inputs+0
	MOVWF      FARG_Inputs_buf_put_const_str_s+0
	MOVLW      hi_addr(?lstr_9_Inputs+0)
	MOVWF      FARG_Inputs_buf_put_const_str_s+1
	CALL       Inputs_buf_put_const_str+0
	GOTO       L_end_buf_put_state
L_Inputs_buf_put_state57:
	MOVF       FARG_Inputs_buf_put_state_buf+0, 0
	MOVWF      FARG_Inputs_buf_put_const_str_buf+0
	MOVF       FARG_Inputs_buf_put_state_pos+0, 0
	MOVWF      FARG_Inputs_buf_put_const_str_pos+0
	MOVLW      ?lstr_10_Inputs+0
	MOVWF      FARG_Inputs_buf_put_const_str_s+0
	MOVLW      hi_addr(?lstr_10_Inputs+0)
	MOVWF      FARG_Inputs_buf_put_const_str_s+1
	CALL       Inputs_buf_put_const_str+0
	GOTO       L_end_buf_put_state
L_Inputs_buf_put_state46:
	MOVF       FARG_Inputs_buf_put_state_state+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buf_put_state48
	MOVF       FARG_Inputs_buf_put_state_state+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buf_put_state49
	MOVF       FARG_Inputs_buf_put_state_state+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buf_put_state50
	MOVF       FARG_Inputs_buf_put_state_state+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buf_put_state51
	MOVF       FARG_Inputs_buf_put_state_state+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buf_put_state52
	MOVF       FARG_Inputs_buf_put_state_state+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buf_put_state53
	MOVF       FARG_Inputs_buf_put_state_state+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buf_put_state54
	MOVF       FARG_Inputs_buf_put_state_state+0, 0
	XORLW      7
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buf_put_state55
	MOVF       FARG_Inputs_buf_put_state_state+0, 0
	XORLW      8
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buf_put_state56
	GOTO       L_Inputs_buf_put_state57
L_end_buf_put_state:
	RETURN
; end of Inputs_buf_put_state

Inputs_buf_pad_line:

L_Inputs_buf_pad_line58:
	MOVLW      16
	SUBWF      FARG_Inputs_buf_pad_line_pos+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_buf_pad_line59
	MOVF       FARG_Inputs_buf_pad_line_pos+0, 0
	ADDWF      FARG_Inputs_buf_pad_line_buf+0, 0
	MOVWF      FSR
	MOVLW      32
	MOVWF      INDF+0
	INCF       FARG_Inputs_buf_pad_line_pos+0, 1
	GOTO       L_Inputs_buf_pad_line58
L_Inputs_buf_pad_line59:
	MOVLW      16
	ADDWF      FARG_Inputs_buf_pad_line_buf+0, 0
	MOVWF      FSR
	CLRF       INDF+0
L_end_buf_pad_line:
	RETURN
; end of Inputs_buf_pad_line

Inputs_lcd_flush_if_changed:

	CLRF       Inputs_lcd_flush_if_changed_changed_L0+0
	CLRF       Inputs_lcd_flush_if_changed_i_L0+0
L_Inputs_lcd_flush_if_changed60:
	MOVLW      16
	SUBWF      Inputs_lcd_flush_if_changed_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_lcd_flush_if_changed61
	MOVLW      17
	MOVWF      R0+0
	MOVF       FARG_Inputs_lcd_flush_if_changed_row+0, 0
	MOVWF      R4+0
	CALL       _Mul_8X8_U+0
	MOVLW      Inputs_lcd_cache+0
	ADDWF      R0+0, 1
	MOVF       Inputs_lcd_flush_if_changed_i_L0+0, 0
	ADDWF      R0+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R1+0
	MOVF       Inputs_lcd_flush_if_changed_i_L0+0, 0
	ADDLW      Inputs_lcd_line_buf+0
	MOVWF      FSR
	MOVF       R1+0, 0
	XORWF      INDF+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_lcd_flush_if_changed63
	MOVLW      1
	MOVWF      Inputs_lcd_flush_if_changed_changed_L0+0
	GOTO       L_Inputs_lcd_flush_if_changed61
L_Inputs_lcd_flush_if_changed63:
	INCF       Inputs_lcd_flush_if_changed_i_L0+0, 1
	GOTO       L_Inputs_lcd_flush_if_changed60
L_Inputs_lcd_flush_if_changed61:
	MOVF       Inputs_lcd_flush_if_changed_changed_L0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_lcd_flush_if_changed64
	CLRF       Inputs_lcd_flush_if_changed_i_L0+0
L_Inputs_lcd_flush_if_changed65:
	MOVLW      17
	SUBWF      Inputs_lcd_flush_if_changed_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_lcd_flush_if_changed66
	MOVLW      17
	MOVWF      R0+0
	MOVF       FARG_Inputs_lcd_flush_if_changed_row+0, 0
	MOVWF      R4+0
	CALL       _Mul_8X8_U+0
	MOVLW      Inputs_lcd_cache+0
	ADDWF      R0+0, 1
	MOVF       Inputs_lcd_flush_if_changed_i_L0+0, 0
	ADDWF      R0+0, 0
	MOVWF      R1+0
	MOVF       Inputs_lcd_flush_if_changed_i_L0+0, 0
	ADDLW      Inputs_lcd_line_buf+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	MOVF       R1+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
	INCF       Inputs_lcd_flush_if_changed_i_L0+0, 1
	GOTO       L_Inputs_lcd_flush_if_changed65
L_Inputs_lcd_flush_if_changed66:
	MOVF       FARG_Inputs_lcd_flush_if_changed_row+0, 0
	MOVWF      FARG_Inputs_lcd_write_line_row+0
	MOVLW      Inputs_lcd_line_buf+0
	MOVWF      FARG_Inputs_lcd_write_line_ram_text+0
	CALL       Inputs_lcd_write_line+0
L_Inputs_lcd_flush_if_changed64:
L_end_lcd_flush_if_changed:
	RETURN
; end of Inputs_lcd_flush_if_changed

Inputs_keypad_rows_idle:

	MOVLW      255
	MOVWF      PORTB+0
L_end_keypad_rows_idle:
	RETURN
; end of Inputs_keypad_rows_idle

Inputs_keypad_scan_raw:

	CLRF       Inputs_keypad_scan_raw_key_L0+0
	CLRF       Inputs_keypad_scan_raw_row_L0+0
L_Inputs_keypad_scan_raw68:
	MOVLW      4
	SUBWF      Inputs_keypad_scan_raw_row_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_keypad_scan_raw69
	MOVF       Inputs_keypad_scan_raw_key_L0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_keypad_scan_raw69
L_Inputs_keypad_scan_raw192:
	MOVF       Inputs_keypad_scan_raw_row_L0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_keypad_scan_raw73
	MOVLW      239
	MOVWF      PORTB+0
	GOTO       L_Inputs_keypad_scan_raw74
L_Inputs_keypad_scan_raw73:
	MOVF       Inputs_keypad_scan_raw_row_L0+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_keypad_scan_raw75
	MOVLW      223
	MOVWF      PORTB+0
	GOTO       L_Inputs_keypad_scan_raw76
L_Inputs_keypad_scan_raw75:
	MOVF       Inputs_keypad_scan_raw_row_L0+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_keypad_scan_raw77
	MOVLW      191
	MOVWF      PORTB+0
	GOTO       L_Inputs_keypad_scan_raw78
L_Inputs_keypad_scan_raw77:
	MOVLW      127
	MOVWF      PORTB+0
L_Inputs_keypad_scan_raw78:
L_Inputs_keypad_scan_raw76:
L_Inputs_keypad_scan_raw74:
	MOVLW      33
	MOVWF      R13+0
L_Inputs_keypad_scan_raw79:
	DECFSZ     R13+0, 1
	GOTO       L_Inputs_keypad_scan_raw79
	BTFSC      PORTB+0, 0
	GOTO       L_Inputs_keypad_scan_raw80
	MOVF       Inputs_keypad_scan_raw_row_L0+0, 0
	MOVWF      Inputs_keypad_scan_raw_key_L0+0
	RLF        Inputs_keypad_scan_raw_key_L0+0, 1
	BCF        Inputs_keypad_scan_raw_key_L0+0, 0
	RLF        Inputs_keypad_scan_raw_key_L0+0, 1
	BCF        Inputs_keypad_scan_raw_key_L0+0, 0
	INCF       Inputs_keypad_scan_raw_key_L0+0, 1
	GOTO       L_Inputs_keypad_scan_raw81
L_Inputs_keypad_scan_raw80:
	BTFSC      PORTB+0, 1
	GOTO       L_Inputs_keypad_scan_raw82
	MOVF       Inputs_keypad_scan_raw_row_L0+0, 0
	MOVWF      Inputs_keypad_scan_raw_key_L0+0
	RLF        Inputs_keypad_scan_raw_key_L0+0, 1
	BCF        Inputs_keypad_scan_raw_key_L0+0, 0
	RLF        Inputs_keypad_scan_raw_key_L0+0, 1
	BCF        Inputs_keypad_scan_raw_key_L0+0, 0
	MOVLW      2
	ADDWF      Inputs_keypad_scan_raw_key_L0+0, 1
	GOTO       L_Inputs_keypad_scan_raw83
L_Inputs_keypad_scan_raw82:
	BTFSC      PORTB+0, 2
	GOTO       L_Inputs_keypad_scan_raw84
	MOVF       Inputs_keypad_scan_raw_row_L0+0, 0
	MOVWF      Inputs_keypad_scan_raw_key_L0+0
	RLF        Inputs_keypad_scan_raw_key_L0+0, 1
	BCF        Inputs_keypad_scan_raw_key_L0+0, 0
	RLF        Inputs_keypad_scan_raw_key_L0+0, 1
	BCF        Inputs_keypad_scan_raw_key_L0+0, 0
	MOVLW      3
	ADDWF      Inputs_keypad_scan_raw_key_L0+0, 1
	GOTO       L_Inputs_keypad_scan_raw85
L_Inputs_keypad_scan_raw84:
	BTFSC      PORTB+0, 3
	GOTO       L_Inputs_keypad_scan_raw86
	MOVF       Inputs_keypad_scan_raw_row_L0+0, 0
	MOVWF      Inputs_keypad_scan_raw_key_L0+0
	RLF        Inputs_keypad_scan_raw_key_L0+0, 1
	BCF        Inputs_keypad_scan_raw_key_L0+0, 0
	RLF        Inputs_keypad_scan_raw_key_L0+0, 1
	BCF        Inputs_keypad_scan_raw_key_L0+0, 0
	MOVLW      4
	ADDWF      Inputs_keypad_scan_raw_key_L0+0, 1
L_Inputs_keypad_scan_raw86:
L_Inputs_keypad_scan_raw85:
L_Inputs_keypad_scan_raw83:
L_Inputs_keypad_scan_raw81:
	INCF       Inputs_keypad_scan_raw_row_L0+0, 1
	GOTO       L_Inputs_keypad_scan_raw68
L_Inputs_keypad_scan_raw69:
	CALL       Inputs_keypad_rows_idle+0
	MOVF       Inputs_keypad_scan_raw_key_L0+0, 0
	MOVWF      R0+0
L_end_keypad_scan_raw:
	RETURN
; end of Inputs_keypad_scan_raw

Inputs_landing_buttons_read_raw_mask:

	CLRF       Inputs_landing_buttons_read_raw_mask_mask_L0+0
	BTFSS      PORTA+0, 2
	GOTO       L_Inputs_landing_buttons_read_raw_mask87
	BSF        Inputs_landing_buttons_read_raw_mask_mask_L0+0, 0
L_Inputs_landing_buttons_read_raw_mask87:
	BTFSS      PORTA+0, 3
	GOTO       L_Inputs_landing_buttons_read_raw_mask88
	BSF        Inputs_landing_buttons_read_raw_mask_mask_L0+0, 1
L_Inputs_landing_buttons_read_raw_mask88:
	BTFSS      PORTA+0, 4
	GOTO       L_Inputs_landing_buttons_read_raw_mask89
	BSF        Inputs_landing_buttons_read_raw_mask_mask_L0+0, 2
L_Inputs_landing_buttons_read_raw_mask89:
	BTFSS      PORTA+0, 5
	GOTO       L_Inputs_landing_buttons_read_raw_mask90
	BSF        Inputs_landing_buttons_read_raw_mask_mask_L0+0, 3
L_Inputs_landing_buttons_read_raw_mask90:
	MOVF       Inputs_landing_buttons_read_raw_mask_mask_L0+0, 0
	MOVWF      R0+0
L_end_landing_buttons_read_raw_mask:
	RETURN
; end of Inputs_landing_buttons_read_raw_mask

Inputs_request_queue_push:

	MOVF       FARG_Inputs_request_queue_push_floor+0, 0
	SUBLW      3
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_request_queue_push91
	GOTO       L_end_request_queue_push
L_Inputs_request_queue_push91:
	MOVLW      8
	SUBWF      Inputs_req_count+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_Inputs_request_queue_push92
	GOTO       L_end_request_queue_push
L_Inputs_request_queue_push92:
	MOVF       Inputs_req_tail+0, 0
	ADDLW      Inputs_req_queue+0
	MOVWF      FSR
	MOVF       FARG_Inputs_request_queue_push_floor+0, 0
	MOVWF      INDF+0
	INCF       Inputs_req_tail+0, 1
	MOVLW      8
	SUBWF      Inputs_req_tail+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_Inputs_request_queue_push93
	CLRF       Inputs_req_tail+0
L_Inputs_request_queue_push93:
	INCF       Inputs_req_count+0, 1
L_end_request_queue_push:
	RETURN
; end of Inputs_request_queue_push

Inputs_handle_debounced_keypad:

	GOTO       L_Inputs_handle_debounced_keypad94
L_Inputs_handle_debounced_keypad96:
	CLRF       FARG_Inputs_request_queue_push_floor+0
	CALL       Inputs_request_queue_push+0
	GOTO       L_Inputs_handle_debounced_keypad95
L_Inputs_handle_debounced_keypad97:
	MOVLW      1
	MOVWF      FARG_Inputs_request_queue_push_floor+0
	CALL       Inputs_request_queue_push+0
	GOTO       L_Inputs_handle_debounced_keypad95
L_Inputs_handle_debounced_keypad98:
	MOVLW      2
	MOVWF      FARG_Inputs_request_queue_push_floor+0
	CALL       Inputs_request_queue_push+0
	GOTO       L_Inputs_handle_debounced_keypad95
L_Inputs_handle_debounced_keypad99:
	MOVLW      3
	MOVWF      FARG_Inputs_request_queue_push_floor+0
	CALL       Inputs_request_queue_push+0
	GOTO       L_Inputs_handle_debounced_keypad95
L_Inputs_handle_debounced_keypad100:
	GOTO       L_Inputs_handle_debounced_keypad95
L_Inputs_handle_debounced_keypad94:
	MOVF       FARG_Inputs_handle_debounced_keypad_key+0, 0
	XORLW      14
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_handle_debounced_keypad96
	MOVF       FARG_Inputs_handle_debounced_keypad_key+0, 0
	XORLW      9
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_handle_debounced_keypad97
	MOVF       FARG_Inputs_handle_debounced_keypad_key+0, 0
	XORLW      10
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_handle_debounced_keypad98
	MOVF       FARG_Inputs_handle_debounced_keypad_key+0, 0
	XORLW      11
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_handle_debounced_keypad99
	GOTO       L_Inputs_handle_debounced_keypad100
L_Inputs_handle_debounced_keypad95:
L_end_handle_debounced_keypad:
	RETURN
; end of Inputs_handle_debounced_keypad

Inputs_hall_read_raw_mask:

	CLRF       Inputs_hall_read_raw_mask_mask_L0+0
	BTFSS      PORTC+0, 3
	GOTO       L_Inputs_hall_read_raw_mask101
	BSF        Inputs_hall_read_raw_mask_mask_L0+0, 0
L_Inputs_hall_read_raw_mask101:
	BTFSS      PORTC+0, 4
	GOTO       L_Inputs_hall_read_raw_mask102
	BSF        Inputs_hall_read_raw_mask_mask_L0+0, 1
L_Inputs_hall_read_raw_mask102:
	BTFSS      PORTC+0, 5
	GOTO       L_Inputs_hall_read_raw_mask103
	BSF        Inputs_hall_read_raw_mask_mask_L0+0, 2
L_Inputs_hall_read_raw_mask103:
	BTFSS      PORTC+0, 6
	GOTO       L_Inputs_hall_read_raw_mask104
	BSF        Inputs_hall_read_raw_mask_mask_L0+0, 3
L_Inputs_hall_read_raw_mask104:
	MOVF       Inputs_hall_read_raw_mask_mask_L0+0, 0
	MOVWF      R0+0
L_end_hall_read_raw_mask:
	RETURN
; end of Inputs_hall_read_raw_mask

Inputs_buzzer_service_tick:

	CLRF       Inputs_buzzer_service_tick_output_on_L0+0
	CLRF       Inputs_buzzer_service_tick_period_L0+0
	GOTO       L_Inputs_buzzer_service_tick105
L_Inputs_buzzer_service_tick107:
	MOVLW      15
	SUBWF      Inputs_bz_tick_cnt+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_buzzer_service_tick108
	MOVLW      1
	MOVWF      Inputs_buzzer_service_tick_output_on_L0+0
	GOTO       L_Inputs_buzzer_service_tick109
L_Inputs_buzzer_service_tick108:
	CLRF       Inputs_bz_active_event+0
L_Inputs_buzzer_service_tick109:
	GOTO       L_Inputs_buzzer_service_tick106
L_Inputs_buzzer_service_tick110:
	MOVLW      10
	SUBWF      Inputs_bz_tick_cnt+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_buzzer_service_tick111
	MOVLW      1
	MOVWF      Inputs_buzzer_service_tick_output_on_L0+0
	GOTO       L_Inputs_buzzer_service_tick112
L_Inputs_buzzer_service_tick111:
	CLRF       Inputs_bz_active_event+0
L_Inputs_buzzer_service_tick112:
	GOTO       L_Inputs_buzzer_service_tick106
L_Inputs_buzzer_service_tick113:
	MOVLW      20
	MOVWF      Inputs_buzzer_service_tick_period_L0+0
	MOVLW      10
	SUBWF      Inputs_bz_tick_cnt+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_buzzer_service_tick114
	MOVLW      1
	MOVWF      R1+0
	GOTO       L_Inputs_buzzer_service_tick115
L_Inputs_buzzer_service_tick114:
	CLRF       R1+0
L_Inputs_buzzer_service_tick115:
	MOVF       R1+0, 0
	MOVWF      Inputs_buzzer_service_tick_output_on_L0+0
	GOTO       L_Inputs_buzzer_service_tick106
L_Inputs_buzzer_service_tick116:
	MOVLW      60
	MOVWF      Inputs_buzzer_service_tick_period_L0+0
	MOVLW      25
	SUBWF      Inputs_bz_tick_cnt+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_Inputs_buzzer_service_tick194
	MOVLW      35
	SUBWF      Inputs_bz_tick_cnt+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_Inputs_buzzer_service_tick195
	MOVLW      45
	SUBWF      Inputs_bz_tick_cnt+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_buzzer_service_tick195
	GOTO       L_Inputs_buzzer_service_tick194
L_Inputs_buzzer_service_tick195:
	GOTO       L_Inputs_buzzer_service_tick121
L_Inputs_buzzer_service_tick194:
	MOVLW      1
	MOVWF      Inputs_buzzer_service_tick_output_on_L0+0
L_Inputs_buzzer_service_tick121:
	GOTO       L_Inputs_buzzer_service_tick106
L_Inputs_buzzer_service_tick122:
	CLRF       Inputs_bz_active_event+0
	CLRF       Inputs_buzzer_service_tick_output_on_L0+0
	GOTO       L_Inputs_buzzer_service_tick106
L_Inputs_buzzer_service_tick105:
	MOVF       Inputs_bz_active_event+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buzzer_service_tick107
	MOVF       Inputs_bz_active_event+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buzzer_service_tick110
	MOVF       Inputs_bz_active_event+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buzzer_service_tick113
	MOVF       Inputs_bz_active_event+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buzzer_service_tick116
	GOTO       L_Inputs_buzzer_service_tick122
L_Inputs_buzzer_service_tick106:
	MOVF       Inputs_bz_active_event+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buzzer_service_tick123
	INCF       Inputs_bz_tick_cnt+0, 1
	MOVF       Inputs_buzzer_service_tick_period_L0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buzzer_service_tick126
	MOVF       Inputs_buzzer_service_tick_period_L0+0, 0
	SUBWF      Inputs_bz_tick_cnt+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_Inputs_buzzer_service_tick126
L_Inputs_buzzer_service_tick193:
	CLRF       Inputs_bz_tick_cnt+0
L_Inputs_buzzer_service_tick126:
L_Inputs_buzzer_service_tick123:
	BTFSC      Inputs_buzzer_service_tick_output_on_L0+0, 0
	GOTO       L_Inputs_buzzer_service_tick226
	BCF        PORTC+0, 7
	GOTO       L_Inputs_buzzer_service_tick227
L_Inputs_buzzer_service_tick226:
	BSF        PORTC+0, 7
L_Inputs_buzzer_service_tick227:
L_end_buzzer_service_tick:
	RETURN
; end of Inputs_buzzer_service_tick

_Inputs_Init:

	MOVLW      6
	MOVWF      ADCON1+0
	MOVLW      7
	MOVWF      CMCON+0
	BCF        TRISE+0, 4
	BCF        OPTION_REG+0, 7
	BCF        TRISB+0, 4
	BCF        TRISB+0, 5
	BCF        TRISB+0, 6
	BCF        TRISB+0, 7
	BSF        TRISB+0, 0
	BSF        TRISB+0, 1
	BSF        TRISB+0, 2
	BSF        TRISB+0, 3
	CALL       Inputs_keypad_rows_idle+0
	BSF        TRISA+0, 2
	BSF        TRISA+0, 3
	BSF        TRISA+0, 4
	BSF        TRISA+0, 5
	BSF        TRISC+0, 3
	BSF        TRISC+0, 4
	BSF        TRISC+0, 5
	BSF        TRISC+0, 6
	BCF        TRISC+0, 7
	BCF        PORTC+0, 7
	CLRF       Inputs_kp_last_key+0
	CLRF       Inputs_kp_stable_cnt+0
	CALL       Inputs_landing_buttons_read_raw_mask+0
	MOVF       R0+0, 0
	MOVWF      Inputs_btn_stable_mask+0
	MOVF       R0+0, 0
	MOVWF      Inputs_btn_last_mask+0
	CLRF       Inputs_btn_stable_cnt+0
	CLRF       Inputs_req_head+0
	CLRF       Inputs_req_tail+0
	CLRF       Inputs_req_count+0
	CALL       Inputs_hall_read_raw_mask+0
	MOVF       R0+0, 0
	MOVWF      Inputs_hall_stable_mask+0
	MOVF       R0+0, 0
	MOVWF      Inputs_hall_last_raw+0
	CLRF       Inputs_hall_stable_cnt+0
	CLRF       Inputs_bz_active_event+0
	CLRF       Inputs_bz_tick_cnt+0
	CALL       Inputs_lcd_hw_init+0
	CLRF       Inputs_Init_pos_L0+0
L_Inputs_Init127:
	MOVLW      17
	SUBWF      Inputs_Init_pos_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_Init128
	MOVF       Inputs_Init_pos_L0+0, 0
	ADDLW      Inputs_lcd_cache+0
	MOVWF      FSR
	CLRF       INDF+0
	MOVF       Inputs_Init_pos_L0+0, 0
	ADDLW      Inputs_lcd_cache+17
	MOVWF      FSR
	CLRF       INDF+0
	INCF       Inputs_Init_pos_L0+0, 1
	GOTO       L_Inputs_Init127
L_Inputs_Init128:
	MOVLW      Inputs_lcd_line_buf+0
	MOVWF      FARG_Inputs_buf_put_const_str_buf+0
	CLRF       FARG_Inputs_buf_put_const_str_pos+0
	MOVLW      ?lstr_11_Inputs+0
	MOVWF      FARG_Inputs_buf_put_const_str_s+0
	MOVLW      hi_addr(?lstr_11_Inputs+0)
	MOVWF      FARG_Inputs_buf_put_const_str_s+1
	CALL       Inputs_buf_put_const_str+0
	MOVF       R0+0, 0
	MOVWF      Inputs_Init_pos_L0+0
	MOVLW      Inputs_lcd_line_buf+0
	MOVWF      FARG_Inputs_buf_pad_line_buf+0
	MOVF       R0+0, 0
	MOVWF      FARG_Inputs_buf_pad_line_pos+0
	CALL       Inputs_buf_pad_line+0
	CLRF       FARG_Inputs_lcd_write_line_row+0
	MOVLW      Inputs_lcd_line_buf+0
	MOVWF      FARG_Inputs_lcd_write_line_ram_text+0
	CALL       Inputs_lcd_write_line+0
	MOVLW      Inputs_lcd_line_buf+0
	MOVWF      FARG_Inputs_buf_put_const_str_buf+0
	CLRF       FARG_Inputs_buf_put_const_str_pos+0
	MOVLW      ?lstr_12_Inputs+0
	MOVWF      FARG_Inputs_buf_put_const_str_s+0
	MOVLW      hi_addr(?lstr_12_Inputs+0)
	MOVWF      FARG_Inputs_buf_put_const_str_s+1
	CALL       Inputs_buf_put_const_str+0
	MOVF       R0+0, 0
	MOVWF      Inputs_Init_pos_L0+0
	MOVLW      Inputs_lcd_line_buf+0
	MOVWF      FARG_Inputs_buf_pad_line_buf+0
	MOVF       R0+0, 0
	MOVWF      FARG_Inputs_buf_pad_line_pos+0
	CALL       Inputs_buf_pad_line+0
	MOVLW      1
	MOVWF      FARG_Inputs_lcd_write_line_row+0
	MOVLW      Inputs_lcd_line_buf+0
	MOVWF      FARG_Inputs_lcd_write_line_ram_text+0
	CALL       Inputs_lcd_write_line+0
L_end_Inputs_Init:
	RETURN
; end of _Inputs_Init

_Inputs_Update:

	CALL       Inputs_keypad_scan_raw+0
	MOVF       R0+0, 0
	MOVWF      Inputs_Update_raw_key_L0+0
	MOVF       R0+0, 0
	XORWF      Inputs_kp_last_key+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_Update130
	MOVF       Inputs_Update_raw_key_L0+0, 0
	MOVWF      Inputs_kp_last_key+0
	CLRF       Inputs_kp_stable_cnt+0
	GOTO       L_Inputs_Update131
L_Inputs_Update130:
	MOVLW      2
	SUBWF      Inputs_kp_stable_cnt+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_Update132
	INCF       Inputs_kp_stable_cnt+0, 1
	MOVF       Inputs_kp_stable_cnt+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_Update135
	MOVF       Inputs_Update_raw_key_L0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_Update135
L__Inputs_Update196:
	MOVF       Inputs_Update_raw_key_L0+0, 0
	MOVWF      FARG_Inputs_handle_debounced_keypad_key+0
	CALL       Inputs_handle_debounced_keypad+0
L_Inputs_Update135:
L_Inputs_Update132:
L_Inputs_Update131:
	CALL       Inputs_landing_buttons_read_raw_mask+0
	MOVF       R0+0, 0
	MOVWF      Inputs_Update_raw_btn_L0+0
	MOVF       R0+0, 0
	XORWF      Inputs_btn_last_mask+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_Update136
	MOVF       Inputs_Update_raw_btn_L0+0, 0
	MOVWF      Inputs_btn_last_mask+0
	CLRF       Inputs_btn_stable_cnt+0
	GOTO       L_Inputs_Update137
L_Inputs_Update136:
	MOVLW      2
	SUBWF      Inputs_btn_stable_cnt+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_Update138
	INCF       Inputs_btn_stable_cnt+0, 1
	MOVF       Inputs_btn_stable_cnt+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_Update139
	COMF       Inputs_btn_stable_mask+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	ANDWF      Inputs_Update_raw_btn_L0+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      Inputs_Update_pressed_edges_L0+0
	MOVF       Inputs_Update_raw_btn_L0+0, 0
	MOVWF      Inputs_btn_stable_mask+0
	BTFSS      R1+0, 0
	GOTO       L_Inputs_Update140
	CLRF       FARG_Inputs_request_queue_push_floor+0
	CALL       Inputs_request_queue_push+0
L_Inputs_Update140:
	BTFSS      Inputs_Update_pressed_edges_L0+0, 1
	GOTO       L_Inputs_Update141
	MOVLW      1
	MOVWF      FARG_Inputs_request_queue_push_floor+0
	CALL       Inputs_request_queue_push+0
L_Inputs_Update141:
	BTFSS      Inputs_Update_pressed_edges_L0+0, 2
	GOTO       L_Inputs_Update142
	MOVLW      2
	MOVWF      FARG_Inputs_request_queue_push_floor+0
	CALL       Inputs_request_queue_push+0
L_Inputs_Update142:
	BTFSS      Inputs_Update_pressed_edges_L0+0, 3
	GOTO       L_Inputs_Update143
	MOVLW      3
	MOVWF      FARG_Inputs_request_queue_push_floor+0
	CALL       Inputs_request_queue_push+0
L_Inputs_Update143:
L_Inputs_Update139:
L_Inputs_Update138:
L_Inputs_Update137:
	CALL       Inputs_hall_read_raw_mask+0
	MOVF       R0+0, 0
	MOVWF      Inputs_Update_raw_hall_L0+0
	MOVF       R0+0, 0
	XORWF      Inputs_hall_last_raw+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_Update144
	MOVF       Inputs_Update_raw_hall_L0+0, 0
	MOVWF      Inputs_hall_last_raw+0
	CLRF       Inputs_hall_stable_cnt+0
	GOTO       L_Inputs_Update145
L_Inputs_Update144:
	MOVLW      2
	SUBWF      Inputs_hall_stable_cnt+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_Update146
	INCF       Inputs_hall_stable_cnt+0, 1
	MOVF       Inputs_hall_stable_cnt+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_Update147
	MOVF       Inputs_Update_raw_hall_L0+0, 0
	MOVWF      Inputs_hall_stable_mask+0
L_Inputs_Update147:
L_Inputs_Update146:
L_Inputs_Update145:
	CALL       Inputs_buzzer_service_tick+0
L_end_Inputs_Update:
	RETURN
; end of _Inputs_Update

_Inputs_GetNewFloorRequest:

	MOVF       FARG_Inputs_GetNewFloorRequest_floor+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L__Inputs_GetNewFloorRequest197
	MOVF       Inputs_req_count+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L__Inputs_GetNewFloorRequest197
	GOTO       L_Inputs_GetNewFloorRequest150
L__Inputs_GetNewFloorRequest197:
	CLRF       R0+0
	GOTO       L_end_Inputs_GetNewFloorRequest
L_Inputs_GetNewFloorRequest150:
	MOVF       Inputs_req_head+0, 0
	ADDLW      Inputs_req_queue+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	MOVF       FARG_Inputs_GetNewFloorRequest_floor+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
	INCF       Inputs_req_head+0, 1
	MOVLW      8
	SUBWF      Inputs_req_head+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_Inputs_GetNewFloorRequest151
	CLRF       Inputs_req_head+0
L_Inputs_GetNewFloorRequest151:
	DECF       Inputs_req_count+0, 1
	MOVLW      1
	MOVWF      R0+0
L_end_Inputs_GetNewFloorRequest:
	RETURN
; end of _Inputs_GetNewFloorRequest

_Inputs_GetCurrentFloor:

	GOTO       L_Inputs_GetCurrentFloor152
L_Inputs_GetCurrentFloor154:
	CLRF       R0+0
	GOTO       L_end_Inputs_GetCurrentFloor
L_Inputs_GetCurrentFloor155:
	MOVLW      1
	MOVWF      R0+0
	GOTO       L_end_Inputs_GetCurrentFloor
L_Inputs_GetCurrentFloor156:
	MOVLW      2
	MOVWF      R0+0
	GOTO       L_end_Inputs_GetCurrentFloor
L_Inputs_GetCurrentFloor157:
	MOVLW      3
	MOVWF      R0+0
	GOTO       L_end_Inputs_GetCurrentFloor
L_Inputs_GetCurrentFloor158:
	MOVLW      255
	MOVWF      R0+0
	GOTO       L_end_Inputs_GetCurrentFloor
L_Inputs_GetCurrentFloor152:
	MOVF       Inputs_hall_stable_mask+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_GetCurrentFloor154
	MOVF       Inputs_hall_stable_mask+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_GetCurrentFloor155
	MOVF       Inputs_hall_stable_mask+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_GetCurrentFloor156
	MOVF       Inputs_hall_stable_mask+0, 0
	XORLW      8
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_GetCurrentFloor157
	GOTO       L_Inputs_GetCurrentFloor158
L_end_Inputs_GetCurrentFloor:
	RETURN
; end of _Inputs_GetCurrentFloor

_Inputs_IsFloorSensorFault:

	DECF       Inputs_hall_stable_mask+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	ANDWF      Inputs_hall_stable_mask+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_IsFloorSensorFault159
	MOVLW      1
	MOVWF      R2+0
	GOTO       L_Inputs_IsFloorSensorFault160
L_Inputs_IsFloorSensorFault159:
	CLRF       R2+0
L_Inputs_IsFloorSensorFault160:
	MOVF       R2+0, 0
	MOVWF      R0+0
L_end_Inputs_IsFloorSensorFault:
	RETURN
; end of _Inputs_IsFloorSensorFault

_Inputs_DisplayStatus:

	MOVF       Inputs_bz_active_event+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_DisplayStatus163
	MOVF       FARG_Inputs_DisplayStatus_controller_state+0, 0
	XORLW      7
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_DisplayStatus163
L__Inputs_DisplayStatus200:
	CLRF       Inputs_bz_active_event+0
	BCF        PORTC+0, 7
	GOTO       L_Inputs_DisplayStatus164
L_Inputs_DisplayStatus163:
	MOVF       Inputs_bz_active_event+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_DisplayStatus167
	MOVF       FARG_Inputs_DisplayStatus_controller_state+0, 0
	XORLW      8
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_DisplayStatus167
L__Inputs_DisplayStatus199:
	CLRF       Inputs_bz_active_event+0
	BCF        PORTC+0, 7
L_Inputs_DisplayStatus167:
L_Inputs_DisplayStatus164:
	CLRF       Inputs_DisplayStatus_pos_L0+0
	MOVF       Inputs_DisplayStatus_pos_L0+0, 0
	ADDLW      Inputs_lcd_line_buf+0
	MOVWF      FSR
	MOVLW      70
	MOVWF      INDF+0
	INCF       Inputs_DisplayStatus_pos_L0+0, 1
	MOVF       Inputs_DisplayStatus_pos_L0+0, 0
	ADDLW      Inputs_lcd_line_buf+0
	MOVWF      FSR
	MOVLW      58
	MOVWF      INDF+0
	INCF       Inputs_DisplayStatus_pos_L0+0, 1
	MOVF       Inputs_DisplayStatus_pos_L0+0, 0
	ADDLW      Inputs_lcd_line_buf+0
	MOVWF      FLOC__Inputs_DisplayStatus+0
	MOVF       FARG_Inputs_DisplayStatus_current_floor+0, 0
	MOVWF      FARG_Inputs_floor_to_char_floor+0
	CALL       Inputs_floor_to_char+0
	MOVF       FLOC__Inputs_DisplayStatus+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
	INCF       Inputs_DisplayStatus_pos_L0+0, 1
	MOVF       Inputs_DisplayStatus_pos_L0+0, 0
	ADDLW      Inputs_lcd_line_buf+0
	MOVWF      FSR
	MOVLW      45
	MOVWF      INDF+0
	INCF       Inputs_DisplayStatus_pos_L0+0, 1
	MOVF       Inputs_DisplayStatus_pos_L0+0, 0
	ADDLW      Inputs_lcd_line_buf+0
	MOVWF      FSR
	MOVLW      62
	MOVWF      INDF+0
	INCF       Inputs_DisplayStatus_pos_L0+0, 1
	MOVF       Inputs_DisplayStatus_pos_L0+0, 0
	ADDLW      Inputs_lcd_line_buf+0
	MOVWF      FLOC__Inputs_DisplayStatus+0
	MOVF       FARG_Inputs_DisplayStatus_target_floor+0, 0
	MOVWF      FARG_Inputs_floor_to_char_floor+0
	CALL       Inputs_floor_to_char+0
	MOVF       FLOC__Inputs_DisplayStatus+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
	INCF       Inputs_DisplayStatus_pos_L0+0, 1
	MOVF       Inputs_DisplayStatus_pos_L0+0, 0
	ADDLW      Inputs_lcd_line_buf+0
	MOVWF      FSR
	MOVLW      32
	MOVWF      INDF+0
	INCF       Inputs_DisplayStatus_pos_L0+0, 1
	MOVF       Inputs_DisplayStatus_pos_L0+0, 0
	ADDLW      Inputs_lcd_line_buf+0
	MOVWF      FSR
	MOVLW      91
	MOVWF      INDF+0
	INCF       Inputs_DisplayStatus_pos_L0+0, 1
	MOVLW      Inputs_lcd_line_buf+0
	MOVWF      FARG_Inputs_buf_put_state_buf+0
	MOVF       Inputs_DisplayStatus_pos_L0+0, 0
	MOVWF      FARG_Inputs_buf_put_state_pos+0
	MOVF       FARG_Inputs_DisplayStatus_controller_state+0, 0
	MOVWF      FARG_Inputs_buf_put_state_state+0
	CALL       Inputs_buf_put_state+0
	MOVF       R0+0, 0
	MOVWF      Inputs_DisplayStatus_pos_L0+0
	MOVLW      16
	SUBWF      R0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_DisplayStatus168
	MOVF       Inputs_DisplayStatus_pos_L0+0, 0
	ADDLW      Inputs_lcd_line_buf+0
	MOVWF      FSR
	MOVLW      93
	MOVWF      INDF+0
	INCF       Inputs_DisplayStatus_pos_L0+0, 1
L_Inputs_DisplayStatus168:
	MOVLW      Inputs_lcd_line_buf+0
	MOVWF      FARG_Inputs_buf_pad_line_buf+0
	MOVF       Inputs_DisplayStatus_pos_L0+0, 0
	MOVWF      FARG_Inputs_buf_pad_line_pos+0
	CALL       Inputs_buf_pad_line+0
	CLRF       FARG_Inputs_lcd_flush_if_changed_row+0
	CALL       Inputs_lcd_flush_if_changed+0
	MOVLW      Inputs_lcd_line_buf+0
	MOVWF      FARG_Inputs_buf_put_const_str_buf+0
	CLRF       FARG_Inputs_buf_put_const_str_pos+0
	MOVLW      ?lstr_13_Inputs+0
	MOVWF      FARG_Inputs_buf_put_const_str_s+0
	MOVLW      hi_addr(?lstr_13_Inputs+0)
	MOVWF      FARG_Inputs_buf_put_const_str_s+1
	CALL       Inputs_buf_put_const_str+0
	MOVF       R0+0, 0
	MOVWF      Inputs_DisplayStatus_pos_L0+0
	MOVLW      Inputs_lcd_line_buf+0
	MOVWF      FARG_Inputs_buf_put_ulong_buf+0
	MOVF       R0+0, 0
	MOVWF      FARG_Inputs_buf_put_ulong_pos+0
	MOVF       FARG_Inputs_DisplayStatus_weight_grams+0, 0
	MOVWF      FARG_Inputs_buf_put_ulong_value+0
	MOVF       FARG_Inputs_DisplayStatus_weight_grams+1, 0
	MOVWF      FARG_Inputs_buf_put_ulong_value+1
	MOVF       FARG_Inputs_DisplayStatus_weight_grams+2, 0
	MOVWF      FARG_Inputs_buf_put_ulong_value+2
	MOVF       FARG_Inputs_DisplayStatus_weight_grams+3, 0
	MOVWF      FARG_Inputs_buf_put_ulong_value+3
	CALL       Inputs_buf_put_ulong+0
	MOVF       R0+0, 0
	MOVWF      Inputs_DisplayStatus_pos_L0+0
	MOVLW      16
	SUBWF      R0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_DisplayStatus169
	MOVF       Inputs_DisplayStatus_pos_L0+0, 0
	ADDLW      Inputs_lcd_line_buf+0
	MOVWF      FSR
	MOVLW      103
	MOVWF      INDF+0
	INCF       Inputs_DisplayStatus_pos_L0+0, 1
L_Inputs_DisplayStatus169:
	MOVLW      16
	SUBWF      Inputs_DisplayStatus_pos_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_DisplayStatus170
	MOVF       Inputs_DisplayStatus_pos_L0+0, 0
	ADDLW      Inputs_lcd_line_buf+0
	MOVWF      FSR
	MOVLW      32
	MOVWF      INDF+0
	INCF       Inputs_DisplayStatus_pos_L0+0, 1
L_Inputs_DisplayStatus170:
	MOVF       FARG_Inputs_DisplayStatus_weight_grams+3, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__Inputs_DisplayStatus234
	MOVF       FARG_Inputs_DisplayStatus_weight_grams+2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__Inputs_DisplayStatus234
	MOVF       FARG_Inputs_DisplayStatus_weight_grams+1, 0
	SUBLW      5
	BTFSS      STATUS+0, 2
	GOTO       L__Inputs_DisplayStatus234
	MOVF       FARG_Inputs_DisplayStatus_weight_grams+0, 0
	SUBLW      220
L__Inputs_DisplayStatus234:
	BTFSS      STATUS+0, 0
	GOTO       L__Inputs_DisplayStatus198
	MOVF       FARG_Inputs_DisplayStatus_controller_state+0, 0
	XORLW      7
	BTFSC      STATUS+0, 2
	GOTO       L__Inputs_DisplayStatus198
	GOTO       L_Inputs_DisplayStatus173
L__Inputs_DisplayStatus198:
	MOVLW      Inputs_lcd_line_buf+0
	MOVWF      FARG_Inputs_buf_put_const_str_buf+0
	MOVF       Inputs_DisplayStatus_pos_L0+0, 0
	MOVWF      FARG_Inputs_buf_put_const_str_pos+0
	MOVLW      ?lstr_14_Inputs+0
	MOVWF      FARG_Inputs_buf_put_const_str_s+0
	MOVLW      hi_addr(?lstr_14_Inputs+0)
	MOVWF      FARG_Inputs_buf_put_const_str_s+1
	CALL       Inputs_buf_put_const_str+0
	MOVF       R0+0, 0
	MOVWF      Inputs_DisplayStatus_pos_L0+0
	GOTO       L_Inputs_DisplayStatus174
L_Inputs_DisplayStatus173:
	MOVLW      Inputs_lcd_line_buf+0
	MOVWF      FARG_Inputs_buf_put_const_str_buf+0
	MOVF       Inputs_DisplayStatus_pos_L0+0, 0
	MOVWF      FARG_Inputs_buf_put_const_str_pos+0
	MOVLW      ?lstr_15_Inputs+0
	MOVWF      FARG_Inputs_buf_put_const_str_s+0
	MOVLW      hi_addr(?lstr_15_Inputs+0)
	MOVWF      FARG_Inputs_buf_put_const_str_s+1
	CALL       Inputs_buf_put_const_str+0
	MOVF       R0+0, 0
	MOVWF      Inputs_DisplayStatus_pos_L0+0
L_Inputs_DisplayStatus174:
	MOVLW      Inputs_lcd_line_buf+0
	MOVWF      FARG_Inputs_buf_pad_line_buf+0
	MOVF       Inputs_DisplayStatus_pos_L0+0, 0
	MOVWF      FARG_Inputs_buf_pad_line_pos+0
	CALL       Inputs_buf_pad_line+0
	MOVLW      1
	MOVWF      FARG_Inputs_lcd_flush_if_changed_row+0
	CALL       Inputs_lcd_flush_if_changed+0
L_end_Inputs_DisplayStatus:
	RETURN
; end of _Inputs_DisplayStatus

_Inputs_Buzzer:

	GOTO       L_Inputs_Buzzer175
L_Inputs_Buzzer177:
L_Inputs_Buzzer178:
	MOVF       Inputs_bz_active_event+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L__Inputs_Buzzer201
	MOVF       Inputs_bz_active_event+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L__Inputs_Buzzer201
	GOTO       L_Inputs_Buzzer181
L__Inputs_Buzzer201:
	GOTO       L_end_Inputs_Buzzer
L_Inputs_Buzzer181:
	MOVF       FARG_Inputs_Buzzer_event_code+0, 0
	MOVWF      Inputs_bz_active_event+0
	CLRF       Inputs_bz_tick_cnt+0
	GOTO       L_Inputs_Buzzer176
L_Inputs_Buzzer182:
	MOVF       Inputs_bz_active_event+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_Buzzer183
	GOTO       L_end_Inputs_Buzzer
L_Inputs_Buzzer183:
	MOVF       Inputs_bz_active_event+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_Buzzer184
	MOVLW      2
	MOVWF      Inputs_bz_active_event+0
	CLRF       Inputs_bz_tick_cnt+0
L_Inputs_Buzzer184:
	GOTO       L_Inputs_Buzzer176
L_Inputs_Buzzer185:
	MOVF       Inputs_bz_active_event+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_Buzzer186
	MOVLW      3
	MOVWF      Inputs_bz_active_event+0
	CLRF       Inputs_bz_tick_cnt+0
L_Inputs_Buzzer186:
	GOTO       L_Inputs_Buzzer176
L_Inputs_Buzzer187:
	CLRF       Inputs_bz_active_event+0
	CLRF       Inputs_bz_tick_cnt+0
	BCF        PORTC+0, 7
	GOTO       L_Inputs_Buzzer176
L_Inputs_Buzzer175:
	MOVF       FARG_Inputs_Buzzer_event_code+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_Buzzer177
	MOVF       FARG_Inputs_Buzzer_event_code+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_Buzzer178
	MOVF       FARG_Inputs_Buzzer_event_code+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_Buzzer182
	MOVF       FARG_Inputs_Buzzer_event_code+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_Buzzer185
	GOTO       L_Inputs_Buzzer187
L_Inputs_Buzzer176:
L_end_Inputs_Buzzer:
	RETURN
; end of _Inputs_Buzzer
