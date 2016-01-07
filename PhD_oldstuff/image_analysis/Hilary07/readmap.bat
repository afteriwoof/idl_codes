; Last Edited 06-02-07


fls = file_search('~/PhD/Data_from_Alex/18-apr-00/*.fts')

mreadfits, fls, in, da 

da = float(da)

da_norm = da
danb = da
sz = size(da, /dim)

for i=0,sz[2]-1 do begin & $

	im = da(*,*,i) & $

;	rm_inner, im, in[i], dr, thr=2.1 & $

	da(*,*,i) = fmedian(im,5,3) & $

	da_norm(*,*,i) = da(*,*,i) / in[i].exptime & $
	
;	danb(*,*,i) = bytscl(da_norm(*,*,i), 25, 225) & $

endfor

diffn = fltarr(sz[0],sz[1],sz[2]-1)
diffnb = diffn

for i=0,sz[2]-2 do begin & $

	diffn(*,*,i) = da_norm(*,*,i+1) - da_norm(*,*,i) & $

;	diffnb(*,*,i) = bytscl(diffn(*,*,i), -10, 18) & $

endfor

newin = in(0:13)

index2map, newin, diffn, maps

index2map, newin, diffnb, mapsb



