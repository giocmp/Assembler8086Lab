;#start=8259.exe#

len EQU 25  

.model small           
.data  

matr db len dup (1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5) 

sommariga2 dw 0 
sommacolonna3 dw 0 
   
.stack     
.code
.startup


mov bx, 0
mov di, 5
mov cx, 5 
sr2:
    mov al, matr[di] ; sposto su al il contenuto della cella
    add ah, 0 ; metto zero in ah per avere ax da 16 bit suppondo i dati senza segno
    add bx, ax
    inc di
    loop sr2
mov sommariga2, bx

mov bx, 0
mov di, 2
mov cx, 5  
sc3:
    mov al, matr[di] 
    add ah, 0 ; metto zero in ah per avere ax da 16 bit suppondo i dati senza segno
    add bx, ax
    add di, 5
    loop sc3
mov sommacolonna3, bx
   
   
   
.exit
end