#include "ti83plus.inc"
#define bcall(xxxx) rst 28h \ .dw xxxx
; Errors:
;   3 = resList does not exist
;   4 = var does not exist



.org _UserMem
;----------- Main function -- DrawPage
    ; get address of result
    bcall(_runIndicOff)
    call checkResList
    cp 0
    jp Z, quit
    
    ; get value of start index
    ld hl,lstStartIdVar
    call loadVarToOP1
    cp 0
    jp Z, quit
    ; it doesnt matter about 0-99 size restriction, indexes wont exceed this.
    ld de,startIndex
    bcall(_MovFrOP1) ; A now contains the start index
    
    ; get value of numCols
    ld hl,numColsVar
    call loadVarToOP1
    cp 0
    jp Z, quit
    ; it doesnt matter about 0-99 size restriction, indexes wont exceed this.
    ld de,numCols
    bcall(_MovFrOP1) ; A now contains the start index
    
    ; get value of num
    ld hl,numVar
    call loadVarToOP1
    cp 0
    jp Z, quit
    bcall(_PushOP1)
    
    ld h,0
    ld l,1
    ld (cID),hl
    
    ld a,1
    ld (cRow),a
    ld (cCol),a
loop:
    ld a,(cRow)
    ld (_curRow),a
    ld a,(cCol)
    ld (_curCol),a
    ld hl,(cID)
    
    
    ld de,(resadr)
    bcall(_GetLToOP1)
    bcall(_FormReal)
    ld hl,_OP3
    bcall(_PutS)
    
    ld hl,mulStr
    bcall(_PutS)
    
    ld hl,(cID)
    ld de,(resadr)
    bcall(_GetLToOP1)
    bcall(_OP1ToOP2)
    bcall(_PopRealO1)
    bcall(_OP1ToOP6)
    bcall(_FPDiv)
    
    bcall(_FormReal)
    ld hl,_OP3
    bcall(_PutS)
    
    ld hl,(cID)
    inc hl
    ld (cID),hl
    
    ld a,(cRow)
    inc a
    ld (cRow),a
    
    cp 8
    jp Z, endDraw
    jp loop
    

endDraw:
    


;----------- utils

;===================================
; Name:    checkResList
;
; Purpose: to make sure the resList
;          exists and is unarcived
; PreCond: None, but l1 should be
;          valid for this to pass
; PostCon: A will equal 1 if pass,
;          and 0 if fail, X will be
;          set to the appropriate
;          error message.
; registers destroyed:
;   all are destroyed
;===================================
checkResList:
    ld hl,resList
    bcall(_Mov9ToOP1)

    bcall(_FindSym) ; look up
    jr NC,exists   ; jump if variable is not
    ; -- res list doesn't exist -- load error code to X and return
    ; -- along with setting X, use accumulator to return an error message to 
    ld a, 3
    bcall(_SetXXOP1)
    bcall(_StoX)
    ld a, 0
    ret
exists:
    ld a,b
    or a
    jp z,inram

    bcall(_Arc_Unarc)
    jp checkResList
inram:
    ld (resadr),de
    ld a,1
    ret
;===================================

;===================================
; Name:    loadVarToOP1
;
; Purpose: to provide a gerneral way
;          to load a user var (A-Z)
;          into OP1
; PreCond: HL must = variable to lookup
; PostCon: OP1 will equal contents of
;          that var
; registers destroyed:
;   all are destroyed
;===================================
loadVarToOP1:
    bcall(_Mov9ToOP1) ; OP1 = var name

    bcall(_FindSym) ; look up
    jr NC,Vexists   ; jump if variable is not
    ; -- var doesn't exist -- load error code to X and return
    ; -- along with setting X, use accumulator to return an error message to 
    ld a, 4
    bcall(_SetXXOP1)
    bcall(_StoX)
    ld a, 0
    ret
Vexists:
    ld a,b
    or a
    jp z,Vinram

    bcall(_Arc_Unarc)
    jp checkResList
Vinram:
    ex de,hl
    bcall(_Mov9ToOP1)
    ld a,1
    ret
;===================================

; here are all of the variables I will use, hopefully 
; they are self explanitory
numVar:        .db REALOBJ,"N",0,0 

numColsVar:    .db REALOBJ,"C",0,0
numCols:       .db 00h

cRow:          .db 00h
cCol:          .db 00h
   
lstStartIdVar: .db REALOBJ,"S",0,0 
startIndex:    .db 00h
cID:           .db 00h

mulStr:        .db "x",0

resList:       .db LISTOBJ,TVARLST,TL1,0,0
resadr:        .db 00h

quit:
    ret
.end
