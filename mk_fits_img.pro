pro mk_fits_img

;;To use procedure lasco_rename. Before run this code,you need to list the date at datelist like these:
;;datelist=['100206','100208','100210','100213']
  
;path='/home/zhzhong/Desktop/mywork/data/'
;cd,path
;spawn,'ls',datelist  ;get filename
datelist=['100418','100419','100616','110119','110121','110130','110325','110711','110914','111001','111002''111026'] 
for i=0,n_elements(datelist)-1 do begin
  stereo_img,date=datelist(i),sat='STA',instr='COR2'
  stereo_img,date=datelist(i),sat='STB',instr='COR2'
  lasco_img,date=datelist(i)
endfor
;cd,'/home/zhzhong/Desktop/mywork/work/code'
end