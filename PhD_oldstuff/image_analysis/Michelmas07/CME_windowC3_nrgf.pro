; Code which makes a mask of area where the CME is determined to be in difference images.

; Last Edited: 08-10-07

PRO CME_windowC3_nrgf, in, da, masks, dim

sz = size(da, /dim)

index2map, in, da, maps
sz_map = size(maps.data, /dim)

masks = fltarr(sz[0],sz[1],sz[2]-1)
dim = masks

for k=0,sz[2]-1 do begin

	plot_image, sigrange(da[*,*,k])

	mu = moment(da[*,*,k], sdev=sdev)
	thr = mu[0] + 1*sdev

	contour, da[*,*,k], lev=thr, /over
	pause
	contour, da[*,*,k], lev=thr, /over, path_info=info, $
		path_xy=xy, /path_data_coords

	c=0	
	x = xy[0,info[c].offset:(info[c].offset+info[c].n-1)]
	y = xy[1,info[c].offset:(info[c].offset+info[c].n-1)]

	index = polyfillv(x,y,sz[0],sz[1])
	temp = fltarr(sz[0],sz[1])
	temp[index] = 1
	se=[1,1,1,1]
	se=[[se,se,se,se],[se,se,se,se],[se,se,se,se],[se,se,se,se]]
	se=[[se,se,se,se],[se,se,se,se],[se,se,se,se],[se,se,se,se]]
	masks[*,*,k] = dilate(temp,se)

	dim[*,*,k] = masks[*,*,k]
	dim[where(dim eq 0)] = 0.1
	dim[*,*,k] = dim[*,*,k]*da[*,*,k+1]
endfor




END





