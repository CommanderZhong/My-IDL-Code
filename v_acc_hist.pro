pro v_acc_hist,v,acc,lat,ps=ps,png=png,bpath=bpath

;plots histogram
  binsize=(max(v)-min(v))/10.
  binsize1=(max(acc)-min(acc))*100.
  vhist=histogram(v,BINSIZE=binsize,locations=binvals)
  acchist=histogram(acc*1000,BINSIZE=binsize1,locations=binvals1)
  histplot=barplot(binvals,vhist,position=[0.06,0.52,0.97,0.99],ytitle='Num(#)')
  text1=text(480,460,'V!IGCS!N(km.s!E-1!N)',color='Blue',FONT_SIZE=24,/device)
  ;histplot=plot(binvals,vhist,/overplot)
  histplot=barplot(binvals1,acchist,/curr,position=[0.06,0.05,0.97,0.48],ytitle='Num(#)')
  text2=text(480,220,'Acc(m.s!E-2!N)',color='Blue',FONT_SIZE=24,/device)
  ;histplot=plot(binvals1,acchist,/overplot)
  if keyword_set(ps) then histplot.save,bpath+'result_image/histogram.eps',resolution=512,/transparent
  if keyword_set(png) then histplot.save,bpath+'result_image/histogram.png',resolution=512,/transparent
  histplot.close
  ;print,n_elements(acc),n_elements(where((acc*1000 lt 20) and (acc*1000 gt -20)))
  acc_v=plot(acc*1000,v[0:47],xtitle='Acc($m.s^{-2}$)',ytitle='V$_{GCS}$($km.s^{-1}$)')
  acc_v.symbol='d'
  acc_v.LINESTYLE=''
  acc_v.SYM_COLOR='r'
  acc_v=plot(replicate(0,51),indgen(51)*1400./50,/curr,/overplot,'b.')
  acc_v=plot(indgen(51)*2-100,replicate(700,51),/curr,/overplot,'b.')
  if keyword_set(ps) then acc_v.save,bpath+'result_image/acc.eps',resolution=512,/transparent
  if keyword_set(png) then acc_v.save,bpath+'result_image/acc.png',resolution=512,/transparent
  acc_v.close
end