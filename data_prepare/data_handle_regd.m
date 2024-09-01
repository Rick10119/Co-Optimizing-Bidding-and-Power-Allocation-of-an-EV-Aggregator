%% ����ԭʼ���ź�����
% ����0.1�ֱ������regd�źŷֲ�
diff = 0.1;% �ֱ��

% �ӵ�һ�������18:00��ʼ,���ڶ����18:00�����������Ͷ����ˡ�
Signals = [Signals(hour_init * 1800 + 1 : end, 1 : end - 1); Signals(1 : hour_init * 1800, 2 : end)];

nofHisDays = 14; % ��ȥ14����ʷ��������Ԥ��
signal_length = 43202 - 2; % (ȥ����β����24*1800)

% 17-18���賿�������ڷ���
Signal_day = Signals(:, day_reg);

% ÿ��Сʱһ���ֲ�
hourly_Distribution = [];
hourly_Mileage = [];

for hour = 1 : 24
    
    Distributions = [];
    
    for day_idx = day_reg - nofHisDays : day_reg - 1 % ��ȥ14������
        signals = Signals(1 : end - 1, day_idx); % ȡ����
        
        Distribution = zeros(2 / diff + 2, 1); % ��ʼ������ɢ��df����������-1��1
        % ��Ŵ�1~22��-1~1
        
        % ɨ�裬�õ�pdf
        for t_cap = 1 + (hour - 1) * 1800 : hour * 1800
            if signals(t_cap) >= 0 % ���ϵ�Ƶ
                s_idx = ceil(signals(t_cap) / diff) + 1 / diff + 1; % �������
                if signals(t_cap) > 0.9999 % ����1����
                    s_idx = length(Distribution);
                end
            else
                s_idx = floor(signals(t_cap) / diff) + 1 / diff + 2; % �������
                if signals(t_cap) < - 0.9999 % ����1����
                    s_idx = 1;
                end
            end
            Distribution(s_idx) = Distribution(s_idx) + 1;
        end
        
        % ����Ƶ��
        Distribution = Distribution / sum(Distribution);
        
        Distributions = [Distributions, Distribution];
        
        % plot(Distribution);hold on;
        % plot(test);
    end
    
    Distribution = Distributions * 1/nofHisDays * ones(nofHisDays, 1);
    hourly_Distribution = [hourly_Distribution, Distribution];
    %% ������ʷ���
    
    Mileage = [];
    for day_idx = day_reg - nofHisDays : day_reg - 1 % ��ȥ���ܵ�����
        
        % ȡ���У�һ�죩
        signals = Signals(1 + (hour - 1) * 1800 : hour * 1800, day_idx);
        
        % �������Сʱ�����
        mileage = sum(abs(signals(2 : end) - signals(1 : end - 1)));
        
        Mileage = [Mileage, mileage];
    end
    
    Mileage =  Mileage * 1/nofHisDays * ones(nofHisDays, 1);
    
    hourly_Mileage = [hourly_Mileage, Mileage];
    
end

%% �У���ͬ���䣻�У���ͬʱ�̣�
param.hourly_Mileage = hourly_Mileage';
param.hourly_Distribution = hourly_Distribution';
param.d_s = [-1; (-1 + 0.5 * diff : diff : 1 - 0.5 * diff)'; 1]; % ���������ź�ƽ��ֵ����������Ϊ��λ1

% ֻȡ16��Сʱ
param.hourly_Mileage = param.hourly_Mileage(1 : NOFSLOTS, :);
param.hourly_Distribution = param.hourly_Distribution(1 : NOFSLOTS, :);

clear Mileage mileage signals Distributions Distribution hourly_Distribution hourly_Mileage nofHisDays
clear col s_idx Signals
clear filename hour sheet t_cap xlRange day_idx
% clear diff
