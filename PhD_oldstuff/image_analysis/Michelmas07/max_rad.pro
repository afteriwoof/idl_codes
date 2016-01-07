; Code to take the window defined in combined_thresholds.pro and highlight max radial pixels.

; Last Edited: 08-10-07

function radials, in, out

lines = fltarr(2, sz_da[0], 4)

for quadrant=1,4 do begin
	
	for j=0,sz_da[0]-1 do begin
		
		case quadrant of
			1: begin
				lines[0,j,0] = in[0].crpix1 + j
				lines[1,j,0] = in[0].crpix2
			end
			2: begin
				lines[0,j,1] = in[0].crpix1
				lines[1,j,1] = in[0].crpix2 + j
			end
			3: begin
				lines[0,j,2] = in[0].crpix1 - j
				lines[1,j,2] = in[0].crpix2
			end
			4: begin
				lines[0,j,3] = in[0].crpix1
				lines[1,j,3] = in[0].crpix2 - j
			end
		endcase
			
				
	endfor

endfor

end


;PRO max_rad, in, combined, modgrads
;
;sz = size(combined,/dim)
;
;for k=0,sz[2]-1 do begin

	



;END
