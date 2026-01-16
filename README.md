# Sales & Revenue Performance Analysis — Olist (Kaggle)

## What this project answers
1. **Revenue trend:** How does revenue change month-to-month?
2. **Growth drivers:** Which categories and states contribute most to revenue?
3. **Order economics:** What is AOV and how does it trend?
4. **Customer value:** Who are the top customers by total revenue?

## Dataset
Source: Kaggle — Brazilian E-Commerce Public Dataset by Olist  
Files expected (already included in your download):
- `olist_orders_dataset.csv`
- `olist_order_items_dataset.csv`
- `olist_customers_dataset.csv`
- `olist_order_payments_dataset.csv`
- `olist_products_dataset.csv`
- `product_category_name_translation.csv`

## KPI definitions (explicit)
- **Scope:** delivered orders only (`order_status = 'delivered'`)
- **Gross revenue:** `price + freight_value` (order-item level), aggregated to order/month
- **AOV:** average revenue per delivered order
- **MoM growth:** monthly revenue percent change

## Repo contents
- `sql/` — Postgres DDL + analysis queries
- `data_processed/` — cleaned KPI outputs (CSV)
- `figures/` — charts ready for a slide deck
- `notebooks/` — reproducible notebook to regenerate outputs
- `reports/` — short executive summary

## How to run locally
### Option A (recommended): Notebook
1. Put the raw Olist CSVs in the same folder as this repo (or update paths in the notebook).
2. Run: `notebooks/01_olist_sales_revenue_analysis.ipynb`

### Option B: SQL (Postgres)
1. Run `sql/create_tables_postgres.sql`
2. Import the raw CSVs into the tables
3. Run `sql/analysis_queries_postgres.sql`

Tableau Public: https://public.tableau.com/views/P1_17684411654760/P1ExecutiveOverview?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link
