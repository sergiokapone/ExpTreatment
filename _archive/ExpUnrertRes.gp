set encoding utf8
set grid  
set style line 1 lc rgb "red"
set style line 2 ps 0.75 pt 7 lc rgb "blue"
set style line 3 ps 0.7 pt 7 lc rgb "orange" 
set key at graph 0.4, 0.95 
set border linewidth 1
set mxtics
set mytics
set style line 12 lc rgb 'gray90' lt 1 lw 1.0
set style line 13 lc rgb 'gray90' lt 1 lw 0.5
set grid xtics mxtics ytics mytics back ls 12, ls 13
set style textbox 1 opaque  fc "white" noborder
set size square 1,1
# ----------- Data file ---------

datafile = "ExpData.dat"
set xlabel "I / A"
set ylabel "B / Тл"
scale=1e4 
set label at graph 0,1.05 left "∙10^{-4}"

# ------------ Fitting ----------

set fit results
B = 0 # FIXED
f(x) = C*x + B;      # B = CI
set fit errorvariables;
fit f(x) datafile u 1:2:3:4  xyerrors via C; 

# ------ Calculating of R^2 ------

stats "" u 2:($2 - C*$1) nooutput
SST = STATS_stddev_x**2*STATS_records
SSE = STATS_sumsq_y
R2 = 1 - SSE/SST
 
# ------------ Graphing ----------
set title "Калібрувальна крива котушок Гельмгольца"
set label 4\
 sprintf("Лінійна модель  B = C∙I, \nПараметр моделі C = (%.2f ± %.2f)∙10^{- 4} Tл∙A^{- 1} \nR^2 = %.2f \nχ^2 = %.2f", C*scale, C_err*scale , R2, (FIT_STDFIT)**2)\
 at graph 0.3, 0.15 boxed  bs 1
plot  [x=0.9:2.3] [6e-4*scale:*] f(x)*scale ls 1 title "Апроксимація", "" u 1:($2*scale):3:($4*scale)  w xyerrorbars ls 2 notitle,\
"" u 1:($2*scale) ls 3 title "Експеримент"

# ------- Print to File ----------

set print "gnuplot.fit.dat"
print C, C_err, R2, (FIT_STDFIT)**2
#show variablesк

