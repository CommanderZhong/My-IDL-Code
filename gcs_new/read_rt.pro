function read_rt, file

;read measurement data file, return raytrace parameters in structure s 



        restore, 'data_temp.sav'
        data=read_ascii(file , template=template)
        n=n_elements(data.field01)
        s1={height:0.0, shock:0.0, half_angle:0.0, rot:0.0, lat:0.0, lon:0.0, ratio:0.0, date_obs:''}
        s=replicate(s1,n)
        s.date_obs=data.field01+' '+data.field02
        s.height=data.field06
        s.shock=data.field07
        s.rot=data.field05
        s.lat=data.field04
        s.lon=data.field03
        s.half_angle=data.field09
        s.ratio=data.field08

        return, s
end


