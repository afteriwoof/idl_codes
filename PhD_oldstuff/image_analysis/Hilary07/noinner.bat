; Reading in da from blink.pro
;(need also to have run readin.bat for certain variables!)
; Normalise for exposure time

da_norm = da

for i=0,sz[2]-1 do begin & $

        da_norm(*,*,i) = da(*,*,i) / in[i].exptime & $

endfor

; Now to byte-scale for viewing the flicker!

danb = da

for i=0,sz[2]-1 do begin & $

	danb(*,*,i) = bytscl(da_norm(*,*,i), 25, 225) & $

endfor
