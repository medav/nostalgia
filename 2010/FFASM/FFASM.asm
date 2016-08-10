#include "ti83plus.inc"
#define bcall(xxxx) rst 28h \ .dw xxxx 
_homeup =4558h
.org _UserMem


; A determines the operation, x and y will be returns
; B is used for activation and everything else will be input for the op
; a=0  --- test for validation
; a=1  --- activate 

main:


    ld hl,lout
    bcall(_Mov9ToOP1) ; OP1 = variable a

    bcall(_FindSym) ; look up
    jr C, Deleted ; jump if variable is not
    
    bcall(_DelVar)
Deleted:

    ld hl,0; size to create at
    bcall(_CREATERLIST) ; create it, HL = pointer to
    jr inram

inram:
    ld (resadr),de
    ld hl,msg
    bcall(_PutS)
    
    bcall(_runIndicOff)
    
    jp FFINDER
   

resadr: .db 00h

lout:
    .db LISTOBJ,TVARLST,TL1,0,0
    
msg:
    .db "Working...",0
msg2:
    .db "Invalid Input.",0
    


;----------------------------------------------------------------   
 
            
num: .db REALOBJ,"A",0,0  

number: .db 00h,00h,00h,00h,00h,00h,00h,00h,00h 

ct: .db 00h,00h,00h,00h,00h,00h,00h,00h,00h 


;-----------------------main function----------
FFINDER:
    
    ld hl,num
    bcall(_Mov9ToOP1)
    bcall(_FindSym)
    ex de,hl
    bcall(_Mov9ToOP1)
    ld a,0
    bcall(_SetXXOP2)
    bcall(_CpOP1OP2)
    jp z,end1
    
    ld de,number
    bcall(_MovFrOP1)
    
    bcall(_Frac)
    bcall(_OP1ToOP2)
    bcall(_OP1Set0)
    bcall(_CpOP1OP2)
    jp nz,err
    
    ld hl,number
    bcall(_Mov9ToOP1)
    
    bcall(_FPSquare)
    bcall(_SqRoot)
    bcall(_SqRoot)
    bcall(_Int)
    
    bcall(_Plus1)
    
    ld de,ct
    bcall(_MovFrOP1)
    

    
floop:
    ;-----------------Dec count
    ld hl,ct
    bcall(_Mov9ToOP1)
    
    bcall(_Minus1)
    
    ld de,ct
    bcall(_MovFrOP1)
    
    bcall(_OP2SET0)
   
    bcall(_CpOP1OP2)
    jp z,ffend        
    ;-----------------jump if end
    
    bcall(_OP1ToOP2);set up the divide
    
    ld hl,number
    bcall(_Mov9ToOP1)
    
    
    bcall(_FPDiv)
     
    ;------------------------------
    bcall(_Frac)
    bcall(_OP2SET0)
    
    bcall(_CpOP1OP2)
    jp z,pair
    
    
    jp floop
    
pair: 
    ld hl,ct
    bcall(_Mov9ToOP1)
    ld de,(resadr)
    bcall(_IncLstSize)
    bcall(_PutToL)
    
    
    jp floop
    
   
    
err:
    ld hl,msg2
    bcall(_NewLine)
    bcall(_PutS)
    bcall(_GetKey)
    
    jp ffend
 
  
    
ffend:
    
    bcall(_ClrScrnFull)
    jp end1


end1:
    bcall(_runIndicOn)
    ret
.end
