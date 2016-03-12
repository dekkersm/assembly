IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
;ex A:
	var1 db 0
	var2 db 1
	fibo db 10 dup (?)
;ex B:
	arr db 5 dup (?)
;ex c:
	var1 db ?
	var2 db ?
	sum db 0
;ex d:
	row db ?
	column db ?
CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------
;ex A:
	mov [fibo], 0
	mov dx, 1
	mov cx, 10
	mov si, 1
loopfibo:
	mov [var2], dl
	mov al, [var1]
	add al, [var2]
	mov [fibo+si], al
	mov dl, [var1]
	mov [var1], al
	inc si
	loop loopfibo
;ex B:
	mov si, 0
	mov cx, 5
loopchars:
	mov ah, 1h
	int 21h
	mov [arr+si], al
	inc si
	loop loopchars
;ex c:
	xor cx, cx
	mov cl, [var2]
	mov [sum], dl
mulvar1:
	mov dl, [sum]
	add dl, [var1]
	mov [sum], dl
	loop mulvar1
;ex d:
	xor ax, ax
	mov ah, 1h
	int 21h
	sub al, '0'
	mov [row], al
	xor ax, ax
	mov ah, 1h
	int 21h
	sub al, '0'
	mov [column], al
	mov bl, [row]
looprow:
	mov cl, [column]
loopcolumn:
	mov dl, 'x'
	mov ah, 2h
	int 21h
	loop loopcolumn
	mov dl, 0ah
	mov ah, 2h
	int 21h
	dec bl
	cmp bl, 0
	jne looprow
exit:
	mov ax, 4c00h
	int 21h
END start


