% Точность около pi/2
eps = 1e-4;

% Сформируем вручную отрезки: от -pi до -pi/2-eps, от -pi/2+eps до pi/2-eps, от pi/2+eps до pi
x1 = linspace(-pi, -pi/2 - eps, 300);
x2 = linspace(-pi/2 + eps, pi/2 - eps, 400);
x3 = linspace(pi/2 + eps, pi, 300);

% Объединяем x с разрывами (между ними NaN)
x = [x1 NaN x2 NaN x3];

% Значения функции f(x)
f1 = ones(size(x1));     % |x| > pi/2
f2 = zeros(size(x2));    % |x| <= pi/2
f3 = ones(size(x3));     % |x| > pi/2

f = [f1 NaN f2 NaN f3];  % вставляем NaN, чтобы показать разрывы


figure('Units', 'pixels', 'Position', [100 100 800 600]);
grid on;
hold on;
xlabel('x');
ylabel('f(x)');
title('График функции f(x)');
plot(x, f, 'LineWidth', 3);
set(gca, 'GridLineStyle', ':', 'GridAlpha', 0.3);
print('../../images/func_2.png', '-dpng');




