pro v_acc_hist,v,acc,ps=ps,png=png,bpath=bpath

;plots histogram
  binsize=(max(v)-min(v))/10.
  binsize1=(max(acc)-min(acc))*100.
  vhist=histogram(v,BINSIZE=binsize,locations=binvals)
  acchist=histogram(acc*1000,BINSIZE=binsize1,locations=binvals1)
  histplot=barplot(binvals,vhist,layout=[1,2,1],xtitle='Velocity(km.s!E-1!N)',ytitle='Num(#)')
  histplot=plot(binvals,vhist,/overplot)
  histplot=barplot(binvals1,acchist,/curr,layout=[1,2,2],xtitle='Acceleration(km.s!E-2!N)',ytitle='Num(#)')
  histplot=plot(binvals1,acchist,/overplot)
  if keyword_set(ps) then histplot.save,bpath+'result_image/histogram.eps',resolution=512,/transparent
  if keyword_set(png) then histplot.save,bpath+'result_image/histogram.png',resolution=512,/transparent
  histplot.close
end