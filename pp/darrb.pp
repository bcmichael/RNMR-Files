; ==========================
; DEFINITIONS
; ==========================
allocx dly dly_t1 alloc_int
allocx dly dly_moret1 alloc_int

allocx dly dly_mix
allocx ppmd ppmd_dec
allocx pwx pwx_flip
allocx pwx pwx_cwdec
; =============================
; 2nd dimension
; =============================
use dim 2 1 2 ;idim,logical_chn,nseg

dimdly 2
pop dly dly_t1

; ==========================
; CALCULATIONS
; ==========================

; moret1 = size*step-t1
push loop loop_size$2
push dly dly_step$2
mul
push dly dly_t1
ifstk lt
  sub
  pop dly dly_moret1
else
   push dly #0
   pop dly dly_moret1
   pop
   pop
endif

use timer

; ==========================
; DEFINE OBSERVE PROGRAM
; ==========================
use pwxpls cppls
use pwxdly cpdly pwrh 1 * * 64	   ;nam,pwr,psx,ppmd,beg,size
use pwxpls flipup pwrh 1 * pwx_flip ;nam,pwr,psx,ppmd,pwx
use pwxpls flipdn pwrh 1 * pwx_flip

iniobs

pwxpls cppls
pwxdly cpdly


	dly gate_idle dly_t1

pwxpls flipup

   dly gate_idle dly_mix

pwxpls flipdn

sample

dly gate_idle dly_moret1

recycle
finobs

; ==========================
; DEFINE DECOUPLE PROGRAM
; ==========================
use pwxpls cppls pwrh 1 * *                ;nam,pwr,psx,ppmd,pwx
use pwxdly cpdly pwrh 1 * * 64             ;nam,pwr,psx,ppmd,beg,size
use pwxpls flipup pwrh 1 ppmd_dec pwx_cwdec
use pwxpls flipdn pwrh 1 ppmd_dec pwx_cwdec
use period sample tppm pwrh * 64 ppmd_dec  ;nam,seq,pwr,beg,size,ppmd
use period evolve tppm pwrh * 64 ppmd_dec

use period mix cw pwrh ppmd_cwdec

inidec


pwxpls cppls
pwxdly cpdly


period evolve dly_t1

pwxpls flipup

      period mix dly_mix

pwxpls flipdn

sample

period evolve dly_moret1

recycle
findec
