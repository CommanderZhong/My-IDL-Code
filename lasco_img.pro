;To draw SOHO/LASCO  C2 picture
;Example:
;	lasco_img,date='120704'

pro lasco_img,date=date
    sat='LASCO'
    instr='C2'
    path='/home/zhzhong/Desktop/mywork/data/'+date+'/LC2'
    pathpicture='/home/zhzhong/Desktop/mywork/work/picture/'+date+'/p3'
    spawn,'mkdir -p '+pathpicture
    file=findfile(path+'/*fts')
    k=0
    ;bimage=lasco_readfits(file[k])
    for i=k+1,n_elements(file)-1 do begin             
        image=lasco_readfits(file[i],index)
        tempimage=image
        if i eq 1 then begin
           bimage=lasco_readfits(file[i-1],bindex)
	   ;The name of movie which will be made at last, so just need the first one
	   name=index.DATE_OBS
	   name=sat+'_'+instr+'_'+strMid(name,0,4)+strMid(name,5,2)+strMid(name,8,2)
        endif
        image=image-bimage
        bimage=tempimage 
        set_plot,'z'
        device,set_resolution=[512,512],decomposed=0
	title=sat+'_'+instr+'_'+index.DATE_OBS+'_'+index.TIME_OBS
        tv, congrid(bytscl(median(smooth(image,3),3),-50,50),512,512)
	xyouts,0,0,title,/device,charsize=1.0,charthick=0.5
        img=tvrd()
        write_image,pathpicture+'/'+string(i-k,format='(I3.3)')+'.png','png',img,r,g,b
        device,/close
        set_plot,'x'
    endfor

;;make a movie using the picture which we drawed just now
    spawn,'ffmpeg -start_number 1 -y -i '+pathpicture+'/%003d.png'+' '+pathpicture+'/'+name+'.mpeg'   
end
