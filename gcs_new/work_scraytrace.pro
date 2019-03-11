pro work_scraytrace, cor1A=cor1A, cor1B=cor1B, cor2A=cor2A, cor2B=cor2B, Apre=Apre, Bpre=Bpre, hi1A=hi1A, hi1B=hi1B, lascopre=lascopre, lascoC2=lascoC2, lascoC3=lascoC3, ldisp=ldisp, seq=seq, mkim=mkim, flip=flip

;Run the scraytrace code. 
;Inputs: The fits files for the image and pre-image (to be used as running difference backgrounds)
;Keywords: /seq-for COR1 files, use sequence images instead of img
;/mkim: create an output image of the scraytrace output
;/flip: the code doesn't always rotate LASCO images properly, so this will artifically rotate the LASCO images for the image output.





pim=make_array(6,1,/ptr)
phdr=make_array(6,1,/ptr)
num_pim=0

if keyword_set(cor1A) then begin
        if keyword_set(seq) then begin
        secchi_prep, cor1A, hdrs1, im, /polariz_on
        secchi_prep, Apre, hdrsp, imp, /polariz_on
        ima=bytscl(alog10(im), min=-12, max=-6)
        ima2=bytscl(im-imp, min=-1e-9, max=1e-9)
        endif else begin

        secchi_prep, cor1A, hdrs1, im
        secchi_prep, Apre, hdrsp, imp
        ima=bytscl(alog10(im), min=-12, max=-6)
        ima2=bytscl(im-imp, min=-1e-9, max=1e-9)
        endelse
        

        pim[num_pim]=ptr_new(ima)
        phdr[num_pim]=ptr_new(hdrs1)
        num_pim=num_pim+1
        pim[num_pim]=ptr_new(ima2)
        phdr[num_pim]=ptr_new(hdrs1)
        num_pim=num_pim+1
endif

if keyword_set(cor1B) then begin
        if keyword_set(seq) then begin
        secchi_prep, cor1B, hdrs1, im, /polariz_on
        secchi_prep, Bpre, hdrsp, imp, /polariz_on
        imb=bytscl(alog10(im), min=-10, max=-6)
        imb2=bytscl(im-imp, min=-1e-9, max=1e-9)
        endif else begin
        ;imm=sccreadfits(cor1A, hdr)
        ;bkg=scc_getbkgimg(hdr)
        secchi_prep, cor1B, hdrs1, im
        secchi_prep, Bpre, hdrsp, imp
        imb=bytscl(alog10(im), min=-12, max=-6)
        imb2=bytscl(im-imp, min=-1e-9, max=1e-9)
        endelse

        pim[num_pim]=ptr_new(imb)
        phdr[num_pim]=ptr_new(hdrs1)
        num_pim=num_pim+1
        pim[num_pim]=ptr_new(imb2)
        phdr[num_pim]=ptr_new(hdrs1)
        num_pim=num_pim+1
endif


if keyword_set(cor2A) then begin 
	ima=scc_mk_image(cor2A, outsize=512, /NOPOP, /NOLOGO, /NODATETIME)

	sa=sccreadfits(cor2A,hdrA)
	secchi_prep, cor2A, hdr, ima_2	
	secchi_prep, Apre, hdr, imap	
	ima2=rebin(bytscl(ima_2-imap, min=-1e-12, max=1e-12), 512,512)
	for i=0L, 511 do begin
	   for j=0L, 511 do begin
		;print, i, j, sqrt((i-255)*(i-255)+(j-255)*(j-255))
		if sqrt((i-255)*(i-255)+(j-255)*(j-255)) gt 256 then ima2(i,j)=0
		
	   endfor
	endfor

	pim[num_pim]=ptr_new(ima)
	phdr[num_pim]=ptr_new(hdrA)
	num_pim=num_pim+1
	pim[num_pim]=ptr_new(ima2)
	phdr[num_pim]=ptr_new(hdrA)
	num_pim=num_pim+1
endif
if keyword_set(cor2B) then begin
	imb=scc_mk_image(cor2B, outsize=512, /NOPOP, /NOLOGO, /NODATETIME)
	secchi_prep, cor2B, hdr, imb_2	
	secchi_prep, Bpre, hdr, imbp	
	imb2=rebin(bytscl(imb_2-imbp, min=-1e-12, max=1e-12), 512,512)
	for i=0L, 511 do begin
	   for j=0L, 511 do begin
		;print, i, j, sqrt((i-255)*(i-255)+(j-255)*(j-255))
		if sqrt((i-255)*(i-255)+(j-255)*(j-255)) gt 256 then imb2(i,j)=0
		
	   endfor
	endfor
	sb=sccreadfits(cor2B,hdrB)

	pim[num_pim]=ptr_new(imb)
	phdr[num_pim]=ptr_new(hdrB)
	num_pim=num_pim+1	
	pim[num_pim]=ptr_new(imb2)
	phdr[num_pim]=ptr_new(hdrB)
	num_pim=num_pim+1
endif
;hi1
if keyword_set(hi1A) then begin
	secchi_prep, Apre, hdrp, imap, outsize=512
	secchi_prep, hi1A, hdrA, imaa, outsize=512
	;stop
	ima=bytscl(alog10((imaa-imap) > 0), min=-150,max=1)
	;ima2=bytscl(alog10((imaa-imap) >0), min=-200,max=1)
        bkg=scc_getbkgimg(hdrA)
        ima2=rebin(bytscl(float(imaa)/float(bkg), min=.97, max=1.05), 512, 512)
;	ima2=scc_mk_image(hi1A, outsize=512, /NOPOP, /NOLOGO, /NODATETIME)
	pim[num_pim]=ptr_new(ima2)
	phdr[num_pim]=ptr_new(hdrA)
	num_pim=num_pim+1
	pim[num_pim]=ptr_new(ima)
	phdr[num_pim]=ptr_new(hdrA)
	num_pim=num_pim+1

;	stop
	

endif
if keyword_set(hi1B) then begin
	secchi_prep, Bpre, hdrb, imbp, outsize=512
	secchi_prep, hi1B, hdrB, imbb, outsize=512
	imb=bytscl(alog10((imbb-imbp) > 0), min=-150,max=1)
	;imb2=bytscl(alog10((imbb-imbp) >0), min=-200,max=1)
        bkg=scc_getbkgimg(hdrB)
        imb2=rebin(bytscl(float(imbb)/float(bkg), min=.97, max=1.05), 512, 512)
;	imb2=scc_mk_image(hi1B, outsize=512, /NOPOP, /NOLOGO, /NODATETIME)

	pim[num_pim]=ptr_new(imb2)
	phdr[num_pim]=ptr_new(hdrB)
	num_pim=num_pim+1
	pim[num_pim]=ptr_new(imb)
	phdr[num_pim]=ptr_new(hdrB)
	num_pim=num_pim+1
	;stop

endif


if keyword_set(lascoC2) then begin
        C2=sccreadfits(lascoC2, hdrC2, /LASCO)
        C2pre=sccreadfits(lascopre, hdrpre, /LASCO)
        bkg=getbkgimg(hdrC2)
       ;imc2b=bytscl(rebin(C2-bkg, 512,512), min=0, max=2000)
       ;res=mk_img(lascoC2,0,2000,/LG_mask_occ)
        res=mk_img(lascoC2,0.9,1.3,/ratio,/LG_mask_occ,/no_display)
        imc2b=bytscl(rebin(res.imaje,512,512), .9, 1.30)
        res1=mk_img(lascopre,0.9,1.3,/ratio,/LG_mask_occ,/no_display)
        imc2=bytscl(rebin(res.imaje-res1.imaje,512,512),-0.03,0.03) 
       
        for i=0L, 511 do begin
           for j=0L, 511 do begin
            if sqrt((i-res.sunxcen/2)*(i-res.sunxcen/2)+(j-res.sunycen/2)*(j-res.sunycen/2)) gt res.r_occ_out/2 or sqrt((i-res.sunxcen/2)*(i-res.sunxcen/2)+(j-res.sunycen/2)*(j-res.sunycen/2)) lt res.r_occ/2 then imc2(i,j)=0
           endfor
        endfor
 
       ;  imc2=rebin(C2/hdrC2.exptime-C2pre/hdrpre.exptime,512,512)
       ;  imc2=bytscl(imc2,min=mean(imc2)-stddev(imc2)/2,max=mean(imc2)+1*stddev(imc2))
       pim[num_pim]=ptr_new(imc2)
       phdr[num_pim]=ptr_new(hdrC2)
       num_pim=num_pim+1

       pim[num_pim]=ptr_new(imc2b)
       phdr[num_pim]=ptr_new(hdrC2)
       num_pim=num_pim+1 
endif


if keyword_set(lascoC3) then begin
       C3=sccreadfits(lascoC3, hdrC3, /LASCO)
       C3pre=sccreadfits(lascopre, hdrpre, /LASCO)
       ;bkg=getbkgimg(hdrc3)
       res=mk_img(lascoC3,.9, 1.15, /ratio,/Lg_mask_occ,/no_display)
       imc3b=bytscl(rebin(res.imaje,512,512), .85, 1.10)
;      imc3b=bytscl(rebin(C3-bkg, 512,512), min=0, max=1000)
       res1=mk_img(lascopre,0.9,1.15,/ratio,/LG_mask_occ,/no_display)
       imc3=bytscl(rebin(res.imaje-res1.imaje,512,512),-0.01,0.01)

; imc3=rebin(C3/hdrc3.exptime-C3pre/hdrpre.exptime,512,512)
; ;imc3=rebin(C3-C3pre,512,512)
; imc3=bytscl(imc3,min=median(imc3)-0.1*stddev(imc3),max=median(imc3)+0.1*stddev(imc3))
      
       for i=0L, 511 do begin
          for j=0L, 511 do begin
            if sqrt((i-res.sunxcen/2)*(i-res.sunxcen/2)+(j-res.sunycen/2)*(j-res.sunycen/2)) gt res.r_occ_out/2 or sqrt((i-res.sunxcen/2)*(i-res.sunxcen/2)+(j-res.sunycen/2)*(j-res.sunycen/2)) lt res.r_occ/2 then imc3(i,j)=0
          endfor
       endfor

      pim[num_pim]=ptr_new(imc3)
      phdr[num_pim]=ptr_new(hdrC3)
      num_pim=num_pim+1

      pim[num_pim]=ptr_new(imc3b)
      phdr[num_pim]=ptr_new(hdrC3)
      num_pim=num_pim+1
endif




rtcloudwidget,pim=pim[0:num_pim-1],phdr=phdr[0:num_pim-1], ldispima=ldisp

mkim=1
if keyword_set(mkim) then begin
totim=bytarr(3,1536,1024)

if num_pim gt 4 then begin
inx=[2,3,5,4,0,1]
;stop
for i=0,5 do totim[*,i/2*512:(i/2+1)*512-1, i mod 2 *512:(i mod 2+1)*512-1]=ldisp[inx[i]].im

if keyword_set(flip) then begin
   tmparr=bytarr(512,512)
   for j=0,2 do begin       
        tmparr[*,*]=totim[j, 512:1023, 0:511]
        totim[j,512:1023, 0:511]=rotate(tmparr,2)
        tmparr[*,*]=totim[j, 512:1023, 512:1023]
        totim[j,512:1023, 512:1023]=rotate(tmparr,2)
    endfor
endif 
im=image(totim)   
t=text(0.05,0.075,strmid(hdrA.date_obs,0,19), FONT_SIZE=18)
                                                                                       
im.save, strmid(hdrA.date_obs, 0, 4)+strmid(hdrA.date_obs, 5,2)+strmid(hdrA.date_obs,8,2)+strmid(hdrA.date_obs, 11,2)+strmid(hdrA.date_obs, 14,2)+'screenshot.eps'

endif else begin

   totim=bytarr(3, 1024, 512)
   totim[*,0:511,*]=ldisp[3].im
   totim[*,512:1023,*]=ldisp[1].im
   im=image(totim)
   t=text(0.05,0.18,strmid(hdrA.date_obs,0,19), FONT_SIZE=18)
   im.save, strmid(hdrA.date_obs, 0, 4)+strmid(hdrA.date_obs, 5,2)+strmid(hdrA.date_obs,8,2)+strmid(hdrA.date_obs, 11,2)+strmid(hdrA.date_obs, 14,2)+'screenshot.eps'
endelse
endif
end

