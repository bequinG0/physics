% Данные из таблицы
U_p = [0.5, 1.0, 1.5, 1.8, 2.2, 2.8]; % Входное напряжение, В
K_c = [3.3, 3.3, 3.0, 2.8, 2.6, 2.4]; % Коэффициент K_c

% Построение графика
figure; % Создание нового окна для графика
plot(U_p, K_c, 'bo-', 'LineWidth', 2, 'MarkerSize', 8, 'MarkerFaceColor', 'b');
grid on; % Включение сетки

% Подписи осей и заголовок
xlabel('U_p, В', 'FontSize', 12);
ylabel('K_c(U_p)', 'FontSize', 12);
title('Зависимость коэффициента K_c от входного напряжения U_p', 'FontSize', 14);

% Настройка внешнего вида
set(gca, 'FontSize', 11); % Размер шрифта на осях
legend('K_c(U_p)', 'Location', 'northeast'); % Легенда

% Опционально: добавление точек данных с числовыми значениями
for i = 1:length(U_p)
    text(U_p(i) + 0.05, K_c(i) + 0.05, sprintf('(%.1f, %.1f)', U_p(i), K_c(i)), ...
        'FontSize', 9, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left');
end

% Сохранение графика в PNG файл
filename = '27-8.png'; % Имя файла
print(filename, '-dpng', '-r300'); % Сохранить как PNG с разрешением 300 DPI
