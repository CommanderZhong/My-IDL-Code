pro work_20120712, start, mkim=mkim, flip=flip

;runs the driver program for the event
;the start_time_INS and end_time_INS will be the start and end times for using each instrument
;start-START TIME OF THE MEASUREMENT in XX:XX format
;/mkim: create an output image of the scraytrace output
;/flip: the code doesn't always rotate LASCO images properly, so this will artifically rotate the LASCO images for the image output.

;.r scc_mkframe

date='20120712'
end_date_hi='20120713'

start_time_cor1=1620
end_time_cor1=1645
start_time_cor2=1650
end_time_cor2=1830
start_time_hi=1830
end_time_hi=1500
end_time_c2=1800
end_time_c3=2000

if ~keyword_set(start) then start='00:00'

work_scloop, date, start_time_cor2, end_time_cor2, start_time_hi, end_date_hi, end_time_hi, end_time_c2, end_time_c3, start_time_cor1, end_time_cor1, start, mkim=mkim, flip=flip

cd, date
end

