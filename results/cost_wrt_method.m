
%% 统计各种方法下，EV聚合商的投标结果、市场收入等结果

Profit_comp = [];
Cost_comp = [];
Bid_P_comp = [];
Bid_R_comp = [];
actualEnergy_comp = [];
P_unbal_comp = [];

% 所提机制
load("results_methods/result_my_alloc.mat");

Profit_comp = [Profit_comp, actualProfit];
Cost_comp = [Cost_comp, actualCost];
Bid_P_comp = [Bid_P_comp, Bid_P_rev];
Bid_R_comp = [Bid_R_comp, Bid_R_rev];
actualEnergy_comp = [actualEnergy_comp, actualEnergy];

% 按比例分配
load("results_methods/result_proportional.mat");
Profit_comp = [Profit_comp, actualProfit];
Cost_comp = [Cost_comp, actualCost];
Bid_P_comp = [Bid_P_comp, Bid_P_rev];
Bid_R_comp = [Bid_R_comp, Bid_R_rev];
actualEnergy_comp = [actualEnergy_comp, actualEnergy];

% 按启发式权重分配
load("results_methods/result_heuristic.mat");
Profit_comp = [Profit_comp, actualProfit];
Cost_comp = [Cost_comp, actualCost];
Bid_P_comp = [Bid_P_comp, Bid_P_rev];
Bid_R_comp = [Bid_R_comp, Bid_R_rev];
actualEnergy_comp = [actualEnergy_comp, actualEnergy];

% 按当下最小老化成本分配
load("results_methods/result_minDeg.mat");
Profit_comp = [Profit_comp, actualProfit];
Cost_comp = [Cost_comp, actualCost];
Bid_P_comp = [Bid_P_comp, Bid_P_rev];
Bid_R_comp = [Bid_R_comp, Bid_R_rev];
actualEnergy_comp = [actualEnergy_comp, actualEnergy];

% 利润
revenue = Profit_comp - Cost_comp;
total_revenue = sum(revenue);
total_profit = sum(Profit_comp);
total_cost = sum(Cost_comp);


total_table = [total_profit; total_cost; total_revenue]';

