import pandas as pd
from pathlib import Path
DATA = Path(__file__).resolve().parents[1] / "data"
df = pd.read_csv(DATA/"leads_clean.csv")
df["priority"] = pd.cut(df["lead_score"], [-1,39,59,74,84,94,101],
                        labels=["Low","Cold","Warm","Qualified","Hot","Priority"])
df.to_csv(DATA/"leads_scored.csv", index=False)
print(df["priority"].value_counts())
