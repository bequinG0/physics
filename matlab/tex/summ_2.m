% === Основной код ===
x = linspace(-pi, pi, 1000);          % ось x
f = double(abs(x) > pi/2);            % кусочная функция
f(abs(abs(x) - pi/2) < 1e-4) = NaN;   % искусственные разрывы


figure('Units', 'pixels', 'Position', [100 100 800 600]);

% Частичная сумма S_3(x)
S3 = 0.5 * ones(size(x));  % начальный член A0/2
for k = 1:3
    ak = -2 / (pi * k) * sin(pi * k / 2);  % коэффициент a_k
    S3 = S3 + ak * cos(k * x);            % добавление k-го члена
end

% Частичная сумма S_5(x)
S5 = 0.5 * ones(size(x));  % начальный член A0/2
for k = 1:5
    ak = -2 / (pi * k) * sin(pi * k / 2);  % коэффициент a_k
    S5 = S5 + ak * cos(k * x);            % добавление k-го члена
end

% Частичная сумма S_7(x)
S7 = 0.5 * ones(size(x));  % начальный член A0/2
for k = 1:7
    ak = -2 / (pi * k) * sin(pi * k / 2);  % коэффициент a_k
    S7 = S7 + ak * cos(k * x);            % добавление k-го члена
end

% Построение графика
plot(x, f, 'k', 'LineWidth', 2); hold on;
plot(x, S3, 'r', 'LineWidth', 1.5);
plot(x, S5, 'b', 'LineWidth', 1.5);
plot(x, S7, 'g', 'LineWidth', 1.5);

xlabel('x');
%legend({'f(x)', 'S_3(x)', 'S_5(x)', 'S_7(x)'}, 'Location', 'north'); % правильная легендаt
title('График частичных сумм ряда Фурье');
grid on;
axis([-pi pi -0.2 1.2]);
set(gca, 'GridLineStyle', ':', 'GridAlpha', 0.3);
print('../../images/summ_2.png', '-dpng', '-r300');
hold off;

