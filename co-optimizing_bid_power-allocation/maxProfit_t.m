%% 计算下一时段投标问题中，电池电量的影子价格，用于当前时段进行分配

% 用于：更新下一时段投标量、更新拉格朗日乘子

% 输入：各时段能量、调频市场价格；电动汽车到达、离开的时段、电量；当前时段时刻t_cap; 当前时段的投标量
% 输入：当前各电池电量；
% 初值： 上一时段投标时，各时段的投标量。
% 输出:  未来各时段投标量、电池电量。未来一个时段L乘子

%% 参数设定

% 更多：见 data_prepare.m

% 当前时段编号 CUR_SLOT
CUR_SLOT = ceil(t_cap / 1800); % 2s一个，除以1800向上取整，为当前时段编号
% 剩下时段数量
REST_SLOTS = NOFSLOTS - CUR_SLOT;

%% 变量
% 投标容量：能量、调频(MW), 从t + 1到T, 其中t + 1为第一个entry
Bid_P = sdpvar(REST_SLOTS, 1, 'full'); 
Bid_R = sdpvar(REST_SLOTS, 1, 'full'); 

% 辅助变量
P_dis = sdpvar(NOFEV, REST_SLOTS + 1, NOFSCEN, 'full'); % EV在各场景放电功率(kW),当前时段剩下时间仍然要分配，因此多一个时段维度
P_ch = sdpvar(NOFEV, REST_SLOTS + 1, NOFSCEN, 'full'); % EV在各场景充电功率(kW),当前时段剩下时间仍然要分配，因此多一个时段维度
E = sdpvar(NOFEV, REST_SLOTS + 2, 'full'); % EV在各时段之初的电池能量(kWh)。包括当前时刻、离开时刻，因此多2个维度
Cost_perf = sdpvar(REST_SLOTS + 1, NOFSCEN, 'full'); % 未来各时段各场景的性能成本($/h)

%% 目标函数
% 能量收益、调频容量收益、调频里程收益、部署成本、性能成本
Profit = param.price_e(CUR_SLOT + 1 : end)' * Bid_P + param.price_reg(CUR_SLOT + 1 : end, 1)' * Bid_R * param.s_perf + ...
    (param.price_reg(CUR_SLOT + 1 : end, 2) .* param.hourly_Mileage(CUR_SLOT + 1 : end))' * Bid_R * param.s_perf + ...
    ((param.hourly_Distribution(CUR_SLOT + 1 : end, :) * param.d_s) .* param.price_e(CUR_SLOT + 1 : end))' * Bid_R - ...
    sum(sum(param.hourly_Distribution(CUR_SLOT + 1 : end, :) .* Cost_perf(2 : end, :)));

% 乘以时段长度
Profit = Profit * delta_t;

% 补上当前时段的成本
Profit = Profit - ((param.hourly_Distribution(CUR_SLOT, :) * param.d_s) .* param.price_e(CUR_SLOT))' * Bid_R_cur * delta_t_rest - ...
    sum(sum(param.hourly_Distribution(CUR_SLOT, :) .* Cost_perf(1, :))) * delta_t_rest;

%% 约束条件

Constraints = [];

% 当前电量，由此推出L乘子
Constraints = [Constraints, E_cur - E(:, 1) == 0];

% 调频容量非负。 NOFSLOTS
Constraints = [Constraints, 0 <= Bid_R];

% 功率响应-各场景平衡(拉满只有容量的一半)。 REST_SLOTS + 1 * NOFSCEN
temp = permute(sum(P_dis - P_ch), [2, 3, 1]); % 把EV的功率聚合
temp = reshape(temp, REST_SLOTS + 1, NOFSCEN);

Constraints = [Constraints, 1e3 * repmat(Bid_P, 1, NOFSCEN) + ...
    1e3 * repmat(Bid_R, 1, NOFSCEN) .* repmat(param.d_s', REST_SLOTS, 1) - temp(2 : end, :) == 0]; % 未来各时段
Constraints = [Constraints, 1e3 * repmat(Bid_P_cur, 1, NOFSCEN) + ...
    1e3 * repmat(Bid_R_cur, 1, NOFSCEN) .* param.d_s' - temp(1, :) == 0]; % 当前时段

% 功率上下限(kW). NOFEV * NOFSLOTS * NOFSCEN
Constraints = [Constraints, 0 <= P_dis];
Constraints = [Constraints, 0 <= P_ch];
Constraints = [Constraints, P_dis(:, 2 : end, :) <= repmat(param.u(:, CUR_SLOT + 1 : end), 1, 1, NOFSCEN) * param.P_max];
Constraints = [Constraints, P_ch(:, 2 : end, :) <= repmat(param.u(:, CUR_SLOT + 1 : end), 1, 1, NOFSCEN) * param.P_max];
Constraints = [Constraints, P_dis(:, 1, :) <= (1 + 1e-4) * repmat(param.u(:, CUR_SLOT), 1, 1, NOFSCEN) * param.P_max]; % 避免数值问题
Constraints = [Constraints, P_ch(:, 1, :) <= (1 + 1e-4) * repmat(param.u(:, CUR_SLOT), 1, 1, NOFSCEN) * param.P_max];

% 放电老化($/h). REST_SLOTS + 1 * NOFSCEN
temp = permute(sum(repmat(param.Pr_deg, 1, REST_SLOTS + 1, NOFSCEN) .* P_dis), [2, 3, 1]); % 把EV的功率聚合, 交换行列
temp = reshape(temp, REST_SLOTS + 1, NOFSCEN);

Constraints = [Constraints, Cost_perf == temp];

% 时段间能量关联(kWh)

% 离开时至少为90%的电量（第五列） NOFEV
Constraints = [Constraints, E(:, end) >= param.E_leave];

% 中间时段的能量在10~60之间 NOFEV * REST_SLOTS + 2
Constraints = [Constraints, repmat(param.E_min, 1, REST_SLOTS + 2) <= E];
Constraints = [Constraints, E <= repmat(param.E_max, 1, REST_SLOTS + 2)];

% 调频投标的连续出力约束 REST_SLOTS, 从t+1（2）开始
Constraints = [Constraints, param.eta' * (E(:, 2 : end - 1) - repmat(param.E_min, 1, REST_SLOTS)) >= 1e3 * Bid_R' * 0.25 * delta_t + 1e3 * Bid_P' * delta_t];
Constraints = [Constraints, (1 ./ param.eta)' * (- E(:, 2 : end - 1) + repmat(param.E_max, 1, REST_SLOTS)) >= 1e3 * Bid_R' * 0.25 * delta_t - 1e3 * Bid_P' * delta_t];

% 前后时段衔接 NOFEV * REST_SLOTS + 1
temp = P_ch .* repmat(param.eta, 1, REST_SLOTS + 1, NOFSCEN) - ...
    P_dis .* repmat(1 ./ param.eta, 1, REST_SLOTS + 1, NOFSCEN);
temp = permute(temp, [3, 2, 1]); % 交换行列
temp = reshape(temp, NOFSCEN, (REST_SLOTS + 1) * NOFEV); % 功率铺平为 SCEN * (SLOTS * EV)
temp2 = repmat(param.hourly_Distribution(CUR_SLOT : end, :)', 1, NOFEV); % 分布重复为 SCEN * (SLOTS + 1 * EV)
temp = sum(temp .* temp2); % 相乘，并按概率加权相加
temp = reshape(temp, REST_SLOTS + 1, NOFEV)'; % 重新写为 SLOTS + 1 * EV,并转置为EV * SLOTS + 1

Constraints = [Constraints, E(:, 3 : end) == E(:, 2 : end - 1) + temp(:, 2 : end) * delta_t]; % 未来时段
Constraints = [Constraints, E(:, 2) == E(:, 1) + temp(:, 1) * delta_t_rest]; % 未来时段

%% 求解solve
ops = sdpsettings('debug', 0, 'solver', 'cplex', 'savesolveroutput', 1, 'savesolverinput', 1);

sol = optimize(Constraints, -Profit, ops);

if sol.problem == 0 || sol.problem == 4 % 求解成功
    disp(" 时段" + (CUR_SLOT + 1) + " :投标完成。")
else
    disp("时段" + (CUR_SLOT + 1) + " :投标优化失败。")
end
