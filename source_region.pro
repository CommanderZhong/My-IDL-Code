pro source_region,lat,lon,png=png,ps=ps,bpath=bpath

  ;;plot soure region

    r_sun=1625.5946 ;from sdo data index
    if keyword_set(png) then begin
      set_plot,'z'
      device,SET_RESOLUTION=[800,900],SET_PIXEL_DEPTH=24,decomposed=1
      bground=!p.background
      bcolor=!p.color
      !p.background='FFFFFF'xl
      !p.color='000000'xl
      device,decomposed=0
    endif
    if keyword_set(ps) then begin
      set_plot,'ps'
      device,filename=bpath+'result_image/source_region.eps',/color,xs=24,ys=30,ENCAPSULATED=1
    endif

    !p.multi=[0,2,1]
    data=fltarr(4096,4096)
    contour,data,xtickformat='(A6)',ytickformat='(A6)',xstyle=1,ystyle=1,position=[0.10,0.37,0.99,0.8],title='Source Region of CMEs'
    n=401
    theta=findgen(n)*2*!pi/(n-1)
    xy=fltarr(2,n)
    xy[0,*]=sin(theta)*r_sun+2048
    xy[1,*]=cos(theta)*r_sun+2048
    plots,xy,color=fsc_color('red')
    lin=(indgen(101)-50)/50.*r_sun+2048
    oplot,lin,replicate(2048,n_elements(lin)),color=fsc_color('red'),linestyle=2
    oplot,replicate(2048,n_elements(lin)),lin,color=fsc_color('red'),linestyle=2

    lat1=lat
    lon1=lon
    for i=0l,n_elements(lat)-1 do begin
      if abs(lon1[i]) gt 90 then begin
        lon1[i]=(180-abs(lon1[i]))*lon1[i]/abs(lon1[i]) ;backward
        color1='green'
      endif else begin
        color1='blue'
      endelse

      xlon=2048+r_sun*cos(lat1[i]*!dtor)*sin(lon1[i]*!dtor)
      ylat=2048+sin(lat1[i]*!dtor)*r_sun
      plots,xlon,ylat,color=fsc_color(color1),psym=1
    endfor

    xyouts,0.55,0.40,'Blue + --Front of The Solar Disk',/normal,ALIGNMENT=0.5,color=fsc_color('blue')
    xyouts,0.55,0.38,'Green  + --Back of The Solar Disk',/normal,ALIGNMENT=0.5,color=fsc_color('green')
    loadct,0l

    maxlat=max(lat)
    minlat=min(lat)
    lx=indgen(361)-180
    ly=indgen(181)-90
    mx=replicate(1,n_elements(lx))
    my=replicate(1,n_elements(ly))
    for i=0l,n_elements(lat)-1 do begin
      if i eq 0l then begin
        plot,lon,lat,/nodata,xrange=[-180,180],yrange=[-90,90],xstyle=1,ystyle=1,position=[0.10,0.1,0.99,0.35],xtitle='Longitude',ytitle='Latitude'
        plots,lon[i],lat[i],psym=1,color=fsc_color('blue')
      endif else begin
        plots,lon[i],lat[i],psym=1,color=fsc_color('blue')
      endelse
    endfor
    oplot,lx,mx*maxlat,color=fsc_color('red'),linestyle=2
    oplot,lx,mx*minlat,color=fsc_color('red'),linestyle=2
    oplot,-90*my,ly,color=fsc_color('red'),linestyle=2
    oplot,90*my,ly,color=fsc_color('red'),linestyle=2
    xyouts,-150,maxlat+2,string(maxlat),color=fsc_color('red')
    xyouts,-150,minlat-10,string(minlat),color=fsc_color('red')
    xyouts,-105,0,'-90',color=fsc_color('red')
    xyouts,92,0,'90',color=fsc_color('red')
    !p.multi=0
    loadct,0l
    if keyword_set(png) then begin
      a=tvrd(/true)
      name=bpath+'result_image/source_region.png'
      write_image,name,"png",a,r,g,b
      !p.background=bground
      !p.color=bcolor
      device,/close
      set_plot,'x'
    endif
    if keyword_set(ps) then begin
      device,/close
      set_plot,'x'
    endif
    
    binsize2=(max(lat)-min(lat))/10.
    lathist=histogram(lat,BINSIZE=binsize2,locations=binvals2)
    histplot1=barplot(binvals2,lathist,ytitle='Num(#)',xtitle='Latitude(!Eo!N)')
    ;histplot1=plot(binvals2,lathist,/overplot)
    text3=text(binvals2,lathist+0.1,strmid(string(binvals2),5,7),/data,color='red',alignment=0.5)
    if keyword_set(ps) then histplot1.save,bpath+'result_image/lathist.eps',resolution=512,/transparent
    if keyword_set(png) then histplot1.save,bpath+'result_image/lathist.png',resolution=512,/transparent
    histplot1.close
    
    omega=acos(cos(lat*!dtor)*cos(lon*!dtor))/!dtor
    binsize3=(max(omega)-min(omega))/10.
    omghist=histogram(omega,BINSIZE=binsize3,locations=binvals3)
    histplot2=barplot(binvals3,omghist,ytitle='Num(#)',xtitle='$\omega $(!Eo!N)')
    ;histplot2=plot(binvals3,omghist,/overplot)
    text3=text(binvals3,omghist+0.1,strmid(string(binvals3),5,6),/data,color='red',alignment=0.5)
    if keyword_set(ps) then histplot2.save,bpath+'result_image/omghist.eps',resolution=512,/transparent
    if keyword_set(png) then histplot2.save,bpath+'result_image/omghist.png',resolution=512,/transparent
    histplot2.close
end