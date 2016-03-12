IDEAL
MODEL small
STACK 100h
DATASEG	
; --------------------------
; Your variables here
; --------------------------
CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------
	mov cl, 3
	mov [cs:17], cl
	; mov [cs:20], 083h
	; mov [cs:21], 0C303h
	xor ax, ax
	xor bx, bx
	add ax, 2
	add ax, 2
	add bx, 3
exit:
	mov ax, 4c00h
	int 21h
END start


