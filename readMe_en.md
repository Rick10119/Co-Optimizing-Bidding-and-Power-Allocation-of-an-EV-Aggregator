### ReadMe

Before getting started:

To run the program, you need MATLAB + YALMIP + CPLEX.
Run `main` in `co-optimizing_bid_power-allocation` to obtain the most basic results.
If the MATLAB version is too high and may cause crashes, you need to use Gurobi. Change:
```matlab
ops = sdpsettings('debug',0,'solver','cplex','savesolveroutput',1,'savesolverinput',1);
```
to:
```matlab
ops = sdpsettings('debug',0,'solver','gurobi','savesolveroutput',1,'savesolverinput',1);
```

The entire code comments are mainly written in Chinese. Only the English explanations of the files are provided in the ReadMe. If you need to delve into each line of code, you can use GPT to translate the comments.

- `data_prepare`: Reads parameters from raw data and constructs the required parameter matrix (`param`).
    - `07 2020.xlsx`: PJM's RegD signal for July 2020.
    - `rt_hrl_lmps.xlsx`: PJM market data: real-time hourly nodal prices (from the PJM official website).
    - `regulation_market_results.xlsx`: PJM market data: hourly regulation market prices (from the PJM official website).
    - `EV_arrive_leave.xlsx`: Data for EV arrivals (4000 vehicles), from Li_Emission-Concerne_2013.
    - `data_prepare_main`: Main data preparation program.
    - `data_generate_ev`: Prepares EV parameters**.
    - `data_handle_regd`: Prepares RegD signal and predicted distribution**.

- `co-optimizing_bid_power-allocation`: Main program.
    - `main`: Main program (bidding - power control)**.
    - `maxProfit_1`: Optimal bidding program for the previous day**.
    - `maxProfit_t`: Real-time optimal bidding program (in the middle of a certain hour)**.
    - `minCostAllocation`: Optimal decomposition problem.

- `proportional_alloc`: Some methods from existing literature for comparison (including bidding and power allocation). Details can be found in our paper. The naming is similar to our method, as it is not proposed by us, it is only included here for reference without detailed explanation.

- `results`: Results of the runs, stored in .mat format, visualization files are omitted.

For a basic understanding, focus on the programs marked with **, to understand:
1. Determining parameters (`param`).
2. Optimal bidding programs and optimal decomposition algorithms (`maxProfit_1`, `maxProfit_t`, `minCostAllocation`).
3. The entire process of participating in the market (`main`).