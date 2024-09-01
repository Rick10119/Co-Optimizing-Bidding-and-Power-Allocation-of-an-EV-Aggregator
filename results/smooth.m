%% 按照正（放电）和负（充电）进行划分统计该ev在各个时段的功率情况。

ev_power = P_alloc(:, ev_id);

ev_dis = zeros(NOFSLOTS, 1);
ev_ch = zeros(NOFSLOTS, 1);

for idx = 1 : length(P_unbal)
    if ev_power(idx) > 0
        ev_dis(floor((idx-1)/1800) + 1) = ev_dis(floor((idx-1)/1800) + 1) + ev_power(idx);
    else
        ev_ch(floor((idx-1)/1800) + 1) = ev_ch(floor((idx-1)/1800) + 1) + ev_power(idx);
    end
end

ev_dis = ev_dis / 1800;% 换算为kWh
ev_ch = ev_ch / 1800;

% 计算电量
ev_e = zeros(16, 1);
ev_e(1) = param.E_0(ev_id) - ev_ch(1) * param.eta(ev_id) - ev_dis(1) / param.eta(ev_id);
for hour = 2 : 16
    ev_e(hour) = ev_e(hour - 1) ...
        - ev_ch(hour) * param.eta(ev_id) - ev_dis(hour) / param.eta(ev_id);
end
