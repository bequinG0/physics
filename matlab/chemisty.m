% === Опыт №2: Влияние температуры на скорость реакции ===

clear; clc; close all;

% Данные
T_C = [26, 36, 46];         % температура в °C
tau = [20.00, 13.00, 5.55]; % время реакции, с
v = 1 ./ tau;                % условная скорость реакции (1/с)

% Перевод температуры в Кельвины
T_K = T_C + 273.15;

% --- Аппроксимация экспонентой ---
% Модель: v = A * exp(B / T)
% Берём логарифм: ln(v) = ln(A) + B / T
x = 1 ./ T_K;
y = log(v);

% Поиск коэффициентов прямой
p = polyfit(x, y, 1);
B = p(1);
lnA = p(2);
A = exp(lnA);

% Модельные значения
T_fit = linspace(min(T_K), max(T_K), 200);
v_fit = A * exp(B ./ T_fit);

% --- Построение графика ---
figure('Color', 'w');
plot(T_K, v, 'o', 'MarkerFaceColor', 'b', 'MarkerSize', 8); hold on;
plot(T_fit, v_fit, 'r-', 'LineWidth', 2);
xlabel('Температура, K', 'FontSize', 12);
ylabel('Условная скорость реакции, 1/с', 'FontSize', 12);
title('Экспоненциальная зависимость скорости от температуры');
legend('Экспериментальные данные', 'Аппроксимация v = A·exp(B/T)', ...
       'Location', 'northwest');
grid on;

% --- Сохранение ---
saveas(gcf, 'exp_fit.png');

% --- Вывод параметров ---
fprintf('=== Аппроксимация ===\n');
fprintf('A = %.6f\n', A);
fprintf('B = %.6f\n', B);

