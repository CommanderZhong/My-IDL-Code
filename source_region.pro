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

    lat1=lat
    lon1=lon
    for i=0l,n_elements(lat)-1 do begin
      if abs(lon1[i]) gt 90 then begin
        lon1[i]=(180-abs(lon1[i]))*lon1[i]/abs(lon1[i]) ;backward
        color1='blue'
      endif else begin
        color1='green'
      endelse

      xlon=2048+r_sun*cos(lat1[i]*!dtor)*sin(lon1[i]*!dtor)
      ylat=2048+sin(lat1[i]*!dtor)*r_sun
      plots,xlon,ylat,color=fsc_color(color1),psym=1
    endfor

    loadct,0l
    xyouts,0.55,0.40,'Green + --Front of The Solar Disk',/normal,ALIGNMENT=0.5
    xyouts,0.55,0.38,'Blue  + --Back of The Solar Disk',/normal,ALIGNMENT=0.5

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
    oplot,l,m*maxlat,color=fsc_color('red'),linestyle=2
    oplot,l,m*minlat,color=fsc_color('red'),linestyle=2
    xyouts,-150,maxlat+2,string(maxlat),color=fsc_color('red')
    xyouts,-150,minlat-10,string(minlat),color=fsc_color('red')
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
end