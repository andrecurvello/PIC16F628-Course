;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   
;   Biblioteca de delay
;   @Author  :  Rafael Dias Menezes
;   @Data    :  Jul/2009
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    list p=16F628A
    #include <p16F628A.inc>
    RADIX   dec

    
; variaveis locais ao modulo
    UDATA_OVR
I RES   1
J RES   1
K RES   2

    GLOBAL Delay_1ms, Delay_500ms

    CODE
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;            

;
;   \brief  Realiza um delay de 1ms
;
Delay_1ms:
    BANKSEL I
    MOVLW   5
    MOVWF   I
    MOVLW   66
    MOVWF   J
    
    DECFSZ  J,F
    GOTO $-1
    
    DECFSZ  I,F
    GOTO $-5
    RETURN;
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    

;
;   \brief  Realiza um delay de 1ms
;
Delay_500ms:

    BANKSEL K
    MOVLW   HIGH (500-1)
    MOVWF   K
    MOVLW   LOW  (500-1)
    MOVWF   K+1
    
    PAGESEL Delay_1ms
    CALL    Delay_1ms
    DECF    K+1,F
    MOVLW   0xFF
    XORWF   K+1,W
    BTFSS   STATUS,Z    ; K+1 < 0
    GOTO    $-5   
    DECF    K,F
    MOVLW   0xFF
    XORWF   K,W
    BTFSS   STATUS,Z    ; K < 0
    GOTO    $-10
    

    RETURN;
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    


    END