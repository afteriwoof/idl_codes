; Based upon the ideas in rings.pro

; Want to produce a full represeentation image corresponding to the polar circles of the image

; Last Edited: 20-03-08

pro ring_plots, in, da, alpgrads, modgrads

s=1
im = da[*,*,s]

temp = fltarr(5239,41)
stepsize=0.12
for i=21,60 do begin
	im2 = im
	im2 = rm_inner(im2, in[s], dr_px, thr=((81-i)/10.+stepsize-0.02))
	im2 = rm_outer(im2, in[s], dr_px, thr=((81-i)/10.+stepsize))
	
	ind = where(im2 gt 0)
	sz_ind = n_elements(ind)
	diff = floor((5239-sz_ind)/2)
	temp[0:sz_ind-1,(60-i)] = im2[ind]
	
	



	
endfor

plot_image, temp




end
