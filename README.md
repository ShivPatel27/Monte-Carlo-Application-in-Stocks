📈 Monte Carlo Stock Price Prediction (Fortran)

This project implements a Monte Carlo simulation using the Geometric Brownian Motion (GBM) model to estimate the probability that a stock’s price will increase over one year, based on historical data.

It uses real stock data (e.g. NVidia) to calculate drift (μ) and volatility (σ) from the daily Close prices, then simulates thousands of possible one-year outcomes.

🧮 Theory

The model assumes the stock follows Geometric Brownian Motion:

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

𝑆
0
S
0
	​

: current stock price (latest closing price)

𝑆
𝑇
S
T
	​

: simulated future price

𝜇
μ: mean return (drift)

𝜎
σ: standard deviation of returns (volatility)

𝑇
T: time horizon in years (default 1.0)

𝑍
Z: random variable ~ Normal(0,1)

After running many simulations, the model estimates:

P(\text{Price Up}) = \frac{\text{# of times } S_T > S_0}{N}
⚙️ Features

Reads a real CSV file of historical stock data (from Yahoo Finance or similar)

Automatically extracts the “Close” column

Estimates drift (μ) and volatility (σ) from log returns

Runs Monte Carlo simulation with configurable number of trials

Outputs probabilities that the stock will rise or fall after one year
