%% 市场收益
% 投标结果
Bid_P_rev = sum(Bid_P_rev')';
Bid_R_rev = sum(Bid_R_rev')';

actualProfit = param.price_e .* actualEnergy + param.price_reg(:, 1) .* Bid_R_rev * param.s_perf + ...
    (param.price_reg(:, 2) .* actualMil) * param.s_perf;
 % 乘以时段长度
actualProfit =  actualProfit * delta_t;