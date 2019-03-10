;;To read sav data file
;;example:
;;       sav_read,date='120614'
pro sav_read,date=date
path='/home/zhzhong/Desktop/mywork/work/savdata/'+date+'/'
file=findfile(path+'*.sav')
;There are 6 kinds of parameters in total
n=6
m=1
m=n_elements(file)
par=fltarr(n,m)
for i=0,m-1 do begin
restore,file(i)
;help,sguiout,/str
par[0,i]=sguiout.LON
par[1,i]=sguiout.LAT
par[2,i]=sguiout.ROT
par[3,i]=sguiout.HAN
par[4,i]=sguiout.HGT
par[5,i]=sguiout.RAT
endfor
title='date='+date
subtitle='      LON          LAT          ROT         HAN           HGT         RAT'
openw,lun,path+'pardata'+date+'.txt',/get_lun
printf,lun,title
printf,lun,subtitle
printf,lun,par
free_lun,lun
end



 ; LON             FLOAT           0.00000
 ; LAT             FLOAT           0.00000
 ; ROT             FLOAT           0.00000
 ; HAN             FLOAT          0.523599
 ; HGT             FLOAT           2.00000
 ; RAT             FLOAT          0.400000
