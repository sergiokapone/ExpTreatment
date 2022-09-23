datafile = "Polyfit.dat"


# ------------ Fitting ----------
set fit errorvariables;
k = -0.0010669
l=0.000156399

h(x) = q + i*x + j*x**2 + k*x**3 + l*x**4
fit h(x) datafile u 1:2:3:4  xyerrors via q,i,j,k,l


plot h(x), datafile u 1:2:3:4 w xyerrorbars