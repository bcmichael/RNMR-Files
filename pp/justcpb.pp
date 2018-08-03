;========================
;DEFINITIONS
;========================
allocx pls pls_z alloc_usr
allocx pls pls_flipdn alloc_usr
allocx pls pls_flipup alloc_usr

allocx ppmd ppmd_cpdly
allocx ppmd ppmd_flipdn
allocx ppmd ppmd_flipup

allocx pwx pwx_zfilter
allocx pwx pwx_flip

;==========================
;DEFINE OBSERVE PROGRAM C13
;==========================

;note, cppls means the 90 degree pulse on proton
;note, cpdly means the contact time period

use timer
use pwxpls cppls				;nam,pwr,psx,ppmd,pwx
use pwxpls zfilter				;nam,pwr,psx,ppmd,pwx
use pwxdly cpdly pwrh 1 ppmd_cpdly * 64		;nam,pwr,psx,ppmd,beg,size
use pwxpls flipdn pwrh 1 ppmd_flipdn pwx_flip
use pwxpls flipup pwrh 1 ppmd_flipup pwx_flip

iniobs
pwxpls cppls		;dummy cp pls
pwxdly cpdly		;psx=1, ppmd=cpdly
pwxpls flipup
pwxpls zfilter
pwxpls flipdn
sample
recycle
finobs

;==========================
;DEFINE DECOUPLE PROGRAM H1
;==========================
;defines the proton channel details

allocx ppmd ppmd_dec
allocx ppmd ppmd_cppls
allocx pwx pwx_cwdec
allocx ppmd ppmd_cpdlydec

use pwxpls cppls pwrh 1 ppmd_cppls * 		;nam pwr psx ppmd pwx
use pwxdly cpdly pwrh 1 ppmd_cpdlydec * 1	;nam pwr psx ppmd beg size
use pwxpls flipdn pwrh 1 ppmd_dec pwx_cwdec
use pwxpls flipup pwrh 1 ppmd_dec pwx_cwdec
use pwxpls z 1 0 pwx_zfilter
use period sample tppm pwrh * 64 ppmd_dec
;<pername> <seqnam> <pwr> <org> <size> <ppmd> ;* means use the default name

inidec
pwxpls cppls		;pls_cppls, psx=1, ppmd=cppls pwx 2 cppls2
pwxdly cpdly		;constant amplitude cp, phase=y,pwx 2 cpdly2
pwxpls flipup
pwxpls z
pwxpls flipdn
sample
recycle
findec
