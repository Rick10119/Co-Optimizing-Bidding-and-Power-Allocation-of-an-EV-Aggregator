%% 准备问题参数(包括EV参数、市场价格、RegD信号）
param = {}; % Initialize the parameter structure

%

%% 读取RegD信号数据
% 时段数量，24小时。但我们只取16个小时。
NOFSLOTS = 16;

% 选择日期为7月17日-18日
if ~exist('day_price')
    day_price = 27; % Corresponding price: May 20th
    day_reg = day_price; % Frequency regulation signal: July 17th, 2020
end

hour_init = 18; % Starting from 18:00-19:00 (the original 19th slot)

% 从excel读取RegD信号数据
filename = '07 2020.xlsx';
sheet = 'Dynamic'; % Specify the sheet
xlRange = 'B2:AF43202'; % Range

% 读取7月份所有信号数据，2s一个点 * 31d
Signals = xlsread(filename, sheet, xlRange);

% 数据清理，排除超出【-1， 1】的数据
Signals(Signals < -1) = -1;
Signals(Signals > 1) = 1;

% 处理RegD数据，给出其逐小时的分布
data_handle_regd;

%% EV参数
% 读取EV到达数据
data_generate_ev;

param.EV_arrive_leave = EV_arrive_leave;

% EV数量
NOFEV = length(param.EV_arrive_leave);
% 场景数量
NOFSCEN = length(param.hourly_Distribution(1, :));

% 调频性能
param.s_perf = 0.984;% 参考PJM教程设定的固定值
% 最大功率(kW)，容量上下限(kWh)
param.P_max = 7.68;

for idx = 1 : NOFEV
    switch mod(idx, 3)
        case 1
            % 充放电效率
            param.eta(idx) = 0.95;
            % 最大功率(kW)，容量上下限(kWh)
            param.E_max(idx) = 90;
            % 放电老化成本($/kWh)
            param.Pr_deg(idx) = 0.1;
        case 2
            % 充放电效率
            param.eta(idx) = 0.92;
            % 最大功率(kW)，容量上下限(kWh)
            param.E_max(idx) = 60;
            % 放电老化成本($/kWh)
            param.Pr_deg(idx) = 0.15;
        case 0
            % 充放电效率
            param.eta(idx) = 0.90;
            % 最大功率(kW)，容量上下限(kWh)
            param.E_max(idx) = 36;
            % 放电老化成本($/kWh)
            param.Pr_deg(idx) = 0.2;
    end
end
param.Pr_deg = param.Pr_deg';
param.eta = param.eta';
param.E_max = param.E_max';
param.E_0 = param.E_max / 3;
param.E_min = param.E_max / 6;
param.E_leave = param.E_max * 0.9;

% 插电状态 u
u = zeros(NOFEV, NOFSLOTS);
for idx = 1 : NOFEV
    for jdx = 1 : NOFSLOTS
        if param.EV_arrive_leave(idx, 2) <= jdx && jdx <= param.EV_arrive_leave(idx, 3)
            u(idx, jdx) = 1;
        end
    end
end
param.u = u;
clear u;

%% 市场价格和其他参数
% 时段长度，1小时
delta_t = 1;

% 读取调频市场价格数据
filename = 'regulation_market_results.xlsx';
sheet = 'regulation_market_results'; % Specify the sheet
start_row = (day_price-1) * 24 + hour_init + 2; % Starting row
xlRange = "G" + start_row + ":H" + (start_row + NOFSLOTS - 1); % Range
param.price_reg = xlsread(filename, sheet, xlRange); % Capacity price, mileage price

% 读取系统能量价格数据
filename = 'rt_hrl_lmps.xlsx';
sheet = 'rt_hrl_lmps'; % Specify the sheet
xlRange = "I" + start_row + ":I" + (start_row + NOFSLOTS - 1); % Range
param.price_e = xlsread(filename, sheet, xlRange); % Capacity price, mileage price

clear price filename sheet xlRange start_row signal_length i idx jdx EV_arrive_leave
