%% 逐小时的投标
close; clc;
cost_wrt_method;

linewidth = 1;

% 调整后调频容量
plot(1:16, Bid_R_comp(:, 1), "-or", 'linewidth', linewidth);hold on;
plot(1:16, Bid_R_comp(:, 2), "-xb", 'linewidth', linewidth);
plot(1:16, Bid_R_comp(:, 3), "-<g", 'linewidth', linewidth);
plot(1:16, Bid_R_comp(:, 4), "-*m", 'linewidth', linewidth);
% 实际能量

plot(1:16, actualEnergy_comp(:, 1), "--or", 'linewidth', linewidth);hold on;
plot(1:16, actualEnergy_comp(:, 2), "--xb", 'linewidth', linewidth);
plot(1:16, actualEnergy_comp(:, 3), "--<g", 'linewidth', linewidth);
plot(1:16, actualEnergy_comp(:, 4), "--*m", 'linewidth', linewidth);

legend('Regualtion-Proposed Method', ...
'Regualtion-Proportional Allocation', ...
'Regualtion-Heuristic Weight', ...
'Regualtion-Minimum Degradation', ...
'Energy-Proposed Method', ...
'Energy-Proportional Allocation', ...
'Energy-Heuristic Weight', ...
'Energy-Minimum Degradation', ...
'fontsize',13.5, ...
'Location','NorthOutside', ...
'Orientation','vertical', ...
'NumColumns', 2, ...
'FontName', 'Times New Roman'); 
set(gca, "YGrid", "on");

%设置figure各个参数
x1 = xlabel('Hour','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');          %轴标题可以用tex解释
y1 = ylabel('Capacity (MW)','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');


%% 图片大小
figureUnits = 'centimeters';
figureWidth = 20;
figureHeight = figureWidth * 2.35 / 4;
set(gcf, 'Units', figureUnits, 'Position', [10 10 figureWidth figureHeight]);

%% 轴属性
ax = gca;
ax.XLim = [0, 17];    
ax.YLim = [-3, 3]; 
% ax.YLim = [30, 50];     
% 字体与大小

ax.FontSize = 13.5;

% 设置刻度
ax.XTick = [1:16];
ax.YTick = [-3:3];

% 调整标签
ax.XTickLabel =  {'18','19','20','21','22','23','24','1','2','3','4','5','6','7','8','9'};
ax.FontName = 'Times New Roman';
% ax.FontName = 'Times New Roman';
set(gcf, 'PaperSize', [17.5, 12]);


saveas(gcf,'bids.pdf');