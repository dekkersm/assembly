IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
indexMin db (0)
arrlength equ 5
array db arrlength dup (3,6,5,2,1)

CODESEG
proc FindMin
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	xor bx, bx
	mov bx, bparray
	mov cx, arrlength
loopmin:
	xor ax, ax
	mov al, [bx]
	cmp ax, [bx+indexMin]
	ja jump
	mov [indexMin], bx
jump:
	inc bx
	loop loopmin
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6
endp FindMin

; proc SortArray
	
	; ret 2
; endp SortArray
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------
	push arrlength
	push offset array
	bparray equ [bp+4]
	call FindMin
exit:
	mov ax, 4c00h
	int 21h
END start


