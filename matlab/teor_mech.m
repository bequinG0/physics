x = linspace(1, 5, 1000);

% Правильное определение анонимных функций
f_1 = @(x) sqrt(2 + 3/2 * x.^2);
f_2 = @(x) -sqrt(2 + 3/2 * x.^2);

% Вычисление значений функций
y1 = f_1(x);
y2 = f_2(x);

figure;
hold on;
grid on;
plot(x, y1, 'b', 'Linewidth', 2);
plot(x, y2, 'r', 'Linewidth', 2);
xlabel('t');
ylabel('f(x)');
title('График функции f(t)');
waitfor(gcf);
