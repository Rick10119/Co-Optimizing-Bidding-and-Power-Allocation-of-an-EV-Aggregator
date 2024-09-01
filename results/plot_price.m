%% 逐小时的投标
close;
diff = 0.1;

cd ../data_prepare
data_prepare;
cd ../results


%%
linewidth = 1.5;

% 实际能量
plot(1:16, param.price_e, "-r", 'linewidth', linewidth);hold on;

y1 = ylabel('Energy Price ($/MWh)','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');
% ax.YLim = [0, 90];     
% 画电池电量（右轴）
yyaxis right


% ax.YLim = [0, 90];     
plot(1:16, param.price_reg(:, 1), "--g", 'linewidth', linewidth);
plot(1:16, param.price_reg(:, 2), ":b", 'linewidth', linewidth);

ax = gca;
ax.YColor = 'black';

legend('Energy','Regulation Capacity','Regulation Mileage','fontsize',13.5, ...
    'Location','NorthEast', ...
'Orientation','vertical', ...
'FontName', 'Times New Roman'); 
set(gca, "YGrid", "on");

%设置figure各个参数
x1 = xlabel('Hour','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');          %轴标题可以用tex解释
y1 = ylabel('Regulation Price ($/MW)','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');


% 图片大小
figureUnits = 'centimeters';
figureWidth = 15;
figureHeight = 10;
set(gcf, 'Units', figureUnits, 'Position', [10 10 figureWidth figureHeight]);

%% 轴属性
ax = gca;
ax.XLim = [0, 17];     
  
% 字体与大小
ax.FontSize = 13.5;

% 设置刻度
ax.XTick = [1:16];

% 调整标签
ax.XTickLabel =  {'18','19','20','21','22','23','24','1','2','3','4','5','6','7','8','9'};
ax.FontName = 'Times New Roman';
set(gcf, 'PaperSize', [15, 10]);

saveas(gcf,'price.pdf');