pro v_others,start,arrive,v,han,ps=ps,png=png,bpath=bpath

  ; velocity & arrive time/Half angle profile
  loc=where(arrive ne '-------------------')
  arrive1=arrive(loc)
  start1=start(loc)
  v1=v(loc)
  han1=han(loc)
  arrive1=strmid(arrive1,0,4)+'/'+strmid(arrive1,5,2)+'/'+strmid(arrive1,8,2)+' '+strmid(arrive1,11,8)
  arrive2=anytim2tai(arrive1)-anytim2tai(start1)
  if min(arrive2) gt 60.*60*24 then begin
    arrive2=arrive2/60./60./24
    v_other=plot(v1,arrive2,POSITION=[0.1,0.61,0.95,0.95],xtickformat='(A6)',ytitle='Arrive Time(day)')
    v_other.SYMBOL='o'
    v_other.LINESTYLE=''
    v_other.SYM_COLOR='r'
    v_other=plot(v,han,/curr,POSITION=[0.1,0.41,0.95,0.59],xtickformat='(A6)',ytitle='Half Angle(!Eo!N)')
    v_other.SYMBOL='x'
    v_other.LINESTYLE=''
    v_other.SYM_COLOR='r'
    re=replicate(1,100)
    au=149597871l
    v_other=plot(v1,v1*arrive2*60.*60*24/au,/curr,xtitle='Velocity(km.s!E-1!N)',ytitle='Velocity*Arrive Time(AU)',position=[0.1,0.1,0.95,0.39],linestyle='',symbol='+',sym_color='r')
    v_other=plot(indgen(100)*25,re,/curr,/overplot,'b.')
    if keyword_set(ps) then v_other.save,bpath+'result_image/v_others.eps',resolution=512,/transparent
    if keyword_set(png) then v_other.save,bpath+'result_image/v_others.png',resolution=512,/transparent
    v_other.close
  endif
end