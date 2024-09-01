%% 投标-功率分解联合优化主程序

M = 1e3; % 大数

% 准备参数
cd ../data_prepare
data_prepare_main; % 调用数据准备函数
cd ../co-optimizing_bid_power-allocation

% 投标更新步长
NOFTCAP = 900; % 对应30分钟
P_alloc = []; % 用于记录功率分配结果
actualMil = zeros(NOFSLOTS, 1); % 记录实际调频里程
actualEnergy = zeros(NOFSLOTS, 1); % 记录实际与电网交换能量
actualCost = zeros(NOFSLOTS, 1); % 记录实际老化成本

% 初始时段
warning('off')
t_cap = 0;
maxProfit_1; % 计算初始时段最大利润

% 中间时段
for t_cap = 1 : (NOFSLOTS - 1) * 1800
    
    if mod(t_cap, 1800) == 0 % 时段末尾，更新下一时段投标，但乘子不更新
        delta_t_rest = 0;
        maxProfit_t; % 计算下一时段最大利润
        % 记录相关结果
        Bid_P_cur = value(Bid_P(1));
        Bid_R_cur = value(Bid_R(1));
        Bid_R_rev = [Bid_R_rev; value(Bid_R(1))];
        Bid_P_rev = [Bid_P_rev; value(Bid_P(1))];
        E_rev = [E_rev, E_cur];
        
    else
        if mod(t_cap, 900) == 1 % 时段初或中间初，更新乘子并分配功率，但不更新当前时段投标
            delta_t_rest = delta_t - mod(t_cap - 1, 1800) / 1800; % 当前时段剩余时间
            maxProfit_t; % 计算当前时段最大利润
            lambda = sol.solveroutput.lambda.eqlin(1 : NOFEV);
            minCostAllocation; % 功率分配
        end
    end
end

% 最后一个时段，不用再投标
for t_cap = (NOFSLOTS - 1) * 1800 + 1 : NOFSLOTS * 1800 - 1
    if mod(t_cap, 900) == 1 % 时段初或中间初，分配功率
        lambda = zeros(NOFEV, 1); % 避免数值问题
        minCostAllocation; % 功率分配
    end
end

E_rev = [E_rev, E_cur];

%% 市场收益
actualProfit = param.price_e .* actualEnergy + param.price_reg(:, 1) .* Bid_R_rev * param.s_perf + ...
    (param.price_reg(:, 2) .* actualMil) * param.s_perf;
 % 乘以时段长度
actualProfit =  actualProfit * delta_t;

save("../results/result_my_alloc.mat", "actualProfit", "actualCost", ...
    "Bid_P_rev", "Bid_R_rev", "Bid_P_init", "Bid_R_init", ...
    "actualEnergy", "actualMil", "P_alloc");
