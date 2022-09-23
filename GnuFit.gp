# ------------ Підгонка ----------
set fit quiet
a = 6e-4;
f(x) = a*x + b; 
set fit errorvariables;
fit f(x) ARG1 u 1:2:3:4  xyerrors via a,b; 

# ------ Обчислення of R^2 ------

stats "" u 2:($2 - (a*$1 + b)) nooutput
SST = STATS_stddev_x**2*STATS_records
SSE = STATS_sumsq_y
R2 = 1 - SSE/SST
 
# ------- Запис результатів ----------

set print ARG2
print "Parameter a: ", a
print "Standart Deviation of a: ", a_err
print "Parameter b: ", b
print "Standart Deviation of b: ", b_err
print "chi square: ", (FIT_STDFIT)**2
print "R square:" , R2
