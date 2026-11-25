
_main:

	CALL       _Motor_Init+0
	CALL       _Inputs_Init+0
	CALL       _Controller_Init+0
L_main0:
	CALL       _Motor_Update+0
	CALL       _Inputs_Update+0
	CALL       _Controller_Update+0
	MOVLW      65
	MOVWF      R12+0
	MOVLW      238
	MOVWF      R13+0
L_main2:
	DECFSZ     R13+0, 1
	GOTO       L_main2
	DECFSZ     R12+0, 1
	GOTO       L_main2
	NOP
	GOTO       L_main0
L_end_main:
	GOTO       $+0
; end of _main
