IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
arrlength equ 5
array db arrlength dup (3,6,5,2,1)
indxmin dw (0)

CODESEG 
proc FindMin
	push bp
	mov bp,sp
	sub sp, 2
	push ax
	push cx
	push bx
	push dx
	push si
	min equ [bp-2]
	mov dx, 0ffh
	mov min, dx
	xor ax, ax
	xor cx, cx
	xor bx, bx
	xor si, si
	mov bx, firstIndx
	mov cx, numElements
loopmin:
	xor ax, ax
	mov al, [si+bx]
	cmp al, min
	ja jump
	mov [indxmin], si
	mov min, al
jump:
	inc si
	loop loopmin
	pop si
	pop dx
	pop bx
	pop cx
	pop ax
	add sp, 2
	pop bp
	ret 4
endp FindMin

proc swap
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push si
	mov bx, firstIndx
	mov si, [indxmin]
	mov	al, [bx+si]
	xor si, si
	mov cl, [bx+si]
	mov si, [indxmin]
	mov [bx+si], cl
	xor si, si
	mov [bx+si], al
	pop si
	pop cx
	pop bx
	pop ax 
	pop bp
	ret 4
endp swap

proc SortArray
	push bx
	xor bx, bx
	mov bx, offset array
	mov dx, arrlength
	mov cx, arrlength
loopSort:
	push dx
	push bx
	numElements equ [bp+6]
	firstIndx equ [bp+4]
	call findmin
	push dx
	push bx
	firstIndx equ [bp+4]
	call swap
	inc bx
	dec dx
	loop loopSort
	pop bx
	ret
endp SortArray
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------
	;call findmin
	
	;call swap
	call SortArray
exit:
	mov ax, 4c00h
	int 21h
END start


