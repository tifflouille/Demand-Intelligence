import pandas as pd 
import numpy as np

monthly_demand = pd.read_csv("monthly_demand.csv")
category_month_demand = pd.read_csv("category_month_demand.csv")
product_month_demand = pd.read_csv("product_month_demand.csv")

print(monthly_demand.head())
print(category_month_demand.head())
print(product_month_demand.head())

print(monthly_demand.shape)
print(category_month_demand.shape)
print(product_month_demand.shape)

#Checking each csv
print("\n--- MONTHLY DEMAND ---")
print(monthly_demand.info())
print(monthly_demand.head())
print(monthly_demand.isna().sum())
print(monthly_demand.duplicated().sum())    

print("\n--- CATEGORY MONTH DEMAND ---")
print(category_month_demand.info())
print(category_month_demand.head())
print(category_month_demand.isna().sum())
print(category_month_demand.duplicated().sum()) 

print("\n--- PRODUCT MONTH DEMAND ---")
print(product_month_demand.info())
print(product_month_demand.head())
print(product_month_demand.isna().sum())
print(product_month_demand.duplicated().sum())  

# Convert month columns to datetime
monthly_demand["month"] = pd.to_datetime(monthly_demand["month"])
category_month_demand["month"] = pd.to_datetime(category_month_demand["month"])
product_month_demand["month"] = pd.to_datetime(product_month_demand["month"])

#Checking the date ranges 
print("\n--- DATE RANGES ---")

print(
    "Monthly:",
    monthly_demand["month"].min(),
    "to",
    monthly_demand["month"].max()
)

print(
    "Category:",
    category_month_demand["month"].min(),
    "to",
    category_month_demand["month"].max()
)

print(
    "Product:",
    product_month_demand["month"].min(),
    "to",
    product_month_demand["month"].max()
)

#Checking how many months are in each dataset
print("\n--- UNIQUE MONTHS ---")

print("Monthly:", monthly_demand["month"].nunique())
print("Category:", category_month_demand["month"].nunique())
print("Product:", product_month_demand["month"].nunique())

#Checking if there's any duplicate rows in the datasets
print("\n--- DUPLICATES ---")

print("Monthly:", monthly_demand.duplicated().sum())

print(
    "Category-month:",
    category_month_demand.duplicated(
        subset=["month", "category"]
    ).sum()
)

print(
    "Product-month:",
    product_month_demand.duplicated(
        subset=["month", "product_id"]
    ).sum()
)

#Checking missing months
print("\n--- MISSING MONTHS ---")

all_months = pd.date_range(
    start=monthly_demand["month"].min(),
    end=monthly_demand["month"].max(),
    freq="MS"
)

missing_months = all_months.difference(monthly_demand["month"])

print(missing_months)

#Reconciliation of monthly demand with category and product level data
print("\n--- CATEGORY RECONCILIATION ---")

category_totals = (
    category_month_demand
    .groupby("month")[["items_sold", "revenue", "orders"]]
    .sum()
    .reset_index()
)

check = monthly_demand.merge(
    category_totals,
    on="month",
    suffixes=("_monthly", "_category")
)

check["items_diff"] = check["items_sold_monthly"] - check["items_sold_category"]
check["revenue_diff"] = check["revenue_monthly"] - check["revenue_category"]
check["orders_diff"] = check["orders_monthly"] - check["orders_category"]

print(check[["month", "items_diff", "revenue_diff", "orders_diff"]])

#Reconciliation of monthly demand with product level data
print("\n--- PRODUCT RECONCILIATION ---")

product_totals = (
    product_month_demand
    .groupby("month")[["items_sold", "revenue"]]
    .sum()
    .reset_index()
)

product_check = monthly_demand.merge(
    product_totals,
    on="month",
    suffixes=("_monthly", "_product")
)

product_check["items_diff"] = (
    product_check["items_sold_monthly"]
    - product_check["items_sold_product"]
)

product_check["revenue_diff"] = (
    product_check["revenue_monthly"]
    - product_check["revenue_product"]
)

print(product_check[["month", "items_diff", "revenue_diff"]])

#Checking for missing categories in the category_month_demand dataset
print("\n--- MISSING CATEGORIES ---")

null_category_rows = category_month_demand["category"].isna().sum()
null_category_items = category_month_demand.loc[
    category_month_demand["category"].isna(), "items_sold"
].sum()
null_category_revenue = category_month_demand.loc[
    category_month_demand["category"].isna(), "revenue"
].sum()

print("Rows:", null_category_rows)
print("Items sold:", null_category_items)
print("Revenue:", null_category_revenue)
