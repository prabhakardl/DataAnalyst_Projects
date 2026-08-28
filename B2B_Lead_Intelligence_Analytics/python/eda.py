import pandas as pd
from pathlib import Path
DATA = Path(__file__).resolve().parents[1] / "data"
leads = pd.read_csv(DATA/"leads_clean.csv", parse_dates=["created_date"])
campaigns = pd.read_csv(DATA/"campaigns_clean.csv", parse_dates=["scheduled_time","sent_time","reply_time"])
print("\nTop countries:\n", leads.groupby("country").size().sort_values(ascending=False).head(10))
print("\nTechnology mix:\n", leads.groupby("technology").size().sort_values(ascending=False))
print("\nIndustry mix:\n", leads.groupby("industry").size().sort_values(ascending=False))
print("\nCampaign KPIs:")
sent = len(campaigns)
delivered = (campaigns.delivery_status=="Delivered").sum()
opened = campaigns.opened.sum()
replies = campaigns.replied.sum()
print({"sent":sent,"delivery_rate":delivered/sent,"open_rate":opened/max(delivered,1),"reply_rate":replies/max(delivered,1)})
