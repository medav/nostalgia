#include "ti83plus.inc"
#define bcall(xxxx) rst 28h \ .dw xxxx 
_homeup =4558h
.org _UserMem


; A determines the operation, x and y will be returns
; B is used for activation and everything else will be input for the op
; a=0  --- test for validation
; a=1  --- activate 

; a=2  --- area of tri by SAS                           aot1
; a=3  --- area of tri by ASA                           aot2
; a=4  --- area of tri by AAS                           aot3
; a=5  --- area of tri by SSS                           aot4

; a=6  --- sides+angles (in lists) of a tri with SAS    sal1
; a=7  --- sides+angles (in lists) with ASA             sal2
; a=8  --- sides+angles (in lists) with ASA             sal3
; a=9  --- angles with SSS                              sal4

; a=10 --- solve law of cosine for angle                loc1
; a=11 --- solve law of cosine for side                 loc2
; a=12 --- solve law of sine for angle                  los1
; a=13 --- solve law of sine for side                   los2






main:
    ld hl,Operation
    bcall(_Mov9ToOP1);put name in OP1
    bcall(_FindSym)
    ex de,hl
    bcall(_Mov9ToOP1)
    
    
    ld a,1
    bcall(_SetXXOP2)
    bcall(_CpOP1OP2)
    jp z,activate
    
    
    ld a,0
    bcall(_SetXXOP2)
    bcall(_CpOP1OP2)
    jp z,test
     
    bcall(_OP1ToOP6)
    
    call validate
    ld a,1
    cp l
    jp nz, end1
    
    bcall(_OP6ToOP1)
    
    ld a,2
    bcall(_SetXXOP2)
    bcall(_CpOP1OP2)
    jp z,aot1
    
    ld a,3
    bcall(_SetXXOP2)
    bcall(_CpOP1OP2)
    jp z,aot2
    
    
    
    jp end1

Operation:
    .db REALOBJ,"A",0,0


msg:
    .db "By Mike Davies",0
  
    

  
arg1:
    .db REALOBJ,"D",0,0
arg2:
    .db REALOBJ,"E",0,0
arg3:
    .db REALOBJ,"F",0,0
  
  
      
test:
    call validate
    ld a,1
    cp l
    jp nz, nval
    ld a,1
    bcall(_SetXXOP1)
    bcall(_StoX)
    ret
nval:
    ld a,0
    bcall(_SetXXOP1)
    bcall(_StoX)
    ret
  
    
        
aot1:
    
    
    
    ld hl,arg2
    bcall(_Mov9ToOP1)
    bcall(_FindSym)
    ex de,hl
    bcall(_Mov9ToOP1)
    bcall(_Sin)
    bcall(_OP1ToOP6)
    
    
    ld hl,arg1
    bcall(_Mov9ToOP1)
    bcall(_FindSym)
    ex de,hl
    bcall(_Mov9ToOP1)
    bcall(_OP6ToOP2)
    bcall(_FPMult)
    
    bcall(_OP1ToOP6)
    
    ld hl,arg3
    bcall(_Mov9ToOP1)
    bcall(_FindSym)
    ex de,hl
    bcall(_Mov9ToOP1)
    bcall(_OP6ToOP2)
    bcall(_FPMult)
    bcall(_OP1ToOP6)
    ld a,2
    bcall(_SetXXOP1)
    bcall(_OP1ToOP2)
    bcall(_OP6ToOP1)

    bcall(_FPDiv)
    
    bcall(_StoX)
    jp end1
    
    
    
    
    
aot2:

    ld hl,arg1
    bcall(_Mov9ToOP1)
    bcall(_FindSym)
    ex de,hl
    bcall(_Mov9ToOP1)
    ld a,90
    bcall(_SetXXOP2)
    bcall(_FPSub)
    bcall(_OP1ToOP6)
    
    ld hl,arg2
    bcall(_Mov9ToOP1)
    bcall(_FindSym)
    ex de,hl
    bcall(_Mov9ToOP1)
    bcall(_OP6ToOP2)
    bcall(_FPAdd)
    bcall(_Tan)
    bcall(_OP1ToOP6)
    
    ld hl,arg2
    bcall(_Mov9ToOP1)
    bcall(_FindSym)
    ex de,hl
    bcall(_Mov9ToOP1)
    bcall(_Sin)
    bcall(_OP6ToOP2)
    bcall(_FPMult)
    bcall(_OP1ToOP6)
    
    ld hl,arg3
    bcall(_Mov9ToOP1)
    bcall(_FindSym)
    ex de,hl
    bcall(_Mov9ToOP1)
    bcall(_OP6ToOP2)
    bcall(_FPMult)
    bcall(_OP1ToOP6)
    
    
    ld hl,arg2
    bcall(_Mov9ToOP1)
    bcall(_FindSym)
    ex de,hl
    bcall(_Mov9ToOP1)
    bcall(_Cos)
    bcall(_OP1ToOP5)
    
    ld hl,arg3
    bcall(_Mov9ToOP1)
    bcall(_FindSym)
    ex de,hl
    bcall(_Mov9ToOP2)
    
    bcall(_OP5ToOP1)
    bcall(_FPMult)
    bcall(_OP6ToOP2)
    bcall(_FPAdd)
    bcall(_OP1ToOP6)
    
    ld hl,arg2
    bcall(_Mov9ToOP1)
    bcall(_FindSym)
    ex de,hl
    bcall(_Mov9ToOP1)
    bcall(_Sin)
    bcall(_OP1ToOP5)
    
    
    ld hl,arg3
    bcall(_Mov9ToOP1)
    bcall(_FindSym)
    ex de,hl
    bcall(_Mov9ToOP2)
    bcall(_OP5ToOP1)
    bcall(_FPMult)
    bcall(_OP6ToOP2)
    bcall(_FPMult)
    
    ld a,2
    bcall(_SetXXOP2)
    bcall(_FPDiv)
    
    bcall(_StoX)
    
    bcall(_DispDone)
    
    jp end1

    
    
    
    

sal4:
    
    ld hl,arg2
    bcall(_Mov9ToOP1)
    bcall(_FindSym)
    ex de,hl
    bcall(_Mov9ToOP1)
    bcall(_FPSquare)
    bcall(_OP1ToOP6)
    
    ld hl,arg3
    bcall(_Mov9ToOP1)
    bcall(_FindSym)
    ex de,hl
    bcall(_Mov9ToOP1)
    bcall(_FPSquare)
    bcall(_OP6ToOP2)
    bcall(_FPAdd)
    bcall(_OP1ToOP6)
    
    ld hl,arg1
    bcall(_Mov9ToOP1)
    bcall(_FindSym)
    ex de,hl
    bcall(_Mov9ToOP2)
    bcall(_OP6ToOP1)
    bcallbcall(_FPSub)
    
    jp end1        
               
                  
                     
                        
                           
                              
                                             
                           



   
;----------------------------------------------------------------
activate:
    call validate
    ld a,1
    cp l
    jp z,end1
    ld hl,activate_randseed
    bcall(_Mov9ToOP1);put name in OP1
    bcall(_FindSym)
    ex de,hl
    bcall(_Mov9ToOP1)
    bcall(_StoRand)
    
    bcall(_ConvOP1)
    ld h,0
    ld l,a
randloop:
    ld a,l 
    cp 0
    jr Z,createvar
    dec hl
    push hl
    bcall(_Random)
    pop hl
    jp randloop
createvar:
    ld d,5
    bcall(_Round)
    bcall(_OP1ToOP6)
    ld hl,key
    bcall(_Mov9ToOP1)
    bcall(_FindSym)
    ex de,hl
    bcall(_Mov9ToOP1)
    bcall(_OP6ToOP2)
    bcall(_CpOP1OP2)
    jr z,Relook
    ld a,1
    bcall(_SetXXOP1)
    bcall(_StoX)
    ret
Relook:
    ld hl,Appvar
    bcall(_Mov9ToOP1) ; OP1 = variable name
    bcall(_ChkFindSym) ; look up
    jr NC,created ; jump if it exists
    ld hl,1; size to create at
    bcall(_CREATERLIST) ; create it, HL = pointer to
    jr created
created:
    push de
    ;put name in OP1
    ld a,1
    bcall(_SetXXOP1)
    bcall(_StoX)
    pop de
    ld hl,1
    bcall(_PutToL)
    ret

;----------------------------------------------------------------   
 
      

validate:  ;return is hl, valid =1 not valid = 0    
Relk:
    ld hl,Appvar
    bcall(_Mov9ToOP1) ; OP1 = variable name
    bcall(_ChkFindSym) ; look up
    jr NC,Varex ; jump if it exists
    jr notex
Varex:
    ld a,b ; check for archived
    or a ; in RAM ?
    jr Z,valid2 ; yes
    bcall(_Arc_Unarc) ; unarchive if enough RAM
    JR Relk   
notex:
    ld hl,0
    ret
valid2:
    ld a,1
    push de
    bcall(_SetXXOP1)
    bcall(_OP1ToOP2)
    pop de
    ld hl,1
    bcall(_GetLToOP1)

    bcall(_CpOP1OP2)
    jp z,valid3
    ld hl,0
    ret  
valid3:
    ld hl,1
    ret     
;----------------------------------------------------------------          
            
              
                

  
    
      
          
activate_randseed:
    .db REALOBJ,"B",0,0
    
key:
    .db REALOBJ,"C",0,0
    
Appvar:
    .db LISTOBJ,TVARLST,"_",0,0


OutP:
    .db LISTOBJ,TVARLST,"TOUT",0,0



end1:
    ld hl,msg
    ld a,0
    ld (_curCol),a
    ld a,7
    ld (_curRow),a
    bcall(_PutS)
    ld a,1
    ld (_curCol),a
    ld (_curRow),a
    ret
.end
