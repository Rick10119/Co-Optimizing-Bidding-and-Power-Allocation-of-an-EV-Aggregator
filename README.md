# lyu_co-optimizing_2023_tsg
Data and code for my paper "Co-Optimizing Bidding and Power Allocation of an EV Aggregator Providing Real-Time Frequency Regulation Service."

Citation: R. Lyu, H. Guo, K. Zheng, M. Sun, and Q. Chen, "Co-Optimizing Bidding and Power Allocation of an EV Aggregator Providing Real-Time Frequency Regulation Service," in IEEE Transactions on Smart Grid, vol. 14, no. 6, pp. 4594-4606, Nov. 2023, doi: 10.1109/TSG.2023.3252664.

### 项目简介

这个GitHub仓库包含了与论文相关的代码，旨在提供编程思路和参考代码，以便解决问题或比较方法。请注意，这些代码主要作为参考，而不是一键运行并获得与论文完全相同的结果。仓库将会持续更新，而论文则不会。

### Introduction

This GitHub repository contains code related to the paper, aimed at providing programming insights and reference code for problem-solving or method comparison. Please note that these codes are primarily for reference and not intended to be run as-is to reproduce the exact results from the paper. The repository will be continuously updated, unlike the static nature of the paper.

### 主要测试部分

在 `co-optimizing_bid_power-allocation` 文件夹中，您可以找到以下主要测试部分：

- `main`: 主程序（投标 - 功率控制）。
- `maxProfit_1`: 前一天的最优投标程序。
- `maxProfit_t`: 实时最优投标程序（在某小时中间）。
- `minCostAllocation`: 最优分解问题。

这些测试部分提供了基本的演示，一旦您安装好环境，即可运行并了解基本场景。

### Main Testing Sections

In the `co-optimizing_bid_power-allocation` folder, you can find the following main testing sections:

- `main`: Main program (bidding - power control).
- `maxProfit_1`: Optimal bidding program for the previous day.
- `maxProfit_t`: Real-time optimal bidding program (in the middle of a certain hour).
- `minCostAllocation`: Optimal decomposition problem.

These testing sections offer a basic demo that can be run once you have set up the environment.

### 如何使用

1. 克隆或下载本仓库到您的本地环境。
2. 安装 MATLAB、YALMIP 和 CPLEX 或 Gurobi。
3. 在 `co-optimizing_bid_power-allocation` 文件夹中运行相应的测试部分以了解代码功能和思路。

### How to Use

1. Clone or download this repository to your local environment.
2. Install MATLAB, YALMIP, and CPLEX or Gurobi.
3. Run the relevant testing sections in the `co-optimizing_bid_power-allocation` folder to understand the code functionality and approach.
