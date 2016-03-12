IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
;ex 1:												
CharArray db 26 dup (?)
;ex 2:												
NumArray1 db 10 dup (?)
;ex 3:												
NumArray2 db 10 dup (?)
;ex 4:														
OffsetArray db 100h dup (?)
;ex 5:												
BufferFrom1 db 1 dup (1,2,3,4,5,6,7,8)
BufferTo1 db 8 dup (?)
;ex 6:												
bufferFrom2 db 5 dup (7,12,3,78,5,0,7,8,9,10)
bufferTo2 db 50 dup (?)
;ex 7:												
MyLine1 db 1 dup (6,8,3,45,0Dh)
LineLength db ?
;ex 8:												
MyLine2 db 1 dup (6,8,0,3,45,1,1,0,0Dh)
CountSmall db ?
;ex 9:												
MySet dw 1 dup (-190,0,7,5,-4,33,0,0ffffh)
Count1 db (?)
Count2 db (?)
Count3 db (?)
;ex 10:												
VarAL db (?)
;ex 11:												
EndGates db (4)
StringFalse db 'both 7 and 8 are false$'
StringTrue db 'at least one of the bits 7,8 is true$'
;ex 13:
StringNum db '753$'
VarNum dw (?)

CODESEG
; -------------------------------------------------------------------------------------------------------------------------------------
;ex 1:moves the ABC as ascii chars
;output:data segment
;registers:ax,bx,cx
proc EX1
	mov ax, 41h
	xor bx, bx
	mov cx, 26
CharLoop:
	mov [CharArray+bx], al
	inc ax
	inc bx
	loop CharLoop
	ret
endp EX1
; ------------------------------------------------------------------------------------------------------------------------------------
;ex 2:writes all the numbers from 0 to 9 as ascii chars
;output:data segment
;registers:ax,bx,cx
proc EX2
	mov ax, 30h
	xor bx, bx
	mov cx, 10
NumLoop:
	mov [NumArray1+bx], al
	inc ax
	inc bx
	loop NumLoop
	ret
endp EX2
; --------------------------------------------------------------------------------------------------------------------------------------
;ex 3:writes all the numbers from 0 to 9 as hexadecimal numbers
;output:data segment
;registers:ax,bx,cx
proc EX3
	mov ax, 0
	xor bx, bx
	mov cx, 10
NumLoop2:
	mov [NumArray2+bx], al
	inc ax
	inc bx
	loop NumLoop2
	ret
endp EX3
; ------------------------------------------------------------------------------------------------------------------------------------
;ex 4:moves 0FFh
;output: offset:0h-100h which divides in 10 or 2
;registers:ax,bx,cx,dx,si
proc EX4
	xor ax, ax
	xor cx, cx
	xor dx, dx
	xor dx, dx
	xor si, si
	mov cx, 100h
LoopNum:
	mov dl, 10
	mov ax, si
	div dl
	cmp ah, 0
	je MovNum
	mov ax, si
	mov dl, 2
	div dl
	cmp ah, 0
	jne MovNum
	inc si
	jmp LoopNum
MovNum:
	mov [OffsetArray+si], 0FFh
	inc si
	loop LoopNum
	ret
endp EX4
; --------------------------------------------------------------------------------------------------------------------------------
;ex 5: moves all the array
;input: BufferFrom1
;output: BufferTo1
;registers:ax,bx,cx
proc EX5
	xor ax, ax
	xor bx, bx
	xor cx, cx
	mov cx, 8
Loop1:
	mov al, [BufferFrom1+bx]
	mov [BufferTo1+bx], al
	inc bl 
	loop Loop1
	ret
endp EX5
; --------------------------------------------------------------------------------------------------------------------------------
;ex 6:moves values grateer then 7
;input: BufferFrom2
;output: BufferTo2
;registers:ax,bx,cx,si
proc EX6
	xor ax, ax
	xor bx, bx
	xor si, si
	mov cx, 50
CheckLoop:
	mov al, [BufferFrom2+bx]
	cmp al, 7
	jb DontMoveNum
	mov [BufferTo2+si], al
	inc si
DontMoveNum:
	inc bx
	loop CheckLoop
	ret
endp EX6
; --------------------------------------------------------------------------------------------------------------------------------
;ex 7: calculat the length of the array
;input: MyLine1
;output: LineLength
;registers:ax,bx,cx
proc EX7
	xor ax, ax 
	xor cx, cx
	xor bx, bx
	mov cx, 1
LoopLength1:
	mov al, [MyLine1+bx]
	inc bx
	inc [LineLength]
	cmp al, 0Dh
	jne LoopLength1
	loop LoopLength1
	ret
endp EX7
; --------------------------------------------------------------------------------------------------------------------------------
;ex 8:calculat the number of numbers under 2 
;input: MyLine2
;output: CountSmall
;registers:ax,bx,cx,si
proc EX8
	xor ax, ax 
	xor cx, cx
	xor bx, bx
	xor si, si
	mov cx, 1
LoopLength2:
	mov al, [MyLine2+si]
	inc si
	cmp al, 2
	ja ResumeLoop
	inc [CountSmall]
ResumeLoop:
	cmp al, 0Dh
	jne LoopLength2
	loop LoopLength2
	ret
endp EX8
; --------------------------------------------------------------------------------------------------------------------------------
;ex 9:calculat the number of negative ,positive and zeros
;input: MySet
;output: Count1, Count2, Count3
;registers:ax,cx,si
proc EX9
	xor ax, ax 
	xor cx, cx
	xor si, si
	mov cx, 1
Loop2:
	mov ax, [MySet+si]
	cmp ax, 0
	jle JumpBig
	inc [Count1] 
JumpBig:
	jge JumpSmall
	inc [Count2]
JumpSmall:
	jne JumpEqual
	inc [Count3]
JumpEqual:
	add si, 2
	cmp ax, 0ffffh
	jne Loop2
	loop Loop2
	ret
endp EX9
; --------------------------------------------------------------------------------------------------------------------------------
;ex 10: prints AL in binar digits
;registers:ax,cx,dx
proc EX10
	xor ax, ax 
	xor cx, cx
	xor dx, dx
	mov al, 7
	mov VarAL
	mov cx, 8
Loop3:
	shl [VarAL], 1
	jb Jump
	mov dl, '0'
	mov ah, 2h
	int 21h
	jmp EndCheck
Jump:
	mov dl, '1'
	mov ah, 2h
	int 21h
EndCheck:
	loop Loop3
	
	mov dl, 'B'
	mov ah, 2h
	int 21h
	ret
endp EX10
; --------------------------------------------------------------------------------------------------------------------------------
;ex 11: checks if the two lowest bits are true
;input: EndGates
;output: true, fales
;registers:ax,cx,dx
proc EX11
	xor ax, ax 
	xor cx, cx
	xor dx, dx
	mov cx, 2
Loop4:
	shr [EndGates], 1
	ja NoZero
	mov dx, offset StringTrue
	mov ah, 9h
	int 21h
	jmp Done1
NoZero:
	loop Loop4
	
	mov dx, offset StringFalse
	mov ah, 9h
	int 21h
Done1:
	ret
endp EX11
; --------------------------------------------------------------------------------------------------------------------------------
;ex 12: checks if the value is 10-70
;input: offset:0A000h
;output: offset:0B000h
;registers:ax
proc EX12
	xor ax, ax 
	mov al, [ds:0a000h]
	cmp al, 10
	jb Done2
	cmp al, 70
	jae Done2
	mov [ds:0b000h], al
Done2:
	ret
endp EX12
; --------------------------------------------------------------------------------------------------------------------------------
;ex 13: moves the decimal value of the string to the variable
;input: StringNum
;output: VarNum
;registers:ax,dx,si
proc EX13
	xor ax, ax
	xor dx, dx
	xor si, si
	mov al, [StringNum]
	sub al, 30h
	mov dl, 64h
	mul dl
	mov si , ax
	mov al, [StringNum+1]
	sub al, 30h
	mov dl, 0ah
	mul dl
	add si, ax
	mov al, [StringNum+2]
	sub al, 30h
	add si, ax	
	mov [VarNum], si
	ret
endp EX13
; --------------------------------------------------------------------------------------------------------------------------------
;ex 14a: prints the value of the four lowest bits 
;input: AL
;registers:ax,bx,dx
proc EX14a
	xor dx, dx
	xor bx, bx
	mov bl, 0fh
	and al, bl
	cmp al, 9h
	ja AandUp1
	add al, 30h
	mov dl, al
	mov ah, 2h
	int 21h
	jmp Done3
AandUp1:
	add al, 55
	mov dl, al
	mov ah, 2h
	int 21h
Done3:
	ret
endp EX14a
; --------------------------------------------------------------------------------------------------------------------------------
;ex 14b: prints the value of AL
;input: AL
;registers:ax,bx,dx
proc EX14b
	xor ax, ax
	xor dx, dx
	xor bx, bx
	mov al, 04dh
	push ax
	mov bl, 0f0h
	and al, bl
	mov dl, 0fh
	div dl
	cmp al, 9h
	ja AandUp2
	add al, 30h
	mov dl, al
	mov ah, 2h
	int 21h
	jmp Continue
AandUp2:
	add al, 55
	mov dl, al
	mov ah, 2h
	int 21h
	
Continue:
	pop ax
	mov bl, 0fh
	and al, bl
	cmp al, 9h
	ja AandUp3
	add al, 30h
	mov dl, al
	mov ah, 2h
	int 21h
	jmp Done4
AandUp3:
	add al, 55
	mov dl, al
	mov ah, 2h
	int 21h
Done4:	
    ret
ENDp EX14b	
;------------------------------------------------------------------------------------------------------------------------------------
;ex 14c:prints the value of AX
;input: AX
;registers:ax,bx,cx,dx,si 
proc EX14c
	xor dx, dx
	xor bx, bx
	xor cx, cx
	xor si, si
	mov ax, 0c64dh
	push ax
	mov bx, 0f000h
	and ax, bx
	mov si, 0fffh
	div si
	cmp ax, 9h
	ja AandUp4
	add al, 30h
	mov dl, al
	mov ah, 2h
	int 21h
	jmp Continue1
AandUp4:
	add al, 55
	mov dl, al
	mov ah, 2h
	int 21h
	
Continue1:
	pop ax
	push ax
	xor dx, dx
	mov bx, 0f00h
	and ax, bx
	mov si, 0ffh
	div si 
	cmp ax, 9h
	ja AandUp5
	add al, 30h
	mov dl, al
	mov ah, 2h
	int 21h
	jmp Continue2
AandUp5:
	add al, 55
	mov dl, al
	mov ah, 2h
	int 21h
	
Continue2:
	pop ax
	push ax
	mov bx, 00f0h
	and ax, bx
	mov cl, 0fh
	div cl
	cmp al, 9h
	ja AandUp6
	add al, 30h
	mov dl, al
	mov ah, 2h
	int 21h
	jmp Continue3
AandUp6:
	add al, 55
	mov dl, al
	mov ah, 2h
	int 21h
	
Continue3:
	pop ax
	push ax
	mov bx, 000fh
	and ax, bx
	cmp al, 9h
	ja AandUp7
	add al, 30h
	mov dl, al
	mov ah, 2h
	int 21h
	jmp Done5
AandUp7:
	add al, 55
	mov dl, al
	mov ah, 2h
	int 21h
Done5:
	ret
endp EX14c
; -------------------------------------------------------------------------

start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------
exit:
	mov ax, 4c00h
	int 21h
END start


