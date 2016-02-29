;#start=8259.exe#  

len EQU 20

.model small           
.data  

vett dw len dup(0)
   
.stack     
.code
.startup 

 
mov ax, 1
mov di, 38
mov si, 36
mov vett[di], ax
mov vett[si], ax
mov cx, len
add cx, -2 
riempimento:
    mov ax, vett[di]
    mov bx, vett[si]
    add ax, bx
    mov vett[si-2], ax
    add si, -2
    add di, -2
    loop riempimento  
.exit
end