# Monte Carlo Stock Price Prediction (Fortran)

This project uses the **Geometric Brownian Motion (GBM)** model with a **Monte Carlo simulation** to estimate the probability that a stock’s price will increase over one year, based on historical data.

The program reads a CSV file of historical stock prices (e.g. NVidia), calculates the drift (μ) and volatility (σ) from daily *Close* prices, and simulates thousands of possible one-year outcomes.

---

## Theory

The stock price is modeled as a stochastic process following the Geometric Brownian Motion equation:

\[
S_T = S_0 \, e^{(\mu - \frac{1}{2}\sigma^2)T + \sigma \sqrt{T} Z}
\]

Where:  
- **S₀** — current stock price (latest closing price)  
- **Sₜ** — simulated future price  
- **μ** — mean daily return (drift)  
- **σ** — volatility (standard deviation of returns)  
- **T** — time in years (1.0 by default)  
- **Z** — random variable drawn from a standard normal distribution  

The probability that the stock price increases is given by:

\[
P(\text{Price Up}) = \frac{\text{Number of simulations where } S_T > S_0}{N}
\]

---

## Features

- Reads real historical stock data from a CSV file  
- Automatically extracts the “Close” column  
- Calculates drift (μ) and volatility (σ) from log returns  
- Simulates price paths using Monte Carlo GBM  
- Outputs the probability that the price goes up or down after one year  

---

## File Structure

```
.
├── cp_cca.f90                     # Main Fortran source code
├── NVidia_stock_history.csv       # Example stock data
└── README.md                      # Documentation
```

---

## How It Works

1. Reads the “Close” prices from `NVidia_stock_history.csv`  
2. Calculates daily log returns:  
   `r_t = log(S_{t+1}/S_t)`  
3. Computes drift (μ) and volatility (σ)  
4. Simulates future price paths for one year using GBM  
5. Estimates the probability that the price will go up  

---

## Requirements

- **gfortran** (any modern version)
- A CSV file with columns like:  
  `Date,Open,High,Low,Close,Adj Close,Volume`

---

## Usage

**Compile:**
```bash
gfortran cp_cca.f90 -o cp_cca
```

**Run:**
```bash
./cp_cca
```

**Example Output:**
```
-----------------------------------------
Loaded 252 price points from NVidia_stock_history.csv
Estimated mu (drift): 0.000450
Estimated sigma (volatility): 0.023100
Starting Price (last close): 135.64
-----------------------------------------
Probability Price Goes Up:   0.6150
Probability Price Goes Down: 0.3850
-----------------------------------------
```

---

## Adjustable Parameters

Inside the code:
```fortran
integer, parameter :: n_sim = 100000   ! Number of simulations
real(dp) :: T = 1.0_dp                 ! Time horizon (1 year)
```

You can modify `T` to simulate different durations, e.g. 0.5 for half a year or 2.0 for two years.

---

## Future Improvements

- Run simulations for multiple time horizons  
- Plot price distribution using Python or gnuplot  
- Implement variance reduction (antithetic variates)  
- Compare different stocks  
