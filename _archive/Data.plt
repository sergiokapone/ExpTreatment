set encoding utf8


set style line 1 lc rgb "red" # http://gnuplot.sourceforge.net/docs_4.2/node237.html
set style line 2 ps 0.75 pt 7 lc rgb "blue"
set style line 3 ps 0.7 pt 7 lc rgb "red" 
set key at graph 0.4, 0.95  # http://gnuplot.sourceforge.net/docs_4.2/node192.html
set border linewidth 1

# Задаємо стилі сітки
set style line 4 lc rgb 'sandybrown' lt 1 lw 0.5
set style line 5 lc rgb 'sandybrown' lt 1 lw 0.25

# Задаємо мінорну сітку
set mxtics # http://gnuplot.sourceforge.net/docs_4.2/node205.html
set mytics

# Будуємо сітку
set grid xtics mxtics ytics mytics front ls 4, ls 5 # http://gnuplot.sourceforge.net/docs_4.2/node188.html

#Задаємо стиль текстоих боксів
set style textbox 1 opaque fc "white" noborder

set size square 1,1
# ----------- Data file ---------

datafile = "data.csv"
set xlabel "t / с"
set ylabel "y / м"


# ------------ Fitting ----------

set fit results
y0 = 1;
v0 = 1;
a = 1;

f(x) = y0 + v0*x + 1/2.*a*x**2;    
set fit errorvariables;
fit f(x) datafile u 1:2:3  yerror via y0,v0,a; # http://gnuplot.sourceforge.net/docs_4.2/node82.html

# ------------ Graphing ----------
set title "Висота підняття каменя"
set label 4 sprintf("Модель  y0 + v0*x + 1/2.*a*x**2, \nПараметр моделі\ny0 = (%.2f ± %.2f) м \nv0=(%.2f ± %.2f) м/c\na=(%.2f ± %.2f)м/с^2\nχ^2 = %.2f", y0, y0_err,v0,v0_err,a,a_err,(FIT_STDFIT)**2) at graph 0.3, 0.35 boxed  bs 1
 
plot  [0:2.25] f(x) ls 1 title "Апроксимація", datafile u 1:2:3  w yerrorbars ls 2 notitle, datafile u 1:2 ls 3 title "Експеримент"

# ------- Print to File ----------

set print "gnuplot.fit.dat"
print y0, y0_err, v0, v0_err, a, a_err, (FIT_STDFIT)**2


