import numpy as np
import matplotlib.pyplot as plt
from scipy.linalg import solve

# ========== ФИЗИЧЕСКИЕ ПАРАМЕТРЫ ==========
w = 400e-6
L = 4e-3

y_bounds = np.array([0, 1200e-9, 1420e-9, 1670e-9, 2320e-9,
                     2362e-9, 3012e-9, 3162e-9, 3512e-9, 3682e-9])
y = y_bounds[1:]

k = np.array([55, 10, 10, 55, 5, 55, 10, 10, 55])

q = np.array([9.77e8, 2.03e8, 3.91e9, 1.22e10,
              2.05e15, 6.51e9, 2.17e9, 6.09e8, 3.48e7])

# Параметры теплоотвода на верхней границе
h_air = -100.0      # Вт/(м²·К)
Tamb = 290.0      # K

# ========== ЧАСТНОЕ РЕШЕНИЕ (n=0) ==========
M = np.zeros((18, 18))
R = np.zeros(18)

# Нижняя граница: T(0) = 293
M[0, 1] = 1
R[0] = 293

row = 1
for i in range(8):
    # Непрерывность температуры
    M[row, 2*i] = y[i]
    M[row, 2*i+1] = 1
    M[row, 2*(i+1)] = -y[i]
    M[row, 2*(i+1)+1] = -1
    R[row] = -(-q[i]/(2*k[i]) * y[i]**2 + q[i+1]/(2*k[i+1]) * y[i]**2)
    row += 1
    
    # Непрерывность потока
    M[row, 2*i] = k[i]
    M[row, 2*(i+1)] = -k[i+1]
    R[row] = -(-q[i] * y[i] + q[i+1] * y[i])
    row += 1

# Верхняя граница: закон Ньютона
#-k9 * (-q9/k9*y9 + A0[9]) = h_air * (-q9/(2*k9)*y9² + A0[9]*y9 + B0[9] - Tamb)
M[row, 16] = -k[8] - h_air * y[8]
M[row, 17] = -h_air
R[row] = -q[8]*y[8] + h_air * (-q[8]/(2*k[8])*y[8]**2 - Tamb)

sol0 = solve(M, R)
A0 = sol0[0::2]
B0 = sol0[1::2]

print("Частное решение:")
print(f"A0 = {A0}")
print(f"B0 = {B0}")
print(f"T(0) = {B0[0]:.2f} K")
print(f"T(y9) = {-q[8]/(2*k[8])*y[8]**2 + A0[8]*y[8] + B0[8]:.2f} K\n")

# ========== ОДНОРОДНЫЕ МОДЫ ==========
def solve_mode(n, y, k, h_air):
    alpha = np.pi * n / w
    
    M = np.zeros((18, 18))
    R = np.zeros(18)
    
    # Нижнее условие: T(0) = 0 → Bn[1] = 0
    M[0, 1] = 1
    
    row = 1
    for i in range(8):
        sh = np.sinh(alpha * y[i])
        ch = np.cosh(alpha * y[i])
        
        # Непрерывность температуры
        M[row, 2*i] = sh
        M[row, 2*i+1] = ch
        M[row, 2*(i+1)] = -sh
        M[row, 2*(i+1)+1] = -ch
        row += 1
        
        # Непрерывность потока
        M[row, 2*i] = k[i] * ch
        M[row, 2*i+1] = k[i] * sh
        M[row, 2*(i+1)] = -k[i+1] * ch
        M[row, 2*(i+1)+1] = -k[i+1] * sh
        row += 1
    
    # Верхнее условие: -k9 * dT/dy = h_air * T
    # dT/dy = α (An[9] ch + Bn[9] sh)
    ch = np.cosh(alpha * y[8])
    sh = np.sinh(alpha * y[8])
    M[row, 16] = k[8] * alpha * ch + h_air * sh
    M[row, 17] = k[8] * alpha * sh + h_air * ch
    
    try:
        return solve(M, R)
    except:
        return None

# Решаем моды
modes = []
for n in range(1, 201):
    sol = solve_mode(n, y, k, h_air)
    if sol is not None:
        modes.append((n, sol))
    if n % 50 == 0:
        print(f"n = {n}: найдено {len(modes)} мод")

print(f"\nВсего ненулевых мод: {len(modes)}")

# ========== ФУНКЦИИ ТЕМПЕРАТУРЫ ==========
def T_partial(y_val):
    if y_val < 0 or y_val > y_bounds[-1]:
        return np.nan
    idx = np.searchsorted(y_bounds[1:], y_val)
    return -q[idx]/(2*k[idx]) * y_val**2 + A0[idx] * y_val + B0[idx]

def T_total(x_val, y_val):
    total = T_partial(y_val)
    for n, sol in modes:
        alpha = np.pi * n / w
        An = sol[0::2]
        Bn = sol[1::2]
        total += (An[0] * np.sinh(alpha * y_val) + Bn[0] * np.cosh(alpha * y_val)) * np.cos(alpha * x_val)
    return T_partial(y_val)

# ========== ПОСТРОЕНИЕ ГРАФИКОВ ==========
y_plot = np.linspace(0, y_bounds[-1], 1000)
T_center = [T_total(w/2, y) for y in y_plot]

plt.figure(figsize=(10, 6))
plt.plot(y_plot*1e9, T_center, 'b-', linewidth=2)
plt.axhline(293, color='r', linestyle='--', alpha=0.7, label='Подложка (293 K)')
plt.axvline(y[5]*1e9, color='g', linestyle='--', alpha=0.5, label='Активная область')
plt.xlabel('y (нм)')
plt.ylabel('T (K)')
plt.title('Профиль температуры по центру структуры (x = w/2)')
plt.grid(True, alpha=0.3)
plt.legend()
plt.tight_layout()
plt.show()

# ========== ТЕПЛОВАЯ КАРТА ==========
nx, ny = 300, 500
x_vals = np.linspace(0, w, nx)
y_vals = np.linspace(0, y_bounds[-1], ny)

T_map = np.zeros((ny, nx))
for i, x in enumerate(x_vals):
    for j, y in enumerate(y_vals):
        T_map[j, i] = T_total(x, y)

plt.figure(figsize=(14, 7))
extent = [0, w*1e6, 0, y_bounds[-1]*1e9]
im = plt.imshow(T_map, extent=extent, origin='lower', aspect='auto', cmap='hot')
plt.colorbar(im, label='T (K)')
plt.axhline(y[5]*1e9, color='cyan', linestyle='--', linewidth=1, label='Активная область')
plt.xlabel('x (мкм)')
plt.ylabel('y (нм)')
plt.title('Распределение температуры T(x, y)')
plt.legend()
plt.tight_layout()
plt.show()

# Вывод максимальной температуры
T_max = np.max(T_map)
y_max_idx, x_max_idx = np.unravel_index(np.argmax(T_map), T_map.shape)
print(f"\nМаксимальная температура: {T_max:.2f} K")
print(f"Положение максимума: x = {x_vals[x_max_idx]*1e6:.1f} мкм, y = {y_vals[y_max_idx]*1e9:.1f} нм")
