import pandas as pd
from pathlib import Path
DATA = Path(__file__).resolve().parents[1] / "data"
df = pd.read_csv(DATA/"campaigns_clean.csv", parse_dates=["sent_time"])
df["month"] = df["sent_time"].dt.to_period("M").astype(str)
monthly = df.groupby("month").agg(
    emails_sent=("campaign_id","count"),
    delivered=("delivery_status", lambda x:(x=="Delivered").sum()),
    opens=("opened","sum"),
    replies=("replied","sum")
).reset_index()
monthly["delivery_rate"] = monthly["delivered"]/monthly["emails_sent"]
monthly["open_rate"] = monthly["opens"]/monthly["delivered"].replace(0,1)
monthly["reply_rate"] = monthly["replies"]/monthly["delivered"].replace(0,1)
monthly.to_csv(DATA/"monthly_campaign_kpis.csv", index=False)
print(monthly)
