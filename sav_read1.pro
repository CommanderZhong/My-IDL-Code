pro sav_read1,date=date,nolasco=nolasco,path=path
  ;+
  ;;To read sav data file
  ;;keyword:
  ;;      date:the date of sav file
  ;;      nolasco:if nolasco ,set /nolasco
  ;;example:
  ;;       sav_read,date='120623',/nolasco
  ;-
  if not keyword_set(nolasco) then nolasco=2
  if not keyword_set(date) then date='121005'
  if not keyword_set(path) then path='/home/zhzhong/Desktop/mywork/work/result/121005/'

  file=findfile(path+date+'savdata*.sav')
  ;There are 6 kinds of parameters in total
  n=6
  m=1
  m=n_elements(file)

  for i=0,m-1 do begin
    restore,file(i)
    ;make a eps picture
    set_plot,'ps'   ;plot eps
    device,filename=path+date+'eps'+string(i+1,format='(I2.2)')+'.eps',xsize=50,ysize =33,/color,ENCAPSULATED=1,BITS_PER_PIXEL=8
    loadct,0l
    !p.multi=[0,2,3]
    ;STEREO Ahead
    plot_image,sgui.ima,position=[0.0025,0.0,0.3325,0.5],charsize=3,xtickformat='(A6)',ytickformat='(A6)'
    xyouts,0.1675,0.03,'STEREO-A '+SGUI.HDRA.DATE_OBS,/NORMAL,ALIGNMENT=0.5,CHARSIZE=1.8,COLOR=255,charthick=1.8
    xyouts,0.05,0.95-0.5,'(d)',/NORMAL,ALIGNMENT=0.5,CHARSIZE=2.,COLOR=255,charthick=1.8
    tvlct,0,255,0,254 ;Green
    findloc,swire.sa.im,1,x,y
    plots,x,y,psym=3,color=254
    ;contour,swire.sa.im,/overplot,color=254,levels=1
    loadct,0l
    plot_image,sgui.ima,position=[0.0025,0.5,0.3325,1],charsize=3,xtickformat='(A6)',ytickformat='(A6)'
    xyouts,0.05,0.95,'(a)',/NORMAL,ALIGNMENT=0.5,CHARSIZE=2.,COLOR=255,charthick=1.8
    ;LASCO
    if nolasco eq 1 then begin
      xyouts,0.165+0.335,0.5,'MISSING LASCO DATA',/NORMAL,ALIGNMENT=0.5,CHARSIZE=1.8,COLOR=0,charthick=1.8
    endif else begin
      plot_image,sgui.imlasco,position=[0.3350,00.,0.6650,0.5],charsize=3,xtickformat='(A6)',ytickformat='(A6)'
      xyouts,0.05+0.335,0.95-0.5,'(e)',/NORMAL,ALIGNMENT=0.5,CHARSIZE=2.,COLOR=255,charthick=1.8
      xyouts,0.165+0.335,0.03,'LASCO C2 20'+strmid(date,0,2)+'-'+strmid(date,2,2)+'-'+strmid(date,4,2)+'T'+SGUI.SHDRLASCO.TIME_OBS,/NORMAL,ALIGNMENT=0.5,CHARSIZE=1.8,COLOR=255,charthick=1.8
      tvlct,0,255,0,254
      findloc,swire.slasco.im,1,x,y  ;to deal with overlap points
      plots,x,y,psym=3,color=254
      ;contour,swire.slasco.im,/overplot,color=254,levels=1
      loadct,0l
      plot_image,sgui.imlasco,position=[0.3350,00.5,0.6650,1],charsize=3,xtickformat='(A6)',ytickformat='(A6)' ;without gcs model
      xyouts,0.05+0.335,0.95,'(b)',/NORMAL,ALIGNMENT=0.5,CHARSIZE=2.,COLOR=255,charthick=1.8
    endelse
    ;STEREO Behind
    plot_image,sgui.imb,position=[0.6675,0.00,0.9975,0.5],charsize=3,xtickformat='(A6)',ytickformat='(A6)'
    xyouts,0.05+0.6675,0.95-0.5,'(f)',/NORMAL,ALIGNMENT=0.5,CHARSIZE=2.,COLOR=255,charthick=1.8
    xyouts,0.165+0.6675,0.03,'STEREO-B '+SGUI.HDRb.DATE_OBS,/NORMAL,ALIGNMENT=0.5,CHARSIZE=1.8,COLOR=255,charthick=1.8
    tvlct,0,255,0,254
    ;contour,swire.sb.im,/overplot,color=254,levels=1
    findloc,swire.sb.im,1,x,y
    plots,x,y,psym=3,color=254
    loadct,0l
    plot_image,sgui.imb,position=[0.6675,0.5,0.9975,1.],charsize=3,xtickformat='(A6)',ytickformat='(A6)'
    xyouts,0.05+0.6675,0.95,'(c)',/NORMAL,ALIGNMENT=0.5,CHARSIZE=2.,COLOR=255,charthick=1.8
    !p.multi=0
    ;write_image,'result.png','png',tvrd(true=1)  ;to plot with windows
    device,/close
    set_plot,'x'
  endfor
end