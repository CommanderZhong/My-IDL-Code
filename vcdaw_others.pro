pro vcdaw_others,v,vcdaw,lat,lon,ps=ps,png=png,bpath=bpath
    
    project=v/vcdaw
    bsize=(max(project)-min(project))/10.
    prohist=histogram(project,BINSIZE=bsize,locations=binvals)
    vcdawp=barplot(binvals,prohist,xtickformat='(A6)',xrange=[0.3,3.0],ytitle='Num(#)',POSITION=[0.1,0.86,0.95,0.99])
    vcdawp=plot(project,lat,/curr,POSITION=[0.1,0.61,0.95,0.84],xrange=[0.3,3.0],ytitle='$\theta (\deg)$',xtickformat='(A6)')
    vcdawp.SYMBOL='+'
    vcdawp.LINESTYLE=''
    vcdawp.SYM_COLOR='r'
    vcdawp=plot(project,lon,/curr,POSITION=[0.1,0.35,0.95,0.59],xrange=[0.3,3.0],ytitle='$\phi (\deg)$',xtickformat='(A6)')
    vcdawp.SYMBOL='d'
    vcdawp.LINESTYLE=''
    vcdawp.SYM_COLOR='r'
   
    epsilon=acos(cos(lat*!dtor)*cos(lon*!dtor))/!dtor
    vcdawp=plot(project,epsilon,/curr,POSITION=[0.1,0.1,0.95,0.33],xrange=[0.3,3.0],ytitle='$\epsilon (\deg)$',xtitle='$V_{GCS}/V_{CDAW}$')
    vcdawp.SYMBOL='o'
    vcdawp.LINESTYLE=''
    vcdawp.SYM_COLOR='r'
    if keyword_set(ps) then vcdawp.save,bpath+'result_image/vcdaw.eps',resolution=512,/transparent
    if keyword_set(png) then vcdawp.save,bpath+'result_image/vcdaw.png',resolution=512,/transparent
    vcdawp.close
    
    loc1=where(project lt 0.8)
    loc2=where((project gt 0.8) and (project lt 1.2))
    loc3=where(project gt 1.2)
    vcdawp1=plot(lat(loc3),vcdaw(loc3),/curr,xtitle='$\theta (\deg)$',ytitle='$V_{CDAW}$')
    vcdawp1.SYMBOL='o'
    vcdawp1.SYM_SIZE=1.4
    vcdawp1.sym_filled=1.0
    vcdawp1.LINESTYLE=''
    vcdawp1.SYM_COLOR='blue'
    vcdawp1=plot(lat(loc2),vcdaw(loc2),/curr,/overplot)
    vcdawp1.SYMBOL='tu'
    vcdawp1.SYM_SIZE=1.0
    vcdawp1.LINESTYLE=''
    vcdawp1.SYM_COLOR='red'
    vcdawp1=plot(lat(loc1),vcdaw(loc1),/curr,/overplot)
    vcdawp1.SYMBOL='D'
    vcdawp1.SYM_SIZE=1.0
    vcdawp1.LINESTYLE=''
    vcdawp1.SYM_COLOR='green'
    if keyword_set(ps) then vcdawp1.save,bpath+'result_image/vcdaw1.eps',resolution=512,/transparent
    if keyword_set(png) then vcdawp1.save,bpath+'result_image/vcdaw1.png',resolution=512,/transparent
    vcdawp1.close   
    
    vcdawp2=plot(lon(loc3),vcdaw(loc3),/curr,xtitle='$\phi (\deg)$',ytitle='$V_{CDAW}$')
    vcdawp2.SYMBOL='o'
    vcdawp2.SYM_SIZE=1.5
    vcdawp2.sym_filled=1.0
    vcdawp2.LINESTYLE=''
    vcdawp2.SYM_COLOR='blue'
    vcdawp2=plot(lon(loc2),vcdaw(loc2),/curr,/overplot)
    vcdawp2.SYMBOL='tu'
    vcdawp2.SYM_SIZE=1
    vcdawp2.LINESTYLE=''
    vcdawp2.SYM_COLOR='red'
    vcdawp2=plot(lon(loc1),vcdaw(loc1),/curr,/overplot)
    vcdawp2.SYMBOL='D'
    vcdawp2.SYM_SIZE=1.0
    vcdawp2.LINESTYLE=''
    vcdawp2.SYM_COLOR='green'
    if keyword_set(ps) then vcdawp2.save,bpath+'result_image/vcdaw2.eps',resolution=512,/transparent
    if keyword_set(png) then vcdawp2.save,bpath+'result_image/vcdaw2.png',resolution=512,/transparent
    vcdawp2.close
    
    if keyword_set(png) then begin
      set_plot,'z'
      device,SET_RESOLUTION=[600,400],SET_PIXEL_DEPTH=24,decomposed=1
      bground=!p.background
      bcolor=!p.color
      !p.background='FFFFFF'xl
      !p.color='000000'xl
      device,decomposed=0
    endif
    if keyword_set(ps) then begin
      set_plot,'ps'
      device,filename=bpath+'result_image/vcdaw_epsilon.eps',/color,xs=24,ys=16,ENCAPSULATED=1
    endif
    thick=!p.thick
    charthick=!p.charthick
    charsize=!p.charsize
    !p.thick=3
    !p.charthick=1.5
    !p.charsize=1.5
    
    np=16
    phi=findgen(np)*!pi*2/np
    phi=[phi,phi[0]]
    loc1=where(project lt 0.8)
    loc2=where((project gt 0.8) and (project lt 1.2))
    loc3=where(project gt 1.2)
    usersym,1.5*cos(phi),1.5*sin(phi),/fill
    n0=51
    up=indgen(n0)*120./(n0-1)
    upre=replicate(1000,n0)
    n1=101
    down=indgen(n1)*1000./(n1-1)
    downre=replicate(50,n1)
    plot,epsilon(loc3),vcdaw(loc3),/nodata,xrange=[0,120],yrange=[0,3000],xtitle='!7e!3(!Eo!N)',ytitle='V!ICDAW!N'
    oplot,up,upre,linestyle=3
    oplot,downre,down,linestyle=2
    oplot,epsilon(loc3),vcdaw(loc3),color=fsc_color('blue'),psym=8
    oplot,epsilon(loc1),vcdaw(loc1),psym=5,color=fsc_color('red')
    oplot,epsilon(loc2),vcdaw(loc2),psym=4,color=fsc_color('green')
    loadct,34l
    legend,['>1.2','[0.8,1.2]','<0.8'],psym=[8,5,4],/data,position=[90,2400],outline_color=fsc_color('black'),textcolors=[0,0,0],colors=[40,255,128]
    loadct,0l
    xyouts,95,2450,'V!IGCS!N/V!ICDAW!N'
    
    !p.thick =thick
    !p.charthick=charthick
    !p.charsize=charsize
    if keyword_set(png) then begin
      a=tvrd(/true)
      name=bpath+'result_image/vcdaw_epsilon.png'
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