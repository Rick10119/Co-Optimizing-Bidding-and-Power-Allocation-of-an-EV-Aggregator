%% 从excel读取EV到达时间，并设置电池相关的其他参数
% Read EV arrival time from Excel and set other parameters related to the battery

filename = 'EV_arrive_leave.xlsx';
sheet = 'EV_arrive_leave'; % 所在表单 Specify the sheet
xlRange = 'A2:C4013'; % 范围 Range

EV_arrive_leave = xlsread(filename, sheet, xlRange); % EV编号， 达到时段， 离开时段 EV number, arrival period, departure period
% 改变车辆数量 4012 => 400，因为不需要那么多
% Change the number of vehicles from 4012 to 400, as not all are needed
EV_arrive_leave = EV_arrive_leave(1:10:end, :);

% 改变到达和离开时间(第二列)，因为原始数据是15min粒度，这里是小时粒度
% Change arrival and departure times (second column) from 15-minute granularity to hourly granularity
col = 2;
for i = 1:length(EV_arrive_leave)
    if EV_arrive_leave(i, col) ~= 1
        EV_arrive_leave(i, col) = ceil(EV_arrive_leave(i, col) / 4) + 2; % 到达时间，向上取整 Arrival time: rounded up
    end
    if EV_arrive_leave(i, col + 1) < 57
        EV_arrive_leave(i, col + 1) = floor((EV_arrive_leave(i, col + 1)) / 4) + 1; %离开时间：向下取整 Departure time: rounded down
    end
    if EV_arrive_leave(i, col + 1) == 57
        EV_arrive_leave(i, col + 1) = 16;
    end
end
