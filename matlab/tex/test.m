% Параметры
t = linspace(-pi, pi, 1000);  % Интервал t ∈ (-π, π)
n_values = [3, 5, 7];         % Числа членов ряда
f = sin(t/(2*pi) + 0.5);      % Исходная функция f(t)

% Создаем окно
figure('Units', 'pixels', 'Position', [100 100 800 600]);
hold on;
grid on;
title('График частичных сумм S_n(t) и функции f(t)');
xlabel('t');
xlim([-pi, pi]);

% Стили графиков
styles = {'-', '-', '-'};    % Стили линий для S_n(t)
colors = [0.9 0.2 0.2;        % Красный (S_3)
          0.2 0.6 0.2;        % Зеленый (S_5)
          0.2 0.2 0.9];       % Синий (S_7)

% 1. Строим исходную функцию (черная жирная линия)
plot(t, f, 'k-', 'LineWidth', 1.5, 'DisplayName', '$f(t) = \sin\left(\frac{t}{2\pi} + \frac{1}{2}\right)$');

% 2. Строим частичные суммы
for i = 1:length(n_values)
    n = n_values(i);
    S = (1 - cos(1)) * ones(size(t));

    for k = 1:n
        coeff_cos = ((-1)^k * (1 - cos(1))) * (1/(1 + 2*pi*k) + 1/(1 - 2*pi*k));
        coeff_sin = ((-1)^k * sin(1)) * (1/(1 - 2*pi*k) - 1/(1 + 2*pi*k));
        S = S + coeff_cos * cos(k*t) + coeff_sin * sin(k*t);
    end

    plot(t, S, 'Color', colors(i,:), 'LineStyle', styles{i}, ...
        'LineWidth', 1.5, 'DisplayName', sprintf('$S_{%d}(t)$', n));
end

% Настройка легенды и осей
legend('Interpreter', 'latex', 'FontSize', 12, 'Location', 'northwest');
plot([-pi, -pi], ylim(), 'k:', 'HandleVisibility', 'off');
plot([pi, pi], ylim(), 'k:', 'HandleVisibility', 'off');

% Настройка сетки
set(gca, 'GridLineStyle', ':', 'GridAlpha', 0.3);
print('../../images/summ.png', '-dpng', '-r300');
hold off;
