;----------- TEMPLATE.ASM -----------;
; ASSEMBLY LANGUAGE PROGRAM STRUCTURE;
;------------------------------------;

.MODEL SMALL
.STACK 64

.DATA
;--BEGINNING OF DATA DECLARATION--;
M1 db "Number 1: $"
M2 db 0dh,0ah,"Number 2: $"
M3 db 0dh,0ah,"Result of subtraction: $"
op1 dd 987654321                                           
op2 dd 123456789
ans dd ?
dot DB '.' 
cnt db 0 
;-----END OF DATA DECLARATION------;
.CODE
MAIN PROC
        MOV AX,@DATA
        MOV DS,AX
        ;----------CODES----------; 
        display1:
        MOV AH, 09H
	LEA DX, M1        ;display string
	INT 21H
        mov      ax, word ptr op1          ; lsb of number1 in ax  
        mov      dx, word ptr op1+2        ; msb of number1 in bx
        mov     bx,10          ;CONST
    push    bx             ;Sentinel
.a: mov     cx,ax          ;Temporarily store LowDividend in CX
    mov     ax,dx          ;First divide the HighDividend
    xor     dx,dx          ;Setup for division DX:AX / BX
    div     bx             ; -> AX is HighQuotient, Remainder is re-used
    xchg    ax,cx          ;Temporarily move it to CX restoring LowDividend
    div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]
    push    dx             ;(1) Save remainder for now
    inc cnt
    mov     dx,cx          ;Build true 32-bit quotient in DX:AX
    or      cx,ax          ;Is the true 32-bit quotient zero?
    jnz     .a             ;No, use as next dividend
    pop     dx             ;(1a) First pop (Is digit for sure)

.b: add     dl,"0"         ;Turn into character [0,9] -> ["0","9"]
    dec cnt
    mov     ah,02h         ;DOS.DisplayCharacter
    int     21h            ; -> AL
    cmp cnt,2
    je displaydot
    jne .b2
.b2:
    pop     dx             ;(1b) All remaining pops
    cmp     dx,bx          ;Was it the sentinel?
    jb      .b             ;Not yet
    mov cnt,0
    jmp display2
displaydot:
    mov     ah,02h         ;DOS.DisplayCharacter
    MOV DL, dot
    int     21h            ; -> AL
    mov cnt,100
    JMP .b2
        display2:
        MOV AH, 09H
	LEA DX, M2        ;display string
	INT 21H
        mov      ax, word ptr op2          ; lsb of number1 in ax  
        mov      dx, word ptr op2+2        ; msb of number1 in bx
        mov si,0
           mov     bx,10          ;CONST
    push    bx             ;Sentinel
.c: mov     cx,ax          ;Temporarily store LowDividend in CX
    mov     ax,dx          ;First divide the HighDividend
    xor     dx,dx          ;Setup for division DX:AX / BX
    div     bx             ; -> AX is HighQuotient, Remainder is re-used
    xchg    ax,cx          ;Temporarily move it to CX restoring LowDividend
    div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]
    push    dx             ;(1) Save remainder for now
    inc cnt
    mov     dx,cx          ;Build true 32-bit quotient in DX:AX
    or      cx,ax          ;Is the true 32-bit quotient zero?
    jnz     .c             ;No, use as next dividend
    pop     dx             ;(1a) First pop (Is digit for sure)

.d: add     dl,"0"         ;Turn into character [0,9] -> ["0","9"]
    dec cnt
    mov     ah,02h         ;DOS.DisplayCharacter
    int     21h            ; -> AL
    cmp cnt,2
    je displaydot1
    jne .d2
.d2:
    pop     dx             ;(1b) All remaining pops
    cmp     dx,bx          ;Was it the sentinel?
    jb      .d             ;Not yet
    mov cnt,0
    jmp display3

    displaydot1:
    mov     ah,02h         ;DOS.DisplayCharacter
    MOV DL, dot
    int     21h            ; -> AL
    mov cnt,100
    JMP .d2

    display3:
        MOV AH, 09H
	LEA DX, M3        ;display string
	INT 21H
        mov      ax, word ptr op1          ; lsb of number1 in ax  
        mov      bx, word ptr op1+2        ; msb of number1 in bx   
        mov      cx, word ptr op2          ; lsb of number2 in cx  
        mov      dx, word ptr op2+2        ; msb of number1 in dx  
        sub      ax, cx                    ; sub subtract lsb - lsb, add for addition
        mov      word ptr ans, ax          ; lsb answer
        sbb      bx, dx                    ; sbb subtract msb - msb, adc for addition 
        mov      word ptr ans+2, bx        ; msb answer  
        mov      dx, word ptr ans+2        ; Result in reg dx  
        mov     bx,10          ;CONST
    push    bx             ;Sentinel
.e: mov     cx,ax          ;Temporarily store LowDividend in CX
    mov     ax,dx          ;First divide the HighDividend
    xor     dx,dx          ;Setup for division DX:AX / BX
    div     bx             ; -> AX is HighQuotient, Remainder is re-used
    xchg    ax,cx          ;Temporarily move it to CX restoring LowDividend
    div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]
    push    dx             ;(1) Save remainder for now
    inc cnt
    mov     dx,cx          ;Build true 32-bit quotient in DX:AX
    or      cx,ax          ;Is the true 32-bit quotient zero?
    jnz     .e             ;No, use as next dividend
    pop     dx             ;(1a) First pop (Is digit for sure)
.f: add     dl,30H         ;Turn into character [0,9] -> ["0","9"]
    dec cnt
    mov     ah,02h         ;DOS.DisplayCharacter
    int     21h            ; -> AL
    cmp cnt,2
    je displaydot2
    jne .f2
.f2:
    pop     dx             ;(1b) All remaining pops
    cmp     dx,bx          ;Was it the sentinel?
    jb      .f             ;Not yet
    mov cnt,0
    jmp ending

    displaydot2:
    mov     ah,02h         ;DOS.DisplayCharacter
    MOV DL, dot
    int     21h            ; -> AL
    mov cnt,100
    JMP .f2

    ending:

        ;-------END OF CODES-------;
        MOV AX,4C00H
        INT 21H
MAIN ENDP
        END MAIN
