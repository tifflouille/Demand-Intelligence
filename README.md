# Ecommerce Demand Intelligence

**Using historical demand patterns and forecast uncertainty to plan commercial decisions.**

## Project Overview

This project explores how ecommerce businesses can use historical sales data to better understand demand, identify volatility, and improve commercial planning through forecasting and demand analysis, with questions such as: 

* Where is demand changing?
* Which product categories are stable or highly volatile?
* How predictable is demand?
* Does a forecasting model provide meaningful value compared with a simple baseline?
* How should uncertainty influence commercial planning?

The project combines SQL, Python, exploratory analysis, demand segmentation, forecasting and scenario analysis.

> **Important:** The dataset used in this project is the public Olist Brazilian ecommerce dataset. It shows however how it such methods can be applied to DTC businesses. The project uses ecommerce demand as the analytical context.

## Business Questions

### 1. Demand evolution

Where is ecommerce demand changing, and which changes appear meaningful rather than short-term noise?

### 2. Demand volatility

Which categories have stable versus unpredictable demand, and how should they be treated differently from a planning perspective?

### 3. Forecasting

Can forecasting improve demand planning compared with a simple baseline?

### 4. Commercial decisions

How can demand patterns, volatility and forecast uncertainty be translated into better commercial planning decisions?

## Dataset

The analysis uses the public **Olist Brazilian ecommerce dataset**, including order, order-item and product information.

The project focuses primarily on:

* orders
* products
* order items
* dates
* product categories
* sales quantities
* revenue

The dataset does not provide all of the information required for real inventory optimisation, such as reliable stock levels, stockouts, purchase orders or inventory carrying costs. These limitations are explicitly considered when translating the analysis into commercial recommendations.

## Methodology

The project is structured into four main analytical stages:

1. **Demand analysis**
   Understand demand evolution, trends, seasonality and category concentration.

2. **Demand volatility**
   Compare categories based on demand volume and variability.

3. **Forecasting**
   Evaluate forecasting approaches against a simple baseline using time-based validation.

4. **Scenario analysis**
   Explore how forecast uncertainty could influence commercial planning and prioritisation.

## Tools

* SQL
* Python
* Pandas
* NumPy
* Matplotlib / Seaborn
* Scikit-learn
* [Forecasting library/model — to be determined]

Additional libraries will be added as the analysis develops.

## Project Structure

```text
01_business_context/   → Business questions and assumptions
02_data/               → Data documentation and processed datasets
03_sql/                → Data preparation and demand aggregation
04_python/             → Analysis and forecasting
05_visualisations/     → Exported charts
06_outputs/            → Findings, metrics and model results
07_case_study/         → Final business case study
```

## Key Findings

*To be completed once the analysis is finished.*

## Commercial Implications

*To be completed once the analysis is finished.*

## Limitations

*To be completed once the analysis is finished.*

## Reproducibility

Instructions for reproducing the analysis will be added once the final project structure and dependencies are established.

## Status

**In progress**
