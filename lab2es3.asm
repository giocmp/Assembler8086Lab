.model small           
.data  

vett1 dw 2 dup(5, 6)
vett2 dw 2 dup(7, 8)
risultato dd 0
   
.stack     
.code
.startup
;(VETT1(0)/(VETT2(1)-1))^2-((-VETT1(1))/(VETT2(0)+1))^2
;prima parte
;(VETT1(0)/(VETT2(1)-1))^2 
mov bx, vett2[2] ; VETT2(1)
dec bx ;VETT2(1)-1)
mov ax, vett1[0] ;VETT1(0)
;div bx => ax/bx il primo operando si prende su ax
;il divisore deve essere più piccolo, se ax e' 16 bit il 
;divisore deve essere di 8. dato che ax e bx sono di 16
;porteremo ax su 32 spalmandolo su dx
mov dx, 0
div bx; ax->quoziente , dx->resto
;per fare il quadrato si usa sempre ax dato che il
;il risultato sara su 32 bit essendo ax di 16 verra'
;spalmato su dx, dumque per non perdere il valore
;del resto della divisione salviamo il resto
;o in memoria o in stack
push dx
mul ax ; dx:ax=ax*ax
;in questo esercizio non consideriamo il resto
push dx  ;parte più significativa
push ax  ;parte meno significativa, la prima che verra' estratta

;seconda parte
;((-VETT1(1))/(VETT2(0)+1))^2 
mov ax, vett1[2] ; VETT1(1)
;neg ax-> ERRATO perche ax è senza segno
;bisogna prima estentere a 32 bit
mov dx, 0
not ax    ;nego ax
not dx    ;nego dx
add ax, 1 ;sommo 1 per fare il complemento a 2
add dx, 0 ;sommo 0 per estendere l'1 a 32 bit
; dx:ax=-vett(1)
mov bx, vett2[0] ;VETT2(0)
inc bx  ;VETT2(0)+1 
test bx, 08000h; in binario il primo bit e' 1. La test
;fa l'and bit a bit se il primo bit e' 0 allora la and
;da tutto zero e viene settato lo zero flag a 1
;verificabile con 
jnz errore ;lo zf non e' settato dunqe il disore e' negativo
;possiamo fare la divisione dato che e' con segno idiv
idiv bx ; ax<- quoziente dx<-resto
imul ax ;elevo al quadrato estendendo su dx

pop bx 
pop cx

;cx:bx-dx:ax
test cx, 08000h
jnz errore

sub bx, ax
sub cx, dx

mov word ptr risultato, bx
mov word ptr risultato+2, cx

errore:  nop

  
.exit
end