import pandas as pd
from pathlib import Path
DATA = Path(__file__).resolve().parents[1] / "data"
leads = pd.read_csv(DATA / "leads.csv", parse_dates=["created_date"])
campaigns = pd.read_csv(DATA / "campaigns.csv", parse_dates=["scheduled_time","sent_time","reply_time"])
leads["company_country"] = leads["country"].str.strip().str.title()
leads["industry"] = leads["industry"].str.strip()
leads["email_domain"] = leads["email"].str.lower().str.split("@").str[-1]
leads = leads.drop_duplicates(subset=["company_id","email"])
leads["lead_score"] = pd.to_numeric(leads["lead_score"], errors="coerce").fillna(0)
leads.to_csv(DATA / "leads_clean.csv", index=False)
campaigns.to_csv(DATA / "campaigns_clean.csv", index=False)
print("Cleaning complete.")
