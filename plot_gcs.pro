pro plot_gcs,date=date
;+
;Purpose: TO plot CMEs front's hight-time image
;Syntax: plot_gcs,date=date
;Keyword:
; date:the string of date,with format of 'yymmdd',like '101206'
;Example:
; plot_gcs,date='111001'
;
;Log:
; v1.0  init            Z.H.Zhong at 04/21/2019
;-

if not keyword_set(date) then date='111001'

path='/home/zhzhong/Desktop/mywork/work/result/'+date+'/parameters'+date+'.txt'
openr,lun,path,/get_lun
nlines=3l
nlines=FILE_LINES(path)
print,nlines
;build up a structure
fmt='(a8,9x,f10.7,7x,f10.7,7x,f10.7,8x,f9.7,7x,f10.7,8x,f9.7)'
info={TIME:'',LON:0.0,LAT:0.0,ROT:0.0,HAN:0.0,HGT:0.0,RAT:0.0}
para=replicate(info,nlines-2) ;parameters

jump=strarr(2)
readf,lun,jump
nrecords=0L
while(nrecords ne nlines-2) do begin
  readf,lun,info,format=fmt
  para[nrecords]=info
  nrecords=nrecords+1L
endwhile
free_lun,lun

time=lindgen(nlines)
date1='20'+strmid(date,0,2)+'/'+strmid(date,2,2)+'/'+strmid(date,4,2)+' ' ;transfer date format from 'yymmdd' to 'yyyy/mm/dd'
time=anytim2tai(date1+para.TIME)-anytim2tai(date1+'00:00:00')
;print,para.TIME
;print,para.HGT
utplot,time,para.HGT,date1,xstyle=1,ytitle='Hight',title='Hight-Time Image'
end