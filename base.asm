IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
var1 db 8h

CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------
mov ax, dx	
exit:
	mov ax, 4c00h
	int 21h
END start


