;#start=8259.exe# 

.model small           
.data  

varw dw 0FFFFh
vard dd 000112233h 
   
.stack     
.code
.startup
    
    mov bx, vard[0]
    mov dx, varw
    mov vard[0], dx
    mov varw, bx
               
    mov ax, vard[0]
    mov bx, vard[2]
    mov cx, varw 
    mov dx, 0
    add ax, cx
    adc bx, dx
    mov vard[0], ax
    mov vard[2], bx
   
   
   
   
.exit
end