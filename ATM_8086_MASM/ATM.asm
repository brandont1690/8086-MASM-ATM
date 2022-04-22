;----------- ATM.ASM -----------;
;    AUTOMATED TELLER MACHINE   ;
; BY:     TAN CHONG HAN         ;
;      SAMYUKTHA A/P MOHAN      ;   
;-------------------------------;

.MODEL SMALL
.STACK 64

.DATA
;--BEGINNING OF DATA DECLARATION--;

;-STRING DATA TYPES-;
        ;LOGIN PAGE
                STR1 DB "+------------------------------------------------------------------------------+$"
                STR2 DB "+                    /\           ----", 194D,"----       |\      /|                   +$"
                STR3 DB "+                   /  \              |           | \    / |                   +$"
                STR4 DB "+                  /____\             |           |  \  /  |                   +$"
                STR5 DB "+                 /      \            |           |   \/   |                   +$"
                STR6 DB "+                /        \           |           |        |                   +$"
                STR7 DB "+                          Automated Teller Machine                            +$"
                STR8 DB "+                                                                              +$"
                STR9 DB "+                                              Please insert your debit card   +$"
                STR10 DB "+                                                            ", 1FH,"                 +$"
        ;PIN INPUT PAGE
                PIN1 DB "+                          Automated Teller Machine                            +$"
                PIN2 DB "+                        Please enter your PIN number                          +$"
        ;LOGOUT PAGE
                OUT1 DB "+                     Thank you for banking with us today                      +$"
                OUT2 DB "+                     We hope to see you again next time!                      +$"
        ;MENU PAGE
                MENU1 DB "+Welcome to our ATM, how can we help you today?                                +$"
                MENU2 DB "+(A) Cash Withdrawal                                                           +$"
                MENU3 DB "+                                                              Cash Deposit (B)+$"
                MENU4 DB "+(C) Balance Inquiry                                                           +$"
                MENU5 DB "+                                                                 PIN Reset (D)+$"
                MENU6 DB "+                            Please input the character of your desired service+$"
        ;WITHDRAW PAGE
                W0 DB "+Cash Withdrawal                                                               +$"
                W1 DB "+Please input the character of your desired withdrawal amount                  +$"
                W2 DB "+(A) Other amount                                                              +$"
                W3 DB "+                                                                     RM150 (B)+$"
                W4 DB "+(C) RM250                                                                     +$"
                W5 DB "+                                                                     RM400 (D)+$"
                W6 DB "+For security purposes, withdrawals larger than RM1000 needs to be performed at+$"
                W7 DB "+our bank counter.                                                             +$"
                W8 DB "+(E) RM500                                                                     +$"
                W9 DB "+                                                                     RM650 (F)+$"
                W10 DB "+(G) RM850                                                                     +$"
                W11 DB "+                                                                    RM1000 (H)+$"
        ;WITHDRAW PAGE2
                W99 DB 52 DUP (' '), ('+') ,('$')
                W98 DB 52 DUP (' '), ('+') ,('$')
                W97 DB 52 DUP (' '), ('+') ,('$')
                W12 DB "+Previous Balance      : RM$"
                W13 DB "+Withdrawal amount     : RM$"
                W14 DB "+New Balance           : RM$"
                W15 DB "+                              Funds insufficient                              +$"
                W16 DB "+                 Please input your desired withdrawal amount.                 +$"
                W17 DB "+          Due to machine inability to dispend notes smaller than RM5          +$"
                W18 DB "+          Value must be divisible by 5, or the input will be invalid.         +$"
                W19 DB "+                    Press Y to proceed, press N to reenter                    +$"
                W20 DB "+                     All 3 spots for input must be filled                     +$"
                W21 DB "+         eg.905 = RM905, 020 = RM20, 1 = RM100, 20 = RM200, 23 = RM23         +$"
        ;DEPOSIT PAGE
                D0 DB "+Cash Deposit                                                                  +$"
                D1 DB "+Please input the character of your desired deposit amount                     +$"
                D2 DB "+For security purposes, deposits larger than RM1000 needs to be performed at   +$"
                D3 DB "+Deposited amount      : RM$"
                D4 DB "+                  Please input your desired deposited amount                  +$"
        ;BALANCE INQUIRY PAGE
                BI0 DB 62 DUP (' '), ('+') ,('$')
                BI1 DB "+Balance Inquiry                                                               +$"
                BI2 DB "+Card number : $"
                BI3 DB "                                                +$"
                BI4 DB "+Currency    : Malaysian Ringgit (RM)                                          +$"
                BI5 DB "+Balance     : RM$"
                BI6 DB "+                                  Thank you!                                  +$"
        ;PIN RESET PAGE
                PC1 DB "+                                  PIN Reset                                   +$"
                PC2 DB "+                      Please enter your desired new PIN:                      +$"
                PC3 DB "+                New PIN will automatically update after logout                +$"
        ;INVALID LOGIN PAGE
                X1 DB "+                 You have inputted the wrong PIN for the card                 +$"
                X2 DB "+                   Your login is hence invalid and rejected                   +$"
        ;PLACEHOLDER EMPTY SPACE STRINGS
                EMPTY DB "                                $"
                EMPTY0 DB "                                     $"
;-END OF STRING DATA TYPES-;

;-INPUT DATA TYPES-;
        INPUT_PIN DB 6 DUP ("*"), ("$")
        INPUT_CARD DB 16 DUP ("*"), ("$")
;-END OF INPUT DATA TYPES-;

;-NUMBER DATA TYPES-;
        ;LOGIN CREDENTIALS
                CARD0 DB 0
                CARD1 DB "1234123412341234$"
                CARD2 DB "1111222233334444$"
                CARD_ADMIN DB "9999000099990000$"
                CARD DB 16 DUP ("*"), ("$")
                PIN DB 6 DUP (" "),("$")
        ;ARITHMETIC FUNCTION VARIABLES
                BAL DD 0
                NEW_BAL DD 0
                BAL_STR DB 40 DUP (" ")
                DIRECT_DEPOSIT DD 0
                BILL DD 0
                INTEREST DD 0
                CNT DB 0
                DEP DD 0
                WIT DD 0
                NOA DD 0
                NOB DD 15000
                NOC DD 25000
                NOD DD 40000
                NOE DD 50000
                NOF DD 65000
                NOG DD 85000
                NOH DD 100000
                TEN dw 10
                HUN dw 100
;-END OF NUMBER DATA TYPES-;

;-ARRAYS-;
        NEW_PIN DB 6 DUP ("*")
;-END OF ARRAYS-;

;-CHAR DATA TYPES-;
        CHARA DB 'A'
        CHARB DB 'B'
        CHARC DB 'C'
        CHARD DB 'D'
        CHARE DB 'E'
        CHARF DB 'F'
        CHARG DB 'G'
        CHARH DB 'H'
        DOT DB '.'
;-END OF CHAR DATA TYPES-;

;-FILE ADDRESSING-;
        HAND DW ?
        CARD1PIN DB "card1pin.txt",0
        card1bal DB "card1bal.txt",0
        CARD1DD DB "card1dd.txt",0
        CARD1BILL DB "card1b.txt",0
        CARD2PIN DB "card2pin.txt",0
        card2bal DB "card2bal.txt",0
        CARD2DD DB "card2dd.txt",0
        CARD2BILL DB "card2b.txt",0
        NUM DB 40 dup (" "),('$')
        NO DD 0
        ERR DB "An error has occured.$"
        NO_BUFF DD 0
        RES DD 0
        NUM_BUFF DB 0
        CNTF dw 0
        CNTF2 dw 0
        CNTW DW 0
        IDX DB 0
;-END OF FILE ADDRESSING-;
;-----END OF DATA DECLARATION------;
.CODE
MAIN PROC
        LOGIN:
        MOV AX,@DATA
        MOV DS,AX
        ;----------CODES----------;
        ;-CLEARING VARIABLE VALUES-;
        XOR AX,AX
        MOV WORD PTR BAL,AX
        MOV WORD PTR BAL+2,AX
        MOV WORD PTR NEW_BAL,AX
        MOV WORD PTR NEW_BAL+2,AX
        MOV WORD PTR NO,AX
        MOV WORD PTR NO+2,AX
        MOV WORD PTR NO_BUFF,AX
        MOV WORD PTR NO_BUFF+2,AX
        MOV WORD PTR RES,AX
        MOV WORD PTR RES+2,AX
        MOV WORD PTR WIT,AX
        MOV WORD PTR WIT+2,AX
        MOV WORD PTR DEP,AX
        MOV WORD PTR DEP+2,AX
        MOV WORD PTR NOA,AX
        MOV WORD PTR NOA+2,AX
        MOV WORD PTR DIRECT_DEPOSIT,AX
        MOV WORD PTR DIRECT_DEPOSIT+2,AX
        MOV WORD PTR INTEREST,AX
        MOV WORD PTR INTEREST+2,AX
        MOV WORD PTR BILL,AX
        MOV WORD PTR BILL+2,AX
        MOV CARD0,AL
        MOV CNT,AL
        MOV NUM_BUFF,AL
        MOV IDX,AL
        MOV CNTF,AX
        MOV CNTF2,AX
        MOV CNTW,AX
        MOV SI,0
        MOV CX,40
        CLEAR1:
                MOV AL,' '
                MOV NUM[SI],AL
                INC SI
                LOOP CLEAR1
        MOV SI,0
        MOV CX,40
        CLEAR2:
                MOV AL,' '
                MOV BAL_STR[SI],AL
                INC SI
                LOOP CLEAR2
        ;-BEGINNING OF LOGIN PAGE-;
	        MOV AH, 09H
	        LEA DX, STR1        ;display string
	        INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR2        ;display string
	            INT 21H
                LEA DX, STR3        ;display string
	            INT 21H
                LEA DX, STR4        ;display string
	            INT 21H
                LEA DX, STR5        ;display string
	            INT 21H
                LEA DX, STR6        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR7        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR9        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR10        ;display string
	            INT 21H
                LEA DX, STR1        ;display string
	            INT 21H
                LEA DX, EMPTY        ;display string
	            INT 21H

        XOR AX,AX
        MOV CX,16        ;LOOP COUNTER = 6 TIMES
        MOV SI,0        ;Pointer to item in list, points to element index 0
        INCARD:
        MOV AH, 01H         ;read character function
        INT 21H             ;read a small letter into AL
        MOV INPUT_CARD[SI], AL        ;and store it in INPUT_PIN[SI]
        INC SI
        LOOP INCARD
        ;-END OF LOGIN PAGE-;

        ;-GET USER KEY PRESS-;
        MOV AH, 08H           ;wait for key press
        INT 21H                   
        ;-END OF USER KEY PRESS-;

        MOV AH, 02H
	MOV DL, 0DH
	INT 21H
	MOV DL, 0AH                ;next line
	INT 21H

        ;-READ FILE-;
                CHECK_CARD0:
                        XOR AX,AX
                        MOV SI,0
                        MOV CX,16
                CHECK0:
                        MOV AL,INPUT_CARD[SI]
                        CMP AL, CARD_ADMIN[SI]  ;compares every character inputted with character for admin code
                        JNE P1_CHECK_CARD1      ;Jump to validate card 1 input in case input is not admin code
                        INC SI
                        LOOP CHECK0             ;Validate admin code input
        ;CARD 1 INTEREST, DIRECT DEPOSIT, AND BILLS
                ;BALANCE & INTEREST
                MOV AX,3d02h                    ;opens file for read/write
                LEA DX,CARD1BAL                 ;file address for txt file storing balance info for account 1
                INT 21h
                MOV HAND,AX                     ;move file handler into HAND
                MOV SI,0
                LA1:
                        MOV AH,3fh
                        MOV BX,HAND
                        MOV CX,20
                        MOV DX,OFFSET NUM
                        int 21h
                        cmp ax,0
                        JE EXITA                        ;read contents of txt file into NUM as a list of number characters
                        INC SI
                        JMP LA1
                EXITA:
                        mov  ah, 3eh
                        mov  bx, HAND
                        int  21h                        ;close the file after finish reading
                        XOR AX,AX
                        MOV SI,0
                COUNTA:
                        CMP NUM[SI]," "
                        JE READNUMA
                        INC SI
                        INC CNTF                ;counts how many numbers are there in the NUM list
                        JMP COUNTA              ;to decide how many times should each number undergo x10 multiplication
                READNUMA: 
                        MOV BL,IDX
                        MOV BH,0
                        MOV NUM_BUFF,BH
                        MOV AL,NUM[BX]
                        MOV NUM_BUFF,AL
                        JMP GET_VALA                    ;moves the specified number character into AL to convert into its designated value
                P1_CHECK_CARD1:
                        JMP P2_CHECK_CARD1
                        GET_VALA:
                                MOV AL,NUM_BUFF
                                SUB AL,30H
                                MOV BYTE PTR NO_BUFF, AL                ;converts char into value and stores into a buffer variable
                                MOV CX,CNTF
                                MOV CNTF2,CX
                                        MULIPLYA:
                                                MOV SI,0
                                                        TENTIMESA:      ;number in buffer variable adds itself 10 times
                                                                MOV AX,WORD PTR NO_BUFF
                                                                MOV BX,WORD PTR NO_BUFF+2
                                                                MOV CX,WORD PTR NO
                                                                MOV DX,WORD PTR NO+2
                                                                Add      ax, cx                    ; adds lsb + lsb
                                                                Mov      word ptr NO, ax          ; lsb answer stored in another buffer NO lower 2 bytes
                                                                Adc      bx, dx                    ; adc adds msb + msb with carry from lsb 
                                                                Mov      word ptr NO+2, bx        ; msb answer stored in another buffer NO higher 2 bytes
                                                                INC si
                                                                CMP SI,10
                                                                JNE TENTIMESA
                                                Mov      ax,word ptr NO          
                                                Mov      bx,word ptr NO+2        
                                                MOV WORD PTR NO_BUFF,AX
                                                MOV WORD PTR NO_BUFF+2,BX       ; moves back the temporary result stored in NO back into AX and BX to repeat TENTIMESA
                                                MOV WORD PTR NO,0
                                                MOV WORD PTR NO+2,0             ; clears NO for the next iteration
                                                DEC CNTF2
                                                CMP CNTF2,1
                                                JA MULIPLYA                     ;repeats the TENTIMES as much as required for each number
                                MOV WORD PTR NO_BUFF,0
                                MOV WORD PTR NO_BUFF+2,0
                                Add      WORD PTR RES,AX                   ; adds lsb + lsb 
                                Adc      WORD PTR RES+2,BX                 ; adc adds msb + msb with carry from lsb 
                        JMP PRE_READNUMA
                B4_READNUMA:
                        JMP READNUMA
                PRE_READNUMA:
                        INC IDX
                        DEC CNTF
                        CMP CNTF,1
                        JA B4_READNUMA                  ;repeats for the next number until the number is "ones" type
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
                        Add      ax, WORD PTR RES                    ; adds the "ones" type number into result RES  
                        Mov      word ptr RES, ax          ; lsb answer
                        Adc      bx, WORD PTR RES+2                  ; adds the "ones" type number into result RES    
                        Mov      word ptr RES+2, bx        ; msb answer
                        MOV AX,WORD PTR RES
                        MOV BX,WORD PTR RES+2
                        Mov      word ptr BAL, ax          ; lsb answer stored into balance
                        Mov      word ptr BAL+2, bx        ; msb answer stored into balance
                        XOR AX,AX                                  ; same process repeated for different number data (interest, direct deposit, bills etc) throughout the code
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
                COUNTA1:
                        CMP NUM[SI]," "
                        JE DECCNT
                        INC SI
                        INC CNTF
                        JMP COUNTA1
                DECCNT:
                        DEC CNTF                        ;As 32 bit numbers take up 2 registers, division and multiplication is complicated, another mechanism is used
                        DEC CNTF                        ;CNTF is decremented twice to make original conversion process go through TENTIMES twice times lesser to obtain 1% value
                READNUMA1: 
                        MOV BL,IDX
                        MOV BH,0
                        MOV NUM_BUFF,BH
                        MOV AL,NUM[BX]
                        MOV NUM_BUFF,AL
                        JMP GET_VALA1
                P2_CHECK_CARD1:
                        JMP P3_CHECK_CARD1
                        GET_VALA1:
                                MOV AL,NUM_BUFF
                                SUB AL,30H
                                MOV BYTE PTR NO_BUFF, AL
                                MOV CX,CNTF
                                MOV CNTF2,CX
                                        MULIPLYA1:
                                                MOV SI,0
                                                        TENTIMESA1:
                                                                MOV AX,WORD PTR NO_BUFF
                                                                MOV BX,WORD PTR NO_BUFF+2
                                                                MOV CX,WORD PTR NO
                                                                MOV DX,WORD PTR NO+2
                                                                Add      ax, cx                    
                                                                Mov      word ptr NO, ax        
                                                                Adc      bx, dx                      
                                                                Mov      word ptr NO+2, bx       
                                                                INC si
                                                                CMP SI,10
                                                                JNE TENTIMESA1
                                                Mov      ax,word ptr NO          
                                                Mov      bx,word ptr NO+2        
                                                MOV WORD PTR NO_BUFF,AX
                                                MOV WORD PTR NO_BUFF+2,BX
                                                MOV WORD PTR NO,0
                                                MOV WORD PTR NO+2,0
                                                DEC CNTF2
                                                CMP CNTF2,1
                                                JA MULIPLYA1
                                MOV WORD PTR NO_BUFF,0
                                MOV WORD PTR NO_BUFF+2,0
                                Add      WORD PTR RES,AX                    
                                Adc      WORD PTR RES+2,BX                   
                        JMP PRE_READNUMA1
                B4_READNUMA1:
                        JMP READNUMA1
                PRE_READNUMA1:
                        INC IDX
                        DEC CNTF
                        CMP CNTF,1
                        JA B4_READNUMA1   
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
                        Add      ax, WORD PTR RES                      
                        Mov      word ptr RES, ax          
                        Adc      bx, WORD PTR RES+2                        
                        Mov      word ptr RES+2, bx        
                        MOV AX,WORD PTR RES
                        MOV BX,WORD PTR RES+2
                        Mov      word ptr INTEREST, ax          ; lsb answer saved in interest variable
                        Mov      word ptr INTEREST+2, bx        ; msb answer saved in interest variable
                ;DIRECT DEPOSIT
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
                CLEARA1:
                        MOV AL,' '
                        MOV NUM[SI],AL
                        INC SI
                        LOOP CLEARA1
                        MOV AX,3D02H
                        LEA DX,CARD1DD                  ;file storing direct deposit value for account 1
                        INT 21H
                        MOV HAND,AX
                        MOV SI,0
                LA2:
                        MOV AH,3FH
                        MOV BX,HAND
                        MOV CX,20
                        MOV DX,OFFSET NUM
                        INT 21H
                        CMP AX,0
                        JE EXITA1
                        INC SI
                        JMP LA2
                EXITA1:
                        MOV AH, 3EH
                        mov  bx, HAND
                        int  21h
                        XOR AX,AX
                        MOV SI,0
                COUNTA2:
                        CMP NUM[SI]," "
                        JE READNUMA2
                        INC SI
                        INC CNTF
                        JMP COUNTA2
                READNUMA2: 
                        MOV BL,IDX
                        MOV BH,0
                        MOV NUM_BUFF,BH
                        MOV AL,NUM[BX]
                        MOV NUM_BUFF,AL
                        JMP GET_VALA2
                        GET_VALA2:
                                MOV AL,NUM_BUFF
                                SUB AL,30H
                                MOV BYTE PTR NO_BUFF, AL
                                MOV CX,CNTF
                                MOV CNTF2,CX
                                        MULIPLYA2:
                                                MOV SI,0
                                                        TENTIMESA2:
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
                                                                JNE TENTIMESA2
                                                Mov      ax,word ptr NO          ; lsb answer
                                                Mov      bx,word ptr NO+2        ; msb answer
                                                MOV WORD PTR NO_BUFF,AX
                                                MOV WORD PTR NO_BUFF+2,BX
                                                MOV WORD PTR NO,0
                                                MOV WORD PTR NO+2,0
                                                DEC CNTF2
                                                CMP CNTF2,1
                                                JA MULIPLYA2
                                MOV WORD PTR NO_BUFF,0
                                MOV WORD PTR NO_BUFF+2,0
                                Add      WORD PTR RES,AX                   ; sub subtract lsb - lsb, add for addition  
                                Adc      WORD PTR RES+2,BX                    ; sbb subtract msb - msb, adc for addition    
                        JMP PRE_READNUMA2
                B4_READNUMA2:
                        JMP READNUMA2
                PRE_READNUMA2:
                        INC IDX
                        DEC CNTF
                        CMP CNTF,1
                        JA B4_READNUMA2   
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
                        Mov      word ptr DIRECT_DEPOSIT, ax          ; lsb answer stored in direct deposit variable
                        Mov      word ptr DIRECT_DEPOSIT+2, bx        ; msb answer stored in direct deposit variable
                        mov ah,3eh
                        mov bx,HAND
                        int 21h
                ;BILLS
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
                CLEARA2:
                        MOV AL,' '
                        MOV NUM[SI],AL
                        INC SI
                        LOOP CLEARA2
                        mov ax,3d02h
                        lea dx,CARD1BILL                ;file address for bills that require payment by account 1
                        int 21h
                        mov HAND,ax
                        mov si,0
                LA3:
                        mov ah,3fh
                        mov bx,HAND
                        mov cx,20
                        mov dx,offset NUM
                        int 21h
                        cmp ax,0
                        JE EXITA2
                        INC SI
                        JMP LA3
                EXITA2:
                        mov  ah, 3eh
                        mov  bx, HAND
                        int  21h
                        XOR AX,AX
                        MOV SI,0
                COUNTA3:
                        CMP NUM[SI]," "
                        JE READNUMA3
                        INC SI
                        INC CNTF
                        JMP COUNTA3
                READNUMA3: 
                        MOV BL,IDX
                        MOV BH,0
                        MOV NUM_BUFF,BH
                        MOV AL,NUM[BX]
                        MOV NUM_BUFF,AL
                        JMP GET_VALA3
                P3_CHECK_CARD1:
                        JMP CHECK_CARD1
                        GET_VALA3:
                                MOV AL,NUM_BUFF
                                SUB AL,30H
                                MOV BYTE PTR NO_BUFF, AL
                                MOV CX,CNTF
                                MOV CNTF2,CX
                                        MULIPLYA3:
                                                MOV SI,0
                                                        TENTIMESA3:
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
                                                                JNE TENTIMESA3
                                                Mov      ax,word ptr NO          ; lsb answer
                                                Mov      bx,word ptr NO+2        ; msb answer
                                                MOV WORD PTR NO_BUFF,AX
                                                MOV WORD PTR NO_BUFF+2,BX
                                                MOV WORD PTR NO,0
                                                MOV WORD PTR NO+2,0
                                                DEC CNTF2
                                                CMP CNTF2,1
                                                JA MULIPLYA3
                                MOV WORD PTR NO_BUFF,0
                                MOV WORD PTR NO_BUFF+2,0
                                Add      WORD PTR RES,AX                   ; sub subtract lsb - lsb, add for addition  
                                Adc      WORD PTR RES+2,BX                    ; sbb subtract msb - msb, adc for addition    
                                JMP PRE_READNUMA3
                B4_READNUMA3:
                        JMP READNUMA3
                PRE_READNUMA3:
                        INC IDX
                        DEC CNTF
                        CMP CNTF,1
                        JA B4_READNUMA3   
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
                        Mov      word ptr BILL, ax          ; lsb answer stored in bills variable
                        Mov      word ptr BILL+2, bx        ; msb answer stored in bills variable
                        MOV AX,WORD PTR BAL
                        MOV BX,WORD PTR BAL+2
                        Add      ax, WORD PTR INTEREST                    ; sub subtract lsb - lsb, add for addition  
                        Adc      bx, WORD PTR INTEREST+2                    ; sbb subtract msb - msb, adc for addition    
                        Add      ax, WORD PTR DIRECT_DEPOSIT                    ; sub subtract lsb - lsb, add for addition  
                        Adc      bx, WORD PTR DIRECT_DEPOSIT+2                    ; sbb subtract msb - msb, adc for addition 
                        SUB      ax, WORD PTR BILL
                        SBB      bx, WORD PTR BILL+2
                        Mov      word ptr BAL, ax          ; lsb answer stored in balance variable
                        Mov      word ptr BAL+2, bx        ; msb answer stored in balance variable

                WRITEBALA1:
                        mov ax,3d02h
                        lea dx,card1bal         ;opens the file storing BAL for card 1
                        int 21h
                        mov ah,41h
                        lea dx,card1bal         ;deletes the file storing BAL for card 1
                        int 21h                 
                        mov ah,3ch
                        mov cx,0
                        lea dx,card1bal         ;creates a new txt file with the same filename as card 1
                        int 21h
                        mov ax,3d02h
                        lea dx,card1bal         ;opens the file storing BAL for card 1
                        int 21h
                        mov HAND,ax
                        MOV CNTF,0
                        MOV CNTF2,0
                        MOV AX, WORD PTR BAL                    ;moves lsb and msb of balance into AX and DX registers
                        MOV DX, WORD PTR BAL+2
                        MOV  BX,10   ;Fixed divider
                        PUSH BX                                 ;Push BX into stack as sentinel, to signal endpoint of stack popping
                        MOV SI,0
                        JMP MOREA01
                MOREA01:
                     MOV CX,AX                          ;Temporarily store lsb in CX
                     MOV AX,DX                          ;First divide the msb
                     XOR DX,DX                          ;Setup for division DX:AX / BX
                     DIV BX                             ; -> AX is msb, remainder is re-used
                     XCHG AX,CX                         ;Temporarily move it to CX restoring lsb
                     DIV BX                             ; -> AX is lsb, Remainder DX storing the number char
                     PUSH DX                            ;Pushes the number char into stack
                     MOV DX,CX                          ;Restores the original 32-bit quotient result in DX:AX
                     OR CX,AX                           ;Checks if the 32-bit quotient is zero yet or not
                     JNZ MOREA01                        ;If not, continue to use as next dividend
                     POP DX                             ;Pops the last digit added into the stack (first in last out rule)
                    NEXTA01:
                     ADD  DL,30H                        ;Turn into a character, from [0,9] to ["0","9"]
                     MOV BAL_STR[SI],DL                 ;saves the character into balance string variable
                     INC SI
                    LASTA01:
                     POP DX                             ;pops the next number from the stack
                     CMP DX,BX                          ;Checks if its the 10 sentinel we added to the stack at first, if not, repeat the process until sentinel is encountered
                     JB NEXTA01
                MOV SI,0
                COUNTA01:
                        CMP BAL_STR[SI],' '             ;checks if the current processing number character is a empty space
                        JE WRITENUMA                    ;if it is, it means we've reached the end of the number string, proceed to write into file
                        INC SI
                        INC CNTF                        ;adds 1 for every number char found that isn't an empty space
                        JMP COUNTA01                    ;records the total number we should write into the file
                WRITENUMA:                              
                        mov ah,40h
                        mov bx,HAND
                        mov cx,CNTF
                        lea dx,BAL_STR                          ;writes BAL_STR into the file
                        int 21h
                        mov ah,3eh
                        mov bx,HAND
                        int 21h
        ;CARD 2 INTEREST, DIRECT DEPOSIT, AND BILLS
        XOR AX,AX
        MOV WORD PTR BAL,AX
        MOV WORD PTR BAL+2,AX
        MOV WORD PTR NEW_BAL,AX
        MOV WORD PTR NEW_BAL+2,AX
        MOV WORD PTR NO,AX
        MOV WORD PTR NO+2,AX
        MOV WORD PTR NO_BUFF,AX
        MOV WORD PTR NO_BUFF+2,AX
        MOV WORD PTR RES,AX
        MOV WORD PTR RES+2,AX
        MOV WORD PTR WIT,AX
        MOV WORD PTR WIT+2,AX
        MOV WORD PTR DEP,AX
        MOV WORD PTR DEP+2,AX
        MOV WORD PTR NOA,AX
        MOV WORD PTR NOA+2,AX
        MOV WORD PTR DIRECT_DEPOSIT,AX
        MOV WORD PTR DIRECT_DEPOSIT+2,AX
        MOV WORD PTR INTEREST,AX
        MOV WORD PTR INTEREST+2,AX
        MOV WORD PTR BILL,AX
        MOV WORD PTR BILL+2,AX
        MOV NUM_BUFF,AL
        MOV IDX,AL
        MOV SI,0
        MOV CNTF,0
        MOV CNTF2,0
        MOV SI,0
        MOV CX,40
        CLEARB:
                MOV AL,' '
                MOV NUM[SI],AL
                INC SI
                LOOP CLEARB             ;Clears all variables and lists for next account
        ;BALANCE & INTEREST
        mov ax,3d02h
        lea dx,CARD2BAL                 ;Opens balance file for account 2, repeating the entire process
        int 21h
        mov HAND,ax
        mov si,0
                LB2:
                        mov ah,3fh
                        mov bx,HAND
                        mov cx,20
                        mov dx,offset NUM
                        int 21h
                        cmp ax,0
                        JE EXITB
                        INC SI
                        JMP LB2
                EXITB:
                        mov  ah, 3eh
                        mov  bx, HAND
                        int  21h
                        XOR AX,AX
                        MOV SI,0
                COUNTB:
                        CMP NUM[SI]," "
                        JE READNUMB
                        INC SI
                        INC CNTF
                        JMP COUNTB
                READNUMB: 
                        MOV BL,IDX
                        MOV BH,0
                        MOV NUM_BUFF,BH
                        MOV AL,NUM[BX]
                        MOV NUM_BUFF,AL
                        JMP GET_VALB
                        GET_VALB:
                                MOV AL,NUM_BUFF
                                SUB AL,30H
                                MOV BYTE PTR NO_BUFF, AL
                                MOV CX,CNTF
                                MOV CNTF2,CX
                                        MULIPLYB:
                                                MOV SI,0
                                                        TENTIMESB:
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
                                                                JNE TENTIMESB
                                                Mov      ax,word ptr NO          ; lsb answer
                                                Mov      bx,word ptr NO+2        ; msb answer
                                                MOV WORD PTR NO_BUFF,AX
                                                MOV WORD PTR NO_BUFF+2,BX
                                                MOV WORD PTR NO,0
                                                MOV WORD PTR NO+2,0
                                                DEC CNTF2
                                                CMP CNTF2,1
                                                JA MULIPLYB
                                MOV WORD PTR NO_BUFF,0
                                MOV WORD PTR NO_BUFF+2,0
                                Add      WORD PTR RES,AX                   ; sub subtract lsb - lsb, add for addition  
                                Adc      WORD PTR RES+2,BX                    ; sbb subtract msb - msb, adc for addition    
                        JMP PRE_READNUMB
                B4_READNUMB:
                        JMP READNUMB
                PRE_READNUMB:
                        INC IDX
                        DEC CNTF
                        CMP CNTF,1
                        JA B4_READNUMB   
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
                COUNTB1:
                        CMP NUM[SI]," "
                        JE DECCNTB
                        INC SI
                        INC CNTF
                        JMP COUNTB1
                DECCNTB:
                        DEC CNTF
                        DEC CNTF
                READNUMB1: 
                        MOV BL,IDX
                        MOV BH,0
                        MOV NUM_BUFF,BH
                        MOV AL,NUM[BX]
                        MOV NUM_BUFF,AL
                        JMP GET_VALB1
                        GET_VALB1:
                                MOV AL,NUM_BUFF
                                SUB AL,30H
                                MOV BYTE PTR NO_BUFF, AL
                                MOV CX,CNTF
                                MOV CNTF2,CX
                                        MULIPLYB1:
                                                MOV SI,0
                                                        TENTIMESB1:
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
                                                                JNE TENTIMESB1
                                                Mov      ax,word ptr NO          ; lsb answer
                                                Mov      bx,word ptr NO+2        ; msb answer
                                                MOV WORD PTR NO_BUFF,AX
                                                MOV WORD PTR NO_BUFF+2,BX
                                                MOV WORD PTR NO,0
                                                MOV WORD PTR NO+2,0
                                                DEC CNTF2
                                                CMP CNTF2,1
                                                JA MULIPLYB1
                                MOV WORD PTR NO_BUFF,0
                                MOV WORD PTR NO_BUFF+2,0
                                Add      WORD PTR RES,AX                   ; sub subtract lsb - lsb, add for addition  
                                Adc      WORD PTR RES+2,BX                    ; sbb subtract msb - msb, adc for addition    
                        JMP PRE_READNUMB1
                B4_READNUMB1:
                        JMP READNUMB1
                PRE_READNUMB1:
                        INC IDX
                        DEC CNTF
                        CMP CNTF,1
                        JA B4_READNUMB1   
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
                ;DIRECT DEPOSIT
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
                CLEARB1:
                        MOV AL,' '
                        MOV NUM[SI],AL
                        INC SI
                LOOP CLEARB1
                mov ax,3d02h
                lea dx,CARD2DD
                int 21h
                mov HAND,ax
                mov si,0
                LB1:
                        mov ah,3fh
                        mov bx,HAND
                        mov cx,20
                        mov dx,offset NUM
                        int 21h
                        cmp ax,0
                        JE EXITB1
                        INC SI
                        JMP LB1
                EXITB1:
                        mov  ah, 3eh
                        mov  bx, HAND
                        int  21h
                        XOR AX,AX
                        MOV SI,0
                COUNTB2:
                        CMP NUM[SI]," "
                        JE READNUMB2
                        INC SI
                        INC CNTF
                        JMP COUNTB2
                READNUMB2: 
                        MOV BL,IDX
                        MOV BH,0
                        MOV NUM_BUFF,BH
                        MOV AL,NUM[BX]
                        MOV NUM_BUFF,AL
                        JMP GET_VALB2
                        GET_VALB2:
                                MOV AL,NUM_BUFF
                                SUB AL,30H
                                MOV BYTE PTR NO_BUFF, AL
                                MOV CX,CNTF
                                MOV CNTF2,CX
                                        MULIPLYB2:
                                                MOV SI,0
                                                        TENTIMESB2:
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
                                                                JNE TENTIMESB2
                                                Mov      ax,word ptr NO          ; lsb answer
                                                Mov      bx,word ptr NO+2        ; msb answer
                                                MOV WORD PTR NO_BUFF,AX
                                                MOV WORD PTR NO_BUFF+2,BX
                                                MOV WORD PTR NO,0
                                                MOV WORD PTR NO+2,0
                                                DEC CNTF2
                                                CMP CNTF2,1
                                                JA MULIPLYB2
                                MOV WORD PTR NO_BUFF,0
                                MOV WORD PTR NO_BUFF+2,0
                                Add      WORD PTR RES,AX                   ; sub subtract lsb - lsb, add for addition  
                                Adc      WORD PTR RES+2,BX                    ; sbb subtract msb - msb, adc for addition    
                        JMP PRE_READNUMB2
                B4_READNUMB2:
                        JMP READNUMB2
                PRE_READNUMB2:
                        INC IDX
                        DEC CNTF
                        CMP CNTF,1
                        JA B4_READNUMB2   
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
                CLEARB2:
                        MOV AL,' '
                        MOV NUM[SI],AL
                        INC SI
                        LOOP CLEARB2
                mov ax,3d02h
                lea dx,CARD2BILL
                int 21h
                mov HAND,ax
                mov si,0
                LB3:
                        mov ah,3fh
                        mov bx,HAND
                        mov cx,20
                        mov dx,offset NUM
                        int 21h
                        cmp ax,0
                        JE EXITB2
                        INC SI
                        JMP LB3
                EXITB2:
                        mov  ah, 3eh
                        mov  bx, HAND
                        int  21h
                        XOR AX,AX
                        MOV SI,0
                COUNTB3:
                        CMP NUM[SI]," "
                        JE READNUMB3
                        INC SI
                        INC CNTF
                        JMP COUNTB3
                READNUMB3: 
                        MOV BL,IDX
                        MOV BH,0
                        MOV NUM_BUFF,BH
                        MOV AL,NUM[BX]
                        MOV NUM_BUFF,AL
                        JMP GET_VALB3
                        GET_VALB3:
                                MOV AL,NUM_BUFF
                                SUB AL,30H
                                MOV BYTE PTR NO_BUFF, AL
                                MOV CX,CNTF
                                MOV CNTF2,CX
                                        MULIPLYB3:
                                                MOV SI,0
                                                        TENTIMESB3:
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
                                                                JNE TENTIMESB3
                                                Mov      ax,word ptr NO          ; lsb answer
                                                Mov      bx,word ptr NO+2        ; msb answer
                                                MOV WORD PTR NO_BUFF,AX
                                                MOV WORD PTR NO_BUFF+2,BX
                                                MOV WORD PTR NO,0
                                                MOV WORD PTR NO+2,0
                                                DEC CNTF2
                                                CMP CNTF2,1
                                                JA MULIPLYB3
                                MOV WORD PTR NO_BUFF,0
                                MOV WORD PTR NO_BUFF+2,0
                                Add      WORD PTR RES,AX                   ; sub subtract lsb - lsb, add for addition  
                                Adc      WORD PTR RES+2,BX                    ; sbb subtract msb - msb, adc for addition    
                        JMP PRE_READNUMB3
                B4_READNUMB3:
                        JMP READNUMB3
                PRE_READNUMB3:
                        INC IDX
                        DEC CNTF
                        CMP CNTF,1
                        JA B4_READNUMB3   
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
                        MOV AX,WORD PTR BAL
                        MOV DX,WORD PTR BAL+2   


                WRITEBALB1:
                        mov ax,3d02h
                        lea dx,card2bal         ;opens the file storing BAL for card 2
                        int 21h
                        mov ah,41h
                        lea dx,card2bal         ;deletes the file storing BAL for card 2
                        int 21h
                        mov ah,3ch
                        mov cx,0
                        lea dx,card2bal         ;creates a new txt file with the same name for card 2
                        int 21h
                        mov ax,3d02h
                        lea dx,card2bal         ;opens the file storing BAL for card 2
                        int 21h
                        mov HAND,ax
                        MOV CNTF,0
                        MOV CNTF2,0
                        MOV AX, WORD PTR BAL
                        MOV DX, WORD PTR BAL+2
                        MOV  BX,10   ;Fixed divider
                        PUSH BX
                        MOV SI,0
                        JMP MOREB01
                MOREB01:
                     MOV CX,AX
                     MOV AX,DX
                     XOR DX,DX
                     DIV BX
                     XCHG AX,CX
                     DIV BX
                     PUSH DX
                     MOV DX,CX
                     OR CX,AX
                     JNZ MOREB01
                     POP DX
                    NEXTB01:
                     ADD  DL,30H   ;Turn into a character, from [0,9] to ["0","9"]
                     MOV BAL_STR[SI],DL
                     INC SI
                    LASTB01:
                     POP DX
                     CMP DX,BX
                     JB NEXTB01
                MOV SI,0
                COUNTB01:
                        CMP BAL_STR[SI],' '
                        JE WRITENUMB
                        INC SI
                        INC CNTF
                        JMP COUNTB01
                WRITENUMB:
                        mov ah,40h
                        mov bx,HAND
                        mov cx,CNTF
                        lea dx,BAL_STR
                        int 21h
                        mov ah,3eh
                        mov bx,HAND
                        int 21h
                        JMP LOGOUT   
                CHECK_CARD1:
                        XOR AX,AX
                        MOV SI,0
                        MOV CX,16
                        CHECK1:
                                MOV AL,INPUT_CARD[SI]
                                CMP AL, CARD1[SI]
                                JNE  CHECK_CARD2        ;Jumps to check card 2 if input does not match card 1
                                INC SI
                                LOOP CHECK1
                        MOV SI,0
                        MOV CX,16
                        CARD_STR1:
                                MOV AL,CARD1[SI]
                                MOV CARD[SI], AL
                                INC SI
                                LOOP CARD_STR1
                        mov ax,3d02h
                        lea dx,CARD1PIN                 ;opens and reads txt file for card 1 PIN for validation
                        int 21h
                        mov HAND,ax
                        mov si,0
                        MOV AL,1
                        MOV CARD0,AL
                        JMP L
                CHECK_CARD2:
                        XOR AX,AX
                        MOV SI,0
                        MOV CX,16
                        CHECK2:
                                MOV AL,INPUT_CARD[SI]
                                CMP AL, CARD2[SI]
                                JNE PRE_WRONG           ;Sends to invalid input page if input does not match card 2
                                INC SI
                                LOOP CHECK2
                        MOV SI,0
                        MOV CX,16
                        CARD_STR2:
                                MOV AL,CARD2[SI]
                                MOV CARD[SI], AL
                                INC SI
                                LOOP CARD_STR2
                        mov ax,3d02h
                        lea dx,CARD2PIN                 ;opens and reads txt file for card 2 PIN for validation
                        int 21h
                        mov HAND,ax
                        mov si,0
                        MOV AL,2
                        MOV CARD0,AL
                        JMP L
                L:
                mov ah,3fh
                mov bx,HAND
                mov cx,6
                mov dx,offset PIN
                int 21h
                cmp ax,0
                JE READ_BAL
                INC SI
                JMP L
        ;-END OF READ FILE-;    
        PRE_WRONG:
        jmp wrong

        ;-READ FILE BALANCE-;
        READ_BAL:
                CMP CARD0,1             ;checks for the account being logged in, reads balance accordingly
                JE READ_BAL1
                CMP CARD0,2
                JE READ_BAL2
                READ_BAL1:
                        mov ah,3eh
                        mov bx,HAND
                        int 21h                     
                        mov ax,3d02h
                        lea dx,CARD1BAL
                        int 21h
                        mov HAND,ax
                        mov si,0
                        JMP L1
                READ_BAL2:
                        mov ah,3eh
                        mov bx,HAND
                        int 21h
                        mov ax,3d02h
                        lea dx,CARD2BAL
                        int 21h
                        mov HAND,ax
                        mov si,0  
                        JMP L1      
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
                        CMP NUM[SI]," "
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
                        Mov      word ptr BAL, ax          ; lsb answer saved in BAL
                        Mov      word ptr BAL+2, bx        ; msb answer saved in BAL
                        JMP PIN_INPUT
        ;-END OF READ FILE BALANCE-;
        ;-PIN INPUT-;
        PIN_INPUT:
	        MOV AH, 09H
	        LEA DX, STR1        ;display string
	        INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR2        ;display string
	            INT 21H
                LEA DX, STR3        ;display string
	            INT 21H
                LEA DX, STR4        ;display string
	            INT 21H
                LEA DX, STR5        ;display string
	            INT 21H
                LEA DX, STR6        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, PIN1        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, PIN2        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR1        ;display string
	            INT 21H
                LEA DX, EMPTY0        ;display string
	            INT 21H

        XOR AX,AX
        MOV CX,6        ;LOOP COUNTER = 6 TIMES
        MOV SI,0        ;Pointer to item in list, points to element index 0
        INPIN:
        MOV AH, 01H         ;read character function
        INT 21H             ;read a small letter into AL
        MOV INPUT_PIN[SI], AL        ;and store it in INPUT_PIN[SI]
        INC SI
        LOOP INPIN

        LEA DX, EMPTY0        ;display string
	    INT 21H
        ;-END OF PIN INPUT-;

        ;-LOGIN VALIDATION-;
                MOV     SI,0

                CHECK_PIN:
                CMP     SI,6
                JE      VALID
                MOV AL, INPUT_PIN[SI]
                CMP AL, PIN[SI]         ;compares the inputted PIN with the stored PIN
                JNE WRONG               ;brings to invalid login page when fails to match PIN
                INC SI
                JMP CHECK_PIN
        ;-END OF LOGIN VALIDATION-;

        ;-WRONG PIN/CARD PAGE-;
        WRONG:
                MOV AH, 09H
	        LEA DX, STR1        ;display string
	        INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                JMP WRONG1
        ;-WRONG PIN/CARD PAGE-;

        ;-MENU PAGE-;
        VALID:
                MOV AH, 09H
                LEA DX, STR1        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, MENU1        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, MENU6        ;display string
	            INT 21H
                JMP VALID1
        ;-MENU PAGE-;
        
        ;-WRONG PIN/CARD PAGE-;
        WRONG1:
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR2        ;display string
	            INT 21H
                LEA DX, STR3        ;display string
	            INT 21H
                LEA DX, STR4        ;display string
	            INT 21H
                LEA DX, STR5        ;display string
	            INT 21H
                    JMP WRONG2
        ;-WRONG PIN/CARD PAGE-;

        ;-MENU PAGE-;
        VALID1:
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, MENU2        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                JMP VALID2
        ;-MENU PAGE-;

        ;-WRONG PIN/CARD PAGE-;
        WRONG2:
                LEA DX, STR6        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                    JMP WRONG3
        ;-WRONG PIN/CARD PAGE-;

        ;-MENU PAGE-;
        VALID2:
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, MENU3        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                JMP VALID3
        ;-MENU PAGE-;

        ;-WRONG PIN/CARD PAGE-;
        WRONG3:
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR7        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                    JMP WRONG4
        ;-WRONG PIN/CARD PAGE-;

        ;-MENU PAGE-;
        VALID3:
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, MENU4        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                JMP VALID4
        ;-MENU PAGE-;

        ;-WRONG PIN/CARD PAGE-;
        WRONG4:
                LEA DX, X1        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, X2        ;display string
	            INT 21H
                LEA DX, STR1        ;display string
	            INT 21H
        ;-END OF WRONG PIN PAGE-;

        ;-GET USER KEY PRESS-;
        MOV AH, 08H           ;wait for key press
        INT 21H                   
        ;-END OF USER KEY PRESS-;
        JMP LOGOUT

        ;-MENU PAGE-;
        VALID4:
                LEA DX, MENU5        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR1        ;display string
	            INT 21H
        ;-END OF MENU PAGE-;

        ;-USER CHOICE-;
                CHOICE:
                MOV AH, 07H            ;read character function
                INT 21H             ;read a small letter into AL      
                CMP AL, CHARA
                JE WITHDRAW
                CMP AL, CHARB
                JE DEPOSIT
                CMP AL, CHARC
                JE BALANCE
                CMP AL, CHARD
                JE PIN_RESET
                JMP CHOICE          ;brings user to different function pages depending on correct key press, does nothing when keypress is invalid
        ;-END OF USER CHOICE-;

        ;-WITHDRAWAL PAGE-;
        WITHDRAW:
                MOV AH, 09H
                LEA DX, STR1        ;display string
	            INT 21H
                LEA DX, W0        ;display string
	            INT 21H
                LEA DX, W1        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                JMP WITHDRAW1
        ;-WITHDRAWAL PAGE-;

        ;-DEPOSIT PAGE-;
        DEPOSIT:
                MOV AH, 09H
                LEA DX, STR1        ;display string
	            INT 21H
                LEA DX, D0        ;display string
	            INT 21H
                LEA DX, D1        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                JMP DEPOSIT1
        ;-DEPOSIT PAGE-;
        ;-BALANCE ENQUIRY PAGE-;
        BALANCE:
                MOV AH, 09H
                LEA DX, STR1        ;display string
	            INT 21H
                LEA DX, BI1        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, BI2        ;display string
	            INT 21H
                JMP BALANCE1
        ;-BALANCE ENQUIRY PAGE-;
        ;-PIN RESET-;
        PIN_RESET:
	        MOV AH, 09H
	        LEA DX, STR1        ;display string
	        INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                JMP PIN_RESET1
        ;-PIN RESET-;
        ;-WITHDRAWAL PAGE-;
        WITHDRAW1:
                LEA DX, W2        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, W3        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, W4        ;display string
	            INT 21H
                JMP WITHDRAW2
        ;-WITHDRAWAL PAGE-;
        ;-DEPOSIT PAGE-;
        DEPOSIT1:
                LEA DX, W2        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, W3        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, W4        ;display string
	            INT 21H
                JMP DEPOSIT2
        ;-DEPOSIT PAGE-;
        ;-BALANCE ENQUIRY PAGE-;
        BALANCE1:
                LEA DX, CARD        ;display string
	            INT 21H
                LEA DX, BI3        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, BI4        ;display string
	            INT 21H
                JMP BALANCE2
        ;-BALANCE ENQUIRY PAGE-;
        ;-PIN RESET-;
        PIN_RESET1:
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR2        ;display string
	            INT 21H
                LEA DX, STR3        ;display string
	            INT 21H
                LEA DX, STR4        ;display string
	            INT 21H
                LEA DX, STR5        ;display string
	            INT 21H
                JMP PIN_RESET2
        ;-PIN RESET-;
        ;-WITHDRAWAL PAGE-;
        WITHDRAW2:
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, W5        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, W8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                JMP WITHDRAW3
        ;-WITHDRAWAL PAGE-;
        ;-DEPOSIT PAGE-;
        DEPOSIT2:
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, W5        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, W8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                JMP DEPOSIT3
        ;-DEPOSIT PAGE-;
        ;-BALANCE ENQUIRY PAGE-;
        BALANCE2:
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, BI5        ;display string
	            INT 21H
                    MOV AX, WORD PTR BAL
                    MOV DX, WORD PTR BAL+2
                    MOV  BX,10   ;Fixed divider
                    PUSH BX
                    MOV SI,0
                JMP MORE0
        ;-BALANCE ENQUIRY PAGE-;
        ;-PIN RESET-;
        PIN_RESET2:
                LEA DX, STR6        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, PC1        ;display string
	            INT 21H
                JMP PIN_RESET3
        ;-PIN RESET-;
        ;-WITHDRAWAL PAGE-;
        WITHDRAW3:
                LEA DX, W9        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, W10        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, W11        ;display string
	            INT 21H
                JMP WITHDRAW4
        ;-WITHDRAWAL PAGE-;
        ;-DEPOSIT PAGE-;
        DEPOSIT3:
                LEA DX, W9        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, W10        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, W11        ;display string
	            INT 21H
                JMP DEPOSIT4
        ;-DEPOSIT PAGE-;
        ;-BALANCE ENQUIRY PAGE-;
            MORE0:
             MOV CX,AX
             MOV AX,DX
             XOR DX,DX
             DIV BX
             XCHG AX,CX
             DIV BX
             PUSH DX            ;pushes number into stack, pops it back out, like how it was did back in reading from file part
             INC CNT
             MOV DX,CX
             OR CX,AX
             JNZ MORE0
             POP DX
            NEXT0:
             ADD  DL,30H   ;Turn into a character, from [0,9] to ["0","9"]
             MOV BI0[SI],DL
             INC SI
             DEC CNT
             CMP CNT,2          ;checks whether or not there is 2 more numbers left to display
             JE ADDDOT0         ;adds a decimal point "." when there are 2 more numbers left to display, to show cents
            LAST0:
             POP DX
             CMP DX,BX
             JB NEXT0
             MOV CNT,0
        JMP BALANCE3
        ;-BALANCE ENQUIRY PAGE-;
        ADDDOT0:
                MOV DL,DOT
                MOV BI0[SI],DL
                INC SI
                JMP LAST0
        ;-PIN RESET-;
        PIN_RESET3:
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, PC2        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                JMP PIN_RESET4
        ;-PIN RESET-;
                        CHOICEW1P2:
                                LEA DX, STR8        ;display string
	                            INT 21H
                                LEA DX, STR8        ;display string
	                            INT 21H
                                LEA DX, W16        ;display string
	                            INT 21H
                                LEA DX, STR8        ;display string
	                            INT 21H
                                LEA DX, STR8        ;display string
	                            INT 21H
                                LEA DX, W17        ;display string
	                            INT 21H
                                LEA DX, STR8        ;display string
	                            INT 21H
                                LEA DX, STR8        ;display string
	                            INT 21H                       
                                LEA DX, W18        ;display string
	                            INT 21H
                                LEA DX, STR8        ;display string
	                            INT 21H                        
                                LEA DX, STR8        ;display string
	                            INT 21H
                                LEA DX, W19        ;display string
	                            INT 21H
                                LEA DX, STR8        ;display string
	                            INT 21H
                                LEA DX, STR8        ;display string
	                            INT 21H
                                LEA DX, W20        ;display string
	                            INT 21H
                                LEA DX, STR8        ;display string
	                            INT 21H
                                LEA DX, W21        ;display string
	                            INT 21H
                                LEA DX, STR8        ;display string
	                            INT 21H
                                LEA DX, STR1        ;display string
	                            INT 21H
                                LEA DX, EMPTY0        ;display string
	                            INT 21H   
                                mov AH,01H
                                INT 21H  
                                SUB AL,30H
                                mov ah,0
                                MUL HUN                       ;accepts 1st digit input from user, multiplies a hundred
                                MOV word ptr NOA,AX           ;saves into lsb of No. A variable

                                mov AH,01H
                                INT 21H  
                                SUB AL,30H
                                mov ah,0
                                MUL TEN                       ;accepts 2nd digit input from user, multiplies ten
                                add word ptr NOA,AX           ;saves into lsb of No. A variable

                                mov AH,01H
                                INT 21H  
                                SUB AL,30H
                                mov ah,0                        ;accepts 3rd digit input from user as it is, in ones
                                CMP AX,0                        ;checks if the last input is number 0
                                JNE T2
                                JE T4
                        T2:
                                CMP AX,5                        ;checks if the last input is number 5
                                JNE T3
                                JE T4
                        T3:
                                MOV AH, 02H
	                        MOV DL, 0DH
	                        INT 21H
	                        MOV DL, 0AH                ;adds next line
	                        INT 21H
                                JMP CHOICED1               ;clears input, asks user to enter another input
                        T4:
                                ADD word ptr NOA,AX        ;if is 0 or 5, adds into lsb of No. A variable

                                MOV AX,word ptr NOA
                                MOV BX,100                 ;multiplies No. A variable by 100
                                MUL BX
                                MOV word ptr NOA,AX         ;Copy AX into lower 2 bytes of NOA
                                MOV word ptr NOA+2,DX       ;Copy DX into upper 2 bytes of NOA

                                MOV AH, 02H
                                MOV DL, dot           ;display character dot     
                                INT 21H
                                MOV DL, '0'           ;display character 0     
                                INT 21H
                                MOV DL, '0'           ;display character 0    
                                INT 21H
                                JMP CHOICEW11
        ;-WITHDRAWAL PAGE-;
        WITHDRAW4:
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, W6        ;display string
	            INT 21H
                LEA DX, W7        ;display string
	            INT 21H
                LEA DX, STR1        ;display string
	            INT 21H
                JMP CHOICEW
        ;-END OF WITHDRAWAL PAGE-;
                        CHOICEW1:
                                MOV AH, 09H
                                LEA DX, STR1        ;display string
	                            INT 21H
                                LEA DX, W0        ;display string
	                            INT 21H
                                LEA DX, STR8        ;display string
	                            INT 21H
                                LEA DX, STR8        ;display string
	                            INT 21H
                                LEA DX, STR8        ;display string
	                            INT 21H
                                JMP CHOICEW1P2

        ;-GET USER KEY PRESS-;
        ;-WITHDRAWAL PROCESSING-;
                CHOICEW:
                        MOV AH, 07H            ;read character function
                        INT 21H             ;read a small letter into AL
                        CMP AL, CHARA
                        JE CHOICEW1
                        CMP AL, CHARB
                        JE CHOICEW2
                        CMP AL, CHARC
                        JE CHOICEW3
                        CMP AL, CHARD
                        JE CHOICEW4
                        CMP AL, CHARE
                        JE CHOICEW5
                        CMP AL, CHARF
                        JE CHOICEW6
                        CMP AL, CHARG
                        JE CHOICEW7
                        CMP AL, CHARH
                        JE CHOICEW8
                        JMP CHOICEW             ;initializes different withdraw value depending on correct key press, does nothing when keypress is invalid

                        CHOICEW11:
                                MOV AH, 02H
                                MOV DL, 0DH
	                        INT 21H
	                        MOV DL, 0AH                ;next line
	                        INT 21H
                                MOV AH, 07H            ;read character function
                                INT 21H                ;read a small letter into AL      
                                CMP AL, 'Y'            ;If user press Y, confirms the input and proceed to withdraw
                                JE CHOICEW12
                                CMP AL, 'N'            ;If user press N, rejects the input and the user can reenter another input
                                JE CHOICEW1
                                JMP CHOICEW11          ;If user presses anything else, nothing happens
                CHOICEW12:
                        mov      cx, word ptr NOA          ; lsb of NOA in cx  
                        mov      dx, word ptr NOA+2        ; msb of NOA in dx
                        JMP WITHDRAW_PROCESS
                CHOICEW2:
                        mov      cx, word ptr NOB          ; lsb of NOB in cx  
                        mov      dx, word ptr NOB+2        ; msb of NOB in dx
                        JMP WITHDRAW_PROCESS   
                CHOICEW3:
                        mov      cx, word ptr NOC          ; lsb of NOC in cx  
                        mov      dx, word ptr NOC+2        ; msb of NOC in dx
                        JMP WITHDRAW_PROCESS
                CHOICEW4:
                        mov      cx, word ptr NOD          ; lsb of NOD in cx  
                        mov      dx, word ptr NOD+2        ; msb of NOD in dx
                        JMP WITHDRAW_PROCESS
                CHOICEW5:
                        mov      cx, word ptr NOE          ; lsb of NOE in cx  
                        mov      dx, word ptr NOE+2        ; msb of NOE in dx
                        JMP WITHDRAW_PROCESS
                CHOICEW6:
                        mov      cx, word ptr NOF          ; lsb of NOF in cx  
                        mov      dx, word ptr NOF+2        ; msb of NOF in dx
                        JMP WITHDRAW_PROCESS
                CHOICEW7:
                        mov      cx, word ptr NOG          ; lsb of NOG in cx  
                        mov      dx, word ptr NOG+2        ; msb of NOG in dx
                        JMP WITHDRAW_PROCESS
                CHOICEW8:
                        mov      cx, word ptr NOH          ; lsb of NOH in cx  
                        mov      dx, word ptr NOH+2        ; msb of NOH in dx
                        JMP WITHDRAW_PROCESS
        
                WITHDRAW_PROCESS:
                        MOV      BX,word ptr BAL+2         ; Msb of BAL in BX
                        MOV      AX,word ptr BAL           ; Lsb of BAL in AX
                        CMP      DX, BX
                        JA       XFUND                     ;jumps to insufficient funds page if withdraw amount higher than balance
                        JE       CHK2
                        JB       WITHDRAW_PROCESS2
                        CHK2:
                        CMP      CX, AX
                        JA       XFUND
                WITHDRAW_PROCESS2:              
                        MOV      word ptr WIT, CX          ; moves CX into variable WIT for withdraw amount for later display
                        MOV      word ptr WIT+2, DX        ; moves DX into variable WIT for withdraw amount for later display 
                        SUB      ax, cx                    ; subtracts  
                        mov      word ptr NEW_BAL, ax          ; lsb answer
                        SBB      bx, dx                    ; sbb subtract msb - msb, adc for addition    
                        mov      word ptr NEW_BAL+2, bx        ; msb answer
                        JMP     WITH
        ;-END OF WITHDRAWAL PROCESSING-;
        ;-INSUFFICIENT FUNDS PAGE-;
                XFUND:
                MOV AH, 09H
                LEA DX, STR1        ;display string
	            INT 21H
                LEA DX, W0        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, W15        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, BI6        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR1        ;display string
	            INT 21H
        ;-END OF INSUFFICIENT FUNDS PAGE-;
        ;-GET USER KEY PRESS-;
        MOV AH, 08H           ;wait for key press
        INT 21H                   
        ;-END OF USER KEY PRESS-;

        JMP LOGOUT
        ;-WITHDRAW DISPLAY PAGE-;
            WITH:
                MOV AH, 09H
                LEA DX, STR1        ;display string
	            INT 21H
                LEA DX, W0        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, W12        ;display string
	            INT 21H
                    MOV AX, WORD PTR BAL
                    MOV DX, WORD PTR BAL+2
                    MOV  BX,10   ;Fixed divider
                    PUSH BX
                    MOV SI,0
                    JMP MORE
                    
            MORE:
             MOV CX,AX
             MOV AX,DX
             XOR DX,DX
             DIV BX
             XCHG AX,CX
             DIV BX
             PUSH DX
             INC CNT
             MOV DX,CX
             OR CX,AX
             JNZ MORE
             POP DX
            NEXT:
             ADD  DL,30H                ;Turn into a character, from [0,9] to ["0","9"]
             MOV W99[SI],DL             ;moves BAL value into string W99 as number string with decimal dot
             INC SI
             DEC CNT
             CMP CNT,2
             JE ADDDOT
            LAST:
             POP DX
             CMP DX,BX
             JB NEXT
             MOV CNT,0
             JMP WITH0
                ADDDOT:
                MOV DL,DOT
                MOV W99[SI],DL
                INC SI
                JMP LAST
                WITH0:
                MOV AH, 09H
                LEA DX, W99        ;display string containing BAL number string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, W13        ;display string
	            INT 21H
                MOV AX, WORD PTR WIT
                    MOV DX, WORD PTR WIT+2
                    MOV  BX,10   ;Fixed divider
                    PUSH BX
                    MOV SI,0
                    JMP MORE1
                    ;-BALANCE ENQUIRY PAGE-;
            MORE1:
             MOV CX,AX
             MOV AX,DX
             XOR DX,DX
             DIV BX
             XCHG AX,CX
             DIV BX
             PUSH DX
             INC CNT
             MOV DX,CX
             OR CX,AX
             JNZ MORE1
             POP DX
            NEXT1:
             ADD  DL,30H                ;Turn into a character, from [0,9] to ["0","9"]
             MOV W98[SI],DL             ;moves WIT value into string W98 as number string with decimal dot
             INC SI
             DEC CNT
             CMP CNT,2
             JE ADDDOT1
            LAST1:
             POP DX
             CMP DX,BX
             JB NEXT1
             MOV CNT,0
             JMP WITH1
                ADDDOT1:
                MOV DL,DOT
                MOV W98[SI],DL
                INC SI
                JMP LAST1
                WITH1:
                MOV AH, 09H
                LEA DX, W98        ;display string containing WIT number string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, W14        ;display string
	            INT 21H
                    MOV AX, WORD PTR NEW_BAL
                    MOV DX, WORD PTR NEW_BAL+2
                    MOV  BX,10   ;Fixed divider
                    PUSH BX
                    MOV SI,0
                    JMP MORE2

            MORE2:
             MOV CX,AX
             MOV AX,DX
             XOR DX,DX
             DIV BX
             XCHG AX,CX
             DIV BX
             PUSH DX
             INC CNT
             MOV DX,CX
             OR CX,AX
             JNZ MORE2
             POP DX
            NEXT2:
             ADD  DL,30H                ;Turn into a character, from [0,9] to ["0","9"]
             MOV W97[SI],DL             ;moves NEW_BAL value into string W97 as number string with decimal dot
             INC SI
             DEC CNT
             CMP CNT,2
             JE ADDDOT2
            LAST2:
             POP DX
             CMP DX,BX
             JB NEXT2
             MOV CNT,0
             JMP WITH2
                ADDDOT2:
                MOV DL,DOT
                MOV W97[SI],DL
                INC SI
                JMP LAST2
                WITH2:
                MOV AH, 09H
                LEA DX, W97        ;display string containing NEW_BAL number string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, BI6        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR1        ;display string
	            INT 21H
                MOV AX, WORD PTR NEW_BAL
                MOV DX, WORD PTR NEW_BAL+2
                MOV WORD PTR BAL,AX
                MOV WORD PTR BAL+2,DX
        ;-END OF WITHDRAW DISPLAY PAGE-;
                      
        ;-GET USER KEY PRESS-;
        MOV AH, 08H           ;wait for key press
        INT 21H                   
        ;-END OF USER KEY PRESS-;

        JMP WRITEBAL0

        ;-BALANCE ENQUIRY PAGE-;
        BALANCE3:
                MOV AH, 09H
                LEA DX, BI0        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                JMP BALANCE4
        ;-BALANCE ENQUIRY PAGE-;
         ;-PIN RESET-;
        PIN_RESET4:
                LEA DX, PC3        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR1        ;display string
	            INT 21H
                LEA DX, EMPTY0        ;display string
	            INT 21H
                JMP PIN_RESET5
        ;-PIN RESET-;
                CHOICED1P2:
                        LEA DX, STR8        ;display string
	                    INT 21H
                        LEA DX, STR8        ;display string
	                    INT 21H
                        LEA DX, D4        ;display string
	                    INT 21H
                        LEA DX, STR8        ;display string
	                    INT 21H
                        LEA DX, STR8        ;display string
	                    INT 21H
                        LEA DX, W17        ;display string
	                    INT 21H
                        LEA DX, STR8        ;display string
	                    INT 21H
                        LEA DX, STR8        ;display string
	                    INT 21H                       
                        LEA DX, W18        ;display string
	                    INT 21H
                        LEA DX, STR8        ;display string
	                    INT 21H                        
                        LEA DX, STR8        ;display string
	                    INT 21H
                        LEA DX, W19        ;display string
	                    INT 21H
                        LEA DX, STR8        ;display string
	                    INT 21H
                        LEA DX, STR8        ;display string
	                    INT 21H
                        LEA DX, W20        ;display string
	                    INT 21H
                        LEA DX, STR8        ;display string
	                    INT 21H
                        LEA DX, W21        ;display string
	                    INT 21H
                        LEA DX, STR8        ;display string
	                    INT 21H
                        LEA DX, STR1        ;display string
	                    INT 21H
                        LEA DX, EMPTY0        ;display string
	                    INT 21H   
                        mov AH,1
                        INT 21H  
                        SUB AL,30H
                        mov ah,0
                        MUL HUN                       ;1st digit
                        MOV word ptr NOA,AX

                        mov AH,1
                        INT 21H  
                        SUB AL,30H
                        mov ah,0
                        MUL TEN                       ;2nd digit
                        add word ptr NOA,AX

                        mov AH,1
                        INT 21H  
                        SUB AL,30H
                        mov ah,0                        ;3rd digit
                        CMP AX,0
                        JNE T6
                        JE T8
                        T6:
                        CMP AX,5
                        JNE T7
                        JE T8
                        T7:
                        MOV AH, 02H
	                MOV DL, 0DH
	                INT 21H
	                MOV DL, 0AH                ;next line
	                INT 21H
                        JMP CHOICED1
                        T8:
                        ADD word ptr NOA,AX

                        MOV AX,word ptr NOA
                        MOV BX,100
                        MUL BX
                        MOV word ptr NOA,AX         ;Copy AX in lower 2 bytes of RES
                        MOV word ptr NOA+2,DX       ;Copy DX in upper 2 bytes of RES

                        MOV AH, 02H
                        MOV DL, dot           ;display character      
                        INT 21H
                        MOV DL, '0'           ;display character      
                        INT 21H
                        MOV DL, '0'           ;display character      
                        INT 21H
                        JMP CHOICED11
        ;-DEPOSIT PAGE-;
        DEPOSIT4:
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, D2        ;display string
	            INT 21H
                LEA DX, W7        ;display string
	            INT 21H
                LEA DX, STR1        ;display string
	            INT 21H
                JMP CHOICED
        ;-END OF DEPOSIT PAGE-;
                CHOICED1:
                        MOV AH, 09H
                        LEA DX, STR1        ;display string
	                    INT 21H
                        LEA DX, D0        ;display string
	                    INT 21H
                        LEA DX, STR8        ;display string
	                    INT 21H
                        LEA DX, STR8        ;display string
	                    INT 21H
                        LEA DX, STR8        ;display string
	                    INT 21H
                        JMP CHOICED1P2
        ;-DEPOSIT PROCESSING-;
                CHOICED:
                        MOV AH, 07H            ;read character function
                        INT 21H             ;read a small letter into AL      
                        CMP AL, CHARA
                        JE CHOICED1
                        CMP AL, CHARB
                        JE CHOICED2
                        CMP AL, CHARC
                        JE CHOICED3
                        CMP AL, CHARD
                        JE CHOICED4
                        CMP AL, CHARE
                        JE CHOICED5
                        CMP AL, CHARF
                        JE CHOICED6
                        CMP AL, CHARG
                        JE CHOICED7
                        CMP AL, CHARH
                        JE CHOICED8
                        JMP CHOICED     ;initializes different withdraw value depending on correct key press, does nothing when keypress is invalid

                        CHOICED11:
                        MOV AH, 02H
                        MOV DL, 0DH
	                INT 21H
	                MOV DL, 0AH                ;next line
	                INT 21H
                        MOV AH, 07H            ;read character function
                        INT 21H             ;read a small letter into AL      
                        CMP AL, 'Y'
                        JE CHOICED12
                        CMP AL, 'N'
                        JE CHOICED1
                        JMP CHOICED11
                        CHOICED12:
                        mov      cx, word ptr NOA          ; lsb of NOA in cx  
                        mov      dx, word ptr NOA+2        ; msb of NOA in dx
                        JMP DEPOSIT_PROCESS
                CHOICED2:
                        mov      cx, word ptr NOB          ; lsb of NOB in cx  
                        mov      dx, word ptr NOB+2        ; msb of NOB in dx
                        JMP DEPOSIT_PROCESS   
                CHOICED3:
                        mov      cx, word ptr NOC          ; lsb of NOC in cx  
                        mov      dx, word ptr NOC+2        ; msb of NOC in dx
                        JMP DEPOSIT_PROCESS
                CHOICED4:
                        mov      cx, word ptr NOD          ; lsb of NOD in cx  
                        mov      dx, word ptr NOD+2        ; msb of NOD in dx
                        JMP DEPOSIT_PROCESS
                CHOICED5:
                        mov      cx, word ptr NOE          ; lsb of NOE in cx  
                        mov      dx, word ptr NOE+2        ; msb of NOE in dx
                        JMP DEPOSIT_PROCESS
                CHOICED6:
                        mov      cx, word ptr NOF          ; lsb of NOF in cx  
                        mov      dx, word ptr NOF+2        ; msb of NOF in dx
                        JMP DEPOSIT_PROCESS
                CHOICED7:
                        mov      cx, word ptr NOG          ; lsb of NOG in cx  
                        mov      dx, word ptr NOG+2        ; msb of NOG in dx
                        JMP DEPOSIT_PROCESS
                CHOICED8:
                        mov      cx, word ptr NOH          ; lsb of NOH in cx  
                        mov      dx, word ptr NOH+2        ; msb of NOH in dx
                        JMP DEPOSIT_PROCESS
                DEPOSIT_PROCESS:
                        MOV      BX,word ptr BAL+2
                        MOV      AX,word ptr BAL              
                        MOV      word ptr DEP, CX          ; moves CX into variable WIT for withdraw amount for later display
                        MOV      word ptr DEP+2, DX        ; moves DX into variable WIT for withdraw amount for later display
                        ADD      ax, cx                    ; sub subtract lsb - lsb, add for addition  
                        mov      word ptr NEW_BAL, ax          ; lsb answer
                        adc      bx, dx                    ; sbb subtract msb - msb, adc for addition    
                        mov      word ptr NEW_BAL+2, bx        ; msb answer
                        JMP     DEPO
                        DEPO:
                        MOV AH, 09H
                        LEA DX, STR1        ;display string
	                    INT 21H
                        LEA DX, D0         ;display string
	                    INT 21H
                        LEA DX, STR8        ;display string
	                    INT 21H
                        LEA DX, STR8        ;display string
	                    INT 21H
                        LEA DX, STR8        ;display string
	                    INT 21H
                        LEA DX, W12        ;display string
	                    INT 21H
                        MOV AX, WORD PTR BAL
                            MOV DX, WORD PTR BAL+2
                            MOV  BX,10   ;Fixed divider
                            PUSH BX
                            MOV SI,0
                            JMP MORE4
                MORE4:
                     MOV CX,AX
                     MOV AX,DX
                     XOR DX,DX
                     DIV BX
                     XCHG AX,CX
                     DIV BX
                     PUSH DX
                     INC CNT
                     MOV DX,CX
                     OR CX,AX
                     JNZ MORE4
                     POP DX
                    NEXT4:
                     ADD  DL,30H                ;Turn into a character, from [0,9] to ["0","9"]
                     MOV W99[SI],DL             ;moves BAL value into string W99 as number string with decimal dot
                     INC SI
                     DEC CNT
                     CMP CNT,2
                     JE ADDDOT4
                    LAST4:
                     POP DX
                     CMP DX,BX
                     JB NEXT4
                     MOV CNT,0
                     JMP DEPO0
                ADDDOT4:
                MOV DL,DOT
                MOV W99[SI],DL
                INC SI
                JMP LAST4
                DEPO0:
                MOV AH, 09H
                LEA DX, W99        ;display string containing BAL number string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, D3        ;display string
	            INT 21H
                MOV AX, WORD PTR DEP
                    MOV DX, WORD PTR DEP+2
                    MOV  BX,10   ;Fixed divider
                    PUSH BX
                    MOV SI,0
                    JMP MORE5
                    ;-BALANCE ENQUIRY PAGE-;
            MORE5:
             MOV CX,AX
             MOV AX,DX
             XOR DX,DX
             DIV BX
             XCHG AX,CX
             DIV BX
             PUSH DX
             INC CNT
             MOV DX,CX
             OR CX,AX
             JNZ MORE5
             POP DX
            NEXT5:
             ADD  DL,30H                ;Turn into a character, from [0,9] to ["0","9"]
             MOV W98[SI],DL             ;moves DEP value into string W98 as number string with decimal dot
             INC SI
             DEC CNT
             CMP CNT,2
             JE ADDDOT5
            LAST5:
             POP DX
             CMP DX,BX
             JB NEXT5
             MOV CNT,0
             JMP DEPO1
                ADDDOT5:
                MOV DL,DOT
                MOV W98[SI],DL
                INC SI
                JMP LAST5
                DEPO1:
                MOV AH, 09H
                LEA DX, W98        ;display string containing DEP number string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, W14        ;display string
	            INT 21H
                    MOV AX, WORD PTR NEW_BAL
                    MOV DX, WORD PTR NEW_BAL+2
                    MOV  BX,10   ;Fixed divider
                    PUSH BX
                    MOV SI,0
                    JMP MORE6

            MORE6:
             MOV CX,AX
             MOV AX,DX
             XOR DX,DX
             DIV BX
             XCHG AX,CX
             DIV BX
             PUSH DX
             INC CNT
             MOV DX,CX
             OR CX,AX
             JNZ MORE6
             POP DX
            NEXT6:
             ADD  DL,30H                ;Turn into a character, from [0,9] to ["0","9"]
             MOV W97[SI],DL             ;moves NEW_BAL value into string W97 as number string with decimal dot
             INC SI
             DEC CNT
             CMP CNT,2
             JE ADDDOT6
            LAST6:
             POP DX
             CMP DX,BX
             JB NEXT6
             MOV CNT,0
             JMP DEPO2
                ADDDOT6:
                MOV DL,DOT
                MOV W97[SI],DL
                INC SI
                JMP LAST6
                DEPO2:
                MOV AH, 09H
                LEA DX, W97        ;display string containing NEW_BAL number string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, BI6        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR1        ;display string
	            INT 21H
                MOV AX, WORD PTR NEW_BAL
                MOV DX, WORD PTR NEW_BAL+2
                MOV WORD PTR BAL,AX
                MOV WORD PTR BAL+2,DX
                ;-GET USER KEY PRESS-;
                MOV AH, 08H           ;wait for key press
                INT 21H                   
                ;-END OF USER KEY PRESS-;

                JMP WRITEBAL0
        ;-END OF DEPOSIT PROCESSING-;
        ;-BALANCE ENQUIRY PAGE-;
        BALANCE4:
                LEA DX, BI6        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR1        ;display string
	            INT 21H
        ;-END OF BALANCE ENQUIRY PAGE-;

        ;-GET USER KEY PRESS-;
        MOV AH, 08H           ;wait for key press
        INT 21H                   
        ;-END OF USER KEY PRESS-;

        JMP LOGOUT

        ;-PIN RESET-;
        PIN_RESET5:
                XOR AX,AX
                MOV CX,6        ;LOOP COUNTER = 6 TIMES
                MOV SI,0        ;Pointer to item in list, points to element index 0
                CHGPIN:
                        MOV AH, 01H         ;read character function
                        INT 21H             ;read a small letter into AL
                        MOV NEW_PIN[SI], AL        ;and store it in INPUT_PIN[SI]
                        INC SI
                        LOOP CHGPIN

                        XOR AX,AX
                        MOV CX,6        ;LOOP COUNTER = 6 TIMES
                        MOV SI,0        ;Pointer to item in list, points to element index 0
                UPD_PIN:
                        MOV AL, NEW_PIN[SI]
                        MOV PIN[SI],AL  ;Overwrites the old PIN with the new one
                        INC SI
                        LOOP UPD_PIN       
        ;-END OF PIN RESET-;

        ;-WRITE NEW PIN TO FILE-;
                MOV AH, 08H           ;wait for key press
                INT 21H    

                MOV AH, 09H
	        LEA DX, EMPTY0        ;display string
	        INT 21H

                CMP CARD0,1             ;writes new PIN to the specific card logged in to
                JE WRITEPIN1
                CMP CARD0,2
                JE WRITEPIN2
                WRITEPIN1:
                        mov ax,3d02h
                        lea dx,card1pin         ;opens the file storing PIN for card 1
                        int 21h
                        JMP WRITEPIN
                WRITEPIN2:
                        mov ax,3d02h
                        lea dx,card2pin         ;opens the file storing PIN for card 2
                        int 21h
                        JMP WRITEPIN
        
                WRITEPIN:
                        mov HAND,ax 
                        mov ah,40h
                        mov bx,HAND
                        mov cx,6
                        lea dx,NEW_PIN          ;writes the new PIN into the file
                        int 21h        
                        mov ah,3eh
                        mov bx,HAND
                        int 21h       
        ;-END OF WRITE NEW PIN TO FILE-;

        JMP LOGOUT

        ;-WRITE NEW BALANCE INTO FILE-;
                WRITEBAL0:                      ;writes new BAL to the specific card logged in to
                        CMP CARD0,1
                        JE WRITEBAL1            
                        CMP CARD0,2
                        JE WRITEBAL2            
                WRITEBAL1:
                        mov ax,3d02h
                        lea dx,card1bal         ;opens the file storing BAL for card 1
                        int 21h
                        mov ah,41h
                        lea dx,card1bal         ;deletes the file storing BAL for card 1
                        int 21h
                        mov ah,3ch
                        mov cx,0
                        lea dx,card1bal         ;creates a new txt file with the same name for card 1
                        int 21h
                        mov ax,3d02h
                        lea dx,card1bal         ;opens the file storing BAL for card 1
                        int 21h
                        JMP WRITEBAL
                WRITEBAL2:
                        mov ax,3d02h
                        lea dx,card2bal         ;opens the file storing BAL for card 2
                        int 21h
                        mov ah,41h
                        lea dx,card2bal         ;deletes the file storing BAL for card 2
                        int 21h
                        mov ah,3ch
                        mov cx,0
                        lea dx,card2bal         ;creates a new txt file with the same name for card 2
                        int 21h
                        mov ax,3d02h
                        lea dx,card2bal         ;opens the file storing BAL for card 2
                        int 21h
                        JMP WRITEBAL
                WRITEBAL:
                        mov HAND,ax
                        mov si,0
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
                     ADD  DL,30H                ;Turn into a character, from [0,9] to ["0","9"]
                     MOV BAL_STR[SI],DL         ;moves BAL value into string BAL_STR as number string
                     INC SI
                    LAST01:
                     POP DX
                     CMP DX,BX
                     JB NEXT01
                MOV SI,0
                COUNT01:
                        CMP BAL_STR[SI],' '     ;counts the number of number chars that is needed to write into file
                        JE WRITENUM
                        INC SI
                        INC CNTF
                        JMP COUNT01
                WRITENUM:
                        DEC CNTF                ;decrements the extra CNTF +1 value due to the empty space
                        mov ah,40h
                        mov bx,HAND
                        mov cx,CNTF
                        lea dx,BAL_STR          ;writes new balance into file
                        int 21h
                        mov ah,3eh
                        mov bx,HAND
                        int 21h
        ;-END OF WRITE NEW BALANCE INTO FILE-;

        ;-LOGOUT PAGE-;
        LOGOUT:
	        MOV AH, 09H
	        LEA DX, STR1        ;display string
	        INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR2        ;display string
	            INT 21H
                LEA DX, STR3        ;display string
	            INT 21H
                LEA DX, STR4        ;display string
	            INT 21H
                LEA DX, STR5        ;display string
	            INT 21H
                LEA DX, STR6        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR7        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, OUT1        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, OUT2        ;display string
	            INT 21H
                LEA DX, STR8        ;display string
	            INT 21H
                LEA DX, STR1        ;display string
	            INT 21H
        ;-END OF LOGOUT PAGE-;

        ;-GET USER KEY PRESS-;
        MOV AH, 08H           ;wait for key press
        INT 21H                   
        ;-END OF USER KEY PRESS-;
        JMP LOGIN
        ;-------END OF CODES-------;
        MOV AX,4C00H
        INT 21H
MAIN ENDP
        END MAIN