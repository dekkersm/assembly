IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
; Sum db 0
; ArrayLength dw 5
; Array db 2, 2, 3, 4, 5
MinAdress dw ?
ArrayLength dw 5
Array dw 3,6,5,2,1

CODESEG

proc Findmin
	ALength equ [bp-4]
	StartPoint equ [bp-2]
	Min equ ah
	xor ax, ax
	mov bx, StartPoint
	mov al, [bx]
	mov Min, al
	mov [MinAdress], bx
	mov cx, Alength
	cmp cx, 1
	je LastTime
	dec cx
LoopFindMin:
	add bx, 2
	mov al, [bx]
	cmp al, ah
	jb NewMin
	loop LoopFindMin
LastTime:
	ret
NewMin:
	mov ah, al
	mov [MinAdress], bx
	loop LoopFindMin
	ret
endp Findmin

proc Swap
	LargeNumberAdress equ [bp-2]
	mov di, LargeNumberAdress	;di holds the adress of the large number
	mov cx, [di]				;cx holds the large number
	mov bx, [MinAdress]			;bx holds the adress of small number
	mov bx, [bx]				;bx holds the small number
	mov [di], bx				;transfer of the small number
	mov bx, [MinAdress]			;bx holds the adress of the small number
	mov [bx], cx				;transfer of the large number
	ret
endp Swap

proc SortArray
	push bp
	mov bp, sp
	xor ax, ax
	xor si, si
	mov cx, [ArrayLength]
LoopSortArray:
	mov ax, offset Array
	add ax, si
	push ax
	mov ax, cx
	push ax
	push cx
	call Findmin
	call Swap
	add si, 2
	pop cx
	add sp, 4
	loop LoopSortArray
	pop bp
	ret
endp SortArray

; proc ArraySum
	; Alength equ [bp+6]
	; Aoffset equ [bp+4]
	; xor ax, ax
	; push bp
	; mov bp, sp
	; mov bx, Aoffset
	; mov cx, Alength
; LoopArraySum:
	; add al, [bx]
	; inc bx
	; loop LoopArraySum
	; mov [Sum], al
	; pop bp
	; ret
	; endp ArraySum
	
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------
	; push [ArrayLength]
	; push offset Array
	; call ArraySum
	call SortArray
	
	
exit:
	mov ax, 4c00h
	int 21h
END start


