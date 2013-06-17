;******************************************************************************
;   This file is a basic template for assembly code for a PIC18F2525. Copy    *
;   this file into your project directory and modify or add to it as needed.  *
;                                                                             *
;   The PIC18FXXXX architecture allows two interrupt configurations. This     *
;   template code is written for priority interrupt levels and the IPEN bit   *
;   in the RCON register must be set to enable priority levels. If IPEN is    *
;   left in its default zero state, only the interrupt vector at 0x008 will   *
;   be used and the WREG_TEMP, BSR_TEMP and STATUS_TEMP variables will not    *
;   be needed.                                                                *
;                                                                             *
;   Refer to the MPASM User's Guide for additional information on the         *
;   features of the assembler.                                                *
;                                                                             *
;   Refer to the PIC18FX681 Data Sheet for additional          *
;   information on the architecture and instruction set.                      *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Filename:                                                                *
;    Date:                                                                    *
;    File Version:                                                            *
;                                                                             *
;    Author:                                                                  *
;    Company:                                                                 *
;                                                                             * 
;******************************************************************************
;                                                                             *
;    Files required:         P18F4681.INC                                     *
;			     18F4681.LKR               			      *
;									      *
;                                                                             *
;                                                                             *
;******************************************************************************

	LIST P=18F4681, F=INHX32	;directive to define processor
	#include <P18F4681.INC>	;processor specific variable definitions

;******************************************************************************
;Configuration bits
; The __CONFIG directive defines configuration data within the .ASM file.
; The labels following the directive are defined in the P18F2525.INC file.
; The PIC18FX681 Data Sheet explains the functions of the
; configuration bits. 

	__CONFIG _CONFIG1H, _OSC_HS_1H & _FCMENB_OFF_1H & _IESOB_OFF_1H 
	__CONFIG _CONFIG2L, _PWRT_OFF_2L & _BOR_OFF_2L & _BORV_45_2L
	__CONFIG _CONFIG2H, _WDT_OFF_2H & _WDTPS_1_2H 
	__CONFIG _CONFIG3H, _MCLRE_ON_3H & _LPT1OSC_OFF_3H & _PBADEN_OFF_3H  
	__CONFIG _CONFIG4L, _DEBUG_OFF_4L & _LVP_OFF_4L & _STVREN_OFF_4L 
	__CONFIG _CONFIG5L, _CP0_OFF_5L & _CP1_OFF_5L & _CP2_OFF_5L & _CP3_OFF_5L
	__CONFIG _CONFIG5H, _CPB_OFF_5H & _CPD_OFF_5H
	__CONFIG _CONFIG6L, _WRT0_OFF_6L & _WRT1_OFF_6L & _WRT2_OFF_6L & _WRT3_OFF_6L
	__CONFIG _CONFIG6H, _WRTB_OFF_6H & _WRTC_OFF_6H & _WRTD_OFF_6H
	__CONFIG _CONFIG7L, _EBTR0_OFF_7L & _EBTR1_OFF_7L & _EBTR2_OFF_7L & _EBTR3_OFF_7L
	__CONFIG _CONFIG7H, _EBTRB_OFF_7H & _DEVID1 & _IDLOC0

;******************************************************************************
;Variable definitions
; These variables are only needed if low priority interrupts are used. 
; More variables may be needed to store other special function registers used
; in the interrupt routines.

		UDATA

WREG_TEMP	RES	1	;variable in RAM for context saving 
STATUS_TEMP	RES	1	;variable in RAM for context saving
BSR_TEMP	RES	1	;variable in RAM for context saving

		UDATA_ACS

EXAMPLE		RES	1	;example of a variable in access RAM



;******************************************************************************
;Reset vector
; This code will start executing when a reset occurs.

RESET_VECTOR	CODE	0x0000

		goto	Main		;go to start of main code

;******************************************************************************
;High priority interrupt vector
; This code will start executing when a high priority interrupt occurs or
; when any interrupt occurs if interrupt priorities are not enabled.

HI_INT_VECTOR	CODE	0x0008

		bra	HighInt		;go to high priority interrupt routine

;******************************************************************************
;Low priority interrupt vector and routine
; This code will start executing when a low priority interrupt occurs.
; This code can be removed if low priority interrupts are not used.

LOW_INT_VECTOR	CODE	0x0018

		bra	LowInt		;go to low priority interrupt routine

;******************************************************************************
;High priority interrupt routine
; The high priority interrupt code is placed here to avoid conflicting with
; the low priority interrupt vector.


		CODE

HighInt:

;	*** high priority interrupt code goes here ***


		retfie	FAST

;******************************************************************************
;Low priority interrupt routine
; The low priority interrupt code is placed here.
; This code can be removed if low priority interrupts are not used.

LowInt:
		movff	STATUS,STATUS_TEMP	;save STATUS register
		movff	WREG,WREG_TEMP		;save working register
		movff	BSR,BSR_TEMP		;save BSR register

;	*** low priority interrupt code goes here ***


		movff	BSR_TEMP,BSR		;restore BSR register
		movff	WREG_TEMP,WREG		;restore working register
		movff	STATUS_TEMP,STATUS	;restore STATUS register
		retfie

;******************************************************************************
;Start of main program
; The main program code is placed here.

Main:

;	*** main code goes here ***


;******************************************************************************
;End of program

		END
