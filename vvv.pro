pro vvv
bpath='/home/zhzhong/Desktop/mywork/work/'
a=10*indgen(51)
b=indgen(201)
c=replicate(500,201)
a1=-3*sqrt(b)+500
a2=c
a3=3*sqrt(b)+500
p=plot(a,xtickformat='(A6)',ytickformat='(A6)',xrange=[0,300],yrange=[0,800],position=[0.01,0.01,0.99,0.99])
p3=plot(indgen(201)+50,a1,/overplot,/curr,'r-',name='Deceleration')
p2=plot(indgen(201)+50,a2,/overplot,/curr,'g-',name='Uniform')
p1=plot(indgen(201)+50,a3,/overplot,/curr,'b-',name='Acceleration')
leg = LEGEND(TARGET=[p1,p2,p3], POSITION=[250,750],/DATA, /AUTO_TEXT_COLOR,font_size=20)
p.save,bpath+'result_image/vvv.eps',resolution=512,/transparent
p.close
end