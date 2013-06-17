;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   
;   Biblioteca de funcoes matematicas
;   @Author  :  Rafael Dias Menezes
;   @Data    :  Jul/2009
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    #include <defs.inc>
    #include <macros.inc>
    
    
    UDATA
B_REG 	RES 1   ;  vari�vel armazenamento de valores temporarios
W_TEMP	RES 1     
    
    UDATA_OVR
iCount	RES 1
LTMP	RES 2
       
        
    GLOBAL  B_REG, DIV_8, MUL_8
     
    CODE
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     
;   MUL_8
;   \brief  realiza a multiplica��o de 8 bits entre W_REG e B_REG.
;   \return WREG(LSB) B_REG(MSB)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
MUL_8:
	BANKSEL	LTMP	; LTMP � a variavel de 16 bits que armazenar� o resultado
	clrf	LTMP
	clrf	LTMP+1
	BANKSEL	iCount
	clrf	iCount
	BANKSEL	W_TEMP
	movwf	W_TEMP

; mutiplica��o n�o passa de uma soma sucessiva	
MUL_8_LOOP:	

	; verifica��o do controle do LOOP.
	; quando iCount for igual a B_REG, sai do loop.
	
	BANKSEL	iCount
	movf	iCount,W
	BANKSEL	B_REG
	subwf	B_REG,W
	
	btfsc	STATUS,Z
	goto	MUL_8_END
	
	BANKSEL	W_TEMP
	movf	W_TEMP,W
	BANKSEL	LTMP
	addwf	LTMP+1,F
	btfsc	STATUS,C
	incf	LTMP,F
	
	BANKSEL	iCount
	incf	iCount,F			; incrementa contador
	
	goto MUL_8_LOOP
	
MUL_8_END:
	; copia os valores finais do calculo.
	; B_REG byte mais significativo do c�lculo (MSB)
	; W_REG	byte menos significativo do c�lculo (LSB)
	BANKSEL	LTMP
	movf	LTMP,W
	BANKSEL	B_REG
	movwf	B_REG
	BANKSEL	LTMP+1
	movf	LTMP+1,W
	return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
 
 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     
;   DIV_8
;   \brief  realiza a divis�o de 8 bits entre W_REG(dividendo) e B_REG(divisor).
;   \return WREG(quociente) B_REG(resto)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
DIV_8:
	; inicializa��o de vari�veis locais
	BANKSEL	iCount
	clrf	iCount
	
	BANKSEL	W_TEMP
	movwf	W_TEMP
	
	BANKSEL	B_REG
	subwf	B_REG,W
	
	btfsc	STATUS,Z
	goto	DIV_8_END_DIV.EQ.DIVD
	btfsc	STATUS,C
	goto	DIV_8_END_DIV.GT.DIVD
	
DIV_8_LOOP:
	; REALIZA O LOOP INTERATIVO PARA CALCULAR A DIVIS�O DE DOIS NUMETROS INTEIROS
	; O LOOP � REALIZADO AT� QUE O VALOR ARMAZENADO NA VARI�VEL W_TEMP SEJA MENOR
	; DO QUE O VALOR DE B_REG
	BANKSEL	W_TEMP
	movf	W_TEMP,W
	
	BANKSEL	B_REG
	movf	B_REG,W
	subwf	W_TEMP,W	; W <= W_TEMP-B_REG
	
	BANKSEL	W_TEMP
	movwf	W_TEMP	

	; agora devo comparar o valor de W_TEMP com B_REG. 
	;Se B_REG > W_TEMP
	BANKSEL	B_REG
	movf	B_REG,W
	subwf	W_TEMP,W
	
	BANKSEL	iCount			; incrementa contador do quociente
	incf	iCount,F	
	
	btfsc   STATUS,Z
	goto 	DIV_8_END_RESTO
	btfss	STATUS,C
	goto 	DIV_8_END_RESTO
	
	goto	DIV_8_LOOP	; repete o loop

DIV_8_END_RESTO:
	; RETORNA O VALOR DO RESTO
	BANKSEL	W_TEMP
	movf	W_TEMP,W
	BANKSEL	B_REG
	movwf	B_REG

	; RETORNA O VALOR DO QUOCIENTE
	BANKSEL	iCount
	movf	iCount,W
	RETURN
	
DIV_8_END_DIV.EQ.DIVD
	BANKSEL	B_REG	
	clrf	B_REG
	movlw	1
	RETURN
	
DIV_8_END_DIV.GT.DIVD
	BANKSEL	W_TEMP
	movf	W_TEMP,W
	BANKSEL	B_REG
	movwf	B_REG
	clrw
	RETURN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
	
  
    END;