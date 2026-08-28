# Power BI Dashboard Build Guide

## Data model
Load `companies.csv`, `technologies.csv`, `company_technology.csv`, `leads_clean.csv`, and `campaigns_clean.csv`.

Relationships:
- Companies[company_id] 1 -> * Leads[company_id]
- Technologies[technology_id] 1 -> * Company_Technology[technology_id]
- Companies[company_id] 1 -> * Company_Technology[company_id]
- Leads[lead_id] 1 -> * Campaigns[lead_id]

## Page 1: Executive Overview
KPI cards: Total Leads, Qualified Leads, Emails Sent, Reply Rate, High Priority Leads.
Charts: monthly leads, funnel, country bar chart.

## Page 2: Lead Intelligence
Slicers: country, industry, technology, lead status.
Charts: technology mix, industry mix, lead-score distribution, country matrix.

## Page 3: Campaign Performance
KPI cards: Delivered, Open Rate, Reply Rate.
Charts: monthly reply rate, email template performance, delivery status.

## Page 4: Geographic Intelligence
Map by country with lead count and reply rate. Add country slicer.

## Page 5: Conversion & Opportunity
Use lead status funnel and tables for high-score leads, industry conversion and technology conversion.

Use the DAX measures in `DAX_Measures.dax`.
