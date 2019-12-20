pro vcdaw_others,v,vcdaw,lat,lon,ps=ps,png=png,bpath=bpath
    
    project=v/vcdaw
    ;print,n_elements(where((project lt 1.2) and (project gt 0.8))),n_elements(project)
    ;print,n_elements(where((project gt 1.2) ))
    bsize=0.2
    prohist=histogram(project,min=0.4,BINSIZE=bsize,locations=binvals)
    npoint=101l
    n1=replicate(0.8,npoint)
    n2=replicate(1.2,npoint)
    vcdawp=barplot(binvals,prohist,xtickformat='(A6)',xrange=[0.5,2.8],ytitle='No (#)',POSITION=[0.1,0.775,0.97,0.99],/histogram)
    vcdawp=plot(project,lat,/curr,POSITION=[0.1,0.540,0.97,0.755],xrange=[0.5,2.8],ytitle='$\theta ( ^o)$',xtickformat='(A6)')
    vcdawp.SYMBOL='+'
    vcdawp.LINESTYLE=''
    vcdawp.SYM_COLOR='r'
    vcdawp=plot(n1,indgen(npoint)-40,'b--',/curr,/overplot)
    vcdawp=plot(n2,indgen(npoint)-40,'b--',/curr,/overplot)
    vcdawp=plot(project,lon,/curr,POSITION=[0.1,0.305,0.97,0.520],xrange=[0.5,2.8],ytitle='$\phi ( ^o)$',xtickformat='(A6)')
    vcdawp.SYMBOL='d'
    vcdawp.LINESTYLE=''
    vcdawp.SYM_COLOR='r'
    vcdawp=plot(n1,indgen(npoint)*2.5-150,'b--',/curr,/overplot)
    vcdawp=plot(n2,indgen(npoint)*2.5-150,'b--',/curr,/overplot)
   
    epsilon=acos(cos(lat*!dtor)*cos(lon*!dtor))/!dtor
    vcdawp=plot(project,epsilon,/curr,POSITION=[0.1,0.07,0.97,0.285],xrange=[0.5,2.8],ytitle='$\epsilon ( ^o)$',xtitle='PE$_v$')
    vcdawp.SYMBOL='o'
    vcdawp.LINESTYLE=''
    vcdawp.SYM_COLOR='r'
    vcdawp=plot(n1,indgen(npoint)*1.2,'b--',/curr,/overplot)
    vcdawp=plot(n2,indgen(npoint)*1.2,'b--',/curr,/overplot)
    text0=text(0.8,0.95,'(a)',/normal,alignment=0.5,font_size=20)
    text1=text(0.8,0.72,'(b)',/normal,alignment=0.5,font_size=20)
    text2=text(0.8,0.48,'(c)',/normal,alignment=0.5,font_size=20)
    text3=text(0.8,0.24,'(d)',/normal,alignment=0.5,font_size=20)
    if keyword_set(ps) then vcdawp.save,bpath+'result_image/vcdaw.eps',resolution=512,/transparent
    if keyword_set(png) then vcdawp.save,bpath+'result_image/vcdaw.png',resolution=512,/transparent
    vcdawp.close
    
    n0=51
    up=indgen(n0)*120./(n0-1)
    upre=replicate(1000,n0)
    n1=101
    down=indgen(n1)*1000./(n1-1)
    downre=replicate(50,n1)
    
    loc1=where(project lt 0.8)
    loc2=where((project gt 0.8) and (project lt 1.2))
    loc3=where(project gt 1.2)
    vcdawp1=plot(lat(loc3),vcdaw(loc3),/curr,xtitle='$\theta ( ^o)$',xrange=[-40,50],ytitle='V!ICDAW!N (km.s!E-1!N)',position=[0.14,0.12,0.97,0.99],font_size=20)
    vcdawp1.SYMBOL='o'
    vcdawp1.SYM_SIZE=1.5
    vcdawp1.sym_filled=1.0
    vcdawp1.LINESTYLE=''
    vcdawp1.SYM_COLOR='blue'
    vcdawp1=plot(indgen(n0)*90./(n0-1)-40,upre,'-.',/curr,/overplot)
    vcdawp1=plot(replicate(-30,n1),down,'--',/curr,/overplot)
    vcdawp1=plot(replicate(30,n1),down,'--',/curr,/overplot)
    vcdawp1=plot(lat(loc1),vcdaw(loc1),/curr,/overplot)
    vcdawp1.SYMBOL='tu'
    vcdawp1.SYM_SIZE=1.0
    vcdawp1.LINESTYLE=''
    vcdawp1.SYM_COLOR='red'
    vcdawp1=plot(lat(loc2),vcdaw(loc2),/curr,/overplot)
    vcdawp1.SYMBOL='D'
    vcdawp1.SYM_SIZE=1.0
    vcdawp1.LINESTYLE=''
    vcdawp1.SYM_COLOR='green'
    text1=text(-35,2700,'(b)',/data,font_size=20)
    if keyword_set(ps) then vcdawp1.save,bpath+'result_image/vcdaw1.eps',resolution=512,/transparent
    if keyword_set(png) then vcdawp1.save,bpath+'result_image/vcdaw1.png',resolution=512,/transparent
    vcdawp1.close   
    
    vcdawp2=plot(lon(loc3),vcdaw(loc3),/curr,xtitle='$\phi ( ^o)$',xrange=[-120,90],ySHOWTEXT=0,position=[0.01,0.12,0.97,0.99],font_size=20)
    vcdawp2.SYMBOL='o'
    vcdawp2.SYM_SIZE=1.5
    vcdawp2.sym_filled=1.0
    vcdawp2.LINESTYLE=''
    vcdawp2.SYM_COLOR='blue'
    vcdawp2=plot(indgen(n0)*210./(n0-1)-120,upre,'-.',/curr,/overplot)
    vcdawp2=plot(replicate(-50,n1),down,'--',/curr,/overplot)
    vcdawp2=plot(replicate(50,n1),down,'--',/curr,/overplot)
    vcdawp2=plot(lon(loc1),vcdaw(loc1),/curr,/overplot)
    vcdawp2.SYMBOL='tu'
    vcdawp2.SYM_SIZE=1
    vcdawp2.LINESTYLE=''
    vcdawp2.SYM_COLOR='red'
    vcdawp2=plot(lon(loc2),vcdaw(loc2),/curr,/overplot)
    vcdawp2.SYMBOL='D'
    vcdawp2.SYM_SIZE=1.0
    vcdawp2.LINESTYLE=''
    vcdawp2.SYM_COLOR='green'
    text2=text(-110,2700,'(c)',/data,font_size=20)
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
      device,filename=bpath+'result_image/vcdaw_epsilon.eps',/color,xs=50,ys=40,ENCAPSULATED=1
    endif
    thick=!p.thick
    charthick=!p.charthick
    charsize=!p.charsize
    !p.thick=3
    !p.charthick=4
    !p.charsize=3
    
    np=16
    phi=findgen(np)*!pi*2/np
    phi=[phi,phi[0]]
    usersym,1.5*cos(phi),1.5*sin(phi),/fill
    
    plot,epsilon(loc3),vcdaw(loc3),/nodata,xrange=[0,120],yrange=[0,3000],position=[0.12,0.11,0.97,0.99],xtitle='!7e!3 (!Eo!N)',ytitle='V!ICDAW!N (km.s!E-1!N)'
    oplot,up,upre,linestyle=3
    oplot,downre,down,linestyle=2
    oplot,epsilon(loc3),vcdaw(loc3),color=fsc_color('blue'),psym=8,symsize=3
    oplot,epsilon(loc1),vcdaw(loc1),psym=5,color=fsc_color('red'),symsize=3
    oplot,epsilon(loc2),vcdaw(loc2),psym=4,color=fsc_color('green'),symsize=3
    loadct,34l
    legend,['>1.2','[0.8,1.2]','<0.8'],psym=[8,4,5],/data,position=[85,2400],outline_color=fsc_color('black'),textcolors=[0,0,0],colors=[40,128,255]
    loadct,0l
    xyouts,95,2450,'PE!Iv!N'
    xyouts,5,2800,'(a)'
    
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