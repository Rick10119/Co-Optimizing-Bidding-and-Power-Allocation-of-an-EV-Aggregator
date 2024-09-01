%% 不同老化因子下，各方法对应的聚合商收益情况


% 所提机制
load("results_deg/result_deg.mat");
A = total_table;

load("results_deg/result_my_alloc.mat");
A1 = [A(1:2, :);
    [sum(actualProfit), sum(actualCost), sum(actualProfit-actualCost)];
    A(3:4, :)];


% 按比例分配
load("results_deg/result_deg_proportional.mat");
A = total_table;

load("results_deg/result_proportional.mat");
A2 = [A(1:2, :);
    [sum(actualProfit), sum(actualCost), sum(actualProfit-actualCost)];
    A(3:4, :)];

% 按启发式权重分配
load("results_deg/result_deg_heuristic.mat");
A = total_table;

load("results_deg/result_heuristic.mat");
A3 = [A(1:2, :);
    [sum(actualProfit), sum(actualCost), sum(actualProfit-actualCost)];
    A(3:4, :)];

% 按当下最小老化成本分配
load("results_deg/result_deg_minDeg.mat");
A = total_table;

load("results_deg/result_minDeg.mat");
A4 = [A(1:2, :);
    [sum(actualProfit), sum(actualCost), sum(actualProfit-actualCost)];
    A(3:4, :)];




close;
linewidth = 1;
% 利润
plot(1:5, A1(:, 3), "-or", 'linewidth', linewidth);hold on;
plot(1:5, A2(:, 3), "-xb", 'linewidth', linewidth);
plot(1:5, A3(:, 3), "-<g", 'linewidth', linewidth);
plot(1:5, A4(:, 3), "-*m", 'linewidth', linewidth);
% 成本
plot(1:5, A1(:, 2), "--or", 'linewidth', linewidth);hold on;
plot(1:5, A2(:, 2), "--xb", 'linewidth', linewidth);
plot(1:5, A3(:, 2), "--<g", 'linewidth', linewidth);
plot(1:5, A4(:, 2), "--*m", 'linewidth', linewidth);

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
x1 = xlabel('Ratio of Degradation Factors','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');          %轴标题可以用tex解释
y1 = ylabel('$','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');


%% 图片大小
figureUnits = 'centimeters';
figureWidth = 20;
figureHeight = figureWidth * 2.35 / 4;
set(gcf, 'Units', figureUnits, 'Position', [10 10 figureWidth figureHeight]);

%% 轴属性
ax = gca;
ax.XLim = [0.5, 5.5];     
% ax.YLim = [30, 50];     
% 字体与大小

ax.FontSize = 13.5;

% 设置刻度
ax.XTick = [1 : 5];

% 调整标签
ax.XTickLabel =  {'0.25 Times','0.5 Times','Defualt Value','2 Times','4 Times'};
ax.FontName = 'Times New Roman';

set(gca, "YGrid", "on");
% set(gca, "ylim", [-10, 10]);
set(gcf, 'PaperSize', [18.5, 12]);


saveas(gcf,'wtr_deg.pdf');

