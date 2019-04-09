; ==========================
; DEFINITIONS
; ==========================

mark 1

allocx dly,dly_t1,alloc_int
allocx dly,dly_moret1,alloc_int

allocx dly,dly_mix,alloc_usr

allocx ppmd,ppmd_dec

allocx pwx,pwx_flip

mark 2

; =============================
; 2nd dimension
; =============================
use dim 2 1 2
; idim,logical_chn,nseg

dimdly 2
pop dly,dly_t1

; ==========================
; CALCULATIONS
; ==========================

; moret1 = size*step-t1
push loop,loop_size$2
push dly,dly_step$2
mul
push dly,dly_t1
ifstk lt
  sub
  pop dly,dly_moret1
else
   push dly,#0
   pop dly,dly_moret1
   pop
   pop
endif

mark 3


use timer

; ==========================
; DEFINE OBSERVE PROGRAM
; ==========================

mark 10
use pwxpls,cppls
use pwxdly,cpdly,pwrh,1,*,*,64	;nam,pwr,psx,ppmd,beg,size
use pwxpls,flipup,pwrh,1,*,pwx_flip
use pwxpls,flipdn,pwrh,1,*,pwx_flip

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

   dly gate_idle,dly_mix

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

use pwxpls,cppls,pwrh,1,*,*  		;nam,pwr,psx,ppmd,pwx
use pwxdly,cpdly,pwrh,1,*,*,64	;nam,pwr,psx,ppmd,beg,size
use pwxpls,flipup,pwrh,1,ppmd_dec,pwx_cwdec
use pwxpls,flipdn,pwrh,1,ppmd_dec,pwx_cwdec
use period,sample,tppm,pwrh,*,64,ppmd_dec
use period,evolve,tppm,pwrh,*,64,ppmd_dec
;pernam,seqnam,pwr,org,size,ppmd

use period,mix,cw,pwrh,ppmd_cwdec

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

      period mix,dly_mix

mark 25

mark 26

pwxpls flipdn

mark 27

sample

period evolve,dly_moret1

recycle
findec
