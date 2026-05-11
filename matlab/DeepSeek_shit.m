clear; clc; close all;

%% Вспомогательные функции (определяем ПЕРЕД использованием)
function res_sq = residual_sq(alpha_real_imag, k, ode_opts)
    alpha = alpha_real_imag(1) + 1i*alpha_real_imag(2);
    beta = 1i * k * (2 - alpha);
    [~, sol] = ode45(@(x, psi) ode_inside(x, psi, k), [0 1], [alpha; beta], ode_opts);
    psi_a = sol(end, 1);
    psi_prime_a = sol(end, 2);
    % Условие уходящей волны: ψ'(a)/ψ(a) = i k
    F = psi_prime_a / psi_a - 1i*k;
    res_sq = abs(F)^2;
end

function dpsi = ode_inside(x, psi, k)
    % psi(1) = ψ, psi(2) = ψ'
    V = 1 - x;   % безразмерный потенциал внутри барьера (U0=1, a=1)
    dpsi = zeros(2,1);
    dpsi(1) = psi(2);
    dpsi(2) = -(k^2 - 2*V) * psi(1);
end

%% Параметры задачи (безразмерные)
hbar = 1; m = 1; a = 1; U0 = 10;
% ... остальной код ...%% Параметры задачи (безразмерные)
hbar = 1; m = 1; a = 1; U0 = 10;
% Потенциал V(x) = U0*(1 - x/a) для 0<x<a, и 0 вне

% Диапазон волновых векторов k
k_min = 0.1; k_max = 5.0; Nk = 300;
k_vec = linspace(k_min, k_max, Nk);

% Массив для коэффициента прохождения T
T_vec = zeros(size(k_vec));

%% Настройки интегрирования
ode_opts = odeset('RelTol', 1e-8, 'AbsTol', 1e-10);

%% Основной цикл по k
for idx = 1:length(k_vec)
    k = k_vec(idx);
    
    % Функция невязки (квадрат модуля)
    residual_fun = @(alpha_real_imag) residual_sq(alpha_real_imag, k, ode_opts);
    
    % Начальное приближение: α = 1 (B=0)
    alpha0 = [1; 0];  % [Re(α), Im(α)]
    
    % Минимизация невязки
    alpha_opt = fminsearch(residual_fun, alpha0);
    alpha = alpha_opt(1) + 1i*alpha_opt(2);
    
    % Решение внутри барьера с найденным α
    beta = 1i * k * (2 - alpha);
    [x_in, psi_in] = ode45(@(x, psi) ode_inside(x, psi, k), [0 a], [alpha; beta], ode_opts);
    psi_a = psi_in(end, 1);
    
    % Амплитуда прошедшей волны и коэффициент прохождения
    C = psi_a * exp(i * k * a);
    T = abs(C)^2;
    T_vec(idx) = T;
end

%% График коэффициента прохождения
figure;
plot(k_vec, T_vec, 'b-', 'LineWidth', 2);
xlabel('Волновой вектор k');
ylabel('Коэффициент прохождения T');
title('Прохождение через треугольный барьер (без Toolbox)');
grid on;
xlim([k_min k_max]);
ylim([0 1]);

%% Построение квадрата волновой функции для выбранного k
k_example = 2;
% Находим α для k_example
res_fun_ex = @(alpha_real_imag) residual_sq(alpha_real_imag, k_example, ode_opts);
alpha0_ex = [1; 0];
alpha_opt_ex = fminsearch(res_fun_ex, alpha0_ex);
alpha_ex = alpha_opt_ex(1) + 1i*alpha_opt_ex(2);
beta_ex = 1i * k_example * (2 - alpha_ex);

% Решение внутри барьера
[x_in, psi_in] = ode45(@(x, psi) ode_inside(x, psi, k_example), [0 a], [alpha_ex; beta_ex], ode_opts);
psi_in_vals = psi_in(:,1);

% Амплитуды
B = alpha_ex - 1;
C = psi_in_vals(end) * exp(-1i * k_example * a);

% Область x < 0
x_left = linspace(-2, 0, 200);
psi_left = exp(1i * k_example * x_left) + B * exp(-1i * k_example * x_left);
psi_left_abs2 = abs(psi_left).^2;

% Область x > a
x_right = linspace(a, 3, 200);
psi_right = C * exp(1i * k_example * x_right);
psi_right_abs2 = abs(psi_right).^2;

% Область внутри барьера
x_in_plot = x_in;
psi_in_abs2 = abs(psi_in_vals).^2;

% Сшиваем
x_full = [x_left, x_in_plot', x_right];
psi2_full = [psi_left_abs2, psi_in_abs2', psi_right_abs2];

figure;
plot(x_full, psi2_full, 'r-', 'LineWidth', 1.5);
xlabel('x');
ylabel('|\psi(x)|^2');
title(sprintf('Квадрат волновой функции при k = %.2f', k_example));
grid on;
hold on;
% Покажем потенциал (масштабирован для визуализации)
x_pot = linspace(-0.2, 1.2, 200);
V_plot = U0 * (1 - min(1, max(0, x_pot/a)));
V_plot_scaled = V_plot / max(V_plot);
plot(x_pot, V_plot_scaled, 'k--', 'LineWidth', 1.5);
legend('|\psi(x)|^2', 'Потенциал (вид)');
waitfor(gcf);
