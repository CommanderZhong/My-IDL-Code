;+
;Purpose: TO plot CMEs front's hight-time image
;Syntax: plot_gcs,date=date,[/nosr,/ps[,/png],degree=value]
;Keyword:
; date:the string of date,with format of 'yymmdd',like '101206'
; nosr:do not plot source region image
; png:set /png to save png image
; ps:set /ps to save ps image
; degree:the degree of polynomial fit of data,at least 2;with a
;        form of f(x)=x1+x2*x+x3*x^2+……
;Example:
; plot_gcs,date=['111001'],/png,/nolist
; plot_gcs,/ps
;Log:
; v1.0  init                       Z.H.Zhong at 04/21/2019
; v1.1  add keyword png,ps,degree  Z.H.Zhong at 04/23/2019
; v1.2  add keyword nosr,nolist    Z.H.Zhong at 04/24/2019
; v1.3  add lin-fit                Z.H.Zhong at 04/30/2019
;-

pro plot_gcs,date=date,nosr=nosr,degree=degree,$
             nolist=nolist          

bpath='/home/zhzhong/Desktop/mywork/work/'
if keyword_set(nolist) then begin
  if not keyword_set(date) then date=['111001']
endif else begin
  if not keyword_set(date) then begin
    spawn,'ls '+bpath+'result/',listing
    date=listing
  endif
endelse

Rsun=696300l ;kilometer
;build up a structure
fmt='(a8,1x,a8,10x,f9.7,7x,f10.7,7x,f10.7,8x,f9.7,7x,f10.7,8x,f9.7)'
info={Date:'',TIME:'',LON:0.0,LAT:0.0,ROT:0.0,HAN:0.0,HGT:0.0,RAT:0.0}
lat=[]
lon=[]
v=[] ;velocity
acc=[] ;acceleration
han=[] ;half angle
rat=[]
rotat=[]

;read data from Prof. Shen
fmt1='(a8,1x,a8,1x,f3,1x,f3,1x,f3,1x,f4)'
info1={Date:'',TIME:'',LON:0.0,LAT:0.0,AN:0.0,V:0.0}
path1=findfile(bpath+'data_shen.txt')
openr,lun,path1,/get_lun
nlines1=3l
nlines1=FILE_LINES(path1)
num1=nlines1-1
para1=replicate(info1,num1) ;parameters
;read data from data file
temp=''
readf,lun,temp
nrecords=0L
while(nrecords ne num1) do begin
  readf,lun,info1,format=fmt1
  para1[nrecords]=info1
  nrecords=nrecords+1L
endwhile
free_lun,lun
;read arrive time data
path2=findfile(bpath+'data_arrive.txt')
openr,lun,path2,/get_lun
nlines2=3l
nlines2=FILE_LINES(path2)
num2=nlines2-1
arrive=strarr(num2)
temp=''
readf,lun,temp
nrecords=0l
while(nrecords ne num2) do begin
  readf,lun,temp,format='(a19)'
  arrive[nrecords]=temp
  nrecords=nrecords+1l
endwhile
free_lun,lun

start=strarr(n_elements(date))  ;start time of observed CME
haver=[]
;openw,lun1,bpath+'dd.txt',/get_lun
for d=0,n_elements(date)-1 do begin
  path=findfile(bpath+'result/'+date[d]+'/*.txt')
  openr,lun,path,/get_lun
  nlines=3l
  nlines=FILE_LINES(path)
  num=nlines-1
  para=replicate(info,num) ;parameters
  ;read data from data file
  temp=''
  readf,lun,temp
  nrecords=0L
  while(nrecords ne num) do begin
    readf,lun,info,format=fmt
    para[nrecords]=info
    nrecords=nrecords+1L
  endwhile
  free_lun,lun

  time=lindgen(num)
  date1=strmid(para.Date,0,4)+'/'+strmid(para.Date,4,2)+'/'+strmid(para.Date,6,2)+' ' ;transfer date format 'yyyy/mm/dd'
  time=anytim2tai(date1+para.TIME)-anytim2tai(date1[0]+para[0].TIME)
  Hight=para.HGT*Rsun
  start[d]=date1[0]+para[0].TIME
  
  hvt_plot,time,Hight,date1[0]+para[0].TIME,num,/ps,date=date[d],bpath=bpath,coeff=coeff,fit_result=fit_result,h0=h0

  haver=[haver,h0]
  lat=[lat,para[0].lat]
  lon=[lon,para[0].lon]
  v=[v,coeff[1]]
  acc=[acc,2*fit_result[0,2]]
  han=[han,average(para.han)]
  rat=[rat,average(para.rat)]
  rotat=[rotat,para[0].rot]
  
;  if para[0].han gt 0.5 then begin
;   
;  printf,lun1,start[d],(para[0].lon/!dtor-tim2carr(start[d]))*!dtor,para[0].lat,para[0].rot,para[0].han,para[0].rat
;  endif  
endfor
;free_lun,lun1
lat=lat/!dtor
lon=lon/!dtor
rotat=rotat/!dtor

han=han+asin(rat)
han=han/!dtor
L0=tim2carr(start)
for i=0,n_elements(lon)-1 do begin
  if lon[i]-L0[i] gt 0 then begin
    lon[i]=lon[i]-L0[i]
  endif else begin
    lon[i]=lon[i]-L0[i]+360
  endelse
endfor
loc=where(lon gt 180)
lon(loc)=lon(loc)-360
;pmm,lon
;*******New Criterion*******
new_criterion,lat,lon,han,rotat,rat,bpath=bpath
;***************************

loc=where(para1.v gt 0)
lat=[lat,para1[loc].lat]
lon=[lon,para1[loc].lon]
rotat=[rotat,replicate(91,num1-1)]
v=[v,para1[loc].v]
han=[han,para1[loc].an/2.]
start=[start,strmid(para1[loc].Date,0,4)+'/'+strmid(para1[loc].Date,4,2)+'/'+strmid(para1[loc].Date,6,2)+' '+para1[loc].Time]

path3=findfile(bpath+'vcdaw.txt')
openr,lun,path3,/get_lun
nline3=3l
nline3=file_lines(path3)
fmt2='(a19,7x,f)'
info2={TIME:'',Vcdaw:0.0}
para2=replicate(info2,nline3)
nrecords3=0L
while(nrecords3 ne nline3) do begin
  readf,lun,info2,format=fmt2
  para2[nrecords3]=info2
  nrecords3=nrecords3+1L
endwhile
free_lun,lun

openw,lun,bpath+'table.txt',/get_lun
record=n_elements(v)
for i=0,record-1 do begin
  printf,lun,start[i],lon[i],lat[i],rotat[i],han[i],v[i]
endfor
free_lun,lun

openw,lun,bpath+'ratio.txt',/get_lun
record=n_elements(rat)
for i=0,record-1 do begin
  printf,lun,start[i],rat[i]
endfor
free_lun,lun

openw,lun,bpath+'acc.txt',/get_lun
record1=n_elements(acc)
for i=0,record1-1 do begin
  printf,lun,start[i],acc[i]*1000
endfor
free_lun,lun

    if not keyword_set(nosr) then source_region,lat,lon,/ps,bpath=bpath,epsilon=epsilon
    v_acc_hist,v,acc,lat,/ps,bpath=bpath,k=k
    v_others,start,arrive,v,acc,han,haver,/ps,bpath=bpath,epsilon=epsilon,k=k
    ;loc=where(para2.vcdaw gt 0)
    ;vcdaw_others,v(loc),para2(loc).vcdaw,lat,lon,/ps,bpath=bpath
;vvv
  v_posi,v,lat,lon,bpath=bpath
end