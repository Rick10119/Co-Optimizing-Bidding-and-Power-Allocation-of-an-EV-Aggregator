% ׼������
M = 1e3;
if ~ exist('param')
    cd ../data_prepare
    data_prepare_main;
    cd ../proportional_alloc
end

% ���²���
NOFTCAP = 900;
P_alloc = [];
P_unbal = [];
actualMil = zeros(NOFSLOTS, 1);
actualEnergy = zeros(NOFSLOTS, 1);
actualCost = zeros(NOFSLOTS, 1);

% ��ʼʱ��
warning('off')
t_cap = 0;
maxProfit_1;

% �м�ʱ��
for t_cap = 1 : (NOFSLOTS - 1) * 1800
    
    if mod(t_cap, 1800) == 0 % ʱ��ĩβ��������һʱ��Ͷ�꣬�����Ӳ�����
        delta_t_rest = 0;
        maxProfit_t;
        Bid_P_cur = value(Bid_P(1, :));
        Bid_R_cur = value(Bid_R(1, :));
        Bid_R_rev = [Bid_R_rev; Bid_R_cur];
        Bid_P_rev = [Bid_P_rev; Bid_P_cur];
        E_rev = [E_rev, E_cur];
        
    else
        if mod(t_cap, 900) == 1 % ʱ�γ����м�������³��Ӳ����书�ʣ��������µ�ǰʱ��Ͷ��
            delta_t_rest = delta_t - mod(t_cap - 1, 1800) / 1800;% ��ǰʱ��ʣ��ʱ��
            maxProfit_t;
            proportionalAllocation;% ���ʷ���
        end
    end
end

% ���һ��ʱ�Σ�������Ͷ��
for t_cap = (NOFSLOTS - 1) * 1800 + 1 : NOFSLOTS * 1800 - 1
    if mod(t_cap, 900) == 1 % ʱ�γ����м�������书��
        proportionalAllocation;% ���ʷ���
    end
end

E_rev = [E_rev, E_cur];

%��������
cal_profit;

save("../results/result_proportional.mat", "actualProfit","actualCost", ...
    "Bid_P_rev","Bid_R_rev","Bid_P_init","Bid_R_init", ...
    "actualEnergy","actualMil","P_alloc","P_unbal");
