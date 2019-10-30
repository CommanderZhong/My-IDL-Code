pro source_region,lat,lon,png=png,ps=ps,bpath=bpath,epsilon=epsilon

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
    thick=!p.thick
    charthick=!p.charthick
    charsize=!p.charsize
    !p.thick=4
    !p.charthick=3

    !p.multi=[0,2,1]
    data=fltarr(4096,4096)
    contour,data,xtickformat='(A6)',ytickformat='(A6)',xstyle=5,ystyle=5,position=[0.17,0.35,0.88,0.9],xthick=0;,title='Source Region of CMEs'
    n=401
    theta=findgen(n)*2*!pi/(n-1)
    xy=fltarr(2,n)
    xy[0,*]=sin(theta)*r_sun+2048
    xy[1,*]=cos(theta)*r_sun+2048
    plots,xy,color=fsc_color('black')
    lin=(indgen(101)-50)/50.*r_sun+2048
    oplot,lin,replicate(2048,n_elements(lin)),color=fsc_color('black'),linestyle=2
    oplot,replicate(2048,n_elements(lin)),lin,color=fsc_color('black'),linestyle=2
    for i=-80,80,10 do begin
      latx=indgen(51)*180./50-90
      xx=2048+r_sun*cos(latx*!dtor)*sin(i*!dtor)
      yy=2048+sin(latx*!dtor)*r_sun
      plots,xx,yy,linestyle=2
    endfor
    for i=-80,80,10 do begin
      lonx=indgen(51)*180./50-90
      xx=2048+r_sun*cos(i*!dtor)*sin(lonx*!dtor)
      yy=2048+sin(i*!dtor)*r_sun
      plots,xx,yy,linestyle=2
    endfor

    lat1=lat
    lon1=lon
    for i=0l,n_elements(lat)-1 do begin
      if abs(lon1[i]) gt 90 then begin
        lon1[i]=(180-abs(lon1[i]))*lon1[i]/abs(lon1[i]) ;backward
        color1='red'
      endif else begin
        color1='blue'
      endelse

      xlon=2048+r_sun*cos(lat1[i]*!dtor)*sin(lon1[i]*!dtor)
      ylat=2048+sin(lat1[i]*!dtor)*r_sun
      plots,xlon,ylat,color=fsc_color(color1),psym=4,symsize=1.8
    endfor

    plots,1400,280,color=fsc_color('blue'),psym=4,symsize=1.8
    plots,1400,130,color=fsc_color('red'),psym=4,symsize=1.8
    loadct,0l
    xyouts,2048,3800,'Solar Disk',ALIGNMENT=0.5,charsize=1.8
    xyouts,2048,250,'->Front of The Solar Disk',ALIGNMENT=0.5
    xyouts,2048,100,'->Back of The Solar Disk',ALIGNMENT=0.5
    ;xyouts,2040,2040,'0!Eo!N',ALIGNMENT=0.5,charsize=1.2,charthick=1.5,color=fsc_color('red')
    loadct,0l
    
    !p.charsize=1.5
    maxlat=max(lat)
    minlat=min(lat)
    lx=indgen(361)-180
    ly=indgen(181)-90
    mx=replicate(1,n_elements(lx))
    my=replicate(1,n_elements(ly))
    for i=0l,n_elements(lat)-1 do begin
      if i eq 0l then begin
        plot,lon,lat,/nodata,xrange=[-180,180],yrange=[-90,90],xstyle=1,ystyle=1,position=[0.10,0.1,0.99,0.34],xtitle='!4w!3 (!Eo!N)',ytitle='!7h!3 (!Eo!N)'
        plots,lon[i],lat[i],psym=4,color=fsc_color('blue'),symsize=1.8
      endif else begin
        plots,lon[i],lat[i],psym=4,color=fsc_color('blue'),symsize=1.8
      endelse
    endfor
    oplot,lx,mx*maxlat,color=fsc_color('red'),linestyle=2
    oplot,lx,mx*minlat,color=fsc_color('red'),linestyle=2
    oplot,-90*my,ly,color=fsc_color('red'),linestyle=2
    oplot,90*my,ly,color=fsc_color('red'),linestyle=2
    xyouts,-150,maxlat+2,strmid(string(maxlat),6,5),color=fsc_color('red')
    xyouts,-150,minlat-10,strmid(string(minlat),5,6),color=fsc_color('red')
    xyouts,-110,0,'-90',color=fsc_color('red')
    xyouts,92,0,'90',color=fsc_color('red')
    !p.multi=0
    loadct,0l
    
    !p.thick =thick
    !p.charthick=charthick
    !p.charsize=charsize
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
    
    binsize2=10
    lathist=histogram(lat,Min=-45,Max=45,BINSIZE=binsize2,locations=binvals2)
    histplot1=barplot(binvals2,lathist,ytitle='No (#)',xtitle='$\theta\ ( ^o)$',position=[0.1,0.11,0.98,0.99],font_size=20,xrange=[-40,50],/histogram)
    ;histplot1=plot(binvals2,lathist,/overplot)
    ;text3=text(binvals2,lathist+0.1,strmid(string(binvals2),5,7),/data,color='red',alignment=0.5)
    text1=TEXT(-32,9.5,'(a)',/data,alignment=0.5,font_size=20)
    if keyword_set(ps) then histplot1.save,bpath+'result_image/lathist.eps',resolution=512,/transparent
    if keyword_set(png) then histplot1.save,bpath+'result_image/lathist.png',resolution=512,/transparent
    histplot1.close
    
    epsilon=acos(cos(lat*!dtor)*cos(lon*!dtor))/!dtor
    binsize3=10
    epshist=histogram(epsilon,min=0,max=120,BINSIZE=binsize3,locations=binvals3)
    histplot2=barplot(binvals3,epshist,ytitle='No (#)',xtitle='$\epsilon\ ( ^o)$',position=[0.1,0.11,0.98,0.99],font_size=20,xrange=[0,115],/histogram)
    ;histplot2=plot(binvals3,omghist,/overplot)
    ;text3=text(binvals3,epshist+0.1,strmid(string(binvals3),5,6),/data,color='red',alignment=0.5)
    if keyword_set(ps) then histplot2.save,bpath+'result_image/epshist.eps',resolution=512,/transparent
    if keyword_set(png) then histplot2.save,bpath+'result_image/epshist.png',resolution=512,/transparent
    histplot2.close

    binsize4=20
    lonhist=histogram(lon,min=-110,max=90,BINSIZE=binsize4,locations=binvals4)
    histplot3=barplot(binvals4,lonhist,ytitle='No (#)',xtitle='$\phi\ ( ^o)$',position=[0.1,0.11,0.98,0.99],font_size=20,xrange=[-120,100],/histogram)
    text1=TEXT(-100,17,'(b)',/data,alignment=0.5,font_size=20)
    if keyword_set(ps) then histplot3.save,bpath+'result_image/lonhist.eps',resolution=512,/transparent
    if keyword_set(png) then histplot3.save,bpath+'result_image/lonhist.png',resolution=512,/transparent
    histplot3.close
end