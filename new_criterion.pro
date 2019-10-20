PRO new_criterion,lat,lon,han,rotat,rat,bpath=bpath
;+
;A new criterion of whether CMEs could hit the Earth: 
;       tan(epsilon) = tan(han)*sin(rotat)+tan(delta)*cos(rotat); 
;       rat=sin(delta); 
;       cos(epsilon)=cos(lat)*cos(lon)
;Developed by Z.H.Zhong at 16 Sep. 2019
;-

e=ACOS(COS(lat*!DTOR)*COS(lon*!DTOR)) ;epsilon
del=ASIN(rat)  ;del
haw=han*!DTOR  ;half-angular width
g=rotat*!DTOR  ;rotation angle: gama

nx=TAN(e)  ;for x axis
ny=TAN(haw)*SIN(g)+TAN(del)*COS(g) ;for y axis

npoint=51l
e0=INDGEN(npoint)*10./(npoint-1)
fig=PLOT(nx,ny,XTITLE='tan $\epsilon$',YTITLE='tan $\omega$ sin $\gamma$ + tan $\delta$ cos $\gamma$',FONT_SIZE=20)
fig.SYMBOL='o'
fig.LINESTYLE=' '
fig.SYM_COLOR='r'
fig.SAVE,bpath+'result_image/newc.eps',RESOLUTION=512,/TRANSPARENT
fig.CLOSE
END