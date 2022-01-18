.MODEL SMALL
.STACK 100
.DATA
;-----MENU MSG
Menu1    DB 10,13,10,13,'                  ::::::HERE COME HAVE A RED BRICK NOODLES::::::$' ,10,13         
Menu2    DB 10,13,10,13,'                     :::          DELICIOUS MENU          :::   $' ,10,13
Menu3    DB 10,13,' ::::      1.SPAGHETTI WITH HOT DOG & MINCED CHICKEN                RM 4.50  ::::$' 
Menu4    DB 10,13,' ::::      2.HAKKA NOODLE WITH MUSHROOM & MINCED CHICKEN            RM 4.00  ::::$' 
Menu5    DB 10,13,' ::::      3.RAMEN SOUP WITH SMOKED DUCK BREAST                     RM 5.00  ::::$' 
Menu6    DB 10,13,' ::::      4.SZE CHUAN "TAN TAN" RAMEN                              RM 4.50  ::::$'
Menu7    DB 10,13,' ::::      5.RICE NOODLE SZE CHUAN MA LA SOUP WITH BOILED EGG       RM 5.50  ::::$' 
Menu8    DB 10,13,' ::::      6.KUAI TEOW SOUP WITH FISH BALL & SEAWEED                RM 4.00  ::::$' 
Menu9    DB 10,13,' ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::$' 

;-----INPUT MSG
ORDERMSG    DB 10,13,'ENTER YOUR ORDER NUMBER : $'
QUANTITYMSG DB 10,13,10,13,'ENTER YOUR QUANTITY(MAX. 9 PER ORDER) : $'
orderERRMSG      DB 10,13,'PLEASE ENTER A VALID ORDER NUMBER : $'
quantityERRMSG      DB 10,13,'PLEASE ENTER A VALID QUANTITY : $'
orderCheckERRMSG DB 10,13,'INVALID ORDER NUMBER, ENTER ONLY 1-6.'
CFMSG1      DB 10,13,10,13,'THE ORDER NUMBER ENTERED IS -> $'
CFMSG2      DB 10,13,10,13,'THE QUANTITY ENTERED IS -> $'
CFMSG3      DB 10,13,'ARE YOU SURE?(Y/N) $'

;-----RECEIPT MSG
R1  DB  'RED BRICK NOODLES STALL$',10,13,
R2  DB  10,13,'Jalan Tumbuhan, Tunku Abdul Rahman University College,$',10,13
R3  DB  10,13,'53100 Kuala Lumpur, Wilayah Persekutuan Kuala Lumpur, Malaysia.$',10,13
R4  DB  10,13,'--------------------------------------------------------------------------------$'
R5  DB  'QUEUE NO. : $'
R6  DB  10,13,'TYPE OF FOOD : $'
R7  DB  10,13,'QUANTITY     : $'
R8 DB 10,13,'PRICE        : $'
R9 DB 10,13,'TOTAL PRICE WITHOUT TAX       : $'
R10 DB 10,13,'TAX (10% SST)                 : $'
R11 DB 10,13,'TOTAL WITH TAX                : $'
R12 DB 10,13,'THANK YOU FOR DINING A WITH US!!!$'
R13 DB 10,13,'PLEASE COME AGAIN$'

;-----FOOD MSG
F1 DB 'SPAGHETTI WITH HOT DOG & MINCED CHICKEN$'
F2 DB 'HAKKA NOODLE WITH MUSHROOM & MINCED CHICKEN$'
F3 DB 'RAMEN SOUP WITH SMOKED DUCK BREAST$'
F4 DB 'SZE CHUAN "TAN TAN" RAMEN$'
F5 DB 'RICE NOODLE SZE CHUAN MA LA SOUP WITH BOILED EGG$'
F6 DB 'KUAI TEOW SOUP WITH FISH BALL & SEAWEED$'

;-----USER RATING MSG
UR1 DB 10,13,10,13,'HOW SATISFIED ARE YOU USING OUR SERVICE?$'
UR2 DB 10,13,'PLEASE RATE ON A SCALE OF 1-5: $'
ERR_MSG DB 10,13,'INVALID INPUT, PLEASE ENTER AGAIN $'    

;-----SALES REPORT MSG
SR1 DB 10,13,10,13,'SALES REPORT$'
SR2 DB 10,13,'TOTAL RATING TODAY   : $'
SR3 DB 10,13,'TOTAL ORDER TODAY    : $'
SR4 DB 10,13,'AVERAGE RATING TODAY : $'

;-----TIME MSG
PROMPT  DB  'Current System Time is : $'     
TIME    DB  '00:00:00$'        ; time format hr:min:sec

;-----VARIABLE
order DB 0
quantity DB 0
noSubtotal1 DB 0
noSubtotal2 DB 0
noSubtotal3 DB 0 
noSubtotal4 DB 0
queueNo DW 0
queueNo_1 DB 0
queueNo_2 DB 0
queueNo_3 DB 0  
userRating DB 0
userRating_1 DB 0
userRating_2 DB 0
userRating_3 DB 0
avgRatingNo1 DB 0
avgRatingNo2 DB 0
avgRatingNo3 DB 0
 
;----CONSTANT
TEN DB 10
HUNDRED DB 100
NL DB 13,10, "$"

.CODE
MAIN PROC
 MOV AX,@DATA
 MOV DS,AX
 
;----------SETUP LOOP
 MOV CX,displayMenu
 MOV BX,printReceipt

;----------DISPLAY COLOR
 MOV AH, 06h    ; Scroll up function
 XOR AL, AL     ; Clear entire screen
 XOR CX, CX     ; Upper left corner CH=row, CL=column
 MOV DX, 184FH  ; lower right corner DH=row, DL=column 
 MOV BH, 1Eh    ; YellowOnBlue
 INT 10H     
 
;----------DISPLAY MENU

displayMenu:
;---OUTPUT INTRO 
MOV AH,09H
LEA DX,Menu1
INT 21H

;---OUTPUT TITLE
MOV AH,09H 
LEA DX,Menu2
INT 21H    

;---OUTPUT BOX LINE
MOV AH,09H
LEA DX,Menu9
INT 21H

;---OUTPUT MENU
 MOV AH,09H
 LEA DX,Menu3 
 INT 21H

 MOV AH,09H
 LEA DX,Menu4
 INT 21H

 MOV AH,09H
 LEA DX,Menu5
 INT 21H

 MOV AH,09H
 LEA DX,Menu6
 INT 21H

 MOV AH,09H
 LEA DX,Menu7
 INT 21H

 MOV AH,09H
 LEA DX,Menu8
 INT 21H 

 MOV AH,09H
 LEA DX,Menu9
 INT 21H

 MOV AH,09H
 LEA DX,ORDERMSG
 INT 21H

;----------GET ORDER
getOrder:
 MOV AH,01H      
 INT 21H 
 MOV order,AL
 
 CMP AL,78H       ; check if user input 'x'
 JE salesReport   ; display sales report 
 
 CMP AL,58H       ; check if user input 'X'
 JE salesReport   ; display sales report 
 
showOrder:
 MOV AH,09H
 LEA DX,CFMSG1
 INT 21H
 
 MOV AH,02H
 MOV DL,order
 INT 21H
 
 MOV AH,09H
 LEA DX,CFMSG3
 INT 21H
 
 MOV AH,01H
 INT 21H
 
orderCheckYN:
 CMP AL,59H
 JE checkOrder
 
 CMP AL,79H
 JE checkOrder
 
 CMP AL,4EH
 JE getOrderMessage
 
 CMP AL,6EH
 JE getOrderMessage

orderERRMesage:
 MOV AH,09H
 LEA DX,orderERRMSG
 INT 21H    
 JMP getOrder
 
getOrderMessage:
 MOV AH,09H
 LEA DX,NL
 INT 21H
 
 MOV AH,09H
 LEA DX,ORDERMSG
 INT 21H

 JMP getOrder
 
;-----------CHK ORDER
checkOrder:
 CMP order,31H
 JL orderERR  
 CMP order,36H
 JG orderERR
 
 JMP getQuantity  
 
orderERR:
 MOV AH,09H
 LEA DX,orderCheckERRMSG
 INT 21H
 JMP getOrder
 
;-----------GET QUANTITY     
     
getQuantity:
 MOV AH,09H
 LEA DX,QUANTITYMSG
 INT 21H
 
 MOV AH,01H
 INT 21H
 MOV quantity,AL 
 
showQuantity:
 MOV AH,09H
 LEA DX,CFMSG2
 INT 21H
 
 MOV AH,02H
 MOV DL,quantity
 INT 21H
 
 MOV AH,09H
 LEA DX,CFMSG3
 INT 21H
 
 MOV AH,01H
 INT 21H 

quantityCheckYN:
 CMP AL,59H
 JE checkQuantity
 
 CMP AL,79H
 JE checkQuantity
 
 CMP AL,4EH
 JE getQuantity
 
 CMP AL,6EH
 JE getQuantity
 
 JMP quantityERR

quantityERRMesage:
 MOV AH,09H
 LEA DX,quantityERRMSG
 INT 21H
 
 JMP getQuantity

;-----------CHK QUANTITY
checkQuantity:
 CMP order,31H
 JL quantityERR  
 CMP order,36H
 JG quantityERR
 
 JMP checkTotalPrice  
 
quantityERR:
 MOV AH,09H
 LEA DX,quantityERRMSG
 INT 21H        
 
 JMP getQuantity       
  
;----------CHECK FOR SUBTOTAL
checkTotalPrice:
 CMP order,31H
 JE price450  
 
 CMP order,32H
 JE price400  
 
 CMP order,33H
 JE price500  
 
 CMP order,34H
 JE price450
 
 CMP order,35H
 JE price550
   
 CMP order,36H
 JE price400

;----------CALC SUBTOTAL
price400:
 MOV AX,0 
 MOV AL,quantity
 SUB AL,30H
 MOV BL,4
 MUL BL
 
 DIV TEN
 MOV noSubtotal1,AL 
 MOV noSubtotal2,AH
 MOV noSubtotal3,0
 MOV noSubtotal4,0
 
 JMP printReceipt     
                        
price450:
 MOV AX,0
 MOV AL,quantity
 SUB AL,30H
 MOV BL,4
 MUL BL
 DIV TEN
 MOV noSubtotal1,AL ;move quotient to the first digit
 MOV noSubtotal2,AH ;move remainder to the second digit
 
 MOV AX,0
 MOV AL,quantity
 SUB AL,30H
 MOV BL,50
 MUL BL
 DIV TEN
 DIV TEN
 ADD noSubtotal2,AL ;add quotient to the second digit
 MOV noSubtotal3,AH ;move remainder to the third digit
 MOV noSubtotal4,0
 
 CMP noSubtotal2,9H ;if second digit greater than 9, eg. 10/11/12/13
 JG addtoFront_450 ;jump to addtoFront
 
 JMP printReceipt
 
addtoFront_450: ;this is to add to the first digit when second digit exceeds ten 
 MOV AX,0
 MOV AL,noSubtotal2
 DIV TEN
 ADD noSubtotal1,AL ;add quotient to the first digit
 MOV noSubtotal2,AH ;move remainder to the second digit

 JMP printReceipt

price500:
 MOV AX,0
 MOV AL,quantity
 SUB AL,30H
 MOV BL,5
 MUL BL
 
 DIV TEN
 MOV noSubtotal1,AL
 MOV noSubtotal2,AH
 MOV noSubtotal3,0 
 MOV noSubtotal4,0
 
 JMP printReceipt

price550:
 MOV AX,0
 MOV AL,quantity
 SUB AL,30H
 MOV BL,5
 MUL BL
 DIV TEN
 MOV noSubtotal1,AL
 MOV noSubtotal2,AH
 
 MOV AX,0
 MOV AL,quantity
 SUB AL,30H
 MOV BL,50
 MUL BL
 DIV TEN
 DIV TEN
 ADD noSubtotal2,AL ;add quotient to the second digit
 MOV noSubtotal3,AH ;move remainder to the third digit 
 MOV noSubtotal4,0
 
 CMP noSubtotal2,9H ;if second digit greater than 9, eg. 10/11/12/13
 JG addtoFront_550 ;jump to addtoFront
 
 JMP printReceipt
 
addtoFront_550: ;this is to add to the first digit when second digit exceeds ten 
 MOV AX,0
 MOV AL,noSubtotal2
 DIV TEN
 ADD noSubtotal1,AL ;add quotient to the first digit
 MOV noSubtotal2,AH ;move remainder to the second digit

 JMP printReceipt
 
;----------RECEIPT
printReceipt:
;---OUTPUT NEW LINE
 MOV AH,09H
 LEA DX,NL
 INT 21H
 MOV AH,09H
 LEA DX,NL
 INT 21H 
 
;---LINE
 MOV AH,09H
 LEA DX,R4
 INT 21H
 
;---OUTPUT NEW LINE
 MOV AH,09H
 LEA DX,NL
 INT 21H
 MOV AH,09H
 LEA DX,NL
 INT 21H

;---OUTPUT STALL NAME
 MOV AH,09H
 LEA DX,R1
 INT 21H 

;---ADDRESS A
 MOV AH,09H
 LEA DX,R2
 INT 21H

;---ADDRESS B
 MOV AH,09H
 LEA DX,R3
 INT 21H
                                       
;---DATE
 MOV AH,09H    ; Newline
 LEA DX,NL
 INT 21H
 
 MOV AH,09H    ; Newline
 LEA DX,NL
 INT 21H

;Day Part
DAY:
 MOV AH,2AH    ; To get System Date
 INT 21H
 MOV AL,DL     ; Day is in DL
 AAM
 MOV BX,AX
 CALL DISP

 MOV DL,'/'
 MOV AH,02H    ; To Print / in DOS
 INT 21H

;Month Part
MONTH:
 MOV AH,2AH    ; To get System Date
 INT 21H
 MOV AL,DH     ; Month is in DH
 AAM
 MOV BX,AX
 CALL DISP

 MOV DL,'/'    ; To Print / in DOS
 MOV AH,02H
 INT 21H

;Year Part
YEAR:
 MOV AH,2AH    ; To get System Date
 INT 21H
 
 ADD CX,0F830H ; To negate the effects of 16bit value,
 MOV AX,CX     ; since AAM is applicable only for AL (YYYY -> YY)
 AAM
 MOV BX,AX
 CALL DISP

;---TIME
 MOV AH,09H                   ; newline
 LEA DX,NL
 INT 21H

 LEA BX, TIME                 ; BX=offset address of string TIME

 CALL GET_TIME                ; call the procedure GET_TIME

 LEA DX, PROMPT               ; DX=offset address of string PROMPT
 MOV AH, 09H                  ; print the string PROMPT
 INT 21H                      

 LEA DX, TIME                 ; DX=offset address of string TIME
 MOV AH, 09H                  ; print the string TIME
 INT 21H                      

;---LINE
 MOV AH,09H
 LEA DX,R4
 INT 21H

;---QUEUE N0
 MOV AH,09H
 LEA DX,R5                                             
 INT 21H
 
 ADD queueNo,1               ; to start queueNo from 1                                               
 
 CMP queueNo,9               ; check if more than 1 digit
 JG twoDigit_queueNo          
 
 CMP queueNo,99              ; check if more than 2 digits 
 JG threeDigit_queueNo
 
 ADD queueNo,30H             ; queueNo under 10 so no need to display 2digits
 MOV DX,queueNo
 MOV AH,02H
 INT 21H
 
 JMP CONT
 
twoDigit_queueNo:
 SUB AX,AX                    ; clear AX
 
 MOV AX,queueNo
 DIV TEN
 MOV queueNo_1, AL            ; store quotient into first digit
 MOV queueNo_2, AH            ; store remainder into second digit
 
 ADD queueNo,30H
 ADD queueNo_1, 30H
 ADD queueNo_2, 30H          
 
 MOV DL,queueNo_1             ; display the first digit of queue no.
 MOV AH,02H
 INT 21H   
 
 MOV DL,queueNo_2             ; display second digit of queue no.
 MOV AH,02H
 INT 21H

 JMP CONT       
        
threeDigit_queueNo:
 SUB AX,AX                    ; clear AX

 MOV AX,queueNo
 DIV TEN
 MOV queueNo_2, AL            ; store quotient into second digit
 MOV queueNo_3, AH            ; store remainder into third digit
                   
 SUB AX,AX
 MOV AL,queueNo_2
 DIV TEN
 MOV queueNo_1,AL             ; store quotient into first digit
 MOV queueNo_2,AH             ; store remainder into second digit
 
 ADD queueNo,30H
 ADD queueNo_1,30H
 ADD queueNo_2,30H
 ADD queueNo_3,30H                            
 
 MOV DL,queueNo_1             ; display first digit of queue no.
 MOV AH,02H
 INT 21H   
 
 MOV DL,queueNo_2             ; display second digit of queue no.
 MOV AH,02H
 INT 21H
 
 MOV DL,queueNo_3             ; display third digit of queue no.
 MOV AH,02H
 INT 21H       
        
 JMP CONT   
    
;---LINE
CONT:
 MOV AH,09H
 LEA DX,R4
 INT 21H

;---TYPE OF FOOD
 MOV AH,09H
 LEA DX,R6
 INT 21H
 
CHKFOOD:        ;check the order number  
 CMP order,31H  ;if order number = 1
 JE displayF1   ;jump to displayF1
 
 CMP order,32H
 JE displayF2

 CMP order,33H
 JE displayF3
 
 CMP order,34H
 JE displayF4
 
 CMP order,35H
 JE displayF5
 
 CMP order,36H
 JE displayF6

displayF1:    ;display the food number1
 MOV AH,09H
 LEA DX,F1
 INT 21H
 
 JMP displayQuantity
 
displayF2:
 MOV AH,09H
 LEA DX,F2
 INT 21H   
 
 JMP displayQuantity
 
displayF3:
 MOV AH,09H
 LEA DX,F3
 INT 21H 
 
 JMP displayQuantity
 
displayF4:
 MOV AH,09H
 LEA DX,F4
 INT 21H
 
 JMP displayQuantity  
 
displayF5:
 MOV AH,09H
 LEA DX,F5
 INT 21H 
 
 JMP displayQuantity 
 
displayF6:
 MOV AH,09H
 LEA DX,F6
 INT 21H    
 
 JMP displayQuantity

;---QUANTITY
displayQuantity: 
 MOV AH,09H
 LEA DX,R7
 INT 21H
 
 MOV AH,02H
 MOV DL,quantity
 INT 21H

;---PRICE
 MOV AH,09H
 LEA DX,R8
 INT 21H
 
CHKPRICE:          
 CMP order,32H
 JE displayPrice400
 
 CMP order,36H
 JE displayPrice400

 CMP order,31H
 JE displayPrice450
 
 CMP order,34H
 JE displayPrice450
 
 CMP order,33H
 JE displayPrice500
 
 CMP order,35H
 JE displayPrice550
 
displayPrice400:
 MOV AH,02H
 MOV DL,52H
 INT 21H
 
 MOV AH,02H
 MOV DL,4DH
 INT 21H
 
 MOV AH,02H
 MOV DL,34H
 INT 21H
 
 MOV AH,02H
 MOV DL,2EH
 INT 21H
 
 MOV AH,02H
 MOV DL,30H
 INT 21H
 
 MOV AH,02H
 MOV DL,30H
 INT 21H
 
 JMP totalNoTax
 
displayPrice450:
 MOV AH,02H
 MOV DL,52H
 INT 21H
 
 MOV AH,02H
 MOV DL,4DH
 INT 21H
 
 MOV AH,02H
 MOV DL,34H
 INT 21H
 
 MOV AH,02H
 MOV DL,2EH
 INT 21H
 
 MOV AH,02H
 MOV DL,35H
 INT 21H
 
 MOV AH,02H
 MOV DL,30H
 INT 21H     
 
 JMP totalNoTax
 
displayPrice500:
 MOV AH,02H
 MOV DL,52H
 INT 21H
 
 MOV AH,02H
 MOV DL,4DH
 INT 21H
 
 MOV AH,02H
 MOV DL,35H
 INT 21H
 
 MOV AH,02H
 MOV DL,2EH
 INT 21H
 
 MOV AH,02H
 MOV DL,30H
 INT 21H
 
 MOV AH,02H
 MOV DL,30H
 INT 21H     
 
 JMP totalNoTax
 
displayPrice550:
 MOV AH,02H
 MOV DL,52H
 INT 21H
 
 MOV AH,02H
 MOV DL,4DH
 INT 21H
 
 MOV AH,02H
 MOV DL,35H
 INT 21H
 
 MOV AH,02H
 MOV DL,2EH
 INT 21H
 
 MOV AH,02H
 MOV DL,35H
 INT 21H
 
 MOV AH,02H
 MOV DL,30H
 INT 21H     
 
 JMP totalNoTax

;---TOTAL PRICE WITHOUT TAX 
totalNoTax:
 MOV AH,09H  
 LEA DX,R9   ;print string R9
 INT 21H  
 
 MOV AH,02H
 MOV DL,52H   ;output 'R'
 INT 21H
 
 MOV AH,02H
 MOV DL,4DH   ;output 'M'
 INT 21H
              
 ADD noSubtotal1,30H
 MOV AH,02H
 MOV DL,noSubtotal1   ;output firstdigit
 INT 21H
 
 ADD noSubtotal2,30H
 MOV AH,02H
 MOV DL,noSubtotal2   ;output seconddigit
 INT 21H
 
 MOV AH,02H
 MOV DL,2EH           ;output '.'
 INT 21H
 
 ADD noSubtotal3,30H
 MOV AH,02H
 MOV DL,noSubtotal3   ;output thirddigit
 INT 21H
    
 ADD noSubtotal4,30H  
 MOV AH,02H
 MOV DL,noSubtotal4          ;output fourthdigit
 INT 21H

;---TAX
 MOV AH,09H
 LEA DX,R10
 INT 21H
 
 MOV AH,02H
 MOV DL,52H   ;output 'R'
 INT 21H
 
 MOV AH,02H
 MOV DL,4DH   ;output 'M'
 INT 21H
              
 MOV AH,02H
 MOV DL,noSubtotal1   ;output firstdigit
 INT 21H
 
 MOV AH,02H
 MOV DL,2EH           ;output '.'
 INT 21H
 
 MOV AH,02H
 MOV DL,noSubtotal2   ;output seconddigit
 INT 21H
 
 MOV AH,02H
 MOV DL,noSubtotal3   ;output thirddigit
 INT 21H
 
;---TOTAL WITH TAX
 MOV AH,09H
 LEA DX,R11
 INT 21H 
 
calcTotalTax:
 SUB AX,AX     ;clear AX reg
 SUB noSubtotal1,30H     ;convert back to decimal for calculation
 SUB noSubtotal2,30H
 SUB noSubtotal3,30H
 SUB noSubtotal4,30H        
 
fourthDigit:
 MOV AX,0
 MOV AL,noSubtotal4
 ADD AL,noSubtotal3
 MOV noSubtotal4,AL 

thirdDigit:
 MOV AX,0            ;clear AX for calculation        
 MOV AL,noSubtotal3  
 ADD AL,noSubtotal2  ;add third digit to second digit
 MOV noSubtotal3,AL    
 
CHK_if0AH_ns3:
 CMP noSubtotal3,0AH
 JE specialCase_ns3

CHK_if0AH_ns2:    
 CMP noSubtotal2,0AH
 JE specialCase_ns2
 
CHK_addtoFront_ns2:
 CMP noSubtotal3,9H ;if third digit greater than 9, eg. 10/11/12/13
 JG addtoFront_noSubtotal2 ;jump to addtoFront_noSubtotal2 

secondDigit: 
 MOV AX,0                   
 MOV AL,noSubtotal2
 ADD AL,noSubtotal1  ;add second digit to first digit
 MOV noSubtotal2,AL                                         
 
CHK_if0AH_ns1:
 CMP noSubtotal1,0AH
 JE specialCase_ns1
 
CHK_addtoFront_ns1:
 CMP noSubtotal2,9H ;if second digit greater than 9, eg. 10/11/12/13
 JG addtoFront_noSubtotal1 ;jump to addtoFront_noSubtotal1  
                             
 JMP display_totalTax  
       
addtoFront_noSubtotal2: ;this is to add to the second digit when third digit exceeds ten 
 MOV AL,noSubtotal3
 DIV TEN
 ADD noSubtotal2,AL ;add quotient to the second digit
 MOV noSubtotal3,AH ;move remainder to the third digit 
 
 JMP CHK_addtoFront_ns2

addtoFront_noSubtotal1: ;this is to add to the first digit when second digit exceeds ten 
 MOV AL,noSubtotal2
 DIV TEN
 ADD noSubtotal1,AL ;add quotient to the first digit
 MOV noSubtotal2,AH ;move remainder to the second digit 
 
 JMP CHK_addtoFront_ns1  
                
specialCase_ns3:
 DIV TEN
 ADD noSubtotal2,AL ;add 1(Quotient) to front
 MOV noSubtotal3,0  ;replace with 0 since already add to front 
 
 JMP CHK_if0AH_ns3                
                
specialCase_ns2:   
 DIV TEN
 ADD noSubtotal1,AL ;add 1(Quotient) to front
 MOV noSubtotal2,0  ;replace with 0 since already add to front
 
 JMP CHK_if0AH_ns2

specialCase_ns1:
 DIV TEN
 MOV noSubtotal1,AL
 
 JMP CHK_if0AH_ns1
 
display_totalTax:
 ADD noSubtotal1,30H   ;convert back to hex for output
 ADD noSubtotal2,30H
 ADD noSubtotal3,30H
 ADD noSubtotal4,30H                                  
 
 MOV AH,02H
 MOV DL,52H   ;output 'R'
 INT 21H
 
 MOV AH,02H
 MOV DL,4DH   ;output 'M'
 INT 21H
 
 MOV AH,02H
 MOV DL,noSubtotal1    ;output firstDigit
 INT 21H
 
 MOV AH,02H
 MOV DL,noSubtotal2    ;output secondDigit
 INT 21H
 
 MOV AH,02H
 MOV DL,2EH   ;output '.'
 INT 21H          
 
 MOV AH,02H
 MOV DL,noSubtotal3    ;output thirdDigit
 INT 21H
 
 MOV AH,02H
 MOV DL,noSubtotal4    ;output fourthDigit
 INT 21H

;---GREETING
 MOV AH,09H
 LEA DX,R12
 INT 21H

 MOV AH,09H
 LEA DX,R13
 INT 21H  

;---USER RATING   
userRating_input:             
 MOV AH,09H       ; output first message
 LEA DX,UR1
 INT 21H
 
 MOV AH,09H       ; output second message
 LEA DX,UR2
 INT 21H
 
 MOV AH,01H       ; take input from user
 INT 21H
                   
 CMP AL,35H
 JG ERR_INPUT
 
 CMP AL,31H
 JL ERR_INPUT                 
                   
 SUB AL,30H
 ADD userRating,AL
                  
 JMP loopProg                 
                  
ERR_INPUT:
 MOV AH,09H
 LEA DX,ERR_MSG
 INT 21H
 
 JMP userRating_input      
 
;---LOOP
loopProg: 
 INC SI
 MOV queueNo,SI
 LOOP displayMenu
 MOV AH,0
 INT 16H
 RET ; stop

salesReport: 
 MOV AH,09H
 LEA DX,R4   ; output line
 INT 21H
   
 MOV AH,09H 
 LEA DX,SR1  ; output SR1 sales report message
 INT 21H
 
 MOV AH,09H
 LEA DX,R4   ; output line
 INT 21H   
  
;Display Total Rating  
  
 MOV AH,09H
 LEA DX,SR2  ; output SR2 (Total Rating)
 INT 21H
 
 CMP userRating,9       ; if Total Rating is 2 digit
 JG displayUR_2digit
 
 CMP userRating,99      ; if Total Rating is 3 digit
 JG displayUR_3digit
 
 JMP displayUR_1digit
 
displayUR_2digit:
 SUB AX,AX              ; Clear AX
 MOV AL,userRating         
 DIV TEN
 MOV userRating_1,AL       ; Store Quotient to first digit
 MOV userRating_2,AH       ; Store Remainder to second digit
 
 ADD userRating_1,30H
 ADD userRating_2,30H
 
 MOV DL,userRating_1 
 MOV AH,02H
 INT 21H
 
 MOV DL,userRating_2
 MOV AH,02H
 INT 21H
 
 JMP displayQueueNo

displayUR_3digit:
 SUB AX,AX              ; Clear AX
 MOV AL,userRating         
 DIV TEN
 MOV userRating_2,AL       ; Store Quotient to second digit
 MOV userRating_3,AH       ; Store Remainder to third digit
 
 DIV TEN
 MOV userRating_1,AL       ; Store Quotient to first digit
 MOV userRating_2,AH       ; Store Remainder to second digit
 
 ADD userRating_1,30H
 ADD userRating_2,30H
 ADD userRating_3,30H
 
 MOV DL,userRating_1 
 MOV AH,02H
 INT 21H
 
 MOV DL,userRating_2
 MOV AH,02H
 INT 21H        
 
 MOV DL,userRating_3
 MOV AH,02H
 INT 21H
 
 JMP displayQueueNo
 
displayUR_1digit: 
 ADD userRating,30H             
 MOV DL,userRating ; if queueNo less than 10
 MOV AH,02H
 INT 21H
 
 JMP displayQueueNo

;Display Total Order
 
displayQueueNo: 
 MOV AH,09H
 LEA DX,SR3
 INT 21H
 
 CMP queueNo,9
 JG displayQN_2digit
 
 CMP queueNo,99
 JG displayQN_3digit
 
 JMP displayQN_1digit
              
displayQN_2digit:
 SUB AX,AX              ; Clear AX
 SUB queueNo,30H        ; Convert HEX to DEC for calc
 MOV AX,queueNo         
 DIV TEN
 MOV queueNo_1,AL       ; Store Quotient to first digit
 MOV queueNo_2,AH       ; Store Remainder to second digit
 
 ADD queueNo_1,30H
 ADD queueNo_2,30H
 
 MOV DL,queueNo_1 
 MOV AH,02H
 INT 21H
 
 MOV DL,queueNo_2
 MOV AH,02H
 INT 21H
 
 JMP calcAvgRating

displayQN_3digit:
 SUB AX,AX              ; Clear AX
 SUB queueNo,30H        ; Convert HEX to DEC for calc
 MOV AX,queueNo         
 DIV TEN
 MOV queueNo_2,AL       ; Store Quotient to second digit
 MOV queueNo_3,AH       ; Store Remainder to third digit
 
 DIV TEN
 MOV queueNo_1,AL       ; Store Quotient to first digit
 MOV queueNo_2,AH       ; Store Remainder to second digit
 
 ADD queueNo_1,30H
 ADD queueNo_2,30H
 ADD queueNo_3,30H
 
 MOV DL,queueNo_1 
 MOV AH,02H
 INT 21H
 
 MOV DL,queueNo_2
 MOV AH,02H
 INT 21H        
 
 MOV DL,queueNo_3
 MOV AH,02H
 INT 21H
 
 JMP calcAvgRating
 
displayQN_1digit:
 ADD queueNo,30H              
 MOV DX,queueNo ; if queueNo less than 10
 MOV AH,02H
 INT 21H
 
 JMP calcAvgRating
 
;---CALC avgRating
calcAvgRating:
 MOV AH,09H
 LEA DX,SR4  ; output SR4 sales report message
 INT 21H
  
 MOV AX,0
 MOV AL,userRating
 SUB queueNo,30H       ; convert HEX to DEC for calc
 MOV BX,queueNo     
 DIV BL
 MOV avgRatingNo1,AL   ; get avgRatingNo1
 MOV avgRatingNo2,AH   
 
 SUB AX,AX      
 MOV AL,avgRatingNo2   ; further division for second digit
 MUL TEN 
 DIV BL                ; divide queueNo
 MOV avgRatingNo2,AL
 MOV avgRatingNo3,AH
 
 SUB AX,AX
 MOV AL,avgRatingNo3   ; further division for third digit
 MUL TEN  
 DIV BL                ; divide queueNo
 MOV avgRatingNo3,AL                           
 
 ADD avgRatingNo1,30H  ; convert avgRating to hex for output          
 ADD avgRatingNo2,30H
 ADD avgRatingNo3,30H                       
 
displayAvgRating:
 MOV DL,avgRatingNo1   ; print averageRatingNo1          
 MOV AH,02H
 INT 21H             
 
 MOV DL,2EH            ; print '.'
 MOV AH,02H
 INT 21H                      
 
 MOV DL,avgRatingNo2   ; print averageRatingNo2
 MOV AH,02H
 INT 21H
 
 MOV DL,avgRatingNo3   ; print averageRatingNo3
 MOV AH,02H
 INT 21H                                    
        
 MOV AH,4CH            ; exit program
 INT 21H

MAIN ENDP

;**************************************************************************;
;**************************************************************************;
;-------------------------  Procedure Definitions  ------------------------;
;**************************************************************************;
;**************************************************************************;

;**************************************************************************;
;------------------------------  GET_TIME  --------------------------------;
;**************************************************************************;

GET_TIME PROC
 ; this procedure will get the current system time 
 ; input : BX=offset address of the string TIME
 ; output : BX=current time

 PUSH AX                       ; PUSH AX onto the STACK
 PUSH CX                       ; PUSH CX onto the STACK 

 MOV AH, 2CH                   ; get the current system time
 INT 21H                       

 MOV AL, CH                    ; set AL=CH , CH=hours
 CALL CONVERT                  ; call the procedure CONVERT
 MOV [BX], AX                  ; set [BX]=hr  , [BX] is pointing to hr
                               ; in the string TIME

 MOV AL, CL                    ; set AL=CL , CL=minutes
 CALL CONVERT                  ; call the procedure CONVERT
 MOV [BX+3], AX                ; set [BX+3]=min  , [BX] is pointing to min
                               ; in the string TIME
                                           
 MOV AL, DH                    ; set AL=DH , DH=seconds
 CALL CONVERT                  ; call the procedure CONVERT
 MOV [BX+6], AX                ; set [BX+6]=min  , [BX] is pointing to sec
                               ; in the string TIME
                                                      
 POP CX                        ; POP a value from STACK into CX
 POP AX                        ; POP a value from STACK into AX

 RET                           ; return control to the calling procedure
GET_TIME ENDP                  ; end of procedure GET_TIME

 ;**************************************************************************;
 ;-------------------------------  CONVERT  --------------------------------;
 ;**************************************************************************;

CONVERT PROC 
 ; this procedure will convert the given binary code into ASCII code
 ; input : AL=binary code
 ; output : AX=ASCII code

 PUSH DX                       ; PUSH DX onto the STACK 

 MOV AH, 0                     ; set AH=0
 MOV DL, 10                    ; set DL=10
 DIV DL                        ; set AX=AX/DL
 OR AX, 3030H                  ; convert the binary code in AX into ASCII

 POP DX                        ; POP a value from STACK into DX 

 RET                           ; return control to the calling procedure
CONVERT ENDP                   ; end of procedure CONVERT 

 ;**************************************************************************;
 ;--------------------------------  DISP  ----------------------------------;
 ;**************************************************************************;

DISP PROC
 MOV DL,BH      ; Since the values are in BX, BH Part
 ADD DL,30H     ; ASCII Adjustment
 MOV AH,02H     ; To Print in DOS
 INT 21H
 
 MOV DL,BL      ; BL Part 
 ADD DL,30H     ; ASCII Adjustment
 MOV AH,02H     ; To Print in DOS
 INT 21H
 
 RET
DISP ENDP      ; End Disp Procedure

 ;**************************************************************************;
 ;--------------------------------------------------------------------------;
 ;**************************************************************************;

 END MAIN