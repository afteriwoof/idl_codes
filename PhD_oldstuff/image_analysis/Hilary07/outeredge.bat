; Last Edited 02-05-07

;plot, r, a

a_int = a
sz=size(a,/dim)
for i=0,sz[1]-1 do begin & $
	a_int(*,i)=fix(a(*,i)) & $
endfor

;plot, r, a_int

;for i=0,13 do begin & $

;window, /free &  plot_image, diffn(*,*,i) & $

for j=min(a_int),max(a_int) do begin & $
	sz1 = size(r(where(a_int eq j)),/dim) & $
		if sz1 gt 2 then begin & $
			array1 = fltarr(1,sz1) & $
			array1 = r(where(a_int eq j)) & $
			
			
			polrec, array1, j, x1, y1, /degrees & $

			plots, x1, y1 & $
endif & $


