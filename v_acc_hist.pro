pro v_acc_hist,v,acc,lat,ps=ps,png=png,bpath=bpath

;plots histogram
  binsize=(max(v)-min(v))/10.
  binsize1=(max(acc)-min(acc))*100.
  vhist=histogram(v,BINSIZE=binsize,locations=binvals)
  acchist=histogram(acc*1000,BINSIZE=binsize1,locations=binvals1)
  histplot=barplot(binvals,vhist,position=[0.1,0.52,0.95,0.95],ytitle='Num(#)')
  text1=text(480,460,'V!IGCS!N(km.s!E-1!N)',color='Blue',/device)
  ;histplot=plot(binvals,vhist,/overplot)
  histplot=barplot(binvals1,acchist,/curr,position=[0.1,0.1,0.95,0.48],ytitle='Num(#)')
  text2=text(480,220,'Acceleration(m.s!E-2!N)',color='Blue',/device)
  ;histplot=plot(binvals1,acchist,/overplot)
  if keyword_set(ps) then histplot.save,bpath+'result_image/histogram.eps',resolution=512,/transparent
  if keyword_set(png) then histplot.save,bpath+'result_image/histogram.png',resolution=512,/transparent
  histplot.close
end