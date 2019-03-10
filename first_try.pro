pro first_try
openr,lun,'C:\Users\Hunter\Desktop\1\txt_try.txt',/get_lun
;建立一个结构体数组
fmt='(2x,f5.2,12x,i2.2,1x,i2.2,1x,i2.2,a)'
info={Height:0.0,hour:0L,min:0L,sec:0L}
data=replicate(info,29)
b=strarr(29)
H=fltarr(29)
time=fltarr(29)
nrecords=0L
;先滤过前面不要的
readf,lun,b
;开始读入数据
while(nrecords ne 29) do begin
     readf,lun,info,format=fmt
     data[nrecords]=info
     nrecords=nrecords+1L
endwhile
free_lun,lun
nrecords=0L
while(nrecords ne 29) do begin
     H[nrecords]=data[nrecords].Height
     time[nrecords]=data[nrecords].hour*3600+data[nrecords].min*60+data[nrecords].sec
    ; time_arr[nrecords]=data[nrecords].Time
     nrecords=nrecords+1L
endwhile
coeff=linfit(time,H)
H_fit=coeff[0]+coeff[1]*time
utplot,time,H,'00:00:00',/ynozero,psym=5,xtitle='time(sec)',ytitle='Height'
oplot,time,H_fit
end