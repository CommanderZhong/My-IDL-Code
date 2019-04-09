pro lasco_rename,date=date

  ;To rename lasco fts file which just download from internet
  ;example:
  ;        lasco_rename,date='120704'

    path='/home/zhzhong/Desktop/mywork/data/'+date+'/LC2'
    cd,path
    file=findfile('./*fts')
    for i=0,n_elements(file)-1 do begin             
	data=lasco_readfits(file(i),index)
	name=index.DATE_OBS+'_'+index.TIME_OBS
	name='C2_'+strMid(name,0,4)+strMid(name,5,2)+strmid(name,8,5)+strmid(name,14,2)+strMid(name,17,2)+'.fts'
	file_move,file(i),name
    endfor
    cd,'/home/zhzhong/Desktop/mywork/work/code'
end


pro use_lasco_rename

;To use procedure lasco_rename. Before run this code, you need to list the date at datelist as follow:
;datelist=['100206','100208','100210','100213']

datelist=['100206','100208','100210','100213']
for i=0,n_elements(datelist)-1 do begin
  lasco_rename,date=datelist[i]
endfor
end
