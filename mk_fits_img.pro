pro mk_fits_img

;;To use procedure lasco_rename. Before run this code,you need to list the date at datelist like these:
;;datelist=['100206','100208','100210','100213']
  
;path='/home/zhzhong/Desktop/mywork/data/'
;cd,path
;spawn,'ls',datelist  ;get filename
datelist=['121027','121109','121120','121123'] 
for i=0,n_elements(datelist)-1 do begin
  stereo_img,date=datelist(i),sat='STA',instr='COR2'
  stereo_img,date=datelist(i),sat='STB',instr='COR2'
  ;lasco_rename,date=datelist(i)
  lasco_img,date=datelist(i)
endfor
;cd,'/home/zhzhong/Desktop/mywork/work/code'
end
