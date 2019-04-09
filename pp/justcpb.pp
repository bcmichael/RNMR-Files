; ========================
; DEFINITIONS
; ========================
allocx pwx pwx_flip
allocx ppmd ppmd_dec
allocx pwx pwx_cwdec

; ==========================
; DEFINE OBSERVE PROGRAM C13
; ==========================
use timer
use pwxpls cppls
use pwxdly cpdly pwrh 1 * * 64		;nam,pwr,psx,ppmd,beg,size
use pwxpls flipdn pwrh 1 * pwx_flip ;nam,pwr,psx,ppmd,pwx
use pwxpls flipup pwrh 1 * pwx_flip

iniobs
pwxpls cppls
pwxdly cpdly
pwxpls flipup
pwxpls flipdn
sample
recycle
finobs

; ==========================
; DEFINE DECOUPLE PROGRAM H1
; ==========================
use pwxpls cppls pwrh 1 * *
use pwxdly cpdly pwrh 1 * * 1
use pwxpls flipdn pwrh 1 ppmd_dec pwx_cwdec
use pwxpls flipup pwrh 1 ppmd_dec pwx_cwdec
use period sample tppm pwrh * 64 ppmd_dec ;nam,seq,pwr,beg,size,ppmd

inidec
pwxpls cppls
pwxdly cpdly
pwxpls flipup
pwxpls flipdn
sample
recycle
findec
