;#start=8259.exe#    
     
    len EQU 5 
    .model small          
    .data
    
    fifo db len dup(0) 
            
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
    pop ax
    inc ax
    push ax
    in al, 080h
    
    cmp al, 'I'
    je iIstr
    cmp al, 'O'
    je oIstr
    cmp al, 'Z'
    je zIstr
    
    cmp si, 1
    je acquisisciDato
    ;cmp si, 2
    ;je estraiDato
    ;cmp si, 3
    ;je azzeraFifo 
                    
    
    iIstr:
        mov si, 1
        jmp fine
        
    oIstr:
        cmp di, 0
        je fifoVuota
        mov al, fifo[0]
        out 081h, al
        mov bx, di
        dec bx
        mov cx,bx; cx=di-1 cioe' gli elementi rimanenti da spostare 
        mov bx, 0
        scalaPosto:
            mov al, fifo[bx]
            mov fifo[bx-1], al
            loop scalaPosto
        dec di
        jmp fine 
        
        fifoVuota:
            jmp fine
        
    zIstr: 
        mov di, 0
        jmp fine 
    
    acquisisciDato:
        cmp di, len
        je fifoPiena
        mov fifo[di], al
        inc di
        mov si, 0
        jmp fine
        
        fifoPiena:
            mov al, 0ffh
            out 081h, al
            mov si, 0
            jmp fine
    
    
            
    fine:     
           
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
    
    pop ax 
    out 081h, ax
    push ax
             
               
              
            
            IRET    
ISR_COUNT0  ENDP   


; ISR executed when count2 ends                                 
ISR_COUNT12 PROC 
                 
            
            IRET    
ISR_COUNT12 ENDP                  
                 
INIT_8255   PROC
            ; init 8255    
            mov al, 10111000b;
            out 083h, al
            ; set PC4 to enable interrupt on PA in
            mov al, 00001001b    
            out 083h, al   
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
            ;mov al, 01010100b
            ;out 063h, al  
             ;counter2 init    
            ;mov al, 10010000b
            ;out 063h, al 
             ;counter0 value                       
            mov ax,  1000
            out 060h, al
            xchg al, ah ;mov al,  0000100b
            out 060h, al                             
             ;counter1 value
            ;mov al, 00000100b
            ;out 061h, al          
             ;counter2 value 
            ;mov al, 00000010b
            ;out 062h, al
            RET
INIT_8253   ENDP    
          
            .startup    
            CLI         
            call INIT_IVT
            call INIT_8255 
            call INIT_8253
            STI
            
            mov di, 0
            mov si, 0 
            mov ax, 0
            push ax

                                               
lab:        jmp lab                 
            
            .exit

            end  ; set entry point and stop the assembler.
