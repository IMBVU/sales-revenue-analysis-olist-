# Executive Summary

## KPI scope and logic
- **Delivered-only** orders to approximate realized revenue
- **Gross revenue** includes item price and shipping (freight_value)
- KPIs computed at order level and rolled up by month, category, and state

## Key outputs to review
- `data_processed/monthly_kpis.csv`
- `data_processed/top_categories.csv`
- `data_processed/state_kpis.csv`
- `data_processed/top_customers.csv`

## Suggested next steps (optional)
- Add profit/margin analysis (requires cost/COGS proxy)
- Add customer cohorts and repeat purchase retention
- Add delivery SLA metrics (purchase → delivered time)
