import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import norm

# Данные из таблицы
intervals = [
    [-17.0945, -16.5436], [-16.5436, -15.9926], [-15.9926, -15.4417],
    [-15.4417, -14.8908], [-14.8908, -14.3398], [-14.3398, -13.7889],
    [-13.7889, -13.2380], [-13.2380, -12.6871], [-12.6871, -12.1361],
    [-12.1361, -11.5851]
]
frequencies = [3, 3, 9, 13, 23, 22, 10, 9, 6, 3]
relative_freq = [0.03, 0.03, 0.09, 0.13, 0.23, 0.22, 0.1, 0.09, 0.06, 0.03]
probabilities = [0.0545, 0.0545, 0.1634, 0.2360, 0.4175, 0.3993, 0.1815, 0.1634, 0.1089, 0.0363]

# Параметры нормального распределения
mu = -14.344491
sigma = np.sqrt(1.21749222668586)

# Создаем фигуру
plt.figure(figsize=(12, 6))

# Гистограмма относительных частот
widths = [interval[1]-interval[0] for interval in intervals]
centers = [(interval[0]+interval[1])/2 for interval in intervals]
plt.bar(centers, relative_freq, width=widths, alpha=0.5, edgecolor='black', label='Гистограмма относительных частот')

# Полигон частот (соединяем середины столбцов)
plt.plot(centers, relative_freq, 'r-o', label='Полигон частот')

# Теоретическая нормальная плотность
x = np.linspace(-18, -11, 1000)
pdf = norm.pdf(x, mu, sigma)
plt.plot(x, pdf, 'g-', linewidth=2, label=f'Нормальная плотность\nμ={mu:.2f}, σ={sigma:.2f}')

# Настройки графика
plt.xlabel('Значения')
plt.ylabel('Плотность вероятности / Относительная частота')
plt.title('Гистограмма, полигон частот и теоретическая плотность распределения')
plt.legend()
plt.grid(True, linestyle='--', alpha=0.7)
plt.xticks(np.arange(-18, -10, 0.5))
plt.xlim(-17.5, -11.5)

plt.tight_layout()
plt.show()
