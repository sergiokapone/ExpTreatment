"""
Апроксимація даних за визначеною моделлю.

В файл передаються параметри 1 - 'Вхідний файл з даними'
                             2 - 'Вихідний файл з результатами'
Модель задається функцією model_func
"""

import sys
import numpy as np
from scipy.odr import ODR, Model, RealData


"""
Завантаження даних в змінні
"""
data = np.loadtxt(sys.argv[1], skiprows=1)
x = data[:, 0]
y = data[:, 1]
dx = data[:, 2]
dy = data[:, 3]


"""
Підгонка
"""


# Задаємо модельну функцію
def model_func(beta, x):
    """
    Визначення математичної моделі для підгони.

    Параметр підгонки beta[0] та beta[1]
    """
    y = beta[0] * x + beta[1]
    return y


# Здійснюємо підгону даних за моделлю
# https://docs.scipy.org/doc/scipy/reference/odr.html

# Створюємо екземпляр моделі
model = Model(model_func)

# Створюємо екземпляр даних data
data = RealData(x, y, dx, dy)

# Створюємо ODR зі своїми даними, моделлю та початковою оцінкою параметрів
odr = ODR(data, model, [6e-4, 0])

# Вибір методу підгонки
odr.set_job(fit_type=0)


def R_square(x, y, model, popt, uncertainty=1):
    """
    Розрахунок R^2.

    Функція повертає R^2 для заданої моделі.
    """
    weight = 1.0 / uncertainty
    Rsq = 1.0 - (np.var((y - model(popt, x)) * weight) / np.var(y * weight))
    n, p = len(y), len(popt)
    coefficient = (n - 1) / (n - p - 1)
    adj_Rsq = 1 - (1 - Rsq) * coefficient
    return adj_Rsq


# Отримуємо результати підгонки
output = odr.run()
adjusted_Rsq = R_square(x, y, model_func, popt=output.beta)

# Заапис параметрів у файл
np.savetxt(
    sys.argv[2],
    [
        ("Parameter a", output.beta[0]),
        ("Standart Deviation of a", output.sd_beta[0]),
        ("Parameter b", output.beta[1]),
        ("Standart Deviation of b", output.sd_beta[1]),
        ("chi square", output.res_var),
        ("R square", adjusted_Rsq),
    ],
    delimiter=": ",
    fmt="%s",
)
