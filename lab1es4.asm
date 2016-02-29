;#start=8259.exe#

;DA RIFARE CON CALMA  

len EQU 8

.model small           
.data  

vett dd len (1, 2, -3, 4, -5, 6, -7, 8) 
varp dd 0
varn dd 0
   
.stack     
.code
.startup 

 
mov si, 0
mov sp, 0
mov bp, 0
mov cx, len 

sommep:
    mov ax, 0 ;ax vale zero
    mov bx, len[si+2]
    cmp ax, bx
    jge numNegOrZero
    ;istruzioni eseguite se ax< bx 
    ;bx>0
    mov ax, len[si]; parte meno significativa del numero
    mov bx, len[si+2]; parte piu significativa del numero
    add bp, bx; bit meno significativi
    adc sp, ax; bit più significativi
    jmp fine
    numNegOrzero:
    ja numNeg
    ;istruzioni eseguite se bx=0 
    ;bx=0
    mov ax, len[si]; parte meno significativa del numero
    mov bx, len[si+2]; parte piu significativa del numero
    add bp, bx; bit meno significativi
    adc sp, ax; bit più significativi
    jmp fine
    numNeg:    
    fine:
    add si, 4
    loop sommep
     
mov bp, varp[0]
mov sp, varp[2]
   
.exit
end