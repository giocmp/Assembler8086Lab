;#start=8259.exe#
.model small          
.data     
.stack     
.code   
;programma principale
.startup  
   mov ax, 0ffffh 
   mov bx, 0ffffh
   mov cx, 0ffffh
   mov dx, 0ffffh 
   ;mov cs, 2
   ;mov ip, 0ffffh
   ;mov ss, 0ffffh
   mov sp, 0ffffh
   mov bp, 0ffffh
   mov si, 0ffffh
   mov di, 0ffffh
   ;mov ds, 0ffffh
   ;mov es, 0ffffh
   ;i registri commentati 
   ;non sono general porpuse
   
   
.exit
end