% === main_fourier.m ===

x = linspace(-pi, pi, 1000);          % ось x
f = double(abs(x) > pi/2);            % кусочная функция
f(abs(abs(x) - pi/2) < 1e-4) = NaN;   % искусственные разрывы

S3 = fourier_sum(3, x);
S5 = fourier_sum(5, x);
S7 = fourier_sum(7, x);

plot(x, f, 'k', 'LineWidth', 2); hold on;
plot(x, S3, 'r--', 'LineWidth', 1.5);
plot(x, S5, 'b--', 'LineWidth', 1.5);
plot(x, S7, 'g--', 'LineWidth', 1.5);

xlabel('x');
ylabel('f(x), S_N(x)');
legend('f(x)', 'S_3(x)', 'S_5(x)', 'S_7(x)', 'Location', 'northeast');
title('Сравнение f(x) и частичных сумм ряда Фурье');
grid on;
axis([-pi pi -0.2 1.2]);

% === вспомогательная функция ===
function S = fourier_sum(N, x)
  S = 0.5 * ones(size(x));
  for k = 1:N
    ak = -2 / (pi * k) * sin(pi * k / 2);
    S = S + ak * cos(k * x);
  end
end

