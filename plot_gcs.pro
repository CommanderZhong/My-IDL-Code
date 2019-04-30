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
; plot_gcs,date='111001',/png,/nolist
; plot_gcs,/ps
;Log:
; v1.0  init                       Z.H.Zhong at 04/21/2019
; v1.1  add keyword png,ps,degree  Z.H.Zhong at 04/23/2019
; v1.2  add keyword nosr,nolist    Z.H.Zhong at 04/24/2019
; v1.3  add lin-fit                Z.H.Zhong at 04/30/2019
;-

pro plot_gcs,date=date,nosr=nosr,png=png,ps=ps,degree=degree,$
             nolist=nolist          

bpath='/home/zhzhong/Desktop/mywork/work/'
if keyword_set(nolist) then begin
  if not keyword_set(date) then date='111001'
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
for d=0,n_elements(date)-1 do begin
  path=findfile(bpath+'result/'+date[d]+'/*.txt')
  openr,lun,path,/get_lun
  nlines=3l
  nlines=FILE_LINES(path)
  num=nlines-2
  para=replicate(info,num) ;parameters
  ;read data from data file
  jump=''
  readf,lun,jump
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
  
  ;linfit
  coeff=linfit(time,Hight)

  ;use poly fit to perform polynomial fit
  npoints=101
  time1=lindgen(npoints)*(max(time)-min(time))/(npoints-1)+min(time) ;min(time)=0
  H_linfit=coeff[0]+coeff[1]*time1
  if not keyword_set(degree) then degree=2
  measure_errors=replicate(1,num)
  fit_result=poly_fit(time,Hight,degree,MEASURE_ERRORS=measure_errors,SIGMA=sigma)
  H_fit=fit_result[0,0]
  H_function='Hight_fit='+strmid(string(fit_result[0,0]),6)
  v_fit=fit_result[0,1]
  V_function='Velocity_fit='+strmid(string(fit_result[0,1]),5)
  for i=0,degree-1 do begin
    H_fit=H_fit+fit_result[0,i+1]*(time1^(i+1))
    if fit_result[0,i+1] ge 0 then begin
      H_function=H_function+'+'+strmid(string(fit_result[0,i+1]),3)+'*!7D!3time^'+strmid(string(i+1),7)
    endif else begin
      H_function=H_function+strmid(string(fit_result[0,i+1]),3)+'*!7D!3time^'+strmid(string(i+1),7)
    endelse
    if i ge 1 then begin
      V_fit=V_fit+(i+1)*fit_result[0,i+1]*(time1^i)
      if fit_result[0,i+1] ge 0 then begin
        V_function=V_function+'+'+strmid(string(fit_result[0,i+1]),3)+'*!7D!3time^'+strmid(string(i),7)
      endif else begin
        V_function=V_function+strmid(string(fit_result[0,i+1]),3)+'*!7D!3time^'+strmid(string(i),7)
      endelse
    endif
  endfor
  ;plot image
  if keyword_set(png) then begin
    ;  loadct,0
    set_plot,'z'
    device,SET_RESOLUTION=resolution,SET_PIXEL_DEPTH=24,decomposed=0
  endif
  if keyword_set(ps) then begin
    set_plot,'ps'
    device,filename=bpath+'result_image/'+date[d]+'.eps',/color,xs=24,ys=12,ENCAPSULATED=1
  endif

  !p.thick=3
  !p.charthick=2
  !p.charsize=1.0
  !p.multi=[0,2,1]
  loadct,0l
  utplot,time,Hight,date1[0]+para[0].TIME,/nodata,xstyle=1,ytitle='Hight/km',position=[0.10,0.57,0.99,0.9],xtickformat='(A6)',xtitle='',title='Hight/Velocity-Time Image'
  oplot,time,Hight,psym=7,color=fsc_color('red')
  oplot,time1,H_fit,color=fsc_color('blue')
  oplot,time1,H_linfit,color=fsc_color('green'),linestyle=2
  xyouts,0.12,0.62,H_function,color=fsc_color('green'),/normal,CHARSIZE=0.9
  loadct,0l
  utplot,time1,V_fit,date1[0]+para[0].TIME,/nodata,xstyle=1,ytitle='Velocity/km*s!E-1!N',position=[0.10,0.1,0.99,0.55];,titile='Velocity-TIme Image'
  oplot,time1,V_fit,color=fsc_color('blue')
  oplot,time1,replicate(coeff[1],npoints),color=fsc_color('green'),linestyle=2
  xyouts,0.12,0.15,V_function,color=fsc_color('green'),/normal,CHARSIZE=0.9
  loadct,0l
  !p.multi=0
  if keyword_set(png) then begin
    a=tvrd(/true)
    filename=bpath+'result_image/'+date[d]+'.png'
    write_image,filename,"png",a,r,g,b
    device,/close
    set_plot,'x'
  endif
  if keyword_set(ps) then begin
    device,/close
    set_plot,'x'
  endif
  lat=[lat,para[0].lat]
  lon=[lon,para[0].lon]
endfor
help,lat
;;plot soure region
if not keyword_set(nosr) then begin
;aia_prep,'aia.lev1_euv_12s.2011-01-01T115933Z.193.image_lev1.fits',-1,index,data;要联网，经过修正
read_sdo,'/home/zhzhong/Desktop/mywork/aia.lev1_euv_12s.2011-01-01T115933Z.193.image_lev1.fits',index,data;不要联网，未经修正
if keyword_set(png) then begin
  ;  loadct,0
  set_plot,'z'
  device,SET_RESOLUTION=resolution,SET_PIXEL_DEPTH=24,decomposed=0
endif
if keyword_set(ps) then begin
  set_plot,'ps'
  device,filename=bpath+'result_image/source_region.eps',/color,xs=24,ys=30,ENCAPSULATED=1
endif
!p.multi=[0,2,1]
contour,data-data,xtickformat='(A6)',ytickformat='(A6)',xstyle=1,ystyle=1,position=[0.10,0.37,0.99,0.8],title='Source Region of CMEs'
;plot_image,bytscl(data/index.exptime,0,1),xtickformat='(A6)',ytickformat='(A6)',position=[0.10,0.37,0.99,0.8],title='Source Region of CMEs'
;help,index,/str
wcs=fitshead2wcs(index)
n=401
theta=findgen(n)*2*!pi/(n-1)
xy=fltarr(2,n)
xy[0,*]=sin(theta)*index.r_sun+2048
xy[1,*]=cos(theta)*index.r_sun+2048
;xy=wcs_get_pixel(wcs,xy*index.rsun_obs) ;rsun_obs,rsun_ref,r_sun
;print,index.rsun_obs,index.rsun_ref,index.r_sun
plots,xy,color=fsc_color('red')
lat=lat/!dtor
lon=lon/!dtor-168.103 ;0-360
lat1=lat
lon1=lon
for i=0l,n_elements(lat)-1 do begin
  if abs(lon1[i]) gt 90 then begin
    lon1[i]=(180-abs(lon1[i]))*lon1[i]/abs(lon1[i]) ;backward
    color1='blue'
  endif else begin
    color1='green'
  endelse
  ;wcs_convert_to_coord,wcs,coord,'HG',lon1[i],lat1[i]
  ;pixel=wcs_get_pixel(wcs,coord)
  xlon=2048+index.r_sun*cos(lat1[i]*!dtor)*sin(lon1[i]*!dtor)
  ylat=2048+sin(lat1[i]*!dtor)*index.r_sun
  plots,xlon,ylat,color=fsc_color(color1),psym=1
  ;plots,pixel[0],pixel[1],color=fsc_color(color1),psym=1
endfor
;for i=0,355,5 do begin
;wcs_convert_to_coord,wcs,coord,'HG',/Carrington,i,40
;pixel=wcs_get_pixel(wcs,coord)
;plots,pixel[0],pixel[1],color=fsc_color('black'),psym=3
;endfor
loadct,0l
xyouts,0.55,0.40,'Green + --Front of The Solar Disk',/normal,ALIGNMENT=0.5
xyouts,0.55,0.38,'Blue  + --Back of The Solar Disk',/normal,ALIGNMENT=0.5
;wcs_convert_to_coord,wcs,coord,'HG',/Carrington,330,0
;pixel=wcs_get_pixel(wcs,coord)
;plots,pixel[0],pixel[1],color=fsc_color(color1),psym=1
;loadct,0l
maxlat=max(lat)
minlat=min(lat)
l=indgen(361)-180
m=replicate(1,n_elements(l))
for i=0l,n_elements(lat)-1 do begin
  if i eq 0l then begin
    plot,lon,lat,/nodata,xrange=[-180,180],yrange=[-90,90],xstyle=1,ystyle=1,position=[0.10,0.1,0.99,0.35],xtitle='Longitude',ytitle='Latitude'
    plots,lon[i],lat[i],psym=1,color=fsc_color('green')
  endif else begin
    plots,lon[i],lat[i],psym=1,color=fsc_color('green')
  endelse
endfor
oplot,l,m*maxlat,color=fsc_color('black'),psym=3
oplot,l,m*minlat,color=fsc_color('black'),psym=3
!p.multi=0
loadct,0l
if keyword_set(png) then begin
  a=tvrd(/true)
  name=bpath+'result_image/source_region.png'
  write_image,name,"png",a,r,g,b
  device,/close
  set_plot,'x'
endif
if keyword_set(ps) then begin
  device,/close
  set_plot,'x'
endif
endif
end