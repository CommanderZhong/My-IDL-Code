pro stereo_img,date=date,sat=sat,instr=instr

;+
;;To draw STEREO  picture
;;example:
;;        stereo_img,date='120704',sat='STA',instr='COR2'
;; 	 stereo_img,date='120704',sat='STA',instr='hi_1'
;;Writen by Z.H.Zhong
;;
;-
   


    path='/home/zhzhong/Desktop/mywork/data/'+date+'/'+sat+'/'
    file=findfile(path+'*fts')
    if sat eq 'STA' then begin
	n=1
    endif else begin
	n=2
    endelse
    pathpicture='/home/zhzhong/Desktop/mywork/work/picture/'+date
    pathn=pathpicture+'/p'+string(n,format='(I1)')
    spawn,'mkdir -p '+pathn

    k=0
    for i=k+1,n_elements(file)-1   do begin       ; 19,22    
        secchi_prep,file[i],index,data,/silent,/rotate_on,/calfac_off,/calimg_off,/polarize_on,/smask_on
;        data=sccreadfits(file[i],index)
;        data=scc_mk_image(file[i], outsize=512, /NOPOP)
;        help,data,/str
        tempdata=data
        if i eq 1 then begin
           secchi_prep,file[i-1],bindex,bdata,/silent,/rotate_on,/calfac_off,/calimg_off,/polarize_on,/smask_on
        endif
        data=data-bdata
        bdata=tempdata

        set_plot,'z'
        device,set_resolution=[512,512],decomposed=0  
        ;loadct,0
	      title=sat+'_'+instr+'_'+index.DATE_OBS
	      
	      if (instr eq 'hi_1') or (instr eq 'hi_2') then begin
		    secchi_colors,instr,'',r,g,b
	      endif else begin
		    secchi_colors,instr,/load
	      endelse
        tv, congrid(bytscl(median(smooth(data,5),5),-2,2),512,512)
;	      tv, congrid(bytscl(data,0,600),512,512)
;	      tv,bytscl(alog10(rebin(data,512,512) > 2000 < 3500))
	      xyouts,0,0,title,/device
        img=tvrd()
        ;write_image,'/home/zhzhong/Desktop/mywork/work/picture/p'+string(n,format='(I1)')+'/'+string(i,format='(I2)')+'.png','png',img,r,g,b
        write_image,pathn+'/'+string(i,format='(I2.2)')+'.png','png',img,r,g,b
        device,/close
        set_plot,'x'  ;for linux
    endfor

;;make a movie using the picture which we drawed just now
    spawn,'ffmpeg -start_number 1 -i '+pathn+'/%02d.png'+' '+pathn+'/'+sat+'_'+instr+'_'+date+'.mpeg'    
end
