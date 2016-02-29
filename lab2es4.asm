; DA RIFARE CON CALMA

.model small           
.data  

var db 3 dup (3,-2,1)
   
.stack     
.code
.startup

mov di, 0
mov si, 0
mov cx, 3

cicloEst:
    mov al, var[di]; al=vett[i]
    mov bx, di
    inc bl
    mov si, bx
    push cx
    mov bx, cx
    mov bx, -1
    mov cx, bx
    cicloInt:
        mov ah, var[si]; ah=vett[i+1]
        cmp al, ah
        JAE LabelGreaterOrEqual
        ; istruzioni eseguite se Al < ah
        LabelGreaterOrEqual:
        JA LabelGreater
        ; istruzioni eseguite se Al = ah
        LabelGreater:
        ; istruzioni eseguite se Al>ah
        xchg al, ah
        mov var[di], al
        mov var[si], ah
        inc si
        loop cicloInt
     pop cx
     inc di
     loop cicloEst   

  
.exit
end