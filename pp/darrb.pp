; ==========================
; DEFINITIONS
; ==========================

mark 1

allocx pls,pls_cppls,alloc_usr
allocx pls,pls_flipup,alloc_usr
allocx pls,pls_flipdn,alloc_usr

allocx dly,dly_t1,alloc_int
allocx dly,dly_moret1,alloc_int
allocx dly,dly_maxt1,alloc_int
allocx loop,loop_maxt1,alloc_usr
allocx pls,pls_t1,alloc_usr

ALLOCX DLY,DLY_MIX,ALLOC_USR

allocx ppmd,ppmd_cppls
allocx ppmd,ppmd_cpdlyobs
allocx ppmd,ppmd_cpdlydec
allocx ppmd,ppmd_flipup
allocx ppmd,ppmd_flipdn
allocx ppmd,ppmd_dec

allocx pwx,pwx_cppls
allocx pwx,pwx_flip

mark 2

; ==========================
; CALCULATIONS
; ==========================

; Calculate d_maxt1
push loop,loop_maxt1
push pls,pls_t1
mul
pop dly,dly_maxt1

; CALCULATE MORE T1
PUSH DLY,DLY_MAXT1
PUSH DLY,DLY_T1
IFSTK LT
  SUB
  POP DLY,DLY_MORET1
ELSE
   PUSH DLY,#0
   POP DLY,DLY_MORET1
   POP
   POP
ENDIF



mark 3

; =============================
; 2nd dimention
; =============================
use dim 2 1 2
; idim,logical_chn,nseg

dimdly 2
pop dly,dly_t1

use timer

; ==========================
; DEFINE OBSERVE PROGRAM
; ==========================

mark 10
use pwxpls,cppls
use pwxdly,cpdly,pwrh,1,ppmd_cpdlyobs,*,64	;nam,pwr,psx,ppmd,beg,size
use pwxpls,flipup,pwrh,1,ppmd_flipup,pwx_flip
use pwxpls,flipdn,pwrh,1,ppmd_flipdn,pwx_flip

mark 11

iniobs

; ramped CP
pwxpls cppls		;dummy cp pls
pwxdly cpdly		;psx=1, ppmd=cpdly

mark 12

mark 13

; t1 evolution

	dly gate_idle,dly_t1

pwxpls flipup

   DLY GATE_IDLE,DLY_MIX

mark 14

mark 15

pwxpls flipdn

mark 16

sample

dly gate_idle,dly_moret1

recycle
finobs

; ==========================
; DEFINE DECOUPLE PROGRAM
; ==========================

; Allocations on Decouple Channel:
allocx pwx,pwx_cwdec

mark 20

use pwxpls,cppls,pwrh,1,ppmd_cppls,pwx_cppls  		;nam,pwr,psx,ppmd,pwx
use pwxdly,cpdly,pwrh,1,ppmd_cpdlydec,*,64	;nam,pwr,psx,ppmd,beg,size
use pwxpls,flipup,pwrh,1,ppmd_dec,pwx_cwdec
use pwxpls,flipdn,pwrh,1,ppmd_dec,pwx_cwdec
use period,sample,tppm,pwrh,*,64,ppmd_dec
use period,evolve,tppm,pwrh,*,64,ppmd_dec
;pernam,seqnam,pwr,org,size,ppmd

USE PERIOD,MIX,cw,PWRH,ppmd_cwdec

mark 21

inidec

; ramped CP
pwxpls cppls		;pls_cppls,psx=1,ppmd=cppls pwx 2 cppls2
pwxdly cpdly		;constant amplitude cp, phase=y,pwx 2 cpdly2

mark 22

mark 23

; t1 evolution _ dec channel

period evolve,dly_t1

pwxpls flipup

mark 24

      PERIOD MIX,DLY_MIX

mark 25

mark 26

pwxpls flipdn

mark 27

sample

period evolve,dly_moret1

recycle
findec
