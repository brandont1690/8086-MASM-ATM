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

        EMPTY DB "                                $"
        EMPTY0 DB "                                     $"
;-END OF STRING DATA TYPES-;

;-INPUT DATA TYPES-;
        INPUT_PIN DB 6 DUP ("*"), ("$")
        INPUT_CARD DB 16 DUP ("*"), ("$")
;-END OF INPUT DATA TYPES-;

;-NUMBER DATA TYPES-;
        CARD DB "1234123412341234$"
        PIN DB "123456"
        BAL DD 50000
        NEW_BAL DD 0
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
        NEW_PIN DB 6 DUP ("*"), ("$")
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
;-----END OF DATA DECLARATION------;
.CODE
MAIN PROC
        LOGIN:
        MOV AX,@DATA
        MOV DS,AX
        ;----------CODES----------;
        
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

        LEA DX, EMPTY        ;display string
	    INT 21H

        ;-END OF LOGIN PAGE-;

        ;-PIN INPUT-;
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
        CHECK_CARD:
        CMP     SI,16            ;SI=3(LAST ELEM)
        JE      RESETSI         ;SI=4, RESET SI=0 b4 CHECK_PSW
        MOV AL,INPUT_CARD[SI]
        CMP AL, CARD[SI]
        JNE WRONG
        INC SI
        JMP CHECK_CARD
        
        RESETSI:
        MOV     SI, 0

        CHECK_PIN:
        CMP     SI,6
        JE      VALID
        MOV AL, INPUT_PIN[SI]
        CMP AL, PIN[SI]
        JNE WRONG
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
                JMP CHOICE
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
             PUSH DX
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
             CMP CNT,2
             JE ADDDOT0
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
                        JNE T2
                        JE T4
                        T2:
                        CMP AX,5
                        JNE T3
                        JE T4
                        T3:
                        MOV AH, 02H
	                MOV DL, 0DH
	                INT 21H
	                MOV DL, 0AH                ;next line
	                INT 21H
                        JMP CHOICED1
                        T4:
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
                        JMP CHOICEW

                        CHOICEW11:
                        MOV AH, 02H
                        MOV DL, 0DH
	                INT 21H
	                MOV DL, 0AH                ;next line
	                INT 21H
                        MOV AH, 07H            ;read character function
                        INT 21H             ;read a small letter into AL      
                        CMP AL, 'Y'
                        JE CHOICEW12
                        CMP AL, 'N'
                        JE CHOICEW1
                        JMP CHOICEW11
                        CHOICEW12:
                        mov      cx, word ptr NOA          ; lsb of number2 in cx  
                        mov      dx, word ptr NOA+2        ; msb of number1 in dx
                        JMP WITHDRAW_PROCESS
                CHOICEW2:
                        mov      cx, word ptr NOB          ; lsb of number2 in cx  
                        mov      dx, word ptr NOB+2        ; msb of number1 in dx
                        JMP WITHDRAW_PROCESS   
                CHOICEW3:
                        mov      cx, word ptr NOC          ; lsb of number2 in cx  
                        mov      dx, word ptr NOC+2        ; msb of number1 in dx
                        JMP WITHDRAW_PROCESS
                CHOICEW4:
                        mov      cx, word ptr NOD          ; lsb of number2 in cx  
                        mov      dx, word ptr NOD+2        ; msb of number1 in dx
                        JMP WITHDRAW_PROCESS
                CHOICEW5:
                        mov      cx, word ptr NOE          ; lsb of number2 in cx  
                        mov      dx, word ptr NOE+2        ; msb of number1 in dx
                        JMP WITHDRAW_PROCESS
                CHOICEW6:
                        mov      cx, word ptr NOF          ; lsb of number2 in cx  
                        mov      dx, word ptr NOF+2        ; msb of number1 in dx
                        JMP WITHDRAW_PROCESS
                CHOICEW7:
                        mov      cx, word ptr NOG          ; lsb of number2 in cx  
                        mov      dx, word ptr NOG+2        ; msb of number1 in dx
                        JMP WITHDRAW_PROCESS
                CHOICEW8:
                        mov      cx, word ptr NOH          ; lsb of number2 in cx  
                        mov      dx, word ptr NOH+2        ; msb of number1 in dx
                        JMP WITHDRAW_PROCESS
        
                WITHDRAW_PROCESS:
                        MOV      BX,word ptr BAL+2
                        MOV      AX,word ptr BAL
                        CMP      DX, BX
                        JA       XFUND
                        JE       CHK2
                        JB       WITHDRAW_PROCESS2
                        CHK2:
                        CMP      CX, AX
                        JA       XFUND
                WITHDRAW_PROCESS2:              
                        MOV      word ptr WIT, CX
                        MOV      word ptr WIT+2, DX   
                        mov      cx, word ptr WIT          ; lsb of number2 in cx  
                        mov      dx, word ptr WIT+2        ; msb of number1 in dx  
                        SUB      ax, cx                    ; sub subtract lsb - lsb, add for addition  
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
                LEA DX, W1        ;display string
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
             ADD  DL,30H   ;Turn into a character, from [0,9] to ["0","9"]
             MOV W99[SI],DL
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
                LEA DX, W99        ;display string
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
             ADD  DL,30H   ;Turn into a character, from [0,9] to ["0","9"]
             MOV W98[SI],DL
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
                LEA DX, W98        ;display string
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
             ADD  DL,30H   ;Turn into a character, from [0,9] to ["0","9"]
             MOV W97[SI],DL
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
                LEA DX, W97        ;display string
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
        ;-END OF WITHDRAW DISPLAY PAGE-;
                      
        ;-GET USER KEY PRESS-;
        MOV AH, 08H           ;wait for key press
        INT 21H                   
        ;-END OF USER KEY PRESS-;

        JMP LOGOUT

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
                        JMP CHOICEW1
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
                        JMP CHOICEW11
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
                        JMP CHOICED

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
                        mov      cx, word ptr NOA          ; lsb of number2 in cx  
                        mov      dx, word ptr NOA+2        ; msb of number1 in dx
                        JMP DEPOSIT_PROCESS
                CHOICED2:
                        mov      cx, word ptr NOB          ; lsb of number2 in cx  
                        mov      dx, word ptr NOB+2        ; msb of number1 in dx
                        JMP DEPOSIT_PROCESS   
                CHOICED3:
                        mov      cx, word ptr NOC          ; lsb of number2 in cx  
                        mov      dx, word ptr NOC+2        ; msb of number1 in dx
                        JMP DEPOSIT_PROCESS
                CHOICED4:
                        mov      cx, word ptr NOD          ; lsb of number2 in cx  
                        mov      dx, word ptr NOD+2        ; msb of number1 in dx
                        JMP DEPOSIT_PROCESS
                CHOICED5:
                        mov      cx, word ptr NOE          ; lsb of number2 in cx  
                        mov      dx, word ptr NOE+2        ; msb of number1 in dx
                        JMP DEPOSIT_PROCESS
                CHOICED6:
                        mov      cx, word ptr NOF          ; lsb of number2 in cx  
                        mov      dx, word ptr NOF+2        ; msb of number1 in dx
                        JMP DEPOSIT_PROCESS
                CHOICED7:
                        mov      cx, word ptr NOG          ; lsb of number2 in cx  
                        mov      dx, word ptr NOG+2        ; msb of number1 in dx
                        JMP DEPOSIT_PROCESS
                CHOICED8:
                        mov      cx, word ptr NOH          ; lsb of number2 in cx  
                        mov      dx, word ptr NOH+2        ; msb of number1 in dx
                        JMP DEPOSIT_PROCESS
                DEPOSIT_PROCESS:
                        MOV      BX,word ptr BAL+2
                        MOV      AX,word ptr BAL              
                        MOV      word ptr DEP, CX
                        MOV      word ptr DEP+2, DX   
                        mov      cx, word ptr DEP          ; lsb of number2 in cx  
                        mov      dx, word ptr DEP+2        ; msb of number1 in dx  
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
                     ADD  DL,30H   ;Turn into a character, from [0,9] to ["0","9"]
                     MOV W99[SI],DL
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
                LEA DX, W99        ;display string
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
             ADD  DL,30H   ;Turn into a character, from [0,9] to ["0","9"]
             MOV W98[SI],DL
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
                LEA DX, W98        ;display string
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
             ADD  DL,30H   ;Turn into a character, from [0,9] to ["0","9"]
             MOV W97[SI],DL
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
                LEA DX, W97        ;display string
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

                ;-GET USER KEY PRESS-;
                MOV AH, 08H           ;wait for key press
                INT 21H                   
                ;-END OF USER KEY PRESS-;

                JMP LOGOUT
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
                MOV PIN[SI],AL
                INC SI
                LOOP UPD_PIN

        ;-END OF PIN RESET-;

        ;-GET USER KEY PRESS-;
        MOV AH, 08H           ;wait for key press
        INT 21H    

        MOV AH, 09H
	LEA DX, EMPTY0        ;display string
	INT 21H               
        ;-END OF USER KEY PRESS-;

        JMP LOGOUT

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