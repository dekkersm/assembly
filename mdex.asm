IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
arrlength equ 5
arr2length equ 4
sortedlength equ 9
sorted db sortedlength dup (?)
array1 db arrlength dup (4,9,5,3,2)
array2 db arr2length dup (3,6,4,1)
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

proc merge
	push bx
	push ax
	push si
	xor bx, bx
	xor si, si
	mov cx, arrlength
merge1loop:
	mov al, [array1+bx]
	mov [sorted+si], al
	inc si
	inc bx
	loop merge1loop
	xor bx, bx
	mov cx, arr2length
merge2loop:
	mov al, [array2+bx]
	mov [sorted+si], al
	inc si
	inc bx
	loop merge2loop
	pop si
	pop ax
	pop bx
	ret
endp merge

proc SortArray
	push bx
	xor bx, bx
	mov bx, offset sorted
	mov dx, sortedlength
	mov cx, sortedlength
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

proc filter
	xor bx, bx
	mov si, 1
	mov cx, sortedlength
filterloop:
	mov al, [sorted+bx]
	mov dl, [sorted+si]
	cmp al, dl
	jne notequ
	push cx
	push bx
	push si
	push ax
	sub cx, 1
removeDup:
	mov al, [sorted+si]
	mov [sorted+bx], al
	inc bx
	inc si
	loop removeDup
	mov [sorted+bx], 0
	pop ax
	pop si
	pop bx
	pop cx
notequ:
	inc bx
	inc si
	loop filterloop
	ret
endp filter

proc Sort2Arrays
	;mov ax, arrlength
	;add ax, arr2length
	;mov sortedlength, ax
	call merge
	call SortArray
	call filter
	ret 
endp Sort2Arrays
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------
	call Sort2Arrays
exit:
	mov ax, 4c00h
	int 21h
END start


