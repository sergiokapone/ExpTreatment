"""
Визначення математичної моделі для підгони.

Параметр підгонки beta[0]
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy.odr import ODR, Model, RealData
import matplotlib.ticker as ticker


"""
налаштування вигляду графіка =================================================
"""
fig, ax = plt.subplots()
plt.xlabel("I / А")
plt.ylabel("В / Тл")
plt.ticklabel_format(style="sci", axis="y", scilimits=(-4, -4), useMathText=True)


plt.tick_params(axis="y", which="both", direction="in")
plt.minorticks_on()
plt.title("Калібрувальна крива котушок Гельмгольца\n", fontsize=12, color="black")

# Встановлюємо інтервал основних поділок:
ax.xaxis.set_major_locator(ticker.MultipleLocator(0.2))
ax.yaxis.set_major_locator(ticker.MultipleLocator(1e-4))

# Налаштовуємо вигляд основних поділок:
ax.tick_params(
    axis="both",  # Застосовуємо параметри до обох осей
    which="major",  # Застосовуємо параметри до основних поділок
    direction="out",  # Рисуємо поділки зовні графіка
    length=5,  # Довжина поділок
    width=1,  # Ширина поділок
    color="k",  # Колір поділок
    pad=5,  # Відстань між рискою та її підписом
    labelsize=10,  # Розмір підпису
    labelcolor="k",  # Колір підпису
    bottom=True,  # Рисуемо риски знизу
    top=False,  # зверху
    left=True,  # ліворуч
    right=False,  # і праворуч
    labelbottom=True,  # Рисуемо підписи знизу
    labeltop=False,  # зверху
    labelleft=True,  # ліворуч
    labelright=False,  # і праворуч
    labelrotation=0,  # Поворот підписів
)


# Налаштовуємо вигляд допоміжних поділок:
ax.tick_params(
    axis="both",  # Застосовуємо параметри до обох осей
    which="minor",  # Застосовуємо параметри до допоміжних поділок
    direction="out",  # Рисуємо поділки зовні графіка
    length=2.5,  # Довжина поділок
    width=1,  # Ширина поділок
    color="k",  # Колір поділок
    pad=5,  # Відстань між рискою та її підписом
    labelsize=15,  # Розмір підпису
    labelcolor="k",  # Колір підпису
    bottom=True,  # Рисуемо риски знизу
    top=False,  # зверху
    left=True,  # ліворуч
    right=False,  # і праворуч
)

# Додаємо линії основної сітки:
ax.grid(which="major", color="sandybrown")

# Вмикаємо видимість допоміжних поділок:
ax.minorticks_on()
# Задаємо вигляд допоміжної сітки:
ax.grid(which="minor", color="darkorange", linestyle=":")

fig.set_figwidth(8)
fig.set_figheight(8)


"""
Завантаження даних в змінні ==================================================
"""

data = np.loadtxt("ExpData.dat", skiprows=1)
x = data[:, 0]
y = data[:, 1]
dx = data[:, 2]
dy = data[:, 3]


"""
Побудова експериментальних точок =============================================
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
Підгонка =====================================================================
"""


# Задаємо модельну функцію
def func(beta, x):
    """
    Визначення математичної моделі для підгони.

    Параметр підгонки beta[0]
    """
    y = beta[0] * x
    return y


# Здійснюємо підгону даних за моделлю
# https://docs.scipy.org/doc/scipy/reference/generated/scipy.odr.ODR.set_job.html


# Створюємо екземпляр моделі
model = Model(func)

# Створюємо екземпляр даних data
data = RealData(x, y, dx, dy)


# Створюємо ODR зі своїми даними, моделлю та початковою оцінкою параметрів
odrdat = ODR(data, model, [6e-4])

# Вибір методу підгонки
odrdat.set_job(fit_type=32)


def R_squared(observed, predicted, uncertainty=1):
    """
    Розрахунок R^2.

    Функція повертає R^2 для заданої моделі.
    """
    weight = 1.0 / uncertainty
    return 1.0 - (np.var((observed - predicted) * weight) / np.var(observed * weight))


def adjusted_R(x, y, model, popt, unc=1):
    """
    Returns adjusted R squared test for optimal parameters popt calculated
    according to W-MN formula, other forms have different coefficients:
    Wherry/McNemar : (n - 1)/(n - p - 1)
    Wherry : (n - 1)/(n - p)
    Lord : (n + p - 1)/(n - p - 1)
    Stein : (n - 1)/(n - p - 1) * (n - 2)/(n - p - 2) * (n + 1)/n

    """
    # Assuming you have a model with ODR argument order f(beta, x)
    # otherwise if model is of the form f(x, a, b, c..) you could use
    # R = R_squared(y, model(x, *popt), uncertainty=unc)
    R = R_squared(y, model(popt, x), uncertainty=unc)
    n, p = len(y), len(popt)
    coefficient = (n - 1) / (n - p - 1)
    adj = 1 - (1 - R) * coefficient
    return adj, R


# Отримуємо результати підгонки
output = odrdat.run()
odrdat.run().pprint()

adjusted_Rsq, Rsq = adjusted_R(x, y, func, popt=output.beta)
# Заапис параметрів у файл
np.savetxt(
    "pyplot.fit.dat",
    [(output.beta[0], output.sd_beta[0], adjusted_Rsq, output.res_var)],
)

"""
Побудова кривої ==============================================================
"""

plt.plot(x, func(output.beta, x), color="red", linewidth=1, label="Модель $B = C I$")


label = r"$C  = ({:.2f} \pm {:.2f} )\cdot 10^{{-4}}$, $\chi^2/(n - p) = {:.2f}$".format(
    output.beta[0] * 1e4, output.sd_beta[0] * 1e4, output.res_var
)
plt.plot([], [], " ", label=label)

# Додаємо легенду
plt.legend(facecolor="white", loc="upper left", frameon=True)

"""
Збрігаємо графік =============================================================
"""
plt.savefig("plot.pdf", transparent=True, pad_inches=0)
