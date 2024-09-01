%% 记录结果+更新电量

E_cur = value(E_cap(:, end));

P_alloc = [P_alloc; value(P_dis_s -P_ch_s)'];

P_unbal = [P_unbal; value(delta_P_dis' - delta_P_ch')];

% 记录成本(仅有老化成本)
actualCost(CUR_SLOT) = actualCost(CUR_SLOT) + sum(param.Pr_deg' * value(P_dis_s)) * delta_t / 1800;

% 记录里程(MW)
P_total = sum(value(P_dis_s -P_ch_s))';% 集群与电网交换的功率
actualMil(CUR_SLOT) = actualMil(CUR_SLOT) + 1e-3 * sum(abs(P_total(2 : end) - P_total(1 : end - 1)));

% 记录真实能量(WMh)
actualEnergy(CUR_SLOT) = actualEnergy(CUR_SLOT) + 1e-3 * sum(P_total) * delta_t / 1800;
