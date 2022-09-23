# ------------ Підгонка ----------
set fit results
b = 0
a = 6e-4;
f(x) = a*x + b; 
set fit errorvariables;
fit f(x) 'ExpData.dat' u 1:2:3:4  xyerrors via a; 

plot f(x), 'ExpData.dat' u 1:2:3:4 with xyerrorbars



