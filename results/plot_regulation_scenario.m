%% 某小时的调频信号场景分布
close;
if ~exist('hour')
test_forecast;% 找到预测最好的那个时段
end
diff = 0.1;
if ~exist('param')
cd ../data_prepare
data_prepare;
cd ../results
end

%%
barwidth = 1;

% 实际能量
A = [hourly_Distribution(hour, :)', param.hourly_Distribution(hour, :)'];
bar(A, barwidth);



legend('Actual Occurrence Frequency','Forecasted Probability','fontsize',13.5, ...
    'Location','NorthWest', ...
'Orientation','vertical', ...
'FontName', 'Times New Roman'); 
set(gca, "YGrid", "on");

%设置figure各个参数
x1 = xlabel('Regulation Signal Scenario','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');          %轴标题可以用tex解释
y1 = ylabel('Probability / Occurrence Frequency','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');



%% 图片大小
figureUnits = 'centimeters';
figureWidth = 20;
figureHeight = figureWidth * 2 / 4;
set(gcf, 'Units', figureUnits, 'Position', [10 10 figureWidth figureHeight]);

%% 轴属性
ax = gca;
ax.XLim = [0.5, 22.5];     
  
% 字体与大小
ax.FontSize = 13.5;

% 设置刻度
ax.XTick = [1:22];

% 调整标签
ax.XTickLabel =  {'-1','(-1, -0.9]','(-0.9,0.8]','(-0.8,0.7]','(-0.7,0.6]','(-0.6,0.5]','(-0.5,0.4]','(-0.4,0.3]','(-0.3,0.2]','(-0.2,0.1]','(-0.1,0.0)', ...
    '[0.0,0.1)','[0.1,0.2)','[0.2,0.3)','[0.3,0.4)','[0.4,0.5)','[0.5,0.6)','[0.6,0.7)','[0.7,0.8)','[0.8,0.9)','[0.9,1)','1'};
ax.FontName = 'Times New Roman';
set(gcf, 'PaperSize', [18.5, 10.2]);



saveas(gcf,'scenario.pdf');