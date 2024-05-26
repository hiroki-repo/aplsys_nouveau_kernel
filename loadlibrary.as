#ifndef __gocainellibrary__
#module __gocainellibrary__
#uselib "crtdll.dll"
#cfunc _____malloc "malloc" int
#func _____free "free" int
#uselib "kernel32.dll"
#func _____VirtualProtect "VirtualProtect" int,int,int,var
#cfunc _____LoadLibrary "LoadLibraryA" str
#cfunc _____GetProcAddress "GetProcAddress" int,sptr
#cfunc _____GetLastError "GetLastError"
#cfunc _____VirtualAlloc "VirtualAlloc" int,int,int,int
#func _____VirtualFree "VirtualFree" int,int,int
#define IMAGE_SCN_MEM_EXECUTE 	0x20000000
#define IMAGE_SCN_MEM_READ 		0x40000000
#define IMAGE_SCN_MEM_WRITE 	0x80000000
#deffunc local initllmodule4gc
dim rwxsettingparam,8
dllcount=0
dllptrtmp(0)=0
dllmainptr(0)=0
rwxsettingparam=0x01,0x10,0x02,0x20,0x04,0x40,0x04,0x40
return
#defcfunc LoadLibraryOH str prm_0
reloc=0
exist prm_0:strsize2=strsize
if strsize2=-1{return 0}
sdim petemp,strsize2
bload prm_0,petemp
startofpeheader=lpeek(petemp,0x3c)
baseaddr=lpeek(petemp,startofpeheader+0x34)
if wpeek(petemp,startofpeheader+0x18)!0x10b{return 0}
ptr4module=_____VirtualAlloc(baseaddr,lpeek(petemp,startofpeheader+0x50),0x3000,0x40)
if ptr4module=0{
ptr4module=_____VirtualAlloc(0,lpeek(petemp,startofpeheader+0x50),0x3000,0x40)
}
dupptr str4mountthepe,ptr4module,lpeek(petemp,startofpeheader+0x50),2
memcpy str4mountthepe,petemp,4096,0,0
sdim str4section,64:dim permissionofsect,wpeek(petemp,startofpeheader+0x6):dim rvaofsection,wpeek(petemp,startofpeheader+0x6):dim sizeofsection,wpeek(petemp,startofpeheader+0x6)
repeat wpeek(petemp,startofpeheader+0x6)
memcpy str4mountthepe,petemp,lpeek(petemp,startofpeheader+0xf8+(cnt*0x28)+0x10),lpeek(petemp,startofpeheader+0xf8+(cnt*0x28)+0xc),lpeek(petemp,startofpeheader+0xf8+(cnt*0x28)+0x14)
memset str4section,0,64,0
memcpy str4section,petemp,8,0,startofpeheader+0xf8+(cnt*0x28)
sizeofsection(cnt)=lpeek(petemp,startofpeheader+0xf8+(cnt*0x28)+0x8)
rvaofsection(cnt)=lpeek(petemp,startofpeheader+0xf8+(cnt*0x28)+0xc)
permissionofsect(cnt)=lpeek(petemp,startofpeheader+0xf8+(cnt*0x28)+0x24)
if str4section=".reloc"{
reloc=lpeek(petemp,startofpeheader+0xf8+(cnt*0x28)+0xc)
}
loop
delta=ptr4module-baseaddr
if reloc=0{_____free ptr4module:return 0}
if delta!0{
tmp4relocptx=8
*relocinternalpe
repeat ((lpeek(str4mountthepe,reloc+tmp4relocptx-4)-8)/2)
relocvector=wpeek(str4mountthepe,reloc+tmp4relocptx+(cnt*2))
switch (relocvector>>12)&0xF
case 1
lpoke str4mountthepe,(relocvector&0xFFF)+lpeek(str4mountthepe,reloc+tmp4relocptx-8),lpeek(str4mountthepe,(relocvector&0xFFF)+lpeek(str4mountthepe,reloc+tmp4relocptx-8))+((delta>>16)&0xFFFF)
swbreak
case 2
lpoke str4mountthepe,(relocvector&0xFFF)+lpeek(str4mountthepe,reloc+tmp4relocptx-8),lpeek(str4mountthepe,(relocvector&0xFFF)+lpeek(str4mountthepe,reloc+tmp4relocptx-8))+((delta>>0)&0xFFFF)
swbreak
case 3
lpoke str4mountthepe,(relocvector&0xFFF)+lpeek(str4mountthepe,reloc+tmp4relocptx-8),lpeek(str4mountthepe,(relocvector&0xFFF)+lpeek(str4mountthepe,reloc+tmp4relocptx-8))+delta
swbreak
swend
loop
tmp4relocptx+=lpeek(str4mountthepe,reloc+tmp4relocptx-4)
if lpeek(str4mountthepe,reloc+tmp4relocptx-4)!0{goto *relocinternalpe}
}
repeat
cnt1=cnt
if lpeek(str4mountthepe,lpeek(petemp,startofpeheader+0x80)+(cnt1*20))=0{break}
	cnt2=0
	if lpeek(str4mountthepe,lpeek(petemp,startofpeheader+0x80)+(cnt1*20)+12)!0{
		dupptr str4loadlib4dll,varptr(str4mountthepe)+lpeek(str4mountthepe,lpeek(petemp,startofpeheader+0x80)+(cnt1*20)+12),8192,2
		HM=_____LoadLibrary(str4loadlib4dll)
		if HM!0{
			repeat
				cnt2=cnt
				if lpeek(str4mountthepe,(cnt2*4)+lpeek(petemp,startofpeheader+0x80)+(cnt1*20)+16)=0{break}
				if lpeek(str4mountthepe,(cnt2*4)+lpeek(petemp,startofpeheader+0x80)+(cnt1*20)+0)&0x80000000{
					lpoke str4mountthepe,(cnt2*4)+lpeek(petemp,startofpeheader+0x80)+(cnt1*20)+16,_____GetProcAddress(HM,lpeek(str4mountthepe,(cnt2*4)+lpeek(petemp,startofpeheader+0x80)+(cnt1*20)+0)&0xFFFF)
				}else{
					dupptr str4loadlib4dll,varptr(str4mountthepe)+lpeek(str4mountthepe,(cnt2*4)+lpeek(petemp,startofpeheader+0x80)+(cnt1*20)+0),8192,2
					lpoke str4mountthepe,(cnt2*4)+lpeek(petemp,startofpeheader+0x80)+(cnt1*20)+16,_____GetProcAddress(HM,str4loadlib4dll)
				}
			loop
		}
	}
loop
repeat wpeek(petemp,startofpeheader+0x6)
tmp4oldperm=0
_____VirtualProtect ptr4module+rvaofsection(cnt),sizeofsection(cnt),rwxsettingparam((permissionofsect(cnt)>>29)&7),tmp4oldperm
dupptr data4debugview,ptr4module+rvaofsection(cnt),sizeofsection(cnt),2
//dialog
loop
//dllparam=ptr4module,1,0
//boolofthedllmain=callfunc(dllparam,ptr4module+lpeek(petemp,startofpeheader+0x28),3)
//if (boolofthedllmain&1)=0{_____free ptr4module:return 0}
dllptrtmp(dllcount)=lpeek(ptr4module,0)
dllmainptr(dllcount)=ptr4module+lpeek(petemp,startofpeheader+0x28)
dllsize(dllcount)=lpeek(petemp,startofpeheader+0x50)
dllcount++
return ptr4module
#deffunc local freelibraryonexit onexit
repeat dllcount
if dllptrtmp(cnt)!0{
//dllparam=dllptrtmp(cnt),0,0
//boolofthedllmain=callfunc(dllparam,dllmainptr(cnt),3)
_____VirtualFree dllptrtmp(cnt),0,0x8000
}
loop
return
#defcfunc GetProcAddressOH int prm_0,str prm_1
dupptr petemp,prm_0,0x7fffffff,2
addr4function=0
startofpeheader=lpeek(petemp,0x3c)
if wpeek(petemp,startofpeheader+0x18)!0x10b{return 0}
repeat
if cnt>=lpeek(petemp,lpeek(petemp,startofpeheader+0x78)+28){break}
dupptr str4chkfuncname,prm_0+lpeek(petemp,(4*cnt)+lpeek(petemp,lpeek(petemp,startofpeheader+0x78)+32)),8192,2
addr4functionbase=lpeek(petemp,lpeek(petemp,startofpeheader+0x78)+28)
if str4chkfuncname=prm_1{
	addr4function=prm_0+lpeek(petemp,addr4functionbase+(wpeek(petemp,(cnt*2)+lpeek(petemp,lpeek(petemp,startofpeheader+0x78)+36))*4))
	break
}
loop
return addr4function
#deffunc FreeLibraryOH int prm_0
if prm_0!0{
repeat dllcount
if dllptrtmp(cnt)=prm_0{
dllparam=dllptrtmp(cnt),0,0
boolofthedllmain=callfunc(dllparam,dllmainptr(cnt),3)
_____VirtualFree dllptrtmp(cnt),0,0x8000
}
loop
if boolofthedllmain=0{return 0}
}
return -1

#global
#define global guselib(%1) __HMHMHMHM_@__gocainellibrary__=LoadLibraryOH(%1)
#define global gfunc(%1) dupptr __ppgfunc__@__gocainellibrary__,libptr(%1)+24,4,4:__Funcname__@__gocainellibrary__="%1":repeat:if strmid(__Funcname__@__gocainellibrary__,0,1)=" "{__Funcname__@__gocainellibrary__=strmid(__Funcname__@__gocainellibrary__,1,strlen(__Funcname__@__gocainellibrary__))}else{break}:loop:lpoke __ppgfunc__@__gocainellibrary__,0,GetProcAddressOH(__HMHMHMHM_@__gocainellibrary__,__Funcname__@__gocainellibrary__)
initllmodule4gc@__gocainellibrary__
#endif
