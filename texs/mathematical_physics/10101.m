x = linspace(-2.5, 2.5, 1000);
f_1 = 2 - x.^2;
f_2 = x.^2;

figure;
grid on;
hold on;

% Находим точки пересечения для ограничения области
intersect_idx = find(f_1 >= f_2);
x_fill = x(intersect_idx);
y1_fill = f_1(intersect_idx);
y2_fill = f_2(intersect_idx);

% Заливаем область между кривыми
fill([x_fill, fliplr(x_fill)], [y1_fill, fliplr(y2_fill)], 'b', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

% Рисуем кривые поверх
plot(x, f_1, 'r', 'LineWidth', 1);
plot(x, f_2, 'b', 'LineWidth', 1);

legend('Область между кривыми', '2 - x^2', 'x^2');
xlabel('x');
ylabel('y');

print('-dpng', '-r300', '10101.png');
waitfor(gcf);


