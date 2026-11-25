
Inputs_lcd_write_nibble:

	BTFSS      FARG_Inputs_lcd_write_nibble_nibble+0, 0
	GOTO       L_Inputs_lcd_write_nibble0
	MOVLW      1
	MOVWF      R1+0
	GOTO       L_Inputs_lcd_write_nibble1
L_Inputs_lcd_write_nibble0:
	CLRF       R1+0
L_Inputs_lcd_write_nibble1:
	BTFSC      R1+0, 0
	GOTO       L_Inputs_lcd_write_nibble183
	BCF        PORTD+0, 4
	GOTO       L_Inputs_lcd_write_nibble184
L_Inputs_lcd_write_nibble183:
	BSF        PORTD+0, 4
L_Inputs_lcd_write_nibble184:
	BTFSS      FARG_Inputs_lcd_write_nibble_nibble+0, 1
	GOTO       L_Inputs_lcd_write_nibble2
	MOVLW      1
	MOVWF      R2+0
	GOTO       L_Inputs_lcd_write_nibble3
L_Inputs_lcd_write_nibble2:
	CLRF       R2+0
L_Inputs_lcd_write_nibble3:
	BTFSC      R2+0, 0
	GOTO       L_Inputs_lcd_write_nibble185
	BCF        PORTD+0, 5
	GOTO       L_Inputs_lcd_write_nibble186
L_Inputs_lcd_write_nibble185:
	BSF        PORTD+0, 5
L_Inputs_lcd_write_nibble186:
	BTFSS      FARG_Inputs_lcd_write_nibble_nibble+0, 2
	GOTO       L_Inputs_lcd_write_nibble4
	MOVLW      1
	MOVWF      R3+0
	GOTO       L_Inputs_lcd_write_nibble5
L_Inputs_lcd_write_nibble4:
	CLRF       R3+0
L_Inputs_lcd_write_nibble5:
	BTFSC      R3+0, 0
	GOTO       L_Inputs_lcd_write_nibble187
	BCF        PORTD+0, 6
	GOTO       L_Inputs_lcd_write_nibble188
L_Inputs_lcd_write_nibble187:
	BSF        PORTD+0, 6
L_Inputs_lcd_write_nibble188:
	BTFSS      FARG_Inputs_lcd_write_nibble_nibble+0, 3
	GOTO       L_Inputs_lcd_write_nibble6
	MOVLW      1
	MOVWF      R4+0
	GOTO       L_Inputs_lcd_write_nibble7
L_Inputs_lcd_write_nibble6:
	CLRF       R4+0
L_Inputs_lcd_write_nibble7:
	BTFSC      R4+0, 0
	GOTO       L_Inputs_lcd_write_nibble189
	BCF        PORTD+0, 7
	GOTO       L_Inputs_lcd_write_nibble190
L_Inputs_lcd_write_nibble189:
	BSF        PORTD+0, 7
L_Inputs_lcd_write_nibble190:
	NOP
	NOP
	NOP
	NOP
	NOP
	BSF        PORTD+0, 3
	MOVLW      8
	MOVWF      R13+0
L_Inputs_lcd_write_nibble8:
	DECFSZ     R13+0, 1
	GOTO       L_Inputs_lcd_write_nibble8
	BCF        PORTD+0, 3
	MOVLW      8
	MOVWF      R13+0
L_Inputs_lcd_write_nibble9:
	DECFSZ     R13+0, 1
	GOTO       L_Inputs_lcd_write_nibble9
L_end_lcd_write_nibble:
	RETURN
; end of Inputs_lcd_write_nibble

Inputs_lcd_send_byte:

	MOVF       FARG_Inputs_lcd_send_byte_is_data+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_lcd_send_byte10
	MOVLW      1
	MOVWF      Inputs_?FLOC__Inputs_lcd_send_byteT21+0
	GOTO       L_Inputs_lcd_send_byte11
L_Inputs_lcd_send_byte10:
	CLRF       Inputs_?FLOC__Inputs_lcd_send_byteT21+0
L_Inputs_lcd_send_byte11:
	BTFSC      Inputs_?FLOC__Inputs_lcd_send_byteT21+0, 0
	GOTO       L_Inputs_lcd_send_byte192
	BCF        PORTD+0, 2
	GOTO       L_Inputs_lcd_send_byte193
L_Inputs_lcd_send_byte192:
	BSF        PORTD+0, 2
L_Inputs_lcd_send_byte193:
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
L_Inputs_lcd_send_byte12:
	DECFSZ     R13+0, 1
	GOTO       L_Inputs_lcd_send_byte12
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
L_Inputs_lcd_hw_init13:
	DECFSZ     R13+0, 1
	GOTO       L_Inputs_lcd_hw_init13
	DECFSZ     R12+0, 1
	GOTO       L_Inputs_lcd_hw_init13
	DECFSZ     R11+0, 1
	GOTO       L_Inputs_lcd_hw_init13
	NOP
	MOVLW      3
	MOVWF      FARG_Inputs_lcd_write_nibble_nibble+0
	CALL       Inputs_lcd_write_nibble+0
	MOVLW      33
	MOVWF      R12+0
	MOVLW      118
	MOVWF      R13+0
L_Inputs_lcd_hw_init14:
	DECFSZ     R13+0, 1
	GOTO       L_Inputs_lcd_hw_init14
	DECFSZ     R12+0, 1
	GOTO       L_Inputs_lcd_hw_init14
	NOP
	MOVLW      3
	MOVWF      FARG_Inputs_lcd_write_nibble_nibble+0
	CALL       Inputs_lcd_write_nibble+0
	MOVLW      2
	MOVWF      R12+0
	MOVLW      75
	MOVWF      R13+0
L_Inputs_lcd_hw_init15:
	DECFSZ     R13+0, 1
	GOTO       L_Inputs_lcd_hw_init15
	DECFSZ     R12+0, 1
	GOTO       L_Inputs_lcd_hw_init15
	MOVLW      3
	MOVWF      FARG_Inputs_lcd_write_nibble_nibble+0
	CALL       Inputs_lcd_write_nibble+0
	MOVLW      2
	MOVWF      R12+0
	MOVLW      75
	MOVWF      R13+0
L_Inputs_lcd_hw_init16:
	DECFSZ     R13+0, 1
	GOTO       L_Inputs_lcd_hw_init16
	DECFSZ     R12+0, 1
	GOTO       L_Inputs_lcd_hw_init16
	MOVLW      2
	MOVWF      FARG_Inputs_lcd_write_nibble_nibble+0
	CALL       Inputs_lcd_write_nibble+0
	MOVLW      2
	MOVWF      R12+0
	MOVLW      75
	MOVWF      R13+0
L_Inputs_lcd_hw_init17:
	DECFSZ     R13+0, 1
	GOTO       L_Inputs_lcd_hw_init17
	DECFSZ     R12+0, 1
	GOTO       L_Inputs_lcd_hw_init17
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
L_Inputs_lcd_hw_init18:
	DECFSZ     R13+0, 1
	GOTO       L_Inputs_lcd_hw_init18
	DECFSZ     R12+0, 1
	GOTO       L_Inputs_lcd_hw_init18
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
	GOTO       L_Inputs_lcd_write_line19
	MOVLW      192
	MOVWF      Inputs_?FLOC__Inputs_lcd_write_lineT51+0
	GOTO       L_Inputs_lcd_write_line20
L_Inputs_lcd_write_line19:
	MOVLW      128
	MOVWF      Inputs_?FLOC__Inputs_lcd_write_lineT51+0
L_Inputs_lcd_write_line20:
	MOVF       Inputs_?FLOC__Inputs_lcd_write_lineT51+0, 0
	MOVWF      FARG_Inputs_lcd_send_byte_value+0
	CLRF       FARG_Inputs_lcd_send_byte_is_data+0
	CALL       Inputs_lcd_send_byte+0
	CLRF       Inputs_lcd_write_line_i_L0+0
L_Inputs_lcd_write_line21:
	MOVLW      16
	SUBWF      Inputs_lcd_write_line_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_lcd_write_line22
	MOVF       Inputs_lcd_write_line_i_L0+0, 0
	ADDWF      FARG_Inputs_lcd_write_line_ram_text+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_Inputs_lcd_send_byte_value+0
	MOVLW      1
	MOVWF      FARG_Inputs_lcd_send_byte_is_data+0
	CALL       Inputs_lcd_send_byte+0
	INCF       Inputs_lcd_write_line_i_L0+0, 1
	GOTO       L_Inputs_lcd_write_line21
L_Inputs_lcd_write_line22:
L_end_lcd_write_line:
	RETURN
; end of Inputs_lcd_write_line

Inputs_buf_put_const_str:

L_Inputs_buf_put_const_str24:
	MOVF       FARG_Inputs_buf_put_const_str_s+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       FARG_Inputs_buf_put_const_str_s+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buf_put_const_str25
	MOVLW      16
	SUBWF      FARG_Inputs_buf_put_const_str_pos+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_buf_put_const_str25
L_Inputs_buf_put_const_str170:
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
	GOTO       L_Inputs_buf_put_const_str24
L_Inputs_buf_put_const_str25:
	MOVF       FARG_Inputs_buf_put_const_str_pos+0, 0
	MOVWF      R0+0
L_end_buf_put_const_str:
	RETURN
; end of Inputs_buf_put_const_str

Inputs_buf_put_ulong:

	CLRF       Inputs_buf_put_ulong_count_L0+0
	MOVF       FARG_Inputs_buf_put_ulong_value+3, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_buf_put_ulong198
	MOVF       FARG_Inputs_buf_put_ulong_value+2, 0
	SUBLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_buf_put_ulong198
	MOVF       FARG_Inputs_buf_put_ulong_value+1, 0
	SUBLW      134
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_buf_put_ulong198
	MOVF       FARG_Inputs_buf_put_ulong_value+0, 0
	SUBLW      159
L_Inputs_buf_put_ulong198:
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_buf_put_ulong28
	MOVLW      159
	MOVWF      FARG_Inputs_buf_put_ulong_value+0
	MOVLW      134
	MOVWF      FARG_Inputs_buf_put_ulong_value+1
	MOVLW      1
	MOVWF      FARG_Inputs_buf_put_ulong_value+2
	MOVLW      0
	MOVWF      FARG_Inputs_buf_put_ulong_value+3
L_Inputs_buf_put_ulong28:
L_Inputs_buf_put_ulong29:
	MOVF       Inputs_buf_put_ulong_count_L0+0, 0
	ADDLW      Inputs_buf_put_ulong_digits_L0+0
	MOVWF      FLOC_Inputs_buf_put_ulong+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      0
	MOVWF      R4+2
	MOVLW      0
	MOVWF      R4+3
	MOVF       FARG_Inputs_buf_put_ulong_value+0, 0
	MOVWF      R0+0
	MOVF       FARG_Inputs_buf_put_ulong_value+1, 0
	MOVWF      R0+1
	MOVF       FARG_Inputs_buf_put_ulong_value+2, 0
	MOVWF      R0+2
	MOVF       FARG_Inputs_buf_put_ulong_value+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R8+2, 0
	MOVWF      R0+2
	MOVF       R8+3, 0
	MOVWF      R0+3
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC_Inputs_buf_put_ulong+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
	INCF       Inputs_buf_put_ulong_count_L0+0, 1
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      0
	MOVWF      R4+2
	MOVLW      0
	MOVWF      R4+3
	MOVF       FARG_Inputs_buf_put_ulong_value+0, 0
	MOVWF      R0+0
	MOVF       FARG_Inputs_buf_put_ulong_value+1, 0
	MOVWF      R0+1
	MOVF       FARG_Inputs_buf_put_ulong_value+2, 0
	MOVWF      R0+2
	MOVF       FARG_Inputs_buf_put_ulong_value+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      FARG_Inputs_buf_put_ulong_value+0
	MOVF       R0+1, 0
	MOVWF      FARG_Inputs_buf_put_ulong_value+1
	MOVF       R0+2, 0
	MOVWF      FARG_Inputs_buf_put_ulong_value+2
	MOVF       R0+3, 0
	MOVWF      FARG_Inputs_buf_put_ulong_value+3
	MOVF       R0+3, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_buf_put_ulong199
	MOVF       R0+2, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_buf_put_ulong199
	MOVF       R0+1, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_buf_put_ulong199
	MOVF       R0+0, 0
	XORLW      0
L_Inputs_buf_put_ulong199:
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_buf_put_ulong29
	MOVF       Inputs_buf_put_ulong_count_L0+0, 0
	MOVWF      Inputs_buf_put_ulong_i_L0+0
L_Inputs_buf_put_ulong32:
	MOVF       Inputs_buf_put_ulong_i_L0+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_buf_put_ulong33
	MOVLW      16
	SUBWF      FARG_Inputs_buf_put_ulong_pos+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_buf_put_ulong35
	MOVF       FARG_Inputs_buf_put_ulong_pos+0, 0
	ADDWF      FARG_Inputs_buf_put_ulong_buf+0, 0
	MOVWF      R2+0
	MOVLW      1
	SUBWF      Inputs_buf_put_ulong_i_L0+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	BTFSS      STATUS+0, 0
	DECF       R0+1, 1
	MOVF       R0+0, 0
	ADDLW      Inputs_buf_put_ulong_digits_L0+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	MOVF       R2+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
	INCF       FARG_Inputs_buf_put_ulong_pos+0, 1
L_Inputs_buf_put_ulong35:
	DECF       Inputs_buf_put_ulong_i_L0+0, 1
	GOTO       L_Inputs_buf_put_ulong32
L_Inputs_buf_put_ulong33:
	MOVF       FARG_Inputs_buf_put_ulong_pos+0, 0
	MOVWF      R0+0
L_end_buf_put_ulong:
	RETURN
; end of Inputs_buf_put_ulong

Inputs_floor_to_char:

	MOVF       FARG_Inputs_floor_to_char_floor+0, 0
	SUBLW      3
	BTFSS      STATUS+0, 0
	GOTO       L_Inputs_floor_to_char36
	MOVF       FARG_Inputs_floor_to_char_floor+0, 0
	ADDLW      48
	MOVWF      R1+0
	GOTO       L_Inputs_floor_to_char37
L_Inputs_floor_to_char36:
	MOVLW      45
	MOVWF      R1+0
L_Inputs_floor_to_char37:
	MOVF       R1+0, 0
	MOVWF      R0+0
L_end_floor_to_char:
	RETURN
; end of Inputs_floor_to_char

Inputs_buf_put_state:

	GOTO       L_Inputs_buf_put_state38
L_Inputs_buf_put_state40:
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
L_Inputs_buf_put_state41:
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
L_Inputs_buf_put_state42:
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
L_Inputs_buf_put_state43:
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
L_Inputs_buf_put_state44:
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
L_Inputs_buf_put_state45:
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
L_Inputs_buf_put_state46:
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
L_Inputs_buf_put_state47:
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
L_Inputs_buf_put_state48:
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
L_Inputs_buf_put_state49:
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
L_Inputs_buf_put_state38:
	MOVF       FARG_Inputs_buf_put_state_state+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buf_put_state40
	MOVF       FARG_Inputs_buf_put_state_state+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buf_put_state41
	MOVF       FARG_Inputs_buf_put_state_state+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buf_put_state42
	MOVF       FARG_Inputs_buf_put_state_state+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buf_put_state43
	MOVF       FARG_Inputs_buf_put_state_state+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buf_put_state44
	MOVF       FARG_Inputs_buf_put_state_state+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buf_put_state45
	MOVF       FARG_Inputs_buf_put_state_state+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buf_put_state46
	MOVF       FARG_Inputs_buf_put_state_state+0, 0
	XORLW      7
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buf_put_state47
	MOVF       FARG_Inputs_buf_put_state_state+0, 0
	XORLW      8
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buf_put_state48
	GOTO       L_Inputs_buf_put_state49
L_end_buf_put_state:
	RETURN
; end of Inputs_buf_put_state

Inputs_buf_pad_line:

L_Inputs_buf_pad_line50:
	MOVLW      16
	SUBWF      FARG_Inputs_buf_pad_line_pos+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_buf_pad_line51
	MOVF       FARG_Inputs_buf_pad_line_pos+0, 0
	ADDWF      FARG_Inputs_buf_pad_line_buf+0, 0
	MOVWF      FSR
	MOVLW      32
	MOVWF      INDF+0
	INCF       FARG_Inputs_buf_pad_line_pos+0, 1
	GOTO       L_Inputs_buf_pad_line50
L_Inputs_buf_pad_line51:
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
L_Inputs_lcd_flush_if_changed52:
	MOVLW      16
	SUBWF      Inputs_lcd_flush_if_changed_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_lcd_flush_if_changed53
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
	GOTO       L_Inputs_lcd_flush_if_changed55
	MOVLW      1
	MOVWF      Inputs_lcd_flush_if_changed_changed_L0+0
	GOTO       L_Inputs_lcd_flush_if_changed53
L_Inputs_lcd_flush_if_changed55:
	INCF       Inputs_lcd_flush_if_changed_i_L0+0, 1
	GOTO       L_Inputs_lcd_flush_if_changed52
L_Inputs_lcd_flush_if_changed53:
	MOVF       Inputs_lcd_flush_if_changed_changed_L0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_lcd_flush_if_changed56
	CLRF       Inputs_lcd_flush_if_changed_i_L0+0
L_Inputs_lcd_flush_if_changed57:
	MOVLW      17
	SUBWF      Inputs_lcd_flush_if_changed_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_lcd_flush_if_changed58
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
	GOTO       L_Inputs_lcd_flush_if_changed57
L_Inputs_lcd_flush_if_changed58:
	MOVF       FARG_Inputs_lcd_flush_if_changed_row+0, 0
	MOVWF      FARG_Inputs_lcd_write_line_row+0
	MOVLW      Inputs_lcd_line_buf+0
	MOVWF      FARG_Inputs_lcd_write_line_ram_text+0
	CALL       Inputs_lcd_write_line+0
L_Inputs_lcd_flush_if_changed56:
L_end_lcd_flush_if_changed:
	RETURN
; end of Inputs_lcd_flush_if_changed

Inputs_keypad_rows_idle:

	BSF        PORTE+0, 0
	BSF        PORTE+0, 1
	BSF        PORTE+0, 2
L_end_keypad_rows_idle:
	RETURN
; end of Inputs_keypad_rows_idle

Inputs_keypad_scan_raw:

	CLRF       Inputs_keypad_scan_raw_key_L0+0
	CLRF       Inputs_keypad_scan_raw_row_L0+0
L_Inputs_keypad_scan_raw60:
	MOVLW      3
	SUBWF      Inputs_keypad_scan_raw_row_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_keypad_scan_raw61
	MOVF       Inputs_keypad_scan_raw_key_L0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_keypad_scan_raw61
L_Inputs_keypad_scan_raw171:
	CALL       Inputs_keypad_rows_idle+0
	MOVF       Inputs_keypad_scan_raw_row_L0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_keypad_scan_raw65
	BCF        PORTE+0, 0
	GOTO       L_Inputs_keypad_scan_raw66
L_Inputs_keypad_scan_raw65:
	MOVF       Inputs_keypad_scan_raw_row_L0+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_keypad_scan_raw67
	BCF        PORTE+0, 1
	GOTO       L_Inputs_keypad_scan_raw68
L_Inputs_keypad_scan_raw67:
	BCF        PORTE+0, 2
L_Inputs_keypad_scan_raw68:
L_Inputs_keypad_scan_raw66:
	MOVLW      16
	MOVWF      R13+0
L_Inputs_keypad_scan_raw69:
	DECFSZ     R13+0, 1
	GOTO       L_Inputs_keypad_scan_raw69
	NOP
	BTFSC      PORTB+0, 0
	GOTO       L_Inputs_keypad_scan_raw70
	MOVF       Inputs_keypad_scan_raw_row_L0+0, 0
	MOVWF      R0+0
	MOVLW      3
	MOVWF      R4+0
	CALL       _Mul_8X8_U+0
	INCF       R0+0, 0
	MOVWF      Inputs_keypad_scan_raw_key_L0+0
	GOTO       L_Inputs_keypad_scan_raw71
L_Inputs_keypad_scan_raw70:
	BTFSC      PORTB+0, 1
	GOTO       L_Inputs_keypad_scan_raw72
	MOVF       Inputs_keypad_scan_raw_row_L0+0, 0
	MOVWF      R0+0
	MOVLW      3
	MOVWF      R4+0
	CALL       _Mul_8X8_U+0
	MOVLW      2
	ADDWF      R0+0, 0
	MOVWF      Inputs_keypad_scan_raw_key_L0+0
	GOTO       L_Inputs_keypad_scan_raw73
L_Inputs_keypad_scan_raw72:
	BTFSC      PORTB+0, 2
	GOTO       L_Inputs_keypad_scan_raw74
	MOVF       Inputs_keypad_scan_raw_row_L0+0, 0
	MOVWF      R0+0
	MOVLW      3
	MOVWF      R4+0
	CALL       _Mul_8X8_U+0
	MOVLW      3
	ADDWF      R0+0, 0
	MOVWF      Inputs_keypad_scan_raw_key_L0+0
L_Inputs_keypad_scan_raw74:
L_Inputs_keypad_scan_raw73:
L_Inputs_keypad_scan_raw71:
	INCF       Inputs_keypad_scan_raw_row_L0+0, 1
	GOTO       L_Inputs_keypad_scan_raw60
L_Inputs_keypad_scan_raw61:
	CALL       Inputs_keypad_rows_idle+0
	MOVF       Inputs_keypad_scan_raw_key_L0+0, 0
	MOVWF      R0+0
L_end_keypad_scan_raw:
	RETURN
; end of Inputs_keypad_scan_raw

Inputs_scan_all_inputs_raw:

	BTFSC      PORTA+0, 2
	GOTO       L_Inputs_scan_all_inputs_raw75
	MOVLW      1
	MOVWF      R0+0
	GOTO       L_end_scan_all_inputs_raw
L_Inputs_scan_all_inputs_raw75:
	BTFSC      PORTA+0, 3
	GOTO       L_Inputs_scan_all_inputs_raw76
	MOVLW      2
	MOVWF      R0+0
	GOTO       L_end_scan_all_inputs_raw
L_Inputs_scan_all_inputs_raw76:
	BTFSC      PORTA+0, 4
	GOTO       L_Inputs_scan_all_inputs_raw77
	MOVLW      3
	MOVWF      R0+0
	GOTO       L_end_scan_all_inputs_raw
L_Inputs_scan_all_inputs_raw77:
	BTFSC      PORTA+0, 5
	GOTO       L_Inputs_scan_all_inputs_raw78
	MOVLW      4
	MOVWF      R0+0
	GOTO       L_end_scan_all_inputs_raw
L_Inputs_scan_all_inputs_raw78:
	CALL       Inputs_keypad_scan_raw+0
	MOVF       R0+0, 0
	MOVWF      Inputs_scan_all_inputs_raw_key_L0+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_scan_all_inputs_raw79
	MOVF       Inputs_scan_all_inputs_raw_key_L0+0, 0
	ADDLW      10
	MOVWF      R0+0
	GOTO       L_end_scan_all_inputs_raw
L_Inputs_scan_all_inputs_raw79:
	CLRF       R0+0
L_end_scan_all_inputs_raw:
	RETURN
; end of Inputs_scan_all_inputs_raw

Inputs_request_queue_push:

	MOVF       FARG_Inputs_request_queue_push_floor+0, 0
	SUBLW      3
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_request_queue_push80
	GOTO       L_end_request_queue_push
L_Inputs_request_queue_push80:
	MOVLW      4
	SUBWF      Inputs_req_count+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_Inputs_request_queue_push81
	GOTO       L_end_request_queue_push
L_Inputs_request_queue_push81:
	MOVF       Inputs_req_tail+0, 0
	ADDLW      Inputs_req_queue+0
	MOVWF      FSR
	MOVF       FARG_Inputs_request_queue_push_floor+0, 0
	MOVWF      INDF+0
	INCF       Inputs_req_tail+0, 1
	MOVLW      4
	SUBWF      Inputs_req_tail+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_Inputs_request_queue_push82
	CLRF       Inputs_req_tail+0
L_Inputs_request_queue_push82:
	INCF       Inputs_req_count+0, 1
L_end_request_queue_push:
	RETURN
; end of Inputs_request_queue_push

Inputs_handle_debounced_press:

	MOVLW      1
	SUBWF      FARG_Inputs_handle_debounced_press_scan_code+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_Inputs_handle_debounced_press85
	MOVLW      5
	SUBWF      FARG_Inputs_handle_debounced_press_scan_code+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_handle_debounced_press85
L_Inputs_handle_debounced_press172:
	DECF       FARG_Inputs_handle_debounced_press_scan_code+0, 0
	MOVWF      FARG_Inputs_request_queue_push_floor+0
	CALL       Inputs_request_queue_push+0
	GOTO       L_end_handle_debounced_press
L_Inputs_handle_debounced_press85:
	MOVF       FARG_Inputs_handle_debounced_press_scan_code+0, 0
	SUBLW      10
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_handle_debounced_press86
	MOVLW      10
	SUBWF      FARG_Inputs_handle_debounced_press_scan_code+0, 0
	MOVWF      Inputs_handle_debounced_press_key_L0+0
	GOTO       L_Inputs_handle_debounced_press87
L_Inputs_handle_debounced_press89:
	CLRF       FARG_Inputs_request_queue_push_floor+0
	CALL       Inputs_request_queue_push+0
	GOTO       L_Inputs_handle_debounced_press88
L_Inputs_handle_debounced_press90:
	MOVLW      1
	MOVWF      FARG_Inputs_request_queue_push_floor+0
	CALL       Inputs_request_queue_push+0
	GOTO       L_Inputs_handle_debounced_press88
L_Inputs_handle_debounced_press91:
	MOVLW      2
	MOVWF      FARG_Inputs_request_queue_push_floor+0
	CALL       Inputs_request_queue_push+0
	GOTO       L_Inputs_handle_debounced_press88
L_Inputs_handle_debounced_press92:
	MOVLW      3
	MOVWF      FARG_Inputs_request_queue_push_floor+0
	CALL       Inputs_request_queue_push+0
	GOTO       L_Inputs_handle_debounced_press88
L_Inputs_handle_debounced_press93:
	GOTO       L_Inputs_handle_debounced_press88
L_Inputs_handle_debounced_press87:
	MOVF       Inputs_handle_debounced_press_key_L0+0, 0
	XORLW      8
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_handle_debounced_press89
	MOVF       Inputs_handle_debounced_press_key_L0+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_handle_debounced_press90
	MOVF       Inputs_handle_debounced_press_key_L0+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_handle_debounced_press91
	MOVF       Inputs_handle_debounced_press_key_L0+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_handle_debounced_press92
	GOTO       L_Inputs_handle_debounced_press93
L_Inputs_handle_debounced_press88:
L_Inputs_handle_debounced_press86:
L_end_handle_debounced_press:
	RETURN
; end of Inputs_handle_debounced_press

Inputs_hall_read_raw_mask:

	CLRF       Inputs_hall_read_raw_mask_mask_L0+0
	BTFSC      PORTC+0, 3
	GOTO       L_Inputs_hall_read_raw_mask94
	BSF        Inputs_hall_read_raw_mask_mask_L0+0, 0
L_Inputs_hall_read_raw_mask94:
	BTFSC      PORTC+0, 4
	GOTO       L_Inputs_hall_read_raw_mask95
	BSF        Inputs_hall_read_raw_mask_mask_L0+0, 1
L_Inputs_hall_read_raw_mask95:
	BTFSC      PORTC+0, 5
	GOTO       L_Inputs_hall_read_raw_mask96
	BSF        Inputs_hall_read_raw_mask_mask_L0+0, 2
L_Inputs_hall_read_raw_mask96:
	BTFSC      PORTC+0, 6
	GOTO       L_Inputs_hall_read_raw_mask97
	BSF        Inputs_hall_read_raw_mask_mask_L0+0, 3
L_Inputs_hall_read_raw_mask97:
	MOVF       Inputs_hall_read_raw_mask_mask_L0+0, 0
	MOVWF      R0+0
L_end_hall_read_raw_mask:
	RETURN
; end of Inputs_hall_read_raw_mask

Inputs_buzzer_service_tick:

	CLRF       Inputs_buzzer_service_tick_output_on_L0+0
	CLRF       Inputs_buzzer_service_tick_period_L0+0
	GOTO       L_Inputs_buzzer_service_tick98
L_Inputs_buzzer_service_tick100:
	MOVLW      15
	SUBWF      Inputs_bz_tick_cnt+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_buzzer_service_tick101
	MOVLW      1
	MOVWF      Inputs_buzzer_service_tick_output_on_L0+0
	GOTO       L_Inputs_buzzer_service_tick102
L_Inputs_buzzer_service_tick101:
	CLRF       Inputs_bz_active_event+0
L_Inputs_buzzer_service_tick102:
	GOTO       L_Inputs_buzzer_service_tick99
L_Inputs_buzzer_service_tick103:
	MOVLW      10
	SUBWF      Inputs_bz_tick_cnt+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_buzzer_service_tick104
	MOVLW      1
	MOVWF      Inputs_buzzer_service_tick_output_on_L0+0
	GOTO       L_Inputs_buzzer_service_tick105
L_Inputs_buzzer_service_tick104:
	CLRF       Inputs_bz_active_event+0
L_Inputs_buzzer_service_tick105:
	GOTO       L_Inputs_buzzer_service_tick99
L_Inputs_buzzer_service_tick106:
	MOVLW      20
	MOVWF      Inputs_buzzer_service_tick_period_L0+0
	MOVLW      10
	SUBWF      Inputs_bz_tick_cnt+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_buzzer_service_tick107
	MOVLW      1
	MOVWF      R1+0
	GOTO       L_Inputs_buzzer_service_tick108
L_Inputs_buzzer_service_tick107:
	CLRF       R1+0
L_Inputs_buzzer_service_tick108:
	MOVF       R1+0, 0
	MOVWF      Inputs_buzzer_service_tick_output_on_L0+0
	GOTO       L_Inputs_buzzer_service_tick99
L_Inputs_buzzer_service_tick109:
	MOVLW      60
	MOVWF      Inputs_buzzer_service_tick_period_L0+0
	MOVLW      25
	SUBWF      Inputs_bz_tick_cnt+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_Inputs_buzzer_service_tick174
	MOVLW      35
	SUBWF      Inputs_bz_tick_cnt+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_Inputs_buzzer_service_tick175
	MOVLW      45
	SUBWF      Inputs_bz_tick_cnt+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_buzzer_service_tick175
	GOTO       L_Inputs_buzzer_service_tick174
L_Inputs_buzzer_service_tick175:
	GOTO       L_Inputs_buzzer_service_tick114
L_Inputs_buzzer_service_tick174:
	MOVLW      1
	MOVWF      Inputs_buzzer_service_tick_output_on_L0+0
L_Inputs_buzzer_service_tick114:
	GOTO       L_Inputs_buzzer_service_tick99
L_Inputs_buzzer_service_tick115:
	CLRF       Inputs_bz_active_event+0
	CLRF       Inputs_buzzer_service_tick_output_on_L0+0
	GOTO       L_Inputs_buzzer_service_tick99
L_Inputs_buzzer_service_tick98:
	MOVF       Inputs_bz_active_event+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buzzer_service_tick100
	MOVF       Inputs_bz_active_event+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buzzer_service_tick103
	MOVF       Inputs_bz_active_event+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buzzer_service_tick106
	MOVF       Inputs_bz_active_event+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buzzer_service_tick109
	GOTO       L_Inputs_buzzer_service_tick115
L_Inputs_buzzer_service_tick99:
	MOVF       Inputs_bz_active_event+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buzzer_service_tick116
	INCF       Inputs_bz_tick_cnt+0, 1
	MOVF       Inputs_buzzer_service_tick_period_L0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_buzzer_service_tick119
	MOVF       Inputs_buzzer_service_tick_period_L0+0, 0
	SUBWF      Inputs_bz_tick_cnt+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_Inputs_buzzer_service_tick119
L_Inputs_buzzer_service_tick173:
	CLRF       Inputs_bz_tick_cnt+0
L_Inputs_buzzer_service_tick119:
L_Inputs_buzzer_service_tick116:
	BTFSC      Inputs_buzzer_service_tick_output_on_L0+0, 0
	GOTO       L_Inputs_buzzer_service_tick211
	BCF        PORTC+0, 7
	GOTO       L_Inputs_buzzer_service_tick212
L_Inputs_buzzer_service_tick211:
	BSF        PORTC+0, 7
L_Inputs_buzzer_service_tick212:
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
	BCF        TRISE+0, 0
	BCF        TRISE+0, 1
	BCF        TRISE+0, 2
	BSF        TRISB+0, 0
	BSF        TRISB+0, 1
	BSF        TRISB+0, 2
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
	CLRF       Inputs_req_last_code+0
	CLRF       Inputs_req_stable_cnt+0
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
	CLRF       Inputs_lcd_cache+0
	CLRF       Inputs_lcd_cache+17
	MOVLW      Inputs_lcd_line_buf+0
	MOVWF      FARG_Inputs_buf_put_const_str_buf+0
	CLRF       FARG_Inputs_buf_put_const_str_pos+0
	MOVLW      ?lstr_11_Inputs+0
	MOVWF      FARG_Inputs_buf_put_const_str_s+0
	MOVLW      hi_addr(?lstr_11_Inputs+0)
	MOVWF      FARG_Inputs_buf_put_const_str_s+1
	CALL       Inputs_buf_put_const_str+0
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

	CALL       Inputs_scan_all_inputs_raw+0
	MOVF       R0+0, 0
	MOVWF      Inputs_Update_raw_code_L0+0
	MOVF       R0+0, 0
	XORWF      Inputs_req_last_code+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_Update120
	MOVF       Inputs_Update_raw_code_L0+0, 0
	MOVWF      Inputs_req_last_code+0
	CLRF       Inputs_req_stable_cnt+0
	GOTO       L_Inputs_Update121
L_Inputs_Update120:
	MOVLW      3
	SUBWF      Inputs_req_stable_cnt+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_Update122
	INCF       Inputs_req_stable_cnt+0, 1
	MOVF       Inputs_req_stable_cnt+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_Update125
	MOVF       Inputs_Update_raw_code_L0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_Update125
L__Inputs_Update176:
	MOVF       Inputs_Update_raw_code_L0+0, 0
	MOVWF      FARG_Inputs_handle_debounced_press_scan_code+0
	CALL       Inputs_handle_debounced_press+0
L_Inputs_Update125:
L_Inputs_Update122:
L_Inputs_Update121:
	CALL       Inputs_hall_read_raw_mask+0
	MOVF       R0+0, 0
	MOVWF      Inputs_Update_raw_hall_L0+0
	MOVF       R0+0, 0
	XORWF      Inputs_hall_last_raw+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_Update126
	MOVF       Inputs_Update_raw_hall_L0+0, 0
	MOVWF      Inputs_hall_last_raw+0
	CLRF       Inputs_hall_stable_cnt+0
	GOTO       L_Inputs_Update127
L_Inputs_Update126:
	MOVLW      2
	SUBWF      Inputs_hall_stable_cnt+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_Update128
	INCF       Inputs_hall_stable_cnt+0, 1
	MOVF       Inputs_hall_stable_cnt+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_Update129
	MOVF       Inputs_Update_raw_hall_L0+0, 0
	MOVWF      Inputs_hall_stable_mask+0
L_Inputs_Update129:
L_Inputs_Update128:
L_Inputs_Update127:
	CALL       Inputs_buzzer_service_tick+0
L_end_Inputs_Update:
	RETURN
; end of _Inputs_Update

_Inputs_GetNewFloorRequest:

	MOVF       FARG_Inputs_GetNewFloorRequest_floor+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L__Inputs_GetNewFloorRequest177
	MOVF       Inputs_req_count+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L__Inputs_GetNewFloorRequest177
	GOTO       L_Inputs_GetNewFloorRequest132
L__Inputs_GetNewFloorRequest177:
	CLRF       R0+0
	GOTO       L_end_Inputs_GetNewFloorRequest
L_Inputs_GetNewFloorRequest132:
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
	MOVLW      4
	SUBWF      Inputs_req_head+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_Inputs_GetNewFloorRequest133
	CLRF       Inputs_req_head+0
L_Inputs_GetNewFloorRequest133:
	DECF       Inputs_req_count+0, 1
	MOVLW      1
	MOVWF      R0+0
L_end_Inputs_GetNewFloorRequest:
	RETURN
; end of _Inputs_GetNewFloorRequest

_Inputs_GetCurrentFloor:

	GOTO       L_Inputs_GetCurrentFloor134
L_Inputs_GetCurrentFloor136:
	CLRF       R0+0
	GOTO       L_end_Inputs_GetCurrentFloor
L_Inputs_GetCurrentFloor137:
	MOVLW      1
	MOVWF      R0+0
	GOTO       L_end_Inputs_GetCurrentFloor
L_Inputs_GetCurrentFloor138:
	MOVLW      2
	MOVWF      R0+0
	GOTO       L_end_Inputs_GetCurrentFloor
L_Inputs_GetCurrentFloor139:
	MOVLW      3
	MOVWF      R0+0
	GOTO       L_end_Inputs_GetCurrentFloor
L_Inputs_GetCurrentFloor140:
	MOVLW      255
	MOVWF      R0+0
	GOTO       L_end_Inputs_GetCurrentFloor
L_Inputs_GetCurrentFloor134:
	MOVF       Inputs_hall_stable_mask+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_GetCurrentFloor136
	MOVF       Inputs_hall_stable_mask+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_GetCurrentFloor137
	MOVF       Inputs_hall_stable_mask+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_GetCurrentFloor138
	MOVF       Inputs_hall_stable_mask+0, 0
	XORLW      8
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_GetCurrentFloor139
	GOTO       L_Inputs_GetCurrentFloor140
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
	GOTO       L_Inputs_IsFloorSensorFault141
	MOVLW      1
	MOVWF      R2+0
	GOTO       L_Inputs_IsFloorSensorFault142
L_Inputs_IsFloorSensorFault141:
	CLRF       R2+0
L_Inputs_IsFloorSensorFault142:
	MOVF       R2+0, 0
	MOVWF      R0+0
L_end_Inputs_IsFloorSensorFault:
	RETURN
; end of _Inputs_IsFloorSensorFault

_Inputs_DisplayStatus:

	MOVF       Inputs_bz_active_event+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_DisplayStatus145
	MOVF       FARG_Inputs_DisplayStatus_controller_state+0, 0
	XORLW      7
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_DisplayStatus145
L__Inputs_DisplayStatus180:
	CLRF       Inputs_bz_active_event+0
	BCF        PORTC+0, 7
	GOTO       L_Inputs_DisplayStatus146
L_Inputs_DisplayStatus145:
	MOVF       Inputs_bz_active_event+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_DisplayStatus149
	MOVF       FARG_Inputs_DisplayStatus_controller_state+0, 0
	XORLW      8
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_DisplayStatus149
L__Inputs_DisplayStatus179:
	CLRF       Inputs_bz_active_event+0
	BCF        PORTC+0, 7
L_Inputs_DisplayStatus149:
L_Inputs_DisplayStatus146:
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
	GOTO       L_Inputs_DisplayStatus150
	MOVF       Inputs_DisplayStatus_pos_L0+0, 0
	ADDLW      Inputs_lcd_line_buf+0
	MOVWF      FSR
	MOVLW      93
	MOVWF      INDF+0
	INCF       Inputs_DisplayStatus_pos_L0+0, 1
L_Inputs_DisplayStatus150:
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
	GOTO       L_Inputs_DisplayStatus151
	MOVF       Inputs_DisplayStatus_pos_L0+0, 0
	ADDLW      Inputs_lcd_line_buf+0
	MOVWF      FSR
	MOVLW      103
	MOVWF      INDF+0
	INCF       Inputs_DisplayStatus_pos_L0+0, 1
L_Inputs_DisplayStatus151:
	MOVLW      16
	SUBWF      Inputs_DisplayStatus_pos_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Inputs_DisplayStatus152
	MOVF       Inputs_DisplayStatus_pos_L0+0, 0
	ADDLW      Inputs_lcd_line_buf+0
	MOVWF      FSR
	MOVLW      32
	MOVWF      INDF+0
	INCF       Inputs_DisplayStatus_pos_L0+0, 1
L_Inputs_DisplayStatus152:
	MOVF       FARG_Inputs_DisplayStatus_weight_grams+3, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__Inputs_DisplayStatus219
	MOVF       FARG_Inputs_DisplayStatus_weight_grams+2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__Inputs_DisplayStatus219
	MOVF       FARG_Inputs_DisplayStatus_weight_grams+1, 0
	SUBLW      5
	BTFSS      STATUS+0, 2
	GOTO       L__Inputs_DisplayStatus219
	MOVF       FARG_Inputs_DisplayStatus_weight_grams+0, 0
	SUBLW      220
L__Inputs_DisplayStatus219:
	BTFSS      STATUS+0, 0
	GOTO       L__Inputs_DisplayStatus178
	MOVF       FARG_Inputs_DisplayStatus_controller_state+0, 0
	XORLW      7
	BTFSC      STATUS+0, 2
	GOTO       L__Inputs_DisplayStatus178
	GOTO       L_Inputs_DisplayStatus155
L__Inputs_DisplayStatus178:
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
	GOTO       L_Inputs_DisplayStatus156
L_Inputs_DisplayStatus155:
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
L_Inputs_DisplayStatus156:
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

	GOTO       L_Inputs_Buzzer157
L_Inputs_Buzzer159:
L_Inputs_Buzzer160:
	MOVF       Inputs_bz_active_event+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L__Inputs_Buzzer181
	MOVF       Inputs_bz_active_event+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L__Inputs_Buzzer181
	GOTO       L_Inputs_Buzzer163
L__Inputs_Buzzer181:
	GOTO       L_end_Inputs_Buzzer
L_Inputs_Buzzer163:
	MOVF       FARG_Inputs_Buzzer_event_code+0, 0
	MOVWF      Inputs_bz_active_event+0
	CLRF       Inputs_bz_tick_cnt+0
	GOTO       L_Inputs_Buzzer158
L_Inputs_Buzzer164:
	MOVF       Inputs_bz_active_event+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_Inputs_Buzzer165
	GOTO       L_end_Inputs_Buzzer
L_Inputs_Buzzer165:
	MOVF       Inputs_bz_active_event+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_Buzzer166
	MOVLW      2
	MOVWF      Inputs_bz_active_event+0
	CLRF       Inputs_bz_tick_cnt+0
L_Inputs_Buzzer166:
	GOTO       L_Inputs_Buzzer158
L_Inputs_Buzzer167:
	MOVF       Inputs_bz_active_event+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_Buzzer168
	MOVLW      3
	MOVWF      Inputs_bz_active_event+0
	CLRF       Inputs_bz_tick_cnt+0
L_Inputs_Buzzer168:
	GOTO       L_Inputs_Buzzer158
L_Inputs_Buzzer169:
	CLRF       Inputs_bz_active_event+0
	CLRF       Inputs_bz_tick_cnt+0
	BCF        PORTC+0, 7
	GOTO       L_Inputs_Buzzer158
L_Inputs_Buzzer157:
	MOVF       FARG_Inputs_Buzzer_event_code+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_Buzzer159
	MOVF       FARG_Inputs_Buzzer_event_code+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_Buzzer160
	MOVF       FARG_Inputs_Buzzer_event_code+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_Buzzer164
	MOVF       FARG_Inputs_Buzzer_event_code+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_Inputs_Buzzer167
	GOTO       L_Inputs_Buzzer169
L_Inputs_Buzzer158:
L_end_Inputs_Buzzer:
	RETURN
; end of _Inputs_Buzzer
