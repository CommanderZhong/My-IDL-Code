pro using_gcs_model,ntime=ntime,psize=psize,nolasco=nolasco,recal=recal,bmp=bmp,outps=outps,ins=ins,lascoins=lascoins,test=test,timeb=timeb,lascotimeb=lascotimeb,noeuvi=noeuvi,diff=diff,lascolevel=lascolevel
if not keyword_set(ntime) then time='2008/11/02 12:00' else time=ntime
;time='2008/11/03 07:00'
print,time
if not keyword_Set(psize) then psize=512
if not keyword_Set(ins) then ins='cor2'
if ins eq 'hi1' then maxheight=100
if not keyword_Set(lascoins) then lascoins='c3'
if not keyword_set(lascolevel) then lascolevel='l05'

if not keyword_set(timeb) then timeb=get_bgtime(time,15)

	if keyword_set(diff) then stab_file=find_close_data(timeb,sat='sta',ins=ins,/both)
	sta_file=find_close_data(time,sat='sta',ins=ins,/both)
	if keyword_set(diff) then stbb_file=find_close_data(timeb,sat='stb',ins=ins,/both)
	stb_file=find_close_data(time,sat='stb',ins=ins,/both)
	if keyword_set(diff) then imgb=crt_image([[stbb_file,stb_file]],ins,outsize=psize) else imgb=crt_dir_image([stb_file],ins,outsize=psize)
	imb=imgb.image
	if keyword_set(diff) then hdrb=imgb.hdr[1] else hdrb=imgb.hdr
	print,'STEREO B' +strupcase(ins)+' data is recorded at:'+hdrb.date_obs
	;print,'STEREO A' +strupcase(ins)+' data is recorded at:'+imgb.hdr[0].date_obs

	if keyword_set(diff) then imga=crt_image([[stab_file,sta_file]],ins,outsize=psize) else imga=crt_dir_image([sta_file],ins,outsize=psize)
	ima=imga.image
	if keyword_set(diff) then hdra=imga.hdr[1] else hdra=imga.hdr
	print,'STEREO A' +strupcase(ins)+' data is recorded at:'+hdra.date_obs
	;print,'STEREO A' +strupcase(ins)+' data is recorded at:'+imga.hdr[0].date_obs

if not keyword_set(nolasco) then begin
	if not keyword_set(lascotimeb) then lascotimeb=get_bgtime(time,30)
	lascob_file=find_lasco(lascotimeb,level=lascolevel,ins=lascoins);find_close_data_old(lascotimeb,ins=lascoins,/both)
	lasco_file=find_lasco(time,ins=lascoins,level=lascolevel)
	imgla=crt_image([[lascob_file,lasco_file]],lascoins,outsize=psize)
	datalasco=imgla.image
	hdrlasco=imgla.hdr[1]
	print,'LASCO '+strupcase(lascoins)+' data is recorded at:'+hdrlasco.date_obs+' '+hdrlasco.time_obs
endif

if not keyword_set(noeuvi) then begin
	stae_file=find_close_data(time,sat='sta',ins='euvi',/both,wavelength=304)
	stbe_file=find_close_data(time,sat='stb',ins='euvi',/both,wavelength=304)
	euvia=crt_image(stae_file,'euvi',outsize=psize)
	print,stae_file
	imeuvia=euvia.image
	hdreuvia=euvia.hdr
	print,'EUVI A data is recorded at: '+hdreuvia.date_obs
	euvib=crt_image(stbe_file,'euvi',outsize=psize)
	imeuvib=euvib.image
	hdreuvib=euvib.hdr
	print,'EUVI B data is recorded at: '+hdreuvib.date_obs
endif

if not keyword_set(nolasco) then begin
	imlasco=datalasco
	hdrlasco=hdrlasco
endif
;save,filename='test.sav',ima,imb,hdra,hdrb,imeuvia,imeuvib,hdreuvia,hdreuvib,imlasco,hdrlasco
rtsccguicloud,ima,imb,hdra,hdrb,$
        imdispsize=[psize,psize],maxheight=maxheight,$
        ssim=ssimout,sgui=sguiout,$
        imeuvia=imeuvia,hdreuvia=hdreuvia,imeuvib=imeuvib,hdreuvib=hdreuvib,$
        demo=demo,showanaglyph=showanaglyph,eruptiondatein=eruptiondatein,$
        imlasco=imlasco,hdrlasco=hdrlasco,$
        forceinit=forceinit,swire=swire,$
        sparaminit=sparaminit,ocout=ocout,$
            imabsunin=imabsunin,imbbsunin=imbbsunin,admin=admin,modal=modal
filename='GCS-'+strupcase(ins)+'-'+strmid(hdrb.date_obs,0,4)+strmid(hdrb.date_obs,5,2)+strmid(hdrb.date_obs,8,2)+'-'+strmid(hdrb.date_obs,11,2)+strmid(hdrb.date_obs,14,2)
if not keyword_Set(test) then begin
	save,filename='./gcs/'+filename+'.sav',ssimout,sguiout,swire,ocout
;	show_gcs_result,time,filename=filename,bmp=bmp,ps=outps,nolasco=nolasco
endif
end
