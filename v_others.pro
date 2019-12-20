pro v_others,start,arrive,v,han,ps=ps,png=png,bpath=bpath,epsilon=epsilon

   au=149597871l
   
   npoint=101l
   eps0=indgen(npoint)*120./(npoint-1)
   aneps=PLOT(epsilon,han,position=[0.12,0.11,0.97,0.99],yrange=[0,100],xtitle='$\epsilon\ ( ^o)$',ytitle='$\omega\ ( ^o)$',font_size=20)
   aneps.symbol='D'
   aneps.linestyle=''
   aneps.sym_color='r'
   aneps=plot(eps0,eps0,/curr,/overplot,'b.')
   text0=text(80,72,'$\omega=\epsilon$',/data,color='blue',alignment=0.5,font_size=20)
   if keyword_set(ps) then aneps.save,bpath+'result_image/aneps.eps',resolution=512,/transparent
   if keyword_set(png) then aneps.save,bpath+'result_image/aneps.png',resolution=512,/transparent
   aneps.close
  ; velocity & arrive time/Half angle profile
  loc=where(arrive ne '-------------------') ;arrive[13]=---------
  arrive1=arrive(loc)
  start1=start(loc)
  v1=v(loc)
  epsilon=epsilon(loc)
  han=han(loc)
  
  coeff1=linfit(v1,han)
  cc=correlate(v1,han)

  npoint=101l
  vn=lindgen(npoint)*2500/(npoint-1)
  han_fit=coeff1[0]+coeff1[1]*vn
  
  arrive1=strmid(arrive1,0,4)+'/'+strmid(arrive1,5,2)+'/'+strmid(arrive1,8,2)+' '+strmid(arrive1,11,8)
  arrive2=anytim2tai(arrive1)-anytim2tai(start1)
  
  
  ;d_fit=coeff3[0]+coeff3[1]*vn
  if min(arrive2) gt 60.*60*24 then begin
    arrive2=arrive2/60./60./24
    v_other=plot(v1,arrive2,POSITION=[0.11,0.11,0.97,0.99],xrange=[100,2200],xtitle='V!IGCS!N (km.s!E-1!N )',ytitle='T!Ipro!N (day)')
    v_other.SYMBOL='o'
    v_other.LINESTYLE=''
    v_other.SYM_COLOR='r'
    v_other.font_size=18
    resultx=comfit(v1,arrive2,[0,6e-4],/double,/HYPERBOLIC)
    cc1=correlate(v1,arrive2)
    t_fit=1./(resultx[0]+resultx[1]*vn)
    v_other=plot(vn,t_fit,/curr,/overplot,'g-.')
    text0=text(0.7,0.9,'LCC='+strmid(string(cc1),5,6),/normal,font_size=20)
    ;re=replicate(1,100)
    ;v_other=plot(v1,v1*arrive2*60.*60*24/au,/curr,xrange=[100,2200],xtitle='V!IGCS!N(km.s!E-1!N)',ytitle='D!Ipro!N(AU)',position=[0.11,0.11,0.97,0.49],linestyle='',symbol='+',sym_color='r')
    ;v_other.font_size=18
    
    ;v_other=plot(indgen(100)*25,re,/curr,/overplot,'b.')
    ;v_other=plot(vn,d_fit,/curr,/overplot,'g-.')
    ;text1=text(1600,2.8,string(coeff3[1]),/data,color='green',alignment=0.5,font_size=20)
    if keyword_set(ps) then v_other.save,bpath+'result_image/v_others.eps',resolution=512,/transparent
    if keyword_set(png) then v_other.save,bpath+'result_image/v_others.png',resolution=512,/transparent
    v_other.close
  endif
  hanerr=REPLICATE(5,N_ELEMENTS(han))
  v_han=ERRORPLOT(v1,han,hanerr,/curr,POSITION=[0.12,0.11,0.97,0.99],xtitle='V!IGCS!N (km.s!E-1!N )',ytitle='$\omega\ ( ^o)$')
  v_han.SYMBOL='x'
  v_han.LINESTYLE=''
  v_han.SYM_COLOR='r'
  v_han.font_size=20
  v_han=plot(vn,han_fit,/curr,/overplot,'b.')
  text0=text(0.8,0.9,'CC='+strmid(string(cc),6,5),/normal,font_color='blue')
  if keyword_set(ps) then v_han.save,bpath+'result_image/v_han.eps',resolution=512,/transparent
  if keyword_set(png) then v_han.save,bpath+'result_image/v_han.png',resolution=512,/transparent
  v_han.close
  
  
  
  loc=where(epsilon le han)
  eps1=epsilon(loc)*!dtor
  han1=han(loc)*!dtor
  tpr=arrive2(loc)*24
  v2=v1(loc)
  d_r=solve_equation(eps1,han1)
  coeff3=linfit(v2,d_r)
  cc2=correlate(v2,d_r)
  loc1=where((v2 gt 400) and (v2 lt 600))
  tpr=tpr(loc1)
  d_r1=d_r(loc1)
  coeff4=linfit(tpr,d_r1)
  cc3=correlate(tpr,d_r1)
  vfit=indgen(2201)
  tfit=indgen(1001)/1000.*(max(tpr)+10)
  dfit=coeff3[0]+coeff3[1]*vfit
  dfit1=coeff4[0]+coeff4[1]*tfit
  
  dv=plot(v2,d_r,font_size=20,xrange=[0,2100],yrange=[0.8,2],xtitle='V!IGCS!N (km.s!E-1!N )',ytitle='D!Irl!N (AU)',position=[0.11,0.11,0.97,0.99])
  dv.symbol='o'
  dv.linestyle=''
  dv.sym_color='r'
  dv=plot(vfit,dfit,/curr,/overplot,'b--')
  text0=text(0.2,0.9,'CC='+strmid(string(cc2),6,5),/normal,font_size=20,color='blue')
  if keyword_set(ps) then dv.save,bpath+'result_image/dv.eps',resolution=512,/transparent
  if keyword_set(png) then dv.save,bpath+'result_image/dv.png',resolution=512,/transparent
  dv.close
  
tv=plot(tpr,d_r1,font_size=20,xrange=[0,max(tpr)+10],yrange=[0.8,2],xtitle='T!Ipr!N (hr)',ytitle='D!Irl!N (AU)',position=[0.11,0.11,0.97,0.99])
tv.symbol='o'
tv.linestyle=''
tv.sym_color='r'
tv=plot(tfit,dfit1,/curr,/overplot,'b--')
text1=text(0.2,0.9,'CC='+strmid(string(cc3),6,5),/normal,font_size=20,color='blue')
if keyword_set(ps) then tv.save,bpath+'result_image/tv.eps',resolution=512,/transparent
if keyword_set(png) then tv.save,bpath+'result_image/tv.png',resolution=512,/transparent
tv.close
end