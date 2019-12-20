FUNCTION calculate_t,v0,h0,k,vsw,drl
;+
;To solve equation drl-h0-v0/k=vsw*t-v0/k*exp(-k*t)
;-

  t=fltarr(1)
  RETURN,t
END
pro v_acc_hist,v,acc,h0,lat,ps=ps,png=png,bpath=bpath,tcal=tcal

;plots histogram
  binsize=200
  binsize1=20
  vhist=histogram(v,min=0,BINSIZE=binsize,locations=binvals)
  acchist=histogram(acc*1000,min=-100,BINSIZE=binsize1,locations=binvals1)
  histplot=barplot(binvals,vhist,position=[0.06,0.52,0.97,0.99],ytitle='No (#)',/histogram)
  text1=text(0,17,'(a)',FONT_SIZE=20,/data)
  ;histplot=plot(binvals,vhist,/overplot)
  histplot=barplot(binvals1,acchist,/curr,position=[0.06,0.05,0.97,0.48],ytitle='No (#)',/histogram)
  text2=text(65,200,'(b)',FONT_SIZE=20,/device)
  ;histplot=plot(binvals1,acchist,/overplot)
  if keyword_set(ps) then histplot.save,bpath+'result_image/histogram.eps',resolution=512,/transparent
  if keyword_set(png) then histplot.save,bpath+'result_image/histogram.png',resolution=512,/transparent
  histplot.close
  acc_v=plot(v[0:46],acc*1000,ytitle='$a_{GCS}\ (m.s^{-2})$',xtitle='$V_{GCS}\ (km.s^{-1})$',position=[0.14,0.13,0.97,0.99],font_size=20)
  acc_v.symbol='d'
  acc_v.LINESTYLE=''
  acc_v.SYM_COLOR='r'
  acc_v.SYM_SIZE=1.5

;------------------Linfit------------------------------
  coeff=linfit(v[0:46],acc*1000)
  cc=correlate(v[0:46],acc*1000)
  vafit=indgen(1001)/1000.*1500
  afit=coeff[0]+coeff[1]*vafit
  vfit0=-coeff[0]/coeff[1]
  acc_v=plot(vafit,afit,/curr,/overplot,'g--')
  acc_v=plot(indgen(51)*1400./50,replicate(0,51),/curr,/overplot,'b.')
  acc_v=plot(replicate(vfit0,51),indgen(51)*4-100,/curr,/overplot,'b.')
  text5=text(1200,80,'CC='+strmid(string(cc),5,6),color='green',/data,font_size=20,alignment=0.5)
  text5=text(100,80,'(c)',font_size=20,/data)
;-------------------------------------------------------

;--------------V-A model----------------------------
  au=149597871l
  Rs=696300l  ;solar radii
  vsw=363.73  ;solar wind speed
  tcal=FLTARR(N_ELEMENTS(acc))
  v0=v[0:46]-vsw
  k=coeff[1]
  drl=au
  tcal=calculate_t(v0,h0,k,vsw,drl)
;---------------------------------------------------

  if keyword_set(ps) then acc_v.save,bpath+'result_image/acc.eps',resolution=512,/transparent
  if keyword_set(png) then acc_v.save,bpath+'result_image/acc.png',resolution=512,/transparent
  acc_v.close
end