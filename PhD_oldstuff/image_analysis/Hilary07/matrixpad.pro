pro matrixpad, mx1, mx2, mx1_new, mx2_new

; NEED TO EDIT THIS TO PAD TO THE MAXIMUM!!!

sz_mx1 = size(mx1, /dim)
sz_mx2 = size(mx2, /dim)

if n_elements(sz_mx1) eq 1 then begin
        ; redefine the vector to a Nx1 array
        temp = fltarr(sz_mx1, sz_mx1)
        temp[*,0] = mx1
	mx1 = temp
	sz_mx1 = size(mx1, /dim)
endif

if n_elements(sz_mx2) eq 1 then begin
        ; redefine the vector to a Nx1 array
        temp = fltarr(sz_mx2, sz_mx2) 
        temp[*,0] = mx2
	mx2 = temp
	sz_mx2 = size(mx2, /dim)
endif       

			
if sz_mx1[0] lt sz_mx2[1] then begin
        temp = fltarr(sz_mx2[1], sz_mx1[1])
        temp[0:sz_mx1[0]-1, *] = mx1
        mx1 = temp
endif

sz_mx1 = size(mx1, /dim)

if sz_mx2[0] lt sz_mx1[1] then begin
        temp = fltarr(sz_mx1[1], sz_mx2[1])
        temp[0:sz_mx2[0]-1, *] = mx2
        mx2 = temp
endif

sz_mx2 = size(mx2, /dim)

if sz_mx1[1] lt sz_mx2[0] then begin
        temp = fltarr(sz_mx1[0], sz_mx2[0])
        temp[*, 0:sz_mx1[1]-1] = mx1
        mx1 = temp
endif

if sz_mx2[1] lt sz_mx1[0] then begin
        temp = fltarr(sz_mx2[0], sz_mx1[0])
        temp[*, 0:sz_mx2[1]-1] = mx2
        mx2 = temp
endif
	
mx1_new = mx1
mx2_new = mx2


end
