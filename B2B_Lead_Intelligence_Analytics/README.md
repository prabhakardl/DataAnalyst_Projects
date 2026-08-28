# B2B Lead Intelligence & Outreach Analytics

## Portfolio project
An enterprise-style Data Analysis with Python project based on a B2B business-development workflow:
online company research -> technology identification -> lead qualification -> campaign activity -> analytics -> Power BI.

## Important
All records in this repository are SYNTHETIC DEMO DATA. They are not real companies, contacts, email addresses, campaign recipients, or customer records.

## Business objective
Identify and prioritize companies that may have relevant database/technology environments and analyze outreach performance to determine which markets, industries and technologies deserve business-development focus.

## Technology stack
- Python: Pandas, NumPy
- SQL: MySQL
- BI: Power BI / DAX
- Data sources: synthetic company and campaign data modeled on public-research workflows
- Automation concept: scheduled SMTP campaigns (demo architecture only)

## KPIs
- Total Leads
- Qualified Leads
- High Priority Leads
- Emails Sent
- Delivery Rate
- Open Rate
- Reply Rate
- Conversion Rate
- Opportunities / Clients

## How to run
1. Install Python 3.11+.
2. Run:
   `python python/data_cleaning.py`
   `python python/lead_scoring.py`
   `python python/eda.py`
   `python python/campaign_analysis.py`
3. Import CSV files into MySQL using `sql/schema.sql`.
4. Run `sql/analysis_queries.sql`.
5. Import the cleaned CSVs into Power BI and follow `powerbi/Dashboard_Build_Guide.md`.

## Portfolio story
The project demonstrates the complete analyst lifecycle:
Business requirement -> data collection design -> cleaning -> relational modeling -> SQL -> Python EDA -> segmentation/scoring -> campaign KPI analysis -> Power BI dashboard -> business recommendations.

## Suggested resume bullet
"Built an end-to-end B2B Lead Intelligence & Outreach Analytics solution using Python, Pandas, MySQL and Power BI, including lead scoring, campaign funnel analysis, geographic/industry segmentation and executive KPI reporting."

## Compliance note
For any real implementation, collect and process business/contact data lawfully, honor privacy and anti-spam requirements, maintain suppression/opt-out lists, and use only authorized email infrastructure.
