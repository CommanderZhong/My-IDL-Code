pro v_posi,v,lat,lon,bpath=bpath
;+
;To plot the effect of different velocity to position 
;-

;;-------------latitude----------------------------
;latv=plot(v,lat,font_size=20,xtitle='$V_{GCS}$ ($km.s^{-1}$)',ytitle='$\theta\ ( ^o)$')
;latv.symbol='o'
;latv.linestyle=''
;latv.sym_color='r'
;latv.save,bpath+'result_image/latv.pdf',resolution=512,/transparent
;latv.close
;
;;-------------longitude---------------------------
;lonv=plot(v,lon,font_size=20,xtitle='$V_{GCS}$ ($km.s^{-1}$)',ytitle='$\phi\ ( ^o)$')
;lonv.symbol='o'
;lonv.linestyle=''
;lonv.sym_color='r'
;lonv.save,bpath+'result_image/lonv.pdf',resolution=512,/transparent
;lonv.close

binsize=100
loc_west=where(lon gt 0,complement=loc_east) 
vwhist=histogram(v[loc_west],min=0,BINSIZE=binsize,locations=binvals1)
vehist=histogram(v[loc_east],min=0,BINSIZE=binsize,locations=binvals2)
v_EW=barplot(binvals1,vwhist,xrange=[0,2200],position=[0.08,0.51,0.97,0.99],ytitle='No (#)',/histogram,xSHOWTEXT=0)
v_EW=barplot(binvals2,vehist,xrange=[0,2200],/curr,position=[0.08,0.05,0.97,0.49],ytitle='No (#)',/histogram)
text1=text(560,470,'West',/device,font_size=18)
text2=text(560,200,'East',/device,font_size=18)
v_EW.save,bpath+'result_image/vew.pdf',resolution=512,/transparent
v_EW.save,bpath+'result_image/vew.eps',resolution=512,/transparent
v_EW.close
end