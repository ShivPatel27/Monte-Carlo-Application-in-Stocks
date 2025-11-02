📈 Monte Carlo Stock Price Prediction (Fortran)

This project implements a Monte Carlo simulation using the Geometric Brownian Motion (GBM) model to estimate the probability that a stock’s price will increase over one year, based on historical data.

It uses real stock data (for example, NVidia) to calculate drift (μ) and volatility (σ) from the daily Close prices, then simulates thousands of possible one-year outcomes.

🧮 Theory

The model assumes the stock follows Geometric Brownian Motion (GBM):

𝑆
𝑇
=
𝑆
0
 
𝑒
(
𝜇
−
1
2
𝜎
2
)
𝑇
+
𝜎
𝑇
𝑍
S
T
	​

=S
0
	​

e
(μ−
2
1
	​

σ
2
)T+σ
T
	​

Z

where

S₀ – current stock price (latest closing price)

Sₜ – simulated future price

μ – mean return (drift)

σ – standard deviation of returns (volatility)

T – time horizon in years (default 1.0)

Z – random variable ~ Normal(0,1)

After running many simulations, the model estimates the probability that the price will go up:

P(\text{Price Up}) = \frac{\text{# of times } S_T > S_0}{N}
⚙️ Features

Reads a real CSV file of historical stock data (e.g. from Yahoo Finance)

Automatically extracts the “Close” column

Estimates drift (μ) and volatility (σ) from log returns

Runs Monte Carlo simulations using GBM

Prints probabilities of price going up or down after one year

🗂️ File Structure
.
├── gbm_from_csv.f90              # Main Fortran source code
├── NVidia_stock_history.csv      # Example input data (Yahoo Finance format)
└── README.md                     # Project documentation

🧾 How It Works

Reads daily closing prices from NVidia_stock_history.csv

Computes log returns: r_t = log(S_{t+1}/S_t)

Calculates drift (μ) and volatility (σ)

Simulates price paths for 1 year using GBM

Counts how many simulated final prices are greater than the starting price

Outputs probabilities for price increase and decrease

🧰 Requirements

gfortran (any recent version)

Historical stock CSV file with columns like:
Date,Open,High,Low,Close,Adj Close,Volume

🧾 Example Usage

Compile:

gfortran gbm_from_csv.f90 -o gbm_from_csv


Run:

./gbm_from_csv


Example Output:

-----------------------------------------
Loaded 252 price points from NVidia_stock_history.csv
Estimated mu (drift): 0.000450
Estimated sigma (volatility): 0.023100
Starting Price (last close): 135.64
-----------------------------------------
Probability Price Goes Up:   0.6150
Probability Price Goes Down: 0.3850
-----------------------------------------

🧩 Parameters You Can Edit

Inside the code:

integer, parameter :: n_sim = 100000   ! number of Monte Carlo simulations
real(dp) :: T = 1.0_dp                 ! time horizon (1 year)


Change these to simulate different durations or improve accuracy.

📊 Ideas for Extension

Run for multiple time horizons (1 month, 6 months, 1 year)

Plot simulated price distributions using Python or gnuplot

Add variance reduction techniques (antithetic variates)

Compare results for different stocks




