
szd = size(diffn, /dim)

for i=0,szd[2]-1 do begin & $

	mu=moment(diffn(50:200, 200:950, i), sdev=sdev) & $
	thresh=mu[0]+3.*sdev & $

	plot_image, diffnb(*,*,i) & $

	contour, diffn(*,*,i), level=thresh, /over, path_info=info, $
		path_xy=xy, /path_data_coords & $

	plots, xy(*, info[0].offset:(info[0].offset+info[0].n-1)), $
		linestyle=0, /data & $


	recpol, xy(0,info[0].offset:(info[0].offset+info[0].n-1)), $
              xy(1,info[0].offset:(info[0].offset+info[0].n-1)), r, a, /degrees & $

	r_ave = (max(r)-min(r))/2. + min(r) & $
	plot, r, a & $
	



	ans='' & $
	read, 'ok?', ans & $

endfor
