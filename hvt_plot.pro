pro hvt_plot,time,Hight,head,num,ps=ps,png=png,bpath=bpath,degree=degree,date=date,coeff=coeff,fit_result=fit_result,$
                  h0=h0

  h0=0.5*(Hight[0]+Hight[-1])
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
  H_function='Height_fit='+strmid(string(fit_result[0,0]),6)
  v_fit=fit_result[0,1]
  V_function='Velocity_fit='+strmid(string(fit_result[0,1]),5)
  for i=0,degree-1 do begin
    H_fit=H_fit+fit_result[0,i+1]*(time1^(i+1))
    if fit_result[0,i+1] ge 0 then begin
      H_function=H_function+'+'+strmid(string(fit_result[0,i+1]),3)+'*T!E'+strmid(string(i+1),7)+'!N'
    endif else begin
      H_function=H_function+strmid(string(fit_result[0,i+1]),3)+'*T!E'+strmid(string(i+1),7)+'!N'
    endelse
    if i ge 1 then begin
      V_fit=V_fit+(i+1)*fit_result[0,i+1]*(time1^i)
      if fit_result[0,i+1] ge 0 then begin
        V_function=V_function+'+'+strmid(string(fit_result[0,i+1]),3)+'*T!E'+strmid(string(i),7)+'!N'
      endif else begin
        V_function=V_function+strmid(string(fit_result[0,i+1]),3)+'*T!E'+strmid(string(i),7)+'!N'
      endelse
    endif
  endfor
  ;plot image
  if keyword_set(png) then begin
    ;  loadct,0
    set_plot,'z'
    device,SET_RESOLUTION=[1024,512],SET_PIXEL_DEPTH=24,decomposed=1
    bground=!p.background
    bcolor=!p.color
    !p.background='FFFFFF'xl
    !p.color='000000'xl
    device,decomposed=0
  endif
  if keyword_set(ps) then begin
    set_plot,'ps'
    device,filename=bpath+'result_image/'+date+'.eps',/color,ENCAPSULATED=1
  endif

  thick=!p.thick
  charthick=!p.charthick
  charsize=!p.charsize
  !p.thick=3
  !p.charthick=3.0
  !p.charsize=1.5
  !p.multi=[0,2,1]
  loadct,0l
  utplot,time,Hight,head,/nodata,xstyle=1,ytitle='h!Ifront!N(km)',position=[0.15,0.57,0.99,0.99],xtickformat='(A6)',xtitle='';,title='Hight/Velocity-Time Image'
  oplot,time,Hight,psym=7,color=fsc_color('red')
  oplot,time1,H_fit,color=fsc_color('blue')
  oplot,time1,H_linfit,color=fsc_color('green'),linestyle=2
  xyouts,0.17,0.62,H_function,color=fsc_color('black'),/normal,CHARSIZE=1.2,charthick=2.5
  loadct,0l
  utplot,time1,V_fit,head,/nodata,xstyle=1,yrange=[min(V_fit)-100,max(V_fit)+100],ystyle=1,ytitle='V!IGCS!N(km*s!E-1!N)',position=[0.15,0.1,0.99,0.55];,titile='Velocity-TIme Image'
  oplot,time1,V_fit,color=fsc_color('blue')
  oplot,time1,replicate(coeff[1],npoints),color=fsc_color('green'),linestyle=2
  xyouts,0.17,0.15,V_function,color=fsc_color('black'),/normal,CHARSIZE=1.2,charthick=2.5
  xyouts,0.15,coeff[1]+5,string(coeff[1]),color=fsc_color('green')
  loadct,0l
  !p.multi=0
  if keyword_set(png) then begin
    a=tvrd(/true)
    filename=bpath+'result_image/'+date+'.png'
    write_image,filename,"png",a,r,g,b
    !p.background=bground
    !p.color=bcolor
    device,/close
    set_plot,'x'
  endif
  if keyword_set(ps) then begin
    device,/close
    set_plot,'x'
  endif
  !p.thick =thick
  !p.charthick=charthick
  !p.charsize=charsize
end