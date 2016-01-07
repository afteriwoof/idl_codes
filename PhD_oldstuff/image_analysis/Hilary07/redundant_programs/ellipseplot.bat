; Code to try and find ellipse parameters for plotting over the contour array indices.

; Last edited 15-02-07


;p = randomu(10,10,2)

p=fltarr(2,2)
p[0,0]=3
p[0,1]=2
p[1,0]=6
p[1,1]=5

x = p(*,0)
y = p(*,1)

x=transpose(x)
y=transpose(y)

;weights = 0.75/(4.0^2+0.1^2)
;p = mpfitellipse(x,y)

;phi = dindgen(101)*2D*!dpi/100
;plots, p(2)+p(0)*cos(phi), p(3)+p(1)*sin(phi)



sz_x = size(x, /dim)
sz_y = size(y, /dim)

x_tot = 0.
y_tot = 0.

i=0.

while(i lt sz_x[1]) do begin & $
	x_tot = x_tot + x(i) & $
	y_tot = y_tot + y(i) & $
	i=i+1 & $
endwhile

x_bar = x_tot / sz_x[1]
y_bar = y_tot / sz_y[1]



i=0.
z=fltarr(2,sz_x[1])
temp1=fltarr(2)
temp2=fltarr(2,2)
mx=fltarr(4,sz_x[1])
total = fltarr(2,2)

while(i lt sz_x[1]) do begin & $

        ; Take the vector (x-xbar, y-ybar)
        z[i,0] = ( x[i] - x_bar ) & $
        z[i,1] = ( y[i] - y_bar ) & $
        
	; Multiply each by its transpose
        temp1[0] = z[i,0] & $
	temp1[1] = z[i,1] & $

	temp2 = transpose(temp1)##temp1 & $
 	
	total = total + temp2 & $

        i=i+1 & $

endwhile
