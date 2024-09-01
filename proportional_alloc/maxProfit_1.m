%% 拉通投标，从时段1开始

% 现有文献的做法，即按照比例分配调频信号

% 输入：各时段能量、调频市场价格；电动汽车到达、离开的时段、电量；
% 输出：各时段投标量、电池电量

%% 参数设定

% 见 data_prepare.m

%% 变量
% 投标容量：能量、调频(MW)
Bid_P = sdpvar(NOFSLOTS, NOFEV, 'full'); 
Bid_R = sdpvar(NOFSLOTS, NOFEV, 'full'); 


% 辅助变量
P_dis = sdpvar(NOFEV, NOFSLOTS, NOFSCEN, 'full'); % EV在各场景放电功率(kW)
P_ch = sdpvar(NOFEV, NOFSLOTS, NOFSCEN, 'full'); % EV在各场景充电功率(kW)
E = sdpvar(NOFEV, NOFSLOTS + 1, 'full'); % EV在各时段之初的电池能量(kWh)。包括离开时刻(时段初)，因此多一个维度
Cost_deg = sdpvar(NOFSLOTS, NOFSCEN, 'full');% 各时段各场景的老化成本($)

%% 目标函数
% 能量收益、调频容量收益、调频里程收益、部署成本、性能成本
Profit = sum(param.price_e' * Bid_P + param.price_reg(:, 1)' * Bid_R * param.s_perf + ...
    (param.price_reg(:, 2) .* param.hourly_Mileage)' * Bid_R * param.s_perf + ...
     ((param.hourly_Distribution * param.d_s) .* param.price_e)' * Bid_R) - ...
     sum(sum(param.hourly_Distribution .* Cost_deg));
 
% 乘以时段长度
Profit = Profit * delta_t;

%% 约束条件

Constraints = [];

% 最初为达到时的电量(第四列) NOFEV，此约束的对偶变量为lambda
Constraints = [Constraints, E(:, 1) == param.E_0];

% 调频容量非负。 NOFSLOTS
Constraints = [Constraints, 0 <= Bid_R];

% 功率响应-各场景平衡 NOFEV * NOFSLOTS * NOFSCEN
temp = repmat(param.d_s', NOFSLOTS, 1, NOFEV);
temp = permute(temp, [3, 1, 2]);

Constraints = [Constraints, 1e3 * repmat(Bid_P', 1, 1, NOFSCEN) + ...
    1e3 * repmat(Bid_R', 1, 1, NOFSCEN) .* temp - (P_dis - P_ch) == 0];
    
% 功率上下限(kW)。 NOFEV * NOFSLOTS * NOFSCEN
Constraints = [Constraints, 0 <= P_dis];
Constraints = [Constraints, 0 <= P_ch];
Constraints = [Constraints, P_dis <= repmat(param.u, 1, 1, NOFSCEN) * param.P_max];
Constraints = [Constraints, P_ch <= repmat(param.u, 1, 1, NOFSCEN) * param.P_max];

% 放电老化($) NOFSLOTS * NOFSCEN
temp = permute(sum(repmat(param.Pr_deg, 1, NOFSLOTS, NOFSCEN) .* P_dis), [2, 3, 1]);% 把EV的功率聚合, 交换行列 
temp = reshape(temp, NOFSLOTS, NOFSCEN);

Constraints = [Constraints, Cost_deg == temp];

% 时段间能量关联(kWh)
% 离开时至少为90%的电量（第五列） NOFEV
Constraints = [Constraints, E(:, end) >= param.E_leave];

% 中间时段的能量在最大、最小之间 NOFEV * NOFSLOTS
Constraints = [Constraints, repmat(param.E_min, 1, NOFSLOTS + 1) <= E];
Constraints = [Constraints, E <= repmat(param.E_max, 1, NOFSLOTS + 1)];

% 调频投标的连续出力约束 NOFSLOTS
Constraints = [Constraints, repmat(param.eta, 1, NOFSLOTS) .* (E(:, 1 : end-1) - repmat(param.E_min, 1, NOFSLOTS)) >= 1e3 * Bid_R' * 0.25 * delta_t + 1e3 * Bid_P' * delta_t];
Constraints = [Constraints, repmat(1 ./ param.eta, 1, NOFSLOTS) .* (- E(:, 1 : end-1) + repmat(param.E_max, 1, NOFSLOTS)) >= 1e3 * Bid_R' * 0.25 * delta_t - 1e3 * Bid_P' * delta_t];

% 前后时段衔接 NOFEV * NOFSLOTS
temp = P_ch .* repmat(param.eta, 1, NOFSLOTS, NOFSCEN) - ...
    P_dis .* repmat(1 ./ param.eta, 1, NOFSLOTS, NOFSCEN);
temp = permute(temp, [3, 2, 1]);% 交换行列
temp = reshape(temp, NOFSCEN, NOFSLOTS * NOFEV);% 功率铺平为 SCEN * (SLOTS * EV)
temp2 = repmat(param.hourly_Distribution', 1, NOFEV);% 分布重复为 SCEN * (SLOTS * EV)
temp = sum(temp .* temp2);% 相乘，并按概率加权相加
temp = reshape(temp, NOFSLOTS, NOFEV)';% 重新写为 SLOTS * EV,并转置为EV * SLOTS

Constraints = [Constraints, E(:, 2 : end) == E(:, 1 : end - 1) + temp * delta_t];

%% 求解solve
ops = sdpsettings('debug',1,'solver','cplex','savesolveroutput',1,'savesolverinput',1);

sol = optimize(Constraints, - Profit, ops);

if sol.problem == 0 % 求解成功
    disp("时段1 :投标完成。")
else 
    disp("时段1 :投标失败。")
end



%% 记录
Bid_R_init = sum(value(Bid_R'));
Bid_P_init = sum(value(Bid_P'));
E_init = value(E);
Bid_R_cur = value(Bid_R(1, :));
Bid_P_cur = value(Bid_P(1, :));
E_cur = value(E(:, 1));


% 用于后续的记录
Bid_R_rev = Bid_R_cur;
Bid_P_rev = Bid_P_cur;
E_rev = E_cur;


