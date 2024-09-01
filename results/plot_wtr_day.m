%% 不同老化因子下，各方法对应的聚合商收益情况


% 所提机制
load("results_days/cost_wrt_day_my_alloc.mat");
A1 = total_table;

% 按比例分配
load("results_days/cost_wrt_day_proportional.mat");
A2 = total_table;

% 按启发式权重分配
load("results_days/cost_wrt_day_heuristic.mat");
A3 = total_table;

% 按当下最小老化成本分配
load("results_days/cost_wrt_day_minDeg.mat");
A4 =total_table;


linewidth = 1;
% 利润
plot(1:14, A1(:, 3), "-or", 'linewidth', linewidth);hold on;
plot(1:14, A2(:, 3), "-xb", 'linewidth', linewidth);
plot(1:14, A3(:, 3), "-<g", 'linewidth', linewidth);
plot(1:14, A4(:, 3), "-*m", 'linewidth', linewidth);
% 成本
plot(1:14, A1(:, 2), "--or", 'linewidth', linewidth);hold on;
plot(1:14, A2(:, 2), "--xb", 'linewidth', linewidth);
plot(1:14, A3(:, 2), "--<g", 'linewidth', linewidth);
plot(1:14, A4(:, 2), "--*m", 'linewidth', linewidth);

legend('Profit-Proposed Method', ...
'Profit-Proportional Allocation', ...
'Profit-Heuristic Weight', ...
'Profit-Minimum Degradation', ...
'Degradation-Proposed Method', ...
'Degradation-Proportional Allocation', ...
'Degradation-Heuristic Weight', ...
'Degradation-Minimum Degradation', ...
'fontsize',13.5, ...
'Location','NorthOutside', ...
'Orientation','vertical', ...
'NumColumns', 2, ...
'FontName', 'Times New Roman'); 

%% 属性
%设置figure各个参数
x1 = xlabel('Date (July)','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');          %轴标题可以用tex解释
y1 = ylabel('$','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');


%% 图片大小
figureUnits = 'centimeters';
figureWidth = 20;
figureHeight = figureWidth *2.35 / 4;
set(gcf, 'Units', figureUnits, 'Position', [10 10 figureWidth figureHeight]);

%% 轴属性
ax = gca;
ax.XLim = [0.5, 14.5];     
% ax.YLim = [30, 50];     
% 字体与大小

ax.FontSize = 13.5;

% 设置刻度
ax.XTick = [1:14];

% 调整标签
ax.XTickLabel =  {'15','16','17','18','19', ...
    '20','21','22','23','24', ...
    '25','26','27','28'};

set(gca, "YGrid", "on");
% set(gca, "ylim", [-10, 10]);

set(gcf, 'PaperSize', [19, 12]);


saveas(gcf,'wtr_day.pdf');


