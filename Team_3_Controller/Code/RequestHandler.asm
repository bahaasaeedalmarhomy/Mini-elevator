
_RequestHandler_Init:

	CLRF       RequestHandler_request_count+0
	CLRF       R1+0
L_RequestHandler_Init0:
	MOVLW      4
	SUBWF      R1+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_RequestHandler_Init1
	MOVF       R1+0, 0
	ADDLW      RequestHandler_requests+0
	MOVWF      FSR
	MOVLW      255
	MOVWF      INDF+0
	INCF       R1+0, 1
	GOTO       L_RequestHandler_Init0
L_RequestHandler_Init1:
L_end_RequestHandler_Init:
	RETURN
; end of _RequestHandler_Init

_RequestHandler_Contains:

	CLRF       R1+0
L_RequestHandler_Contains3:
	MOVF       RequestHandler_request_count+0, 0
	SUBWF      R1+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_RequestHandler_Contains4
	MOVF       R1+0, 0
	ADDLW      RequestHandler_requests+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORWF      FARG_RequestHandler_Contains_floor+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_RequestHandler_Contains6
	MOVLW      1
	MOVWF      R0+0
	GOTO       L_end_RequestHandler_Contains
L_RequestHandler_Contains6:
	INCF       R1+0, 1
	GOTO       L_RequestHandler_Contains3
L_RequestHandler_Contains4:
	CLRF       R0+0
L_end_RequestHandler_Contains:
	RETURN
; end of _RequestHandler_Contains

_RequestHandler_Add:

	MOVF       FARG_RequestHandler_Add_floor+0, 0
	SUBLW      3
	BTFSC      STATUS+0, 0
	GOTO       L_RequestHandler_Add7
	GOTO       L_end_RequestHandler_Add
L_RequestHandler_Add7:
	MOVF       FARG_RequestHandler_Add_floor+0, 0
	MOVWF      FARG_RequestHandler_Contains_floor+0
	CALL       _RequestHandler_Contains+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_RequestHandler_Add8
	GOTO       L_end_RequestHandler_Add
L_RequestHandler_Add8:
	MOVLW      4
	SUBWF      RequestHandler_request_count+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_RequestHandler_Add9
	MOVF       RequestHandler_request_count+0, 0
	ADDLW      RequestHandler_requests+0
	MOVWF      FSR
	MOVF       FARG_RequestHandler_Add_floor+0, 0
	MOVWF      INDF+0
	INCF       RequestHandler_request_count+0, 1
L_RequestHandler_Add9:
L_end_RequestHandler_Add:
	RETURN
; end of _RequestHandler_Add

_RequestHandler_HasRequests:

	MOVF       RequestHandler_request_count+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_RequestHandler_HasRequests10
	MOVLW      1
	MOVWF      R1+0
	GOTO       L_RequestHandler_HasRequests11
L_RequestHandler_HasRequests10:
	CLRF       R1+0
L_RequestHandler_HasRequests11:
	MOVF       R1+0, 0
	MOVWF      R0+0
L_end_RequestHandler_HasRequests:
	RETURN
; end of _RequestHandler_HasRequests

_RequestHandler_GetNext:

	MOVF       RequestHandler_request_count+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_RequestHandler_GetNext12
	MOVLW      255
	MOVWF      R0+0
	GOTO       L_end_RequestHandler_GetNext
L_RequestHandler_GetNext12:
	MOVF       RequestHandler_requests+0, 0
	MOVWF      R0+0
L_end_RequestHandler_GetNext:
	RETURN
; end of _RequestHandler_GetNext

_RequestHandler_GetNextOptimal:

	MOVF       FARG_RequestHandler_GetNextOptimal_direction+0, 0
	MOVWF      RequestHandler_GetNextOptimal_scan_dir_L0+0
	MOVF       RequestHandler_request_count+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_RequestHandler_GetNextOptimal13
	MOVLW      255
	MOVWF      R0+0
	GOTO       L_end_RequestHandler_GetNextOptimal
L_RequestHandler_GetNextOptimal13:
	MOVF       FARG_RequestHandler_GetNextOptimal_current_floor+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L__RequestHandler_GetNextOptimal52
	MOVF       FARG_RequestHandler_GetNextOptimal_current_floor+0, 0
	SUBLW      3
	BTFSS      STATUS+0, 0
	GOTO       L__RequestHandler_GetNextOptimal52
	GOTO       L_RequestHandler_GetNextOptimal16
L__RequestHandler_GetNextOptimal52:
	MOVF       RequestHandler_requests+0, 0
	MOVWF      R0+0
	GOTO       L_end_RequestHandler_GetNextOptimal
L_RequestHandler_GetNextOptimal16:
	MOVF       FARG_RequestHandler_GetNextOptimal_current_floor+0, 0
	MOVWF      FARG_RequestHandler_Contains_floor+0
	CALL       _RequestHandler_Contains+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_RequestHandler_GetNextOptimal17
	MOVF       FARG_RequestHandler_GetNextOptimal_current_floor+0, 0
	MOVWF      R0+0
	GOTO       L_end_RequestHandler_GetNextOptimal
L_RequestHandler_GetNextOptimal17:
	MOVF       RequestHandler_GetNextOptimal_scan_dir_L0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_RequestHandler_GetNextOptimal18
	MOVF       RequestHandler_requests+0, 0
	SUBWF      FARG_RequestHandler_GetNextOptimal_current_floor+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_RequestHandler_GetNextOptimal19
	MOVLW      1
	MOVWF      RequestHandler_GetNextOptimal_scan_dir_L0+0
	GOTO       L_RequestHandler_GetNextOptimal20
L_RequestHandler_GetNextOptimal19:
	MOVF       FARG_RequestHandler_GetNextOptimal_current_floor+0, 0
	SUBWF      RequestHandler_requests+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_RequestHandler_GetNextOptimal21
	MOVLW      255
	MOVWF      RequestHandler_GetNextOptimal_scan_dir_L0+0
	GOTO       L_RequestHandler_GetNextOptimal22
L_RequestHandler_GetNextOptimal21:
	MOVF       RequestHandler_requests+0, 0
	MOVWF      R0+0
	GOTO       L_end_RequestHandler_GetNextOptimal
L_RequestHandler_GetNextOptimal22:
L_RequestHandler_GetNextOptimal20:
L_RequestHandler_GetNextOptimal18:
	MOVF       RequestHandler_GetNextOptimal_scan_dir_L0+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_RequestHandler_GetNextOptimal23
	INCF       FARG_RequestHandler_GetNextOptimal_current_floor+0, 0
	MOVWF      RequestHandler_GetNextOptimal_f_L0+0
L_RequestHandler_GetNextOptimal24:
	MOVLW      4
	SUBWF      RequestHandler_GetNextOptimal_f_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_RequestHandler_GetNextOptimal25
	MOVF       RequestHandler_GetNextOptimal_f_L0+0, 0
	MOVWF      FARG_RequestHandler_Contains_floor+0
	CALL       _RequestHandler_Contains+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_RequestHandler_GetNextOptimal27
	MOVF       RequestHandler_GetNextOptimal_f_L0+0, 0
	MOVWF      R0+0
	GOTO       L_end_RequestHandler_GetNextOptimal
L_RequestHandler_GetNextOptimal27:
	INCF       RequestHandler_GetNextOptimal_f_L0+0, 1
	GOTO       L_RequestHandler_GetNextOptimal24
L_RequestHandler_GetNextOptimal25:
	MOVF       FARG_RequestHandler_GetNextOptimal_current_floor+0, 0
	MOVWF      RequestHandler_GetNextOptimal_f_L0+0
L_RequestHandler_GetNextOptimal28:
	MOVF       RequestHandler_GetNextOptimal_f_L0+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_RequestHandler_GetNextOptimal29
	DECF       RequestHandler_GetNextOptimal_f_L0+0, 0
	MOVWF      FARG_RequestHandler_Contains_floor+0
	CALL       _RequestHandler_Contains+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_RequestHandler_GetNextOptimal31
	DECF       RequestHandler_GetNextOptimal_f_L0+0, 0
	MOVWF      R0+0
	GOTO       L_end_RequestHandler_GetNextOptimal
L_RequestHandler_GetNextOptimal31:
	DECF       RequestHandler_GetNextOptimal_f_L0+0, 1
	GOTO       L_RequestHandler_GetNextOptimal28
L_RequestHandler_GetNextOptimal29:
	GOTO       L_RequestHandler_GetNextOptimal32
L_RequestHandler_GetNextOptimal23:
	MOVF       RequestHandler_GetNextOptimal_scan_dir_L0+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L_RequestHandler_GetNextOptimal33
	MOVF       FARG_RequestHandler_GetNextOptimal_current_floor+0, 0
	MOVWF      RequestHandler_GetNextOptimal_f_L0+0
L_RequestHandler_GetNextOptimal34:
	MOVF       RequestHandler_GetNextOptimal_f_L0+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_RequestHandler_GetNextOptimal35
	DECF       RequestHandler_GetNextOptimal_f_L0+0, 0
	MOVWF      FARG_RequestHandler_Contains_floor+0
	CALL       _RequestHandler_Contains+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_RequestHandler_GetNextOptimal37
	DECF       RequestHandler_GetNextOptimal_f_L0+0, 0
	MOVWF      R0+0
	GOTO       L_end_RequestHandler_GetNextOptimal
L_RequestHandler_GetNextOptimal37:
	DECF       RequestHandler_GetNextOptimal_f_L0+0, 1
	GOTO       L_RequestHandler_GetNextOptimal34
L_RequestHandler_GetNextOptimal35:
	INCF       FARG_RequestHandler_GetNextOptimal_current_floor+0, 0
	MOVWF      RequestHandler_GetNextOptimal_f_L0+0
L_RequestHandler_GetNextOptimal38:
	MOVLW      4
	SUBWF      RequestHandler_GetNextOptimal_f_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_RequestHandler_GetNextOptimal39
	MOVF       RequestHandler_GetNextOptimal_f_L0+0, 0
	MOVWF      FARG_RequestHandler_Contains_floor+0
	CALL       _RequestHandler_Contains+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_RequestHandler_GetNextOptimal41
	MOVF       RequestHandler_GetNextOptimal_f_L0+0, 0
	MOVWF      R0+0
	GOTO       L_end_RequestHandler_GetNextOptimal
L_RequestHandler_GetNextOptimal41:
	INCF       RequestHandler_GetNextOptimal_f_L0+0, 1
	GOTO       L_RequestHandler_GetNextOptimal38
L_RequestHandler_GetNextOptimal39:
L_RequestHandler_GetNextOptimal33:
L_RequestHandler_GetNextOptimal32:
	MOVF       RequestHandler_requests+0, 0
	MOVWF      R0+0
L_end_RequestHandler_GetNextOptimal:
	RETURN
; end of _RequestHandler_GetNextOptimal

_RequestHandler_Remove:

	CLRF       R3+0
L_RequestHandler_Remove42:
	MOVF       RequestHandler_request_count+0, 0
	SUBWF      R3+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_RequestHandler_Remove43
	MOVF       R3+0, 0
	ADDLW      RequestHandler_requests+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORWF      FARG_RequestHandler_Remove_floor+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_RequestHandler_Remove45
	MOVF       R3+0, 0
	MOVWF      R4+0
L_RequestHandler_Remove46:
	MOVLW      1
	SUBWF      RequestHandler_request_count+0, 0
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
	GOTO       L__RequestHandler_Remove60
	MOVF       R1+0, 0
	SUBWF      R4+0, 0
L__RequestHandler_Remove60:
	BTFSC      STATUS+0, 0
	GOTO       L_RequestHandler_Remove47
	MOVF       R4+0, 0
	ADDLW      RequestHandler_requests+0
	MOVWF      R2+0
	MOVF       R4+0, 0
	ADDLW      1
	MOVWF      R0+0
	CLRF       R0+1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVF       R0+0, 0
	ADDLW      RequestHandler_requests+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	MOVF       R2+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
	INCF       R4+0, 1
	GOTO       L_RequestHandler_Remove46
L_RequestHandler_Remove47:
	DECF       RequestHandler_request_count+0, 1
	MOVF       RequestHandler_request_count+0, 0
	ADDLW      RequestHandler_requests+0
	MOVWF      FSR
	MOVLW      255
	MOVWF      INDF+0
	GOTO       L_end_RequestHandler_Remove
L_RequestHandler_Remove45:
	INCF       R3+0, 1
	GOTO       L_RequestHandler_Remove42
L_RequestHandler_Remove43:
L_end_RequestHandler_Remove:
	RETURN
; end of _RequestHandler_Remove

_RequestHandler_Clear:

	CLRF       RequestHandler_request_count+0
	CLRF       R1+0
L_RequestHandler_Clear49:
	MOVLW      4
	SUBWF      R1+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_RequestHandler_Clear50
	MOVF       R1+0, 0
	ADDLW      RequestHandler_requests+0
	MOVWF      FSR
	MOVLW      255
	MOVWF      INDF+0
	INCF       R1+0, 1
	GOTO       L_RequestHandler_Clear49
L_RequestHandler_Clear50:
L_end_RequestHandler_Clear:
	RETURN
; end of _RequestHandler_Clear

_RequestHandler_GetCount:

	MOVF       RequestHandler_request_count+0, 0
	MOVWF      R0+0
L_end_RequestHandler_GetCount:
	RETURN
; end of _RequestHandler_GetCount
