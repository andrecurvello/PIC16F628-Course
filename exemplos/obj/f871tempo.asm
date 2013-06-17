;**********************************************************************
;   This file is a basic code template for object module code         *
;   generation on the PICmicro PIC16F871. This file contains the      *
;   basic code building blocks to build upon.  As a project minimum   *
;   the 16F871.lkr file will also be required for this file to        *
;   correctly build. The .lkr files are located in the MPLAB          *  
;   directory.                                                        *
;                                                                     *
;   If interrupts are not used all code presented between the         *
;   code section "INT_VECTOR and code section "MAIN" can be removed.  *
;   In addition the variable assignments for 'w_temp' and             *
;   'status_temp' can be removed.                                     *                         
;                                                                     *
;   If interrupts are used, as in this template file, the 16F871.lkr  *
;   file will need to be modified as follows: Remove the lines        *
;     CODEPAGE   NAME=vectors  START=0x0      END=0x4      PROTECTED  *
;   and                                                               *
;     SECTION    NAME=STARTUP  ROM=vectors                            *
;   and change the start address of the page0 section from 0x5 to 0x0 *                                                               *
;                                                                     *
;   Refer to the MPASM User's Guide for additional information on     *
;   features of the assembler and linker (Document DS33014).          *
;                                                                     *
;   Refer to the respective PICmicro data sheet for additional        *
;   information on the instruction set.                               *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Filename:	    xxx.asm                                           *
;    Date:                                                            *
;    File Version:                                                    *
;                                                                     *
;    Author:                                                          *
;    Company:                                                         *
;                                                                     * 
;                                                                     *
;**********************************************************************
;                                                                     *
;    Files required:                                                  *
;                                                                     *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Notes:                                                           *
;                                                                     *
;                                                                     *
;                                                                     *
;                                                                     *
;**********************************************************************


	list		p=16f871	; list directive to define processor
	#include	<p16f871.inc>	; processor specific variable definitions
	
	__CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_ON & _RC_OSC & _WRT_ENABLE_ON & _LVP_ON & _CPD_OFF


; '__CONFIG' directive is used to embed configuration data within .asm file.
; The labels following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.






;***** VARIABLE DEFINITIONS (examples)

; example of using Shared Uninitialized Data Section
INT_VAR		UDATA_SHR	0x71   
w_temp		RES     1		; variable used for context saving 
status_temp	RES     1		; variable used for context saving


; example of using Uninitialized Data Section
TEMP_VAR	UDATA_SHR	0x20		; explicit address specified is not required
temp_count	RES	1		; temporary variable (example)








;**********************************************************************
RESET_VECTOR	CODE	0x000		; processor reset vector
	movlw	high  start		; load upper byte of 'start' label
	movwf	PCLATH			; initialize PCLATH
	goto	start			; go to beginning of program


INT_VECTOR	CODE	0x004		; interrupt vector location
	movwf	w_temp			; save off current W register contents
	movf	STATUS,w		; move status register into W register
	movwf	status_temp		; save off contents of STATUS register


; isr code can go here or be located as a call subroutine elsewhere


	movf	status_temp,w		; retrieve copy of STATUS register
	movwf	STATUS			; restore pre-isr STATUS register contents
	swapf	w_temp,f
	swapf	w_temp,w		; restore pre-isr W register contents
	retfie				; return from interrupt


MAIN	CODE
start



; remaining code goes here






	END                       ; directive 'end of program'

