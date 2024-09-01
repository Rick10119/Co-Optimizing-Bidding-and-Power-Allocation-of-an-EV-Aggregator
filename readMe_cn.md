### 说明文档

**开始之前:**

为了运行程序，您需要安装 MATLAB + YALMIP + CPLEX。
在 `co-optimizing_bid_power-allocation` 文件夹中运行 `main` 即可获得最基础的结果。
如果 MATLAB 版本过高可能导致崩溃，您需要使用 Gurobi。请将以下代码修改为：
```matlab
ops = sdpsettings('debug',0,'solver','cplex','savesolveroutput',1,'savesolverinput',1);
```
改为：
```matlab
ops = sdpsettings('debug',0,'solver','gurobi','savesolveroutput',1,'savesolverinput',1);
```

**data_prepare:** 从原始数据中读取参数，并构建所需的参数矩阵（`param`）。
- `07 2020.xlsx`: PJM 2020年7月的 RegD 信号。
- `rt_hrl_lmps.xlsx`: PJM 市场数据：实时逐小时节点电价（来自 PJM 官网）。
- `regulation_market_results.xlsx`: PJM 市场数据：逐小时调频市场价格（来自 PJM 官网）。
- `EV_arrive_leave.xlsx`: 电动汽车到达数据（4000辆），来自 Li_Emission-Concerne_2013。
- `data_prepare_main`: 数据准备主程序。
- `data_generate_ev`: 准备 EV 参数**。
- `data_handle_regd`: 准备 RegD 信号和预测的分布**。

**co-optimizing_bid_power-allocation:** 主要程序。
- `main`: 主程序（投标 - 功率控制）**。
- `maxProfit_1`: 前一天的最优投标程序**。
- `maxProfit_t`: 实时最优投标程序（在某小时中间）**。
- `minCostAllocation`: 最优分解问题。

**proportional_alloc:** 对比现有文献中的一些方法（包括投标和功率分配）。具体细节请参考我们的论文。命名方式与我们的方法类似，因为并非我们提出的，所以仅供参考，没有详细解释。

**results:** 运行结果以 .mat 格式存储，相关可视化文件已省略。

对于基础认识，请关注标有 ** 的程序，了解：
1. 参数的确定（`param`）。
2. 最优投标程序和最优分解算法（`maxProfit_1`、`maxProfit_t`、`minCostAllocation`）。
3. 参与市场的整个流程（`main`）。