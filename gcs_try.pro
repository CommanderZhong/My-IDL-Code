pro sav_read,date=date

;;To read sav data file
;;example:
;;       sav_read,date='120614'


path='/home/zhzhong/Desktop/mywork/work/savdata/'+date+'/'
file=findfile(path+'*.sav')
;There are 6 kinds of parameters in total
n=6
m=1
m=n_elements(file)
par=fltarr(n,m)
;;create a new txt file to save parameters' data
openw,lun,path+'pardata'+date+'.txt',/get_lun
title='date='+date
subtitle='TIME              LON              LAT              ROT              HAN              HGT              RAT'
printf,lun,title
printf,lun,subtitle
thisFormat='(a,6(f,2x))'
for i=0,m-1 do begin
restore,file(i)
;help,sguiout,/str
par[0,i]=sguiout.LON
par[1,i]=sguiout.LAT
par[2,i]=sguiout.ROT
par[3,i]=sguiout.HAN
par[4,i]=sguiout.HGT
par[5,i]=sguiout.RAT
eruptiontime=strmid(sguiout.ERUPTIONDATE,11,12)
printf,lun,eruptiontime,par[*,i],Format=thisFormat
endfor
free_lun,lun
end

pro gcs_try,date=date,head,tail

;;Purpose:   To use gcs model 
;;Use:   gcs_try,date=date,head,tail
;;Keywords:
;;       date:string,the date to use gcs model
;;       head:the start number of file
;;       tail:the end number of file
;;Example:
;;	 gcs_try,date='120623',20,28
;;Editor:
;;      Z.H.Zhong at 02/26/2019


    patha='/home/zhzhong/Desktop/mywork/data/'+date+'/STA'
    pathb='/home/zhzhong/Desktop/mywork/data/'+date+'/STB'
    pathl='/home/zhzhong/Desktop/mywork/data/'+date+'/LC2'
    filea=findfile(patha+'/*fts')
    fileb=findfile(pathb+'/*fts')
    filel=findfile(pathl+'/*fts')
    ;k=41
    ;secchi_prep,filea[k],bindexa,bdataa,/silent,/smask_on,/rotate_on,/calfac_off,/calimg_off
    ;secchi_prep,fileb[k],bindexb,bdatab,/silent,/smask_on,/rotate_on,/calfac_off,/calimg_off
    ;bdatal=lasco_readfits(filel[k],bindexl)
    for i=head+1,tail do begin             
        secchi_prep,filea[i],indexa,dataa,/silent,/smask_on,/rotate_on,/calfac_off,/calimg_off
        secchi_prep,fileb[i],indexb,datab,/silent,/smask_on,/rotate_on,/calfac_off,/calimg_off
        datal=lasco_readfits(filel[i],indexl)
	tempa=dataa
	tempb=datab
	templ=datal  
	;running difference      
	if i-head eq 1 then begin
	secchi_prep,filea[i-1],bindexa,bdataa,/silent,/smask_on,/rotate_on,/calfac_off,/calimg_off
        secchi_prep,fileb[i-1],bindexb,bdatab,/silent,/smask_on,/rotate_on,/calfac_off,/calimg_off
        bdatal=lasco_readfits(filel[i-1],bindexl)
	endif
	dataa=dataa-bdataa
	datab=datab-bdatab
	datal=datal-bdatal
	bdataa=tempa
	bdatab=tempb
	bdatal=templ

        imagea=congrid(bytscl(median(smooth(dataa,5),5),-5,5),512,512)       ;running difference -2-2
        imageb=congrid(bytscl(median(smooth(datab,5),5),-5,5),512,512)
        imagel=congrid(bytscl(median(smooth(datal,3),3),-100,100),512,512)      ;running difference -30-30
	;use gcs model
        rtsccguicloud,imagea,imageb,indexa,indexb,imlasco=imagel,hdrlasco=indexl,sgui=sguiout
	;save sav data file
	savfile='/home/zhzhong/Desktop/mywork/work/savdata/'+date+'/'
	spawn,'mkdir -p '+savfile
	name=savfile+'/sguiout'+string(i-head,format='(I2.2)')+'.sav'
	SAVE,sguiout,FILENAME=name
    endfor
    sav_read,date=date
end

