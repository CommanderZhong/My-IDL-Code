pro findloc,data,val,x,y
;From Jiayi Liu
;To find overlap points---deal with the problem of contour
  n1=n_elements(data[0,*])
  n2=n_elements(data[*,0])
  x=-1 & y=-1
  for i=0,n1-1 do begin
    for j=0,n2-1 do begin
      if (abs(data[j,i]-val) le 0.01) then begin ;or data[j,i] eq va1
        x=[x,j] & y=[y,i]
      endif
    endfor
  endfor
  id=where(x ge 0)
  x=x[id]
  y=y[id]
end

pro sav_read,date=date,nolasco=nolasco

;;To read sav data file
;;keyword:
;;      date:the date of sav file
;;      nolasco:if nolasco ,set /nolasco
;;example:
;;       sav_read,date='120623',/nolasco

if not keyword_set(nolasco) then nolasco=2

path='/home/zhzhong/Desktop/mywork/work/savdata/'+date+'/'
file=findfile(path+'*.sav')
;There are 6 kinds of parameters in total
n=6
m=1
m=n_elements(file)
par=fltarr(n,m)
;;create a new txt file to save parameters' data
openw,lun,path+'parameters'+date+'.txt',/get_lun
title='date='+date
subtitle='TIME              LON              LAT              ROT              HAN              HGT              RAT' ;blank to keep formation
printf,lun,title
printf,lun,subtitle
thisFormat='(a,6(f,2x),/)'

for i=0,m-1 do begin
  restore,file(i)
  ;make a eps picture
  set_plot,'ps'   ;plot eps
  device,filename=path+date+string(i+1,format='(I2.2)')+'.eps',xsize=50,ysize =33,/color,ENCAPSULATED=1,BITS_PER_PIXEL=8
  loadct,0l
  !p.multi=[0,2,3]
;STEREO Ahead
  plot_image,sgui.ima,position=[0.0025,0.0,0.3325,0.5],charsize=3,xtickformat='(A6)',ytickformat='(A6)'
  xyouts,0.1675,0.03,'STEREO-A '+SGUI.HDRA.DATE_OBS,/NORMAL,ALIGNMENT=0.5,CHARSIZE=1.5,COLOR=255
  tvlct,0,255,0,254 ;Green
  findloc,swire.sa.im,1,x,y
  plots,x,y,psym=3,color=254
  ;contour,swire.sa.im,/overplot,color=254,levels=1
  loadct,0l
  plot_image,sgui.ima,position=[0.0025,0.5,0.3325,1],charsize=3,xtickformat='(A6)',ytickformat='(A6)'
;LASCO
  if nolasco eq 1 then begin
    xyouts,0.165+0.335,0.5,'MISSING LASCO DATA',/NORMAL,ALIGNMENT=0.5,CHARSIZE=1.5,COLOR=0
  endif else begin
    plot_image,sgui.imlasco,position=[0.3350,00.,0.6650,0.5],charsize=3,xtickformat='(A6)',ytickformat='(A6)'
    xyouts,0.165+0.335,0.03,'LASCO C2 20'+strmid(date,0,2)+'-'+strmid(date,2,2)+'-'+strmid(date,4,2)+'T'+SGUI.SHDRLASCO.TIME_OBS,/NORMAL,ALIGNMENT=0.5,CHARSIZE=1.5,COLOR=255
    tvlct,0,255,0,254
    findloc,swire.sa.im,1,x,y  ;to deal with overlap points
    plots,x,y,psym=3,color=254
    ;contour,swire.slasco.im,/overplot,color=254,levels=1
    loadct,0l
    plot_image,sgui.imlasco,position=[0.3350,00.5,0.6650,1],charsize=3,xtickformat='(A6)',ytickformat='(A6)' ;without gcs model
  endelse
;STEREO Behind
  plot_image,sgui.imb,position=[0.6675,0.00,0.9975,0.5],charsize=3,xtickformat='(A6)',ytickformat='(A6)'
  xyouts,0.165+0.6675,0.03,'STEREO-B '+SGUI.HDRb.DATE_OBS,/NORMAL,ALIGNMENT=0.5,CHARSIZE=1.5,COLOR=255
  tvlct,0,255,0,254
  ;contour,swire.sb.im,/overplot,color=254,levels=1
  findloc,swire.sa.im,1,x,y
  plots,x,y,psym=3,color=254
  loadct,0l
  plot_image,sgui.imb,position=[0.6675,0.5,0.9975,1.],charsize=3,xtickformat='(A6)',ytickformat='(A6)'

  !p.multi=0
  ;write_image,'result.png','png',tvrd(true=1)  ;to plot with windows
  device,/close
  set_plot,'x'
;save 6 parameters
  par[0,i]=sgui.LON
  par[1,i]=sgui.LAT
  par[2,i]=sgui.ROT
  par[3,i]=sgui.HAN
  par[4,i]=sgui.HGT
  par[5,i]=sgui.RAT
  eruptiontime=strmid(sgui.ERUPTIONDATE,11,12)
  printf,lun,eruptiontime,par[*,i],Format=thisFormat
endfor
free_lun,lun

end


pro gcs_try,date=date,base=base,nolasco=nolasco,head,tail

;;Purpose:   To use gcs model 
;;Use:   gcs_try,date=date,head,tail[,/nolasco]
;;Keywords:
;;       date:string,the date to use gcs model
;;       nolasco:set /nolasco if there is no lasco data
;;       base:the base to diff
;;       head:the start number of file
;;       tail:the end number of file
;;Example:
;;	 gcs_try,date='120623',base=18,/nolasco,20,28 ;for nolasco
;;Log:
;;v1.0   init                                    Z.H.Zhong at 02/26/2019
;;v1.1   use base difference                     Z.H.Zhong at 03/17/2019
;;v1.2   add keyword nolasco                     Z.H.Zhong at 03/18/2019
;;v1.3   add keyword base                        Z.H.Zhong at 03/19/2019
;;v1.4   use keyword swire(rtsccguicloud.pro)    Z.H.Zhong at 03/21/2019

if not keyword_set(nolasco) then nolasco=2
if not keyword_set(base) then base=0 

;set base 
k=base
;find fits file
patha='/home/zhzhong/Desktop/mywork/data/'+date+'/STA'
pathb='/home/zhzhong/Desktop/mywork/data/'+date+'/STB'
filea=findfile(patha+'/*fts')
fileb=findfile(pathb+'/*fts')
;read base fits file
secchi_prep,filea[k],bindexa,bdataa,/silent,/smask_on,/rotate_on,/calfac_off,/calimg_off
secchi_prep,fileb[k],bindexb,bdatab,/silent,/smask_on,/rotate_on,/calfac_off,/calimg_off
if nolasco ne 1 then begin
  pathl='/home/zhzhong/Desktop/mywork/data/'+date+'/LC2'
  filel=findfile(pathl+'/*fts')
  bdatal=lasco_readfits(filel[k],bindexl)
endif

;do cycle to read fits file
for i=head,tail do begin          
  secchi_prep,filea[i],indexa,dataa,/silent,/smask_on,/rotate_on,/calfac_off,/calimg_off
  secchi_prep,fileb[i],indexb,datab,/silent,/smask_on,/rotate_on,/calfac_off,/calimg_off
;do diff
  dataa=dataa-bdataa
  datab=datab-bdatab
;do data procession
  imagea=congrid(bytscl(median(smooth(dataa,5),5),-5,5),512,512)       ;running difference -2-2
  imageb=congrid(bytscl(median(smooth(datab,5),5),-5,5),512,512)
  if nolasco ne 1 then begin
    datal=lasco_readfits(filel[i],indexl)
    datal=datal-bdatal
    imagel=congrid(bytscl(median(smooth(datal,3),3),-80,80),512,512)      ;running difference -30-30
  endif
	
;use gcs model
  if nolasco eq 1 then begin
    rtsccguicloud,imagea,imageb,indexa,indexb,sgui=sgui,swire=swire
  endif else begin
    rtsccguicloud,imagea,imageb,indexa,indexb,imlasco=imagel,hdrlasco=indexl,sgui=sgui,swire=swire
  endelse
        
	;save sav data file
	savfile='/home/zhzhong/Desktop/mywork/work/savdata/'+date+'/'
	spawn,'mkdir -p '+savfile
	name=savfile+'/out'+string(i-head+1,format='(I2.2)')+'.sav'
	SAVE,sgui,swire,FILENAME=name
endfor

   ;call for procedure sav_read
   if nolasco eq 1 then begin 
    sav_read,date=date,/nolasco
   endif else begin
    sav_read,date=date
   endelse
end