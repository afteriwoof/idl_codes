function myfunct, p, X=x, Y=y, err=err, forward=fw

model = p[0] + p[1]*x + p[2]*x^2.

if keyword_set(fw) then return, model $
	else return, (y-model)/err

end
