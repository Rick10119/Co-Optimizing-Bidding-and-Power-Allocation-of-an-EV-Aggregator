%% 处理原始的信号数据
% 按照0.1分辨度整理regd信号分布
diff = 0.1;% 分辨度

% 从第一天的下午18:00开始,到第二天的18:00结束。这样就对上了。
Signals = [Signals(hour_init * 1800 + 1 : end, 1 : end - 1); Signals(1 : hour_init * 1800, 2 : end)];

nofHisDays = 14; % 过去14天历史数据用于预测
signal_length = 43202 - 2; % (去除首尾，共24*1800)

% 17-18日凌晨数据用于仿真
Signal_day = Signals(:, day_reg);

% 每个小时一个分布
hourly_Distribution = [];
hourly_Mileage = [];

for hour = 1 : 24
    
    Distributions = [];
    
    for day_idx = day_reg - nofHisDays : day_reg - 1 % 过去14天数据
        signals = Signals(1 : end - 1, day_idx); % 取出列
        
        Distribution = zeros(2 / diff + 2, 1); % 初始化，离散化df，单独考虑-1和1
        % 编号从1~22：-1~1
        
        % 扫描，得到pdf
        for t_cap = 1 + (hour - 1) * 1800 : hour * 1800
            if signals(t_cap) >= 0 % 向上调频
                s_idx = ceil(signals(t_cap) / diff) + 1 / diff + 1; % 场景编号
                if signals(t_cap) > 0.9999 % 当作1计算
                    s_idx = length(Distribution);
                end
            else
                s_idx = floor(signals(t_cap) / diff) + 1 / diff + 2; % 场景编号
                if signals(t_cap) < - 0.9999 % 当作1计算
                    s_idx = 1;
                end
            end
            Distribution(s_idx) = Distribution(s_idx) + 1;
        end
        
        % 计算频率
        Distribution = Distribution / sum(Distribution);
        
        Distributions = [Distributions, Distribution];
        
        % plot(Distribution);hold on;
        % plot(test);
    end
    
    Distribution = Distributions * 1/nofHisDays * ones(nofHisDays, 1);
    hourly_Distribution = [hourly_Distribution, Distribution];
    %% 计算历史里程
    
    Mileage = [];
    for day_idx = day_reg - nofHisDays : day_reg - 1 % 过去两周的数据
        
        % 取出列（一天）
        signals = Signals(1 + (hour - 1) * 1800 : hour * 1800, day_idx);
        
        % 计算这个小时的里程
        mileage = sum(abs(signals(2 : end) - signals(1 : end - 1)));
        
        Mileage = [Mileage, mileage];
    end
    
    Mileage =  Mileage * 1/nofHisDays * ones(nofHisDays, 1);
    
    hourly_Mileage = [hourly_Mileage, Mileage];
    
end

%% 行：不同区间；列（不同时刻）
param.hourly_Mileage = hourly_Mileage';
param.hourly_Distribution = hourly_Distribution';
param.d_s = [-1; (-1 + 0.5 * diff : diff : 1 - 0.5 * diff)'; 1]; % 各场景的信号平均值，以容量作为单位1

% 只取16个小时
param.hourly_Mileage = param.hourly_Mileage(1 : NOFSLOTS, :);
param.hourly_Distribution = param.hourly_Distribution(1 : NOFSLOTS, :);

clear Mileage mileage signals Distributions Distribution hourly_Distribution hourly_Mileage nofHisDays
clear col s_idx Signals
clear filename hour sheet t_cap xlRange day_idx
% clear diff
