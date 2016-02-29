;#start=8259.exe#    

    .model small          
    .data  
    
    flag db 0
    pacchetto db 512 dup(0)
             
    .stack     
    .code   
    
    
    ; procedura di inizializzazione della interrupt vector table
INIT_IVT	PROC
		PUSH 	AX
		PUSH	BX
		PUSH	DX
		PUSH 	DS
		XOR	AX, 	AX
		MOV	DS, 	AX      
		
		; channel 7
		MOV	BX, 	39		
		SHL	BX, 	2		
		MOV AX, 	offset ISR_PA_IN
		MOV	DS:[BX], 	AX
		MOV	AX,     seg ISR_PA_IN
		MOV	DS:[BX+2], 	AX       
		; channel 6
		MOV	BX, 	38		
		SHL	BX, 	2		
		MOV AX, 	offset ISR_PA_OUT
		MOV	DS:[BX], 	AX
		MOV	AX,     seg ISR_PA_OUT
		MOV	DS:[BX+2], 	AX       		
		; channel 5
		MOV	BX, 	37		
		SHL	BX, 	2		
		MOV AX, 	offset ISR_PB_IN
		MOV	DS:[BX], 	AX
		MOV	AX,     seg ISR_PB_IN
		MOV	DS:[BX+2], 	AX       				
		; channel 4
		MOV	BX, 	36		
		SHL	BX, 	2		
		MOV AX, 	offset ISR_PB_OUT
		MOV	DS:[BX], 	AX
		MOV	AX,     seg ISR_PB_OUT
		MOV	DS:[BX+2], 	AX       		
		; channel 3
		MOV	BX, 	35		
		SHL	BX, 	2		
		MOV AX, 	offset ISR_COUNT0
		MOV	DS:[BX], 	AX
		MOV	AX,     seg ISR_COUNT0
		MOV	DS:[BX+2], 	AX 					
		; channel 4
		MOV	BX, 	34		
		SHL	BX, 	2		
		MOV AX, 	offset ISR_COUNT12
		MOV	DS:[BX], 	AX
		MOV	AX,     seg ISR_COUNT12
		MOV	DS:[BX+2], 	AX 					
										
		POP	DS
		POP	DX
		POP	BX
		POP	AX 		
		RET
INIT_IVT	ENDP

; ISR for reading the value received on PA            
ISR_PA_IN   PROC                
            
           
            IRET    
ISR_PA_IN   ENDP             
              
; ISR for waiting a confirmation that the value written on PA is externally read 
ISR_PA_OUT  PROC               


                                      
            IRET    
ISR_PA_OUT  ENDP                                  
                           
; ISR for reading the value received on PB                                       
ISR_PB_IN   PROC              
            
            
            
                                            
            IRET    
ISR_PB_IN   ENDP             
                                          
; ISR for waiting a confirmation that the value written on PB is externally read                                           
ISR_PB_OUT  PROC  

                              
            IRET    
ISR_PB_OUT  ENDP         
                
; ISR executed when count0 ends                
ISR_COUNT0  PROC
    
     in al, 080h 
     ;se di e' pari, cioè ultimo bit a 0
     ;allora sto ricevendo un msb e dunque
     ;lo devo porre a pacchetto[di+1]. 
     ;se di e' dispoari allora sto un lsb
     ;e dunque devo porre il byte in 
     ;pacchetto[di-1]
     test di, 00000000000000001b
     ;se lo zf viene settato a 1 il numero
     ;e' pari
     jz diPari
     ;diDispari
     mov pacchetto[di-1], al
     ;quando è dispari significa che un 
     ;elemento dei 255 è stato inserito
     ;quidi si deve calcolare la parita
     ;che salvero' sul registro dx
     ;recupero intero valore
     ;mov al, pacchetto[di-1]
     mov ah, pacchetto[di]
     cmp di, 511 ;se non sono i bit di parita
     je inserito 
     or dx, ax     
     jmp inserito
     
     diPari:        
        mov pacchetto[di+1], al
        
     inserito:
        inc di
        
        cmp di, 512
        jne fine 
        ;controllo parita
        mov bh, pacchetto[510]
        mov bl, pacchetto[511] 
        
        cmp bx, dx
        jne fine
        ;corretto->setto il flag per la lettura
        mov al, 1
        mov flag, al        
            
     fine:
     
            IRET    
ISR_COUNT0  ENDP   


; ISR executed when count2 ends                                 
ISR_COUNT12 PROC 
    mov al, flag
    cmp al, 1
    jne errato
    
    
    
    errato:
        mov ax, 0ffffh
        mov dx, 0ffffh
                 
            
            IRET    
ISR_COUNT12 ENDP                  
                 
INIT_8255   PROC
            ; init 8255    
            mov al, 10010000b;
            out 083h, al
            ; set PC4 to enable interrupt on PA in
            ;mov al, 00001001b    
            ;out 083h, al   
            ; set PC2 to enable interrupt on PB in or PB out
            ;mov al, 00000101b 
            ;out 083h, al   
            ; set PC6 to enable interrupt on PA out
            ;mov al, 00001101b 
            ;out 083h, al  
            RET            
INIT_8255   ENDP          

INIT_8253   PROC
            ;init 8253
             ;counter0 init
            mov al, 00110100b
            out 063h, al 
             ;counter1 init
            mov al, 01010100b
            out 063h, al  
             ;counter2 init    
            mov al, 10010100b
            out 063h, al 
             ;counter0 value                       
            mov ax,  25500
            out 060h, al
            xchg al, ah;mov al,  0000100b
            out 060h, al                             
             ;counter1 value
            mov al, 100
            out 061h, al          
             ;counter2 value 
            mov al, 15
            out 062h, al
            RET
INIT_8253   ENDP    
          
            .startup    
            CLI         
            call INIT_IVT
            call INIT_8255 
            call INIT_8253
            STI
            ;azzero il flag
            mov al, 0
            mov flag, al
            
            mov di, 0 ;conta i pacchetti
            mov dx, 0 ;00000000000000000        
                                               
lab:        jmp lab                 
            
            .exit

            end  ; set entry point and stop the assembler.
