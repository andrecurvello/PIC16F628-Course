

	;#include <defs.inc>
	
	
	;CODE
	
CJNE	MACRO	REG, VAL, ENDER
		movlw	VAL
		subwf	REG,W
		btfsc	STATUS,Z
		goto	ENDER	
		ENDM	
	
	
	;END