"""
Визначення математичної моделі для підгони.

Параметр підгонки beta[0]
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy.odr import ODR, Model, RealData


def func(beta, x):
    """
    Визначення математичної моделі для підгони.

    Параметр підгонки beta[0]
    """
    y = beta[0] * x
    return y


"""
налаштування вигляду графіка
"""
plt.figure(figsize=(5, 5))
plt.style.use("seaborn-white")
plt.xlabel("I / А")
plt.ylabel("В / Тл")
plt.ticklabel_format(style="sci", axis="y", scilimits=(-4, -4), useMathText=True)


plt.tick_params(axis="y", which="both", direction="in")
plt.minorticks_on()
plt.title("Калібрувальна крива котушок Гельмгольца\n", fontsize=12, color="black")
plt.grid(
    True, which="both", linestyle="dashed", color="lightgray", linewidth=0.3, alpha=0.5
)


"""
Завантаження даних в змінні
"""

data = np.loadtxt("ExpUnrertRes.dat", skiprows=1)
x = data[:, 0]
y = data[:, 1]
dx = data[:, 2]
dy = data[:, 3]


"""
Побудова експериментальних точок
"""

plt.errorbar(
    x,
    y,
    xerr=dx,
    yerr=dy,
    fmt="o",
    color="blue",
    markersize="4",
    elinewidth=1,
    capsize=1,
)
plt.errorbar(
    x,
    y,
    fmt="o",
    color="red",
    markersize="4",
    elinewidth=1,
    capsize=1,
    label="Есперимент",
)


"""
Підгонка
"""

model = Model(func)
data = RealData(x, y, dx, dy)
odr = ODR(data, model, [1])
odr.set_job(fit_type=0)
output = odr.run()
odr.run().pprint()


"""
Побудова кривої
"""

plt.plot(x, func(output.beta, x), color="red", linewidth=1, label="Модель $B = C I$")


label = "$C  = ({:.2f} \pm {:.2f} )\cdot 10^{{-4}}$,\
    \n $\chi^2/(n - p) = {:.2f}$".format(
    output.beta[0] * 1e4, output.sd_beta[0] * 1e4, output.res_var
)
plt.plot([], [], " ", label=label)

plt.legend(loc="upper left")

# plt.show()
plt.savefig("plot.pdf", transparent=True, pad_inches=0)
