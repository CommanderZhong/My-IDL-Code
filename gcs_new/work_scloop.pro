pro work_scloop, date, start_time_cor2, end_time_cor2, start_time_hi, end_date_hi, end_time_hi, end_time_c2, end_time_c3, start_time_cor1, end_time_cor1, start, ldisp=ldisp, mkim=mkim, flip=flip

;date-string of date in form of '20100403'
;start_time_cor2 etc, time in 4 digit int, 08:00 would be the first observations used in COR2
;enddate hi-string of enddate in hi-1, usually just the next day after the first observation
;start- time of first used image in form of 'XX:XX'. Enter a time before the desired start and after a previous observing time if you want to skip to a frame 
;/mkim: create an output image of the scraytrace output
;/flip: the code doesn't always rotate LASCO images properly, so this will artifically rotate the LASCO images for the image output.

start=strtrim(start,1)
start_time=fix(strmid(start,0,2)+strmid(start,3,2))
date_str=strmid(date, 0,4)+'/'+strmid(date,4,2)+'/'+strmid(date, 6,2)


;GMU DATA PATHS
path_stereo='/swd3/stereo/secchi/lz/L0/'
path_lasco='/swd2/data'

;NRL DATA PATHS

;if date gt 20100615 then begin 
;   path_stereo='/net/corona/secchi/lz/L0/'
;   path_stereo2=''
;   path_stereo3='img/cor2/'
;   tinx=54
;endif else begin
;   path_stereo='/Volumes/data/'
;   path_stereo2='img/
;   path_stereo3=''
;   tinx=38
;endelse 
;path_lasco='/net/corona/'

date_lasco=STRMID(date,2,6)



if start_time gt start_time_cor1 then start_time_cor1=start_time


if start_time gt start_time_cor2 then start_time_cor2=start_time

;start_time_hi=1000
;end_date_hi='20100404'
;end_time_hi=0100

if start_time gt end_time_cor2 then start_time_hi=start_time

if end_time_cor1 gt start_time then begin
   sumfile=path_stereo+'/secchi/lz/L0/a/summary/sccA'+strmid(date, 0, 6)+'.img.c1' 
   spawn, 'ls '+sumfile, exist
   if exist eq '' then begin
   seq=1
   sumfile=path_stereo+'/secchi/lz/L0/a/summary/sccA'+strmid(date, 0, 6)+'.seq.c1' 
   restore, 'sumtemp.sav'
   files=read_ascii(sumfile, template=template)
   len=n_elements(files.field01)

   cor1Aindex=where(strmid(files.field01, 17, 1) eq '4' and files.field05 eq 512 and utc2tai(str2utc(strmid(files.field01,0,15))) gt utc2tai(str2utc(date_str+' '+strmid(start_time_cor1+10000,4,2)+':'+strmid(start_time_cor1+10000,6,2)+':00'))-360 and utc2tai(str2utc(strmid(files.field01, 0, 15))) lt utc2tai(str2utc(date_str+' '+strmid(end_time_cor1+10000,4,2)+':'+strmid(end_time_cor1+10000,6,2)+':00')))
   cor1Afiles=path_stereo+'a/seq/cor1/'+date+'/'+files.field01[cor1Aindex]
   
   len1=size(cor1Afiles)
   cor1Atimes=intarr(len1(1))

   for i=0, len1(1)-1,3 do cor1Atimes(i)=fix(strmid(cor1Afiles(i),tinx,4))

   sumfile=path_stereo+'/secchi/lz/L0/b/summary/sccB'+strmid(date, 0, 6)+'.seq.c1' 
   files=read_ascii(sumfile, template=template)
   len=n_elements(files.field01)

   cor1Bindex=where(strmid(files.field01, 17, 1) eq '4' and files.field05 eq 512 and utc2tai(str2utc(strmid(files.field01,0,15))) gt utc2tai(str2utc(date_str+' '+strmid(start_time_cor1+10000,4,2)+':'+strmid(start_time_cor1+10000,6,2)+':00'))-360 and utc2tai(str2utc(strmid(files.field01, 0, 15))) lt utc2tai(str2utc(date_str+' '+strmid(end_time_cor1+10000,4,2)+':'+strmid(end_time_cor1+10000,6,2)+':00')))
   cor1Bfiles=path_stereo+'b/seq/cor1/'+date+'/'+files.field01[cor1Bindex]

  len=size(cor1Bfiles)
  cor1Btimes=intarr(len(1))
  for i=0, len(1)-1,3 do cor1Btimes(i)=fix(strmid(cor1Bfiles(i),tinx,4))

   
  if len1(1) lt len(1) then begin

  for i=0, len1(1)-1,3 do begin
  ;stop

	if (cor1Atimes(i) gt cor1Btimes(i)) then begin
;stop
		cor1Btimes(i:len(1)-4)=cor1Btimes(i+3:len(1)-1)
		cor1Bfiles(i:len(1)-4)=cor1Bfiles(i+3:len(1)-1)
		remove, indgen(3)+len(1)-3, cor1Bfiles
		len(1)=len(1)-3
	endif
  endfor
  endif else begin
  for i=0, len(1)-1,3 do begin
	if (cor1Btimes(i) gt cor1Atimes(i)) then begin
stop
		cor1Atimes(i:len1(1)-4)=cor1Atimes(i+3:len1(1)-1)
		cor1Afiles(i:len1(1)-4)=cor1Afiles(i+3:len1(1)-1)
		remove, indgen(3)+len(1)-3, cor1Afiles
		len1(1)=len1(1)-3
	endif
  endfor
  endelse
endif else begin
  seq=0
  if end_time_cor1 gt start_time then begin
   sumfile=path_stereo+'/secchi/lz/L0/a/summary/sccA'+strmid(date, 0, 6)+'.img.c1' 
   restore, 'sumtemp.sav'
   files=read_ascii(sumfile, template=template)
   len=n_elements(files.field01)
;   for i=0, 
   
   cor1Aindex=where(strmid(files.field01, 17, 1) eq '4' and files.field05 eq 512 and utc2tai(str2utc(strmid(files.field01,0,15))) gt utc2tai(str2utc(date_str+' '+strmid(start_time_cor1,4,2)+':'+strmid(start_time_cor1,6,2)+':00'))-360 and utc2tai(str2utc(strmid(files.field01, 0, 15))) lt utc2tai(str2utc(date_str+' '+strmid(end_time_cor1,4,2)+':'+strmid(end_time_cor1,6,2)+':00')))
   cor1Afiles=path_stereo+'a/img/cor1/'+date+'/'+files.field01[cor1Aindex]

;cd, path_stereo+'a/img/cor2/'+date,current=cur
;spawn, 'ls', resulta
;cd, cur
;len=size(resulta)
;tmp=intarr(len(1))


;for i=0,len(1)-1 do tmp(i)=fix(strmid(resulta(i),9,4))


;cor2Aindex=where(tmp gt start_time_cor2 and tmp lt end_time_cor2 and tmp mod 10 ne 8)
;cor2Afiles=path_stereo+path_stereo2+'a/'+path_stereo3+date+'/'+resulta[cor2Aindex]
len1=size(cor1Afiles)
cor1Atimes=intarr(len1(1))
;stop 

for i=0, len1(1)-1 do cor1Atimes(i)=fix(strmid(cor1Afiles(i),tinx,4))

   sumfile=path_stereo+'/secchi/lz/L0/b/summary/sccB'+strmid(date, 0, 6)+'.img.c1' 
   ;restore, 'sumtemp.sav'
   files=read_ascii(sumfile, template=template)
   len=n_elements(files.field01)
;   for i=0, 
   
   cor1Bindex=where(strmid(files.field01, 17, 1) eq '4' and files.field05 eq 512 and utc2tai(str2utc(strmid(files.field01,0,15))) gt utc2tai(str2utc(date_str+' '+strmid(start_time_cor1,4,2)+':'+strmid(start_time_cor1,6,2)+':00'))-360 and utc2tai(str2utc(strmid(files.field01, 0, 15))) lt utc2tai(str2utc(date_str+' '+strmid(end_time_cor1,4,2)+':'+strmid(end_time_cor1,6,2)+':00')))
   cor1Bfiles=path_stereo+'b/img/cor1/'+date+'/'+files.field01[cor1Bindex]



;cd, path_stereo+'b/img/cor2/'+date,current=cur
;spawn, 'ls', resultb
;cd, cur
;len=size(resultb)
;tmp=intarr(len(1))
;for i=0,len(1)-1 do tmp(i)=fix(strmid(resultb(i),9,4))

;cor2Bindex=where(tmp gt start_time_cor2 and tmp lt end_time_cor2 and tmp mod 10 ne 8)
;cor2Bfiles=path_stereo+'b/img/cor2/'+date+'/'+resultb[cor2Bindex]
len=size(cor1Bfiles)
cor1Btimes=intarr(len(1))
for i=0, len(1)-1 do cor1Btimes(i)=fix(strmid(cor1Bfiles(i),tinx,4))

if len1(1) lt len(1) then begin

for i=0, len1(1)-1 do begin
	if (cor1Atimes(i) gt cor1Btimes(i)) then begin
		cor1Btimes(i:len(1)-2)=cor1Btimes(i+1:len(1)-1)
		cor1Bfiles(i:len(1)-2)=cor1Bfiles(i+1:len(1)-1)
		remove, len(1)-1, cor1Bfiles
		len(1)=len(1)-1
	endif
endfor
endif else begin
for i=0, len(1)-1 do begin
	if (cor1Btimes(i) gt cor1Atimes(i)) then begin
		cor1Atimes(i:len1(1)-2)=cor1Atimes(i+1:len1(1)-1)
		cor1Afiles(i:len1(1)-2)=cor1Afiles(i+1:len1(1)-1)
		remove, len1(1)-1, cor1Afiles
		len1(1)=len1(1)-1
	endif
endfor
endelse
endif


endelse
endif
if end_time_cor2 gt start_time then begin
   sumfile=path_stereo+'a/summary/sccA'+strmid(date, 0, 6)+'.img.c2' 
   restore, 'sumtemp.sav'
   files=read_ascii(sumfile, template=template)
   len=n_elements(files.field01)
;   for i=0, 
   
   cor2Aindex=where(strmid(files.field01, 17, 1) eq '4' and files.field05 eq 2048 and utc2tai(str2utc(strmid(files.field01,0,15))) gt utc2tai(str2utc(date_str+' '+strmid(start_time_cor2,4,2)+':'+strmid(start_time_cor2,6,2)+':00'))-1800 and utc2tai(str2utc(strmid(files.field01, 0, 15))) lt utc2tai(str2utc(date_str+' '+strmid(end_time_cor2,4,2)+':'+strmid(end_time_cor2,6,2)+':00')))
   cor2Afiles=path_stereo+'a/img/cor2/'+date+'/'+files.field01[cor2Aindex]

;cd, path_stereo+'a/img/cor2/'+date,current=cur
;spawn, 'ls', resulta
;cd, cur
;len=size(resulta)
;tmp=intarr(len(1))


;for i=0,len(1)-1 do tmp(i)=fix(strmid(resulta(i),9,4))


;cor2Aindex=where(tmp gt start_time_cor2 and tmp lt end_time_cor2 and tmp mod 10 ne 8)
;cor2Afiles=path_stereo+path_stereo2+'a/'+path_stereo3+date+'/'+resulta[cor2Aindex]
len1=size(cor2Afiles)
cor2Atimes=intarr(len1(1))
;stop 

for i=0, len1(1)-1 do cor2Atimes(i)=fix(strmid(cor2Afiles(i),55,4))

   sumfile=path_stereo+'b/summary/sccB'+strmid(date, 0, 6)+'.img.c2' 
   ;restore, 'sumtemp.sav'
   files=read_ascii(sumfile, template=template)
   len=n_elements(files.field01)

   cor2Bindex=where(strmid(files.field01, 17, 1) eq '4' and files.field05 eq 2048 and utc2tai(str2utc(strmid(files.field01,0,15))) gt utc2tai(str2utc(date_str+' '+strmid(start_time_cor2,4,2)+':'+strmid(start_time_cor2,6,2)+':00'))-1800 and utc2tai(str2utc(strmid(files.field01, 0, 15))) lt utc2tai(str2utc(date_str+' '+strmid(end_time_cor2,4,2)+':'+strmid(end_time_cor2,6,2)+':00')))
   cor2Bfiles=path_stereo+'b/img/cor2/'+date+'/'+files.field01[cor2Bindex]


len=size(cor2Bfiles)
cor2Btimes=intarr(len(1))
for i=0, len(1)-1 do cor2Btimes(i)=fix(strmid(cor2Bfiles(i),55,4))

if len1(1) lt len(1) then begin

for i=0, len1(1)-1 do begin
	if (cor2Atimes(i) gt cor2Btimes(i)) then begin
		cor2Btimes(i:len(1)-2)=cor2Btimes(i+1:len(1)-1)
		cor2Bfiles(i:len(1)-2)=cor2Bfiles(i+1:len(1)-1)
		remove, len(1)-1, cor2Bfiles
		len(1)=len(1)-1
	endif
endfor
endif else begin
for i=0, len(1)-1 do begin
	if (cor2Btimes(i) gt cor2Atimes(i)) then begin
		cor2Atimes(i:len1(1)-2)=cor2Atimes(i+1:len1(1)-1)
		cor2Afiles(i:len1(1)-2)=cor2Afiles(i+1:len1(1)-1)
		remove, len1(1)-1, cor2Afiles
		len1(1)=len1(1)-1
	endif
endfor
endelse
endif

;   path_stereo='/net/corona/secchi/lz/L0/'


cd, path_stereo+'a/img/hi_1/'+date,current=cur
spawn, 'ls *s4h1A.fts', resulthia
cd, cur
len=size(resulthia)
tmp=intarr(len(1)+2)
for i=0,len(1)-1 do tmp(i)=fix(strmid(resulthia(i),9,4))

hi1Aindex=where(tmp gt (start_time_hi-300)); and tmp lt end_time_cor2)
hi1Afiles1=path_stereo+'a/img/hi_1/'+date+'/'+resulthia[hi1Aindex]

if end_date_hi ne date then begin
cd, path_stereo+'a/img/hi_1/'+end_date_hi,current=cur
spawn, 'ls *s4h1A.fts', resulthia2
cd, cur
len2=size(resulthia2)
tmp=intarr(len2(1))
for i=0,len2(1)-1 do tmp(i)=fix(strmid(resulthia2(i),9,4))

hi1Aindex=where(tmp lt end_time_hi); and tmp lt end_time_cor2 and tmp ne 1108)
hi1Afiles2=path_stereo+'a/img/hi_1/'+end_date_hi+'/'+resulthia2[hi1Aindex]

hi1Afiles=[hi1Afiles1, hi1Afiles2]

endif else begin
hi1Afiles=hi1Afiles1
endelse

n=where(strmid(hi1Afiles, 62, 1) eq 'n')
if n(0) ne -1 then remove, n, hi1Afiles

cd, path_stereo+'b/img/hi_1/'+date,current=cur
spawn, 'ls *s4h1B.fts', resulthib
cd, cur
len=size(resulthib)
tmp=intarr(len(1)+2)
for i=0,len(1)-1 do tmp(i)=fix(strmid(resulthib(i),9,4))

hi1Bindex=where(tmp gt (start_time_hi-300)); and tmp lt end_time_cor2)
hi1Bfiles1=path_stereo+'b/img/hi_1/'+date+'/'+resulthib[hi1Bindex]

if end_date_hi ne date then begin
cd, path_stereo+'b/img/hi_1/'+end_date_hi,current=cur
spawn, 'ls *s4h1B.fts', resulthib2
cd, cur
len2=size(resulthib2)
tmp=intarr(len2(1))
for i=0,len2(1)-1 do tmp(i)=fix(strmid(resulthib2(i),9,4))

hi1Bindex=where(tmp lt end_time_hi); and tmp lt end_time_cor2 and tmp ne 1108)
hi1Bfiles2=path_stereo+'b/img/hi_1/'+end_date_hi+'/'+resulthib2[hi1Bindex]
hi1Bfiles=[hi1Bfiles1,hi1Bfiles2]
endif else begin
hi1Bfiles=hi1Bfiles1
endelse

n=where(strmid(hi1Bfiles, 62, 1) eq 'n')
if n(0) ne -1 then remove, n, hi1Bfiles
tmpn=where(strmid(hi1Bfiles, 48, 10) eq '100408_232')
if tmpn(0) ne -1 then remove, tmpn, hi1Bfiles
s1=size(hi1Afiles)
s2=size(hi1Bfiles)

sancheck=0
while s1(1) ne s2(1) and sancheck lt 30 do begin

tmparr=where(strmid(hi1Bfiles, 54,3) ne strmid(hi1Afiles,54,3))
index=tmparr(0)

if(index ne-1)then begin
if fix(strmid(hi1Bfiles(index), 55,3)) gt fix(strmid(hi1Afiles(index), 55, 3)) then begin
	remove, index, hi1Afiles
endif else begin
	remove, index, hi1Bfiles
endelse
endif
s1=size(hi1Afiles)
s2=size(hi1Bfiles)
sancheck=sancheck+1
endwhile

lasco=1
if lasco eq 1 then begin
;if str2int(strmid(date, 0, 4)) gt 2010 then begin
;las_path=path_lasco+'lz/level_05/'
las_path=path_lasco+'/soho/lasco/lz_tmp/level_05/'
;endif else begin
;las_path='/swd/data/soho/lasco/lz/level_05/'
;endelse

luse=1
if luse ne 0 then begin
hdrc2=las_path+date_lasco+'/c2/img_hdr.txt'
hdrc3=las_path+date_lasco+'/c3/img_hdr.txt'
;hdrc3=las_path+date_lasco+'/c2/img_hdr.txt'
c2times=intarr(150)
c2files=strarr(150)
OPENR,lu,hdrc2,/get_lun

line=''     
i=0
while (not eof(lu)) DO BEGIN 
    READF,lu,line               ; read line by line
    if strmid(line, 52,4) eq '1024' then begin
    c2times(i)=fix(strmid(line,28,2)+strmid(line,31,2))
    c2files(i)=las_path+date_lasco+'/c2/'+strmid(line,0,12)
    i=i+1
    endif
ENDWHILE

FREE_LUN,lu

c3times=intarr(150)
c3files=strarr(150)

if findfile(hdrc3) ne '' then begin
OPENR,lu,hdrc3,/get_lun
 
line=''     
i=0
while (not eof(lu)) DO BEGIN 
    READF,lu,line               ; read line by line
    if strmid(line, 52,4) eq '1024' then begin
    c3times(i)=fix(strmid(line,28,2)+strmid(line,31,2))
    c3files(i)=las_path+date_lasco+'/c3/'+strmid(line,0,12)
    i=i+1
    endif
ENDWHILE
endif

FREE_LUN,lu
endif
choice=''
ldisp=list()

;stop

if end_time_cor1 gt start_time then begin
sizecor1=size(cor1Afiles)
if seq eq 1 then begin
for i=3, sizecor1(1)-1, 3 do begin
        tmp=fix(strmid(cor1Afiles(i),55,4))
        lascoindex=where(abs(tmp-c2times) eq (min(abs(tmp-c2times))))
        print, cor1Afiles(i), cor1Bfiles(i), c2files(lascoindex)
        work_scraytrace, cor1A=cor1Afiles[i:i+2], cor1B=cor1Bfiles[i:i+2], Apre=cor1Afiles[i-3:i-1], Bpre=cor1Bfiles[i-3:i-1], lascopre=c2files(lascoindex[0]-1), lascoc2=c2files(lascoindex[0]), /seq


	read, choice, prompt='Continue to Next Time Step, Y or N: '
	if (strcmp(choice, 'n', /fold_case) eq 1) then return

;stop
endfor
endif else begin
for i=1, sizecor1(1)-1 do begin
        tmp=fix(strmid(cor1Afiles(i),55,4))
        lascoindex=where(abs(tmp-c2times) eq (min(abs(tmp-c2times))))
        print, cor1Afiles(i), cor1Bfiles(i), c2files(lascoindex)
        work_scraytrace, cor1A=cor1Afiles[i], cor1B=cor1Bfiles[i], Apre=cor1Afiles[i-1], Bpre=cor1Bfiles[i-1], lascopre=c2files(lascoindex[0]-1), lascoc2=c2files(lascoindex[0])
	read, choice, prompt='Continue to Next Time Step, Y or N: '
	if (strcmp(choice, 'n', /fold_case) eq 1) then return

;stop
endfor
endelse
endif
if end_time_cor2 gt start_time then begin
sizecor2=size(cor2Afiles)
;stop
for i=1, sizecor2(1)-1 do begin
	tmp=fix(strmid(cor2Afiles(i),55,4))
	if tmp lt end_time_c2 then begin 
		lascoindex=where(abs(tmp-c2times) eq (min(abs(tmp-c2times))))
     ;stop
;		work_scraytrace, cor2A=cor2Afiles(i), cor2B=cor2Bfiles(i), Apre=cor2Afiles(i-1), Bpre=cor2Bfiles(i-1), lascopre=c2files(lascoindex-3), lascoC2=c2files(lascoindex)
		work_scraytrace, cor2A=cor2Afiles(i), cor2B=cor2Bfiles(i), Apre=cor2Afiles(i-1), Bpre=cor2Bfiles(i-1), ldisp=tmpl, lascopre=c2files(lascoindex-3), lascoC2=c2files(lascoindex), mkim=mkim, flip=flip
		ldisp.add, tmpl, /extract
		print, 'COR2 TIME: ', int2str(tmp/100)+':'+int2str(tmp mod 100)
		tlas=where(abs(tmp-c2times) eq (min(abs(tmp-c2times))))
		print, 'C2 TIME: ', int2str(c2times(tlas[0])/100)+':'+int2str(c2times(tlas[0]) mod 100)
	endif else if tmp lt end_time_c3 then begin
		lascoindex=where(abs(tmp-c3times) eq (min(abs(tmp-c3times))))
		s=size(lascoindex)
		if(s(1) gt 1) then lascoindex=lascoindex(0)
	 ; stop
		work_scraytrace, cor2A=cor2Afiles(i), cor2B=cor2Bfiles(i), Apre=cor2Afiles(i-1), Bpre=cor2Bfiles(i-1), ldisp=tmpl, lascopre=c3files(lascoindex-1), lascoC3=c3files(lascoindex)
		ldisp.add, tmpl, /extract
		print, 'COR2 TIME: ', int2str(tmp/100)+':'+int2str(tmp mod 100)
		tlas=where(abs(tmp-c3times) eq (min(abs(tmp-c3times))))
		print, 'C3 TIME: ', int2str(c3times(tlas[0])/100)+':'+int2str(c3times(tlas[0]) mod 100)
	endif
	read, choice, prompt='Continue to Next Step, Y or N: '
	if (strcmp(choice, 'n', /fold_case) eq 1) then return	
	
endfor
endif
endif
choice=''
sizehi=size(hi1Afiles)

for i=1, sizehi(1)-1 do begin
	tmp=fix(strmid(hi1Afiles(i),55,4))
	tmp2=fix(strmid(hi1Afiles(i),50,4))
;	start_time_hi=400
	if tmp gt start_time_hi || tmp2 eq fix(strmid(end_date_hi,4, 4)) then begin
	if tmp lt end_time_c3 then begin ;&& tmp2 lt fix(strmid(end_date_hi,4, 4)) then begin
		;stop
		work_scraytrace, Apre=hi1Afiles(i-1), Bpre=hi1Bfiles(i-1), hi1A=hi1Afiles(i), hi1B=hi1Bfiles(i), ldisp=tmpl, lascopre=c3files(where(abs(tmp-c3times) eq (min(abs(tmp-c3times))))-3), lascoC3=c3files(where(abs(tmp-c3times) eq (min(abs(tmp-c3times))))), mkim=mkim
		ldisp.add, tmpl, /extract
		print, 'HI1 TIME: ', int2str(tmp/100)+':'+int2str(tmp mod 100)
		tlas=where(abs(tmp-c3times) eq (min(abs(tmp-c3times))))
		print, 'C3 TIME: ', int2str(c3times(tlas[0])/100)+':'+int2str(c3times(tlas[0]) mod 100)

	endif else begin
		work_scraytrace, Apre=hi1Afiles(i-1), Bpre=hi1Bfiles(i-1), hi1A=hi1Afiles(i), hi1B=hi1Bfiles(i)
		print, 'HI1 TIME: ', int2str(tmp/100)+':'+int2str(tmp mod 100)
	endelse
	
	read, choice, prompt='Continue to Next Time Step, Y or N: '
	if (strcmp(choice, 'n', /fold_case) eq 1) then return

	endif

endfor


;stop
end

