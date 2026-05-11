hold on;
grid on;
x = linspace(-3, 3, 1000);
f = @(x) 1/sqrt(2*pi)*exp(-x.^2 /2);

plot(x, f(x), 'b', 'LineWidth', 2);
xlabel('x');
ylabel('f(x)');
title('Интервалы с корнями (отмечены красным)');
legend('Функция', 'Границы интервалов', 'Location', 'northwest');
waitfor(gcf);