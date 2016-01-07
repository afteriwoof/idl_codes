; Code which produces normalised exposure time data array and byte-scaling of same from Alex's data 18-apr-2000.
; Also removes disk surrounding Solar disk.

; This code uses fmedian before it applies the normalisation or bytscl.
; fmedian calls fmedian_slow which takes a long time to run!!!

; Creating MAPS from the data and scaling contour values to maps coords.

; Made tangents to the CME edges and also lines at intervals of ten through CME angle.

; Obtains average point of CME front and deduces the apex.

; Derives width of CME from the maximum width close to the mid curve through ave. point.

; Sample attempt to fit an ellipse to the array of data points.

; Last edited 05-03-07


pro mapcontours_fast, tangents=tangents, previous=previous, lines=lines

;fls = file_search('~/PhD/Data_from_Alex/18-apr-00/*.fts')
;fls = file_search('~/PhD/Data_from_James/010515/*.fts')

;mreadfits, fls, in, da
;save, da, filename='da.sav'
;save, in, filename='in.sav'
restore, '~/PhD/Data_sav_files/da.sav'
restore, '~/PhD/Data_sav_files/in.sav'

;restore, 'da_221194.sav'
;restore, 'in_221194.sav'


; Operations to be done on James's data
;c2data = where( in.detector eq 'C2' and in.naxis1 eq 1024)
;mreadfits, fls(c2data), in, c2data
;ssw_fill_cube2, c2data, da

;restore, '~/PhD/18apr2000.sav'

;restore, '~/PhD/in.sav'

; Convert INT array to FLOAT
da = float(da)

da_norm = da

danb = da

sz = size(da, /dim)


;for i=0,sz[2]-1 do begin
	
;	im = da(*,*,i)

	; Remove inner disk
;	rm_inner, im, in[i], dr, thr=2.2
	
	; Median operator to smooth noise pixels
;	da(*,*,i) = fmedian(im, 5, 3)

	; Normalising the data with regard to exposure time
;	da_norm(*,*,i) = da(*,*,i) / in[i].exptime

	; Bytscaling for image presentation only.
;	danb(*,*,i) = bytscl(da_norm(*,*,i), 25, 225)

;endfor

;save, da_norm, filename='da_norm.sav'
;save, danb, filename='danb.sav'

restore, '~/PhD/Data_sav_files/da_norm.sav'
restore, '~/PhD/Data_sav_files/danb.sav'

;restore, 'da_norm_221194.sav'
;restore, 'danb_221194.sav'


; Now computing Running Difference

diffn = fltarr(sz[0],sz[1],sz[2]-1)

diffnb = diffn

for i=0,sz[2]-2 do begin

	diffn(*,*,i) = da_norm(*,*,i+1) - da_norm(*,*,i)

	diffnb(*,*,i) = bytscl( diffn(*,*,i), -10, 18)

endfor

szd = size(diffn, /dim)

; Creating maps but note the header isn't being edited (the times will be wrong)!

newin = in[0:szd[2]-1]

index2map, newin, diffn, maps

index2map, newin, diffnb, mapsb

szmap = size(maps.data, /dim)

loadct, 3

;For making the movie: 
temparr = fltarr(776, 745, szd[2]-1)

; Contour / Thresholding

delvarx, da, da_norm, danb

for i=1,szd[2]-1 do begin
;for i=9,9 do begin

	print, i

	mu = moment( diffn(50:200, 200:950, i), sdev=sdev)
	thresh = mu[0] + 6.*sdev
	;thresh_lwr = mu[0] - 3.*sdev

	;print, 'mu:' & print, mu
	;print, 'thresh:' & print, thresh

	set_line_color

	;plot_hist, diffn[50:200, 200:950, i], xr=[-10, 10] ; yr=[0,5000]
	;plots, [ mu[0], mu[0] ], [0,3000], color=3
	;plots, [ thresh, thresh ], [0,3000], color=5
	;plots, [ thresh_lwr, thresh_lwr ], [0,3000], color=5

	loadct, 3
	;plot_image, diffnb(*,*,i)

	contour, diffn(*,*,i), level=thresh, /over, path_info=info, $
		path_xy=xy, /path_data_coords, c_color=3, thick=2

	
	
	; Scaling the xy indices for map, lining up according to the Sun's centre.
	xy_org = xy
	help, xy
	
	xy(0,*) = ( xy(0,*)-in[i].crpix1 ) * in[i].cdelt1
	xy(1,*) = ( xy(1,*)-in[i].crpix2 ) * in[i].cdelt2

	plot_map, mapsb[i]


	; plotting tangents from previous image
	if keyword_set(previous) then begin
		if i ne 0 then begin	
			set_line_color
			plots, [0,x_apex], [0,y_apex], color=3
			plots, [0,x_edge1],[0,y_edge1], color=5
			plots, [0,x_edge2],[0,y_edge2], color=4	
		endif
	endif
	
	; Plotting the contours
	
	;plots, xy(*, info[0].offset : (info[0].offset + info[0].n -1) ), $
	;	linestyle=0, /data

	;plots, xy(*, info[1].offset : (info[1].offset + info[1].n -1) ), $
	;	linestyle=0, /data

	;plots, xy(*, info[2].offset : (info[2].offset + info[2].n -1) ), $
	;	linestyle=0, /data


	; This was attempt at fitting ellipse!

	;x1 = xy(0, info[0].offset : (info[0].offset + info[0].n -1))
	;y1 = xy(1, info[0].offset : (info[0].offset + info[0].n -1))

	;x1 = transpose(x1)
	;y1 = transpose(y1)

	;weights = 0.75/(4.0^2 + 0.1^2)

	;p = mpfitellipse(x1,y1)

	;phi = dindgen(101) * 2D * !dpi/100

	;plots, p(2)+p(0)*cos(phi), p(3)+p(1)*sin(phi)
	
	


	; Increase c to include more contours
	c = 1
	for k=0,c do begin

		x_org = xy_org(0,info[k].offset:(info[k].offset+info[k].n-1))
		y_org = xy_org(1,info[k].offset:(info[k].offset+info[k].n-1))
	
;***************************************************
		; Calling function ellipsefit.pro to plot ellipse	
		ellipse = ellipsefit(x_org, y_org)
		aprime = ellipse[0:(size(ellipse,/dim)-2)/2-1]
		bprime = ellipse[(size(ellipse,/dim)-2)/2:(size(ellipse,/dim)-2)-1]
	
		aprime = (aprime-in[i].crpix1) * in[i].cdelt1
		bprime = (bprime-in[i].crpix2) * in[i].cdelt2 
		x_bar_org = ellipse[size(ellipse,/dim)-2]
		y_bar_org = ellipse[size(ellipse,/dim)-1]
		x_bar = (x_bar_org-in[i].crpix1) * in[i].cdelt1
		y_bar = (y_bar_org-in[i].crpix2) * in[i].cdelt2	
		
;		plots, aprime, bprime, color=2 ;plots my ellipse
;		plots, x_bar, y_bar, psym=2	
;****************************************************


		recpol, x_org, y_org, r_org, a_org, /degrees

		
		x_map = xy(0,info[k].offset:(info[k].offset+info[k].n-1))
		y_map = xy(1,info[k].offset:(info[k].offset+info[k].n-1))
		recpol, x_map, y_map, r, a, /degrees

		a_max1 = max(a)
		a_min1 = min(a)

		a = round(a)
		r = round(r)

		a_max = max(a)
		a_min = min(a)

		a_front = fltarr(a_max - a_min +1)
		r_front = fltarr(a_max - a_min +1)
		temp = 0.
		count = a_min
		stepsize = 1.
		while(count le a_max) do begin
			a_front(temp) = count
			if(where(a eq count) eq [-1]) then goto, jump1
			r_front(temp) = max(r(where(a eq count)))
			jump1:
			temp = temp + 1
			count = count + stepsize
		endwhile

		polrec, r_front, a_front, x_front, y_front, /degrees

		; Average point of front

		sz_x_front = size(x_front, /dim)
		sz_y_front = size(y_front, /dim)
		sumx = 0.
		sumy = 0.
		count = 0.
		while(count lt sz_x_front[0]) do begin
			sumx = sumx + x_front[count]
			sumy = sumy + y_front[count]
			count = count + 1
		endwhile

		x_front_bar = sumx / sz_x_front[0]
		y_front_bar = sumy / sz_y_front[0]

		plots, x_front, y_front
		;plots, x_front_bar, y_front_bar, psym=7
		
;*****************************************************************
	


		recpol, x_front_bar, y_front_bar, r_bar, a_bar, /degrees
		r_a_bar = max(r(where(a eq round(a_bar))))
		polrec, r_a_bar, a_bar, x_apex, y_apex, /degrees
		;plots, x_apex, y_apex, psym=2	
		;print, 'apex:' & print, r_a_bar	

		; Obtain slope and perpendicular to find width
		;slope = y_front_bar/x_front_bar
		;slope_perp = -1./slope
		;print, slope, slope_perp
		;c = y_front_bar - slope_perp*x_front_bar
		;print, c
		;plots, [0,x_front_bar], [c,y_front_bar]
		

		
		; Attempt to find the width of the CME

		n = 30
		count = 1
		sign = 0
		crossing = where(r eq round(r_bar))
		range = [crossing]
		while (size(range, /dim) lt n) do begin
			if sign mod 2 eq 0 then crossings = where(r eq round(r_bar)+count)
			if sign mod 2 eq 1 then crossings = where(r eq round(r_bar)-count)
			range = [range, [crossings]]
			count = count + 1
			sign = sign + 1
		endwhile

		a_width = max(a(range)) - min(a(range))
		polrec, r_bar, max(a(range)), x_width1, y_width1, /degrees
		polrec, r_bar, min(a(range)), x_width2, y_width2, /degrees
		;plots, x_width1, y_width1, psym=7
		;plots, x_width2, y_width2, psym=7
		;plots, [x_width1,x_width2], [y_width1,y_width2], color=8
		
		width = fltarr(szd[2],c+1)
		;help, width
		;slope_width = (y_width2 - y_width1) / (x_width2 - x_width1)
		width[i,k] = sqrt((y_width2 - y_width1)^2 + (x_width2 - x_width1)^2)
		;print, 'width:' & print, width

	

		
		; drawing circle of solar limb
		r_sun = pb0r(maps[i].time, /soho, /arcsec)
		draw_circle, 0, 0, r_sun[2]
	
	
		; drawing tangents to the CME edges
		if keyword_set(tangents) then begin
			;plotting lines to points of width
			plots, [0,x_width1], [0,y_width1]
			plots, [0,x_width2], [0,y_width2]
			;plotting line to apex
			plots, [0,x_apex], [0,y_apex]
			slope1 = sqrt((y_front[0] / x_front[0])^2)
			y_edge1 = (in[i].naxis2 - in[i].crpix2) * in[i].cdelt2
			x_edge1 = y_edge1/slope1
			if y_front[0] lt 0 then begin
				y_edge1 = -y_edge1
				if x_front[0] lt 0 then begin
					x_edge1 = -x_edge1
				endif
			endif else begin
				if x_front[0] lt 0 then begin
					x_edge1 = -x_edge1
				endif
			endelse
			plots, [0,x_edge1], [0,y_edge1]		
			;plots, [0,x_new[0]], [0, y_new[0]]
		
			szx_front = size(x_front, /dim)
			szy_front = size(y_front, /dim)
		
			slope2 = sqrt((y_front[szy_front] / x_front[szx_front])^2)
       		 	y_edge2 = (in[i].naxis2 - in[i].crpix2) * in[i].cdelt2
       		 	x_edge2 = y_edge2/slope2
       		 	if y_front[szy_front] lt 0 then begin
       		        	y_edge2 = -y_edge2
       		        	if x_front[szx_front] lt 0 then begin
       		                	x_edge2 = -x_edge2
       		         	endif   
		       	endif else begin
		                if x_front[szx_front] lt 0 then begin
       		         	        x_edge2 = -x_edge2
       		         	endif   
      	 	 	endelse
        		plots, [0,x_edge2], [0,y_edge2]
			;plots, [0,x_front[szx_front]], [0,y_front[szy_front]]
		endif


		; plotting N angle lines along CME
		;if keyword_set(lines) then begin
			dist = a_max1 - a_min1
			n = 30.
			steps = dist / n
			angles = fltarr(n+1)
			r_angles = fltarr(n+1)
			r_mid = fltarr(n+1)
			r_front = fltarr(n+1)
			count = a_min1
			temp = 0
			;print, angles
			;print, temp
			;print, count
			;print, steps
			;print, a_max1	
			while(count le a_max1) do begin
				angles(temp) = count
				if(where(a eq round(count)) eq [-1]) then goto, jump2
				r_angles(temp) = max(r(where(a eq round(count)))) 
				jump2:
				r_mid(temp) = r_bar
				r_front(temp) = r_a_bar
				temp = temp + 1
				count = count + steps
			endwhile		
			r_mid = r_mid(where(r_mid ne 0))	
			polrec, r_angles, angles, x_step, y_step, /degrees
			polrec, r_mid, angles, x_mid, y_mid, /degrees
			polrec, r_front, angles, x_front2, y_front2, /degrees
			;plots, x_front2, y_front2	
	;		plots, x_mid, y_mid
			szx_step = size(x_step, /dim)
		
		if keyword_set(lines) then begin	
			for j=0,szx_step[0]-1 do begin
				plots, [0,x_step[j]],[0,y_step[j]]
			endfor
		endif


;*****************************************************************
;               Using the average point of the front coords (scaled to origin) 
;		to find the fit given by MPFITFUN for inclined ellipse equation.

		xbar = (x_bar_org[0]-in[i].crpix1) * in[i].cdelt1
		ybar = (y_bar_org[0]-in[i].crpix2) * in[i].cdelt2
		x0 = x_front - xbar
		y0 = y_front - ybar
		recpol, x0, y0, y, x
		fit = 'sqrt((p(0)^2*p(1)^2)/((p(0)^2+p(1)^2)/2-((p(0)^2-p(1)^2)/2)*cos(2*x-2*p(2))))'
		parinfo = replicate({value:0.D, fixed:0, limited:[0,0], limits:[0.D,0]},3)
		parinfo(*).value = [10*width[i,k], 10*width[i,k], 1.]
		param = mpfitexpr(fit, x, y, y*0.1, parinfo=parinfo, perror=perror, yfit=yfit)
		polrec, yfit, x, nx, ny
		nx = nx + xbar
		ny = ny + ybar
		plots, nx, ny ;plotting the fitted ellipse

		;*****
		; Use the p params to oplot the major and minor axes.
		plots, [xbar-param[0]*cos(param[2]), xbar+param[0]*cos(param[2])], $
			[ybar-param[0]*sin(param[2]), ybar+param[0]*sin(param[2])], color=3
		plots, [xbar-param[1]*cos(param[2]+!pi/2.), xbar+param[1]*cos(param[2]+!pi/2.)], $
			[ybar-param[1]*sin(param[2]+!pi/2.), ybar+param[1]*sin(param[2]+!pi/2.)], color=3

		;*****

		
		;*****
		; Can include plots of the lines within the CME to the fitted ellipse points.
		sz_nx = size(nx, /dim)
		temparr = fltarr(sz_nx[0])
		for j=0,sz_nx[0]-1 do begin
			;plots, [xbar, nx[j]], [ybar, ny[j]]
			temparr[j] = sqrt((xbar-nx[j])^2 + (ybar-ny[j])^2)
		endfor
		; Silly taking max one as semimajor when mpfitfun spits out the p params.
		;max_major = 2. * max(temparr)
		;print, temparr
		;print, max_major
		;*****
		
		;plot, x_front, y_front
		plots, xbar, ybar, psym=2
		
	endfor
	;r_ave = (max(r)-min(r))/2. + min(r)


	; Drawing lines from contour edge to edge

	;a_int = a
	;sz=size(a,/dim)
	;for k=0,sz[1]-1 do begin 
	;	a_int(*,k)=fix(a(*,k))
	;endfor

	;plot, r, a_int

	;for i=0,13 do begin & $

	;window, /free &  plot_image, diffn(*,*,i) & $

	;for j=min(a_int),max(a_int) do begin
	;        sz1 = size(r(where(a_int eq j)),/dim)
	;        if sz1 gt 2 then begin
;			array1 = fltarr(1,sz1)
;			array1 = r(where(a_int eq j))
			
;			polrec, array1, j, xx, yy, /degrees
;			plots, xx, yy
;		endif
;	endfor																			
	;for making the movie
	;entry = tvrd()
	;print, size(entry,/dim)
	;temparr(*,*,i) = entry
	
	ans=''
	read, 'ok?', ans

endfor

;wr_movie, 'CME_ellipses+axes', temparr



end

