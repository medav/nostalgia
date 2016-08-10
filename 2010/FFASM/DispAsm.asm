#include "ti83plus.inc"
#define bcall(xxxx) rst 28h \ .dw xxxx 
_homeup =4558h
.org _UserMem



main:


    ld hl,lout
    bcall(_Mov9ToOP1) ; OP1 = variable a

    bcall(_FindSym) ; look up
    jr NC   ; jump if variable is not
    
exists:
    ld a,b
    or a
    jp z,inram
    ld hl,errarch
    bcall(_PutS)
    jp end1
inram:
    ld (resadr),de

    bcall(_runIndicOff)
    
    jp DISP
   

resadr: .db 00h

lout:
    .db LISTOBJ,TVARLST,TL1,0,0
    
errarch:
    .db "Error, L1 is not in RAM",0
    


;----------------------------------------------------------------   
 
            
vstart: .db REALOBJ,"D",0,0  

vend: .db REALOBJ,"E",0,0  

nstart: .db 00h,00h,00h,00h,00h,00h,00h,00h,00h 

nend: .db 00h,00h,00h,00h,00h,00h,00h,00h,00h 


;-----------------------main function----------
DISP:
    ld (IY + sGrFlags),1
    
    ld hl,1
    push hl
    ld hl,1
    push hl
    
    
    ld hl,vstart
    bcall(_Mov9ToOP1)
    bcall(_FindSym)
    ex de,hl
    bcall(_Mov9ToOP1)
    
    ld de,nstart
    bcall(_MovFrOP1)
    
    ld hl,vend
    bcall(_Mov9ToOP1)
    bcall(_FindSym)
    ex de,hl
    bcall(_Mov9ToOP1)
    
    ld de,nend
    bcall(_MovFrOP1)
    
    

    
floop:
    
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
