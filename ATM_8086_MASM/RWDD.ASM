;----------- TEMPLATE.ASM -----------;
; ASSEMBLY LANGUAGE PROGRAM STRUCTURE;
;------------------------------------;

.MODEL SMALL
.STACK 64

.DATA
;--BEGINNING OF DATA DECLARATION--;
FILE DB "test.txt",0
FILE1 DB "testdd.txt",0
FILE2 DB "testbill.txt",0
NUM DB 40 dup ('*'),('$')
HAND DW ?
CNT3 DB 0
NO DD 0
ERR DB "An error has occured.$"
NO_BUFF DD 0
RES DD 0
BAL DD 0
DIRECT_DEPOSIT DD 0
BILL DD 0
INTEREST DD 0
NUM_BUFF DB 0
CNTF dw 0
dot DB '.'
CNTF2 dw 0
IDX DB 0
BAL_STR DB 40 DUP (" ")
;-----END OF DATA DECLARATION------;
.CODE
MAIN PROC
        MOV AX,@DATA
        MOV DS,AX
        ;----------CODES----------; 
        mov ax,3d02h
        lea dx,FILE
        int 21h
        mov HAND,ax
        mov si,0
        L1:
                mov ah,3fh
                mov bx,HAND
                mov cx,20
                mov dx,offset NUM
                int 21h
                cmp ax,0
                JE EXIT
                INC SI
                JMP L1
                EXIT:
                mov  ah, 3eh
                mov  bx, HAND
                int  21h
                XOR AX,AX
                MOV SI,0
                COUNT:
                        CMP NUM[SI],"*"
                        JE READNUM
                        INC SI
                        INC CNTF
                        JMP COUNT
                READNUM: 
                MOV BL,IDX
                MOV BH,0
                MOV NUM_BUFF,BH
                MOV AL,NUM[BX]
                MOV NUM_BUFF,AL
                JMP GET_VAL
                        GET_VAL:
                                MOV AL,NUM_BUFF
                                SUB AL,30H
                                MOV BYTE PTR NO_BUFF, AL
                                MOV CX,CNTF
                                MOV CNTF2,CX
                                        MULIPLY:
                                                MOV SI,0
                                                        TENTIMES:
                                                                MOV AX,WORD PTR NO_BUFF
                                                                MOV BX,WORD PTR NO_BUFF+2
                                                                MOV CX,WORD PTR NO
                                                                MOV DX,WORD PTR NO+2
                                                                Add      ax, cx                    ; sub subtract lsb - lsb, add for addition  
                                                                Mov      word ptr NO, ax          ; lsb answer
                                                                Adc      bx, dx                    ; sbb subtract msb - msb, adc for addition    
                                                                Mov      word ptr NO+2, bx        ; msb answer
                                                                INC si
                                                                CMP SI,10
                                                                JNE TENTIMES
                                                Mov      ax,word ptr NO          ; lsb answer
                                                Mov      bx,word ptr NO+2        ; msb answer
                                                MOV WORD PTR NO_BUFF,AX
                                                MOV WORD PTR NO_BUFF+2,BX
                                                MOV WORD PTR NO,0
                                                MOV WORD PTR NO+2,0
                                                DEC CNTF2
                                                CMP CNTF2,1
                                                JA MULIPLY
                                MOV WORD PTR NO_BUFF,0
                                MOV WORD PTR NO_BUFF+2,0
                                Add      WORD PTR RES,AX                   ; sub subtract lsb - lsb, add for addition  
                                Adc      WORD PTR RES+2,BX                    ; sbb subtract msb - msb, adc for addition    
                        JMP PRE_READNUM
                B4_READNUM:
                JMP READNUM
                PRE_READNUM:
                INC IDX
                DEC CNTF
                CMP CNTF,1
                JA B4_READNUM   
                MOV BL,IDX
                MOV BH,0
                MOV NUM_BUFF,BH
                MOV AL,NUM[BX]
                MOV NUM_BUFF,AL
                MOV AL,NUM_BUFF
                SUB AL,30H
                MOV BYTE PTR NO_BUFF, AL
                MOV AX,WORD PTR NO_BUFF
                MOV BX,WORD PTR NO_BUFF+2
                Add      ax, WORD PTR RES                    ; sub subtract lsb - lsb, add for addition  
                Mov      word ptr RES, ax          ; lsb answer
                Adc      bx, WORD PTR RES+2                    ; sbb subtract msb - msb, adc for addition    
                Mov      word ptr RES+2, bx        ; msb answer
                MOV AX,WORD PTR RES
                MOV BX,WORD PTR RES+2
                Mov      word ptr BAL, ax          ; lsb answer
                Mov      word ptr BAL+2, bx        ; msb answer
                mov ah,3eh
                mov bx,HAND
                int 21h 
        XOR AX,AX
        MOV WORD PTR NO_BUFF,AX
        MOV WORD PTR NO_BUFF+2,AX
        MOV WORD PTR NO,AX
        MOV WORD PTR NO+2,AX
        MOV WORD PTR RES,AX
        MOV WORD PTR RES+2,AX
        MOV NUM_BUFF,AL
        MOV IDX,AL
        MOV SI,0
        MOV CNTF,0
        MOV CNTF2,0
        COUNT1:
                        CMP NUM[SI],"*"
                        JE DECCNT
                        INC SI
                        INC CNTF
                        JMP COUNT1
                DECCNT:
                DEC CNTF
                DEC CNTF
                READNUM1: 
                MOV BL,IDX
                MOV BH,0
                MOV NUM_BUFF,BH
                MOV AL,NUM[BX]
                MOV NUM_BUFF,AL
                JMP GET_VAL1
                        GET_VAL1:
                                MOV AL,NUM_BUFF
                                SUB AL,30H
                                MOV BYTE PTR NO_BUFF, AL
                                MOV CX,CNTF
                                MOV CNTF2,CX
                                        MULIPLY1:
                                                MOV SI,0
                                                        TENTIMES1:
                                                                MOV AX,WORD PTR NO_BUFF
                                                                MOV BX,WORD PTR NO_BUFF+2
                                                                MOV CX,WORD PTR NO
                                                                MOV DX,WORD PTR NO+2
                                                                Add      ax, cx                    ; sub subtract lsb - lsb, add for addition  
                                                                Mov      word ptr NO, ax          ; lsb answer
                                                                Adc      bx, dx                    ; sbb subtract msb - msb, adc for addition    
                                                                Mov      word ptr NO+2, bx        ; msb answer
                                                                INC si
                                                                CMP SI,10
                                                                JNE TENTIMES1
                                                Mov      ax,word ptr NO          ; lsb answer
                                                Mov      bx,word ptr NO+2        ; msb answer
                                                MOV WORD PTR NO_BUFF,AX
                                                MOV WORD PTR NO_BUFF+2,BX
                                                MOV WORD PTR NO,0
                                                MOV WORD PTR NO+2,0
                                                DEC CNTF2
                                                CMP CNTF2,1
                                                JA MULIPLY1
                                MOV WORD PTR NO_BUFF,0
                                MOV WORD PTR NO_BUFF+2,0
                                Add      WORD PTR RES,AX                   ; sub subtract lsb - lsb, add for addition  
                                Adc      WORD PTR RES+2,BX                    ; sbb subtract msb - msb, adc for addition    
                        JMP PRE_READNUM1
                B4_READNUM1:
                JMP READNUM1
                PRE_READNUM1:
                INC IDX
                DEC CNTF
                CMP CNTF,1
                JA B4_READNUM1   
                MOV BL,IDX
                MOV BH,0
                MOV NUM_BUFF,BH
                MOV AL,NUM[BX]
                MOV NUM_BUFF,AL
                MOV AL,NUM_BUFF
                SUB AL,30H
                MOV BYTE PTR NO_BUFF, AL
                MOV AX,WORD PTR NO_BUFF
                MOV BX,WORD PTR NO_BUFF+2
                Add      ax, WORD PTR RES                    ; sub subtract lsb - lsb, add for addition  
                Mov      word ptr RES, ax          ; lsb answer
                Adc      bx, WORD PTR RES+2                    ; sbb subtract msb - msb, adc for addition    
                Mov      word ptr RES+2, bx        ; msb answer
                MOV AX,WORD PTR RES
                MOV BX,WORD PTR RES+2
                Mov      word ptr INTEREST, ax          ; lsb answer
                Mov      word ptr INTEREST+2, bx        ; msb answer
                mov ah,3eh
                mov bx,HAND
                int 21h
        XOR AX,AX
        MOV WORD PTR NO_BUFF,AX
        MOV WORD PTR NO_BUFF+2,AX
        MOV WORD PTR NO,AX
        MOV WORD PTR NO+2,AX
        MOV WORD PTR RES,AX
        MOV WORD PTR RES+2,AX
        MOV NUM_BUFF,AL
        MOV IDX,AL
        MOV SI,0
        MOV CNTF,0
        MOV CNTF2,0
        MOV SI,0
        MOV CX,40
        CLEAR1:
                MOV AL,'*'
                MOV NUM[SI],AL
                INC SI
                LOOP CLEAR1
        mov ax,3d02h
        lea dx,FILE1
        int 21h
        mov HAND,ax
        mov si,0
        L2:
                mov ah,3fh
                mov bx,HAND
                mov cx,20
                mov dx,offset NUM
                int 21h
                cmp ax,0
                JE EXIT1
                INC SI
                JMP L2
                EXIT1:
                mov  ah, 3eh
                mov  bx, HAND
                int  21h
                XOR AX,AX
                MOV SI,0
        COUNT2:
                        CMP NUM[SI],"*"
                        JE READNUM2
                        INC SI
                        INC CNTF
                        JMP COUNT2
                READNUM2: 
                MOV BL,IDX
                MOV BH,0
                MOV NUM_BUFF,BH
                MOV AL,NUM[BX]
                MOV NUM_BUFF,AL
                JMP GET_VAL2
                        GET_VAL2:
                                MOV AL,NUM_BUFF
                                SUB AL,30H
                                MOV BYTE PTR NO_BUFF, AL
                                MOV CX,CNTF
                                MOV CNTF2,CX
                                        MULIPLY2:
                                                MOV SI,0
                                                        TENTIMES2:
                                                                MOV AX,WORD PTR NO_BUFF
                                                                MOV BX,WORD PTR NO_BUFF+2
                                                                MOV CX,WORD PTR NO
                                                                MOV DX,WORD PTR NO+2
                                                                Add      ax, cx                    ; sub subtract lsb - lsb, add for addition  
                                                                Mov      word ptr NO, ax          ; lsb answer
                                                                Adc      bx, dx                    ; sbb subtract msb - msb, adc for addition    
                                                                Mov      word ptr NO+2, bx        ; msb answer
                                                                INC si
                                                                CMP SI,10
                                                                JNE TENTIMES2
                                                Mov      ax,word ptr NO          ; lsb answer
                                                Mov      bx,word ptr NO+2        ; msb answer
                                                MOV WORD PTR NO_BUFF,AX
                                                MOV WORD PTR NO_BUFF+2,BX
                                                MOV WORD PTR NO,0
                                                MOV WORD PTR NO+2,0
                                                DEC CNTF2
                                                CMP CNTF2,1
                                                JA MULIPLY2
                                MOV WORD PTR NO_BUFF,0
                                MOV WORD PTR NO_BUFF+2,0
                                Add      WORD PTR RES,AX                   ; sub subtract lsb - lsb, add for addition  
                                Adc      WORD PTR RES+2,BX                    ; sbb subtract msb - msb, adc for addition    
                        JMP PRE_READNUM2
                B4_READNUM2:
                JMP READNUM2
                PRE_READNUM2:
                INC IDX
                DEC CNTF
                CMP CNTF,1
                JA B4_READNUM2   
                MOV BL,IDX
                MOV BH,0
                MOV NUM_BUFF,BH
                MOV AL,NUM[BX]
                MOV NUM_BUFF,AL
                MOV AL,NUM_BUFF
                SUB AL,30H
                MOV BYTE PTR NO_BUFF, AL
                MOV AX,WORD PTR NO_BUFF
                MOV BX,WORD PTR NO_BUFF+2
                Add      ax, WORD PTR RES                    ; sub subtract lsb - lsb, add for addition  
                Mov      word ptr RES, ax          ; lsb answer
                Adc      bx, WORD PTR RES+2                    ; sbb subtract msb - msb, adc for addition    
                Mov      word ptr RES+2, bx        ; msb answer
                MOV AX,WORD PTR RES
                MOV BX,WORD PTR RES+2
                Mov      word ptr DIRECT_DEPOSIT, ax          ; lsb answer
                Mov      word ptr DIRECT_DEPOSIT+2, bx        ; msb answer 
                mov ah,3eh
                mov bx,HAND
                int 21h 
        XOR AX,AX
        MOV WORD PTR NO_BUFF,AX
        MOV WORD PTR NO_BUFF+2,AX
        MOV WORD PTR NO,AX
        MOV WORD PTR NO+2,AX
        MOV WORD PTR RES,AX
        MOV WORD PTR RES+2,AX
        MOV NUM_BUFF,AL
        MOV IDX,AL
        MOV SI,0
        MOV CNTF,0
        MOV CNTF2,0
        MOV SI,0
        MOV CX,40
        CLEAR2:
                MOV AL,'*'
                MOV NUM[SI],AL
                INC SI
                LOOP CLEAR2
        mov ax,3d02h
        lea dx,FILE2
        int 21h
        mov HAND,ax
        mov si,0
        L3:
                mov ah,3fh
                mov bx,HAND
                mov cx,20
                mov dx,offset NUM
                int 21h
                cmp ax,0
                JE EXIT2
                INC SI
                JMP L3
                EXIT2:
                mov  ah, 3eh
                mov  bx, HAND
                int  21h
                XOR AX,AX
                MOV SI,0
        COUNT3:
                        CMP NUM[SI],"*"
                        JE READNUM3
                        INC SI
                        INC CNTF
                        JMP COUNT3
                READNUM3: 
                MOV BL,IDX
                MOV BH,0
                MOV NUM_BUFF,BH
                MOV AL,NUM[BX]
                MOV NUM_BUFF,AL
                JMP GET_VAL3
                        GET_VAL3:
                                MOV AL,NUM_BUFF
                                SUB AL,30H
                                MOV BYTE PTR NO_BUFF, AL
                                MOV CX,CNTF
                                MOV CNTF2,CX
                                        MULIPLY3:
                                                MOV SI,0
                                                        TENTIMES3:
                                                                MOV AX,WORD PTR NO_BUFF
                                                                MOV BX,WORD PTR NO_BUFF+2
                                                                MOV CX,WORD PTR NO
                                                                MOV DX,WORD PTR NO+2
                                                                Add      ax, cx                    ; sub subtract lsb - lsb, add for addition  
                                                                Mov      word ptr NO, ax          ; lsb answer
                                                                Adc      bx, dx                    ; sbb subtract msb - msb, adc for addition    
                                                                Mov      word ptr NO+2, bx        ; msb answer
                                                                INC si
                                                                CMP SI,10
                                                                JNE TENTIMES3
                                                Mov      ax,word ptr NO          ; lsb answer
                                                Mov      bx,word ptr NO+2        ; msb answer
                                                MOV WORD PTR NO_BUFF,AX
                                                MOV WORD PTR NO_BUFF+2,BX
                                                MOV WORD PTR NO,0
                                                MOV WORD PTR NO+2,0
                                                DEC CNTF2
                                                CMP CNTF2,1
                                                JA MULIPLY3
                                MOV WORD PTR NO_BUFF,0
                                MOV WORD PTR NO_BUFF+2,0
                                Add      WORD PTR RES,AX                   ; sub subtract lsb - lsb, add for addition  
                                Adc      WORD PTR RES+2,BX                    ; sbb subtract msb - msb, adc for addition    
                        JMP PRE_READNUM3
                B4_READNUM3:
                JMP READNUM3
                PRE_READNUM3:
                INC IDX
                DEC CNTF
                CMP CNTF,1
                JA B4_READNUM3   
                MOV BL,IDX
                MOV BH,0
                MOV NUM_BUFF,BH
                MOV AL,NUM[BX]
                MOV NUM_BUFF,AL
                MOV AL,NUM_BUFF
                SUB AL,30H
                MOV BYTE PTR NO_BUFF, AL
                MOV AX,WORD PTR NO_BUFF
                MOV BX,WORD PTR NO_BUFF+2
                Add      ax, WORD PTR RES                    ; sub subtract lsb - lsb, add for addition  
                Mov      word ptr RES, ax          ; lsb answer
                Adc      bx, WORD PTR RES+2                    ; sbb subtract msb - msb, adc for addition    
                Mov      word ptr RES+2, bx        ; msb answer
                MOV AX,WORD PTR RES
                MOV BX,WORD PTR RES+2
                Mov      word ptr BILL, ax          ; lsb answer
                Mov      word ptr BILL+2, bx        ; msb answer 
                MOV AX,WORD PTR BAL
                MOV BX,WORD PTR BAL+2
                Add      ax, WORD PTR INTEREST                    ; sub subtract lsb - lsb, add for addition  
                Adc      bx, WORD PTR INTEREST+2                    ; sbb subtract msb - msb, adc for addition    
                Add      ax, WORD PTR DIRECT_DEPOSIT                    ; sub subtract lsb - lsb, add for addition  
                Adc      bx, WORD PTR DIRECT_DEPOSIT+2                    ; sbb subtract msb - msb, adc for addition 
                SUB      ax, WORD PTR BILL
                SBB      bx, WORD PTR BILL+2
                Mov      word ptr BAL, ax          ; lsb answer  
                Mov      word ptr BAL+2, bx        ; msb answer              

        WRITEBAL1:
        mov ax,3d02h
        lea dx,FILE
        int 21h
        mov HAND,ax
        MOV CNTF,0
        MOV CNTF2,0
        MOV AX, WORD PTR BAL
        MOV DX, WORD PTR BAL+2
        MOV  BX,10   ;Fixed divider
        PUSH BX
        MOV SI,0
        JMP MORE01
        MORE01:
             MOV CX,AX
             MOV AX,DX
             XOR DX,DX
             DIV BX
             XCHG AX,CX
             DIV BX
             PUSH DX
             MOV DX,CX
             OR CX,AX
             JNZ MORE01
             POP DX
            NEXT01:
             ADD  DL,30H   ;Turn into a character, from [0,9] to ["0","9"]
             MOV BAL_STR[SI],DL
             INC SI
            LAST01:
             POP DX
             CMP DX,BX
             JB NEXT01
        MOV SI,0
        COUNT01:
                CMP BAL_STR[SI],' '
                JE WRITENUM
                INC SI
                INC CNTF
                JMP COUNT01
        WRITENUM:
        DEC CNTF
        mov ah,40h
        mov bx,HAND
        mov cx,CNTF
        lea dx,BAL_STR
        int 21h
        mov ah,3eh
        mov bx,HAND
        int 21h
        ;-END OF WRITE NEW BALANCE INTO FILE-;

        ;-------END OF CODES-------;
        MOV AX,4C00H
        INT 21H
MAIN ENDP
        END MAIN
