from pathlib import Path
import pandas as pd
import matplotlib.pyplot as plt

# Project root:
# D:\DRDO\Thermal_Analysis_Project
ROOT = Path(__file__).resolve().parents[2]

def create_project_directories():
    """Create every output directory before any file is written."""
    folders = [
        ROOT / "excel",
        ROOT / "powerbi",
        ROOT / "output",
        ROOT / "output" / "cleaned",
        ROOT / "output" / "analysis",
        ROOT / "output" / "plots",
        ROOT / "output" / "reports",
        ROOT / "logs",
    ]

    for folder in folders:
        folder.mkdir(parents=True, exist_ok=True)

def run_all():
    # IMPORTANT: directories must exist BEFORE ExcelWriter is opened.
    create_project_directories()

    files = {
        "dsc": ROOT / "input" / "sample" / "DSC" / "dsc_sample.csv",
        "tga": ROOT / "input" / "sample" / "TGA" / "tga_sample.csv",
        "dma": ROOT / "input" / "sample" / "DMA" / "dma_sample.csv",
        "tma": ROOT / "input" / "sample" / "TMA" / "tma_sample.csv",
        "rheometer": ROOT / "input" / "sample" / "RHEOMETER" / "rheometer_sample.csv",
    }

    excel_file = ROOT / "excel" / "Thermal_Rheology_Analysis.xlsx"

    # Remove an incomplete Excel file from a previous failed run.
    if excel_file.exists():
        try:
            excel_file.unlink()
        except PermissionError:
            raise PermissionError(
                f"Close this Excel file before running again:\n{excel_file}"
            )

    processed = 0

    with pd.ExcelWriter(excel_file, engine="openpyxl") as xw:

        # Guarantees at least one visible worksheet even if an input file is missing.
        pd.DataFrame({
            "Status": ["Thermal Analysis & Rheology Pipeline"],
            "Project_Root": [str(ROOT)],
        }).to_excel(xw, sheet_name="Run_Info", index=False)

        for name, path in files.items():

            if not path.exists():
                print(f"[WARNING] Input file not found: {path}")
                continue

            df = pd.read_csv(path)

            # Standardize column names.
            df.columns = [
                str(c).strip().replace(" ", "_")
                for c in df.columns
            ]

            # Cleaned CSV.
            cleaned_file = ROOT / "output" / "cleaned" / f"{name}_cleaned.csv"
            cleaned_file.parent.mkdir(parents=True, exist_ok=True)
            df.to_csv(cleaned_file, index=False)

            # Numeric analysis.
            numeric = df.select_dtypes(include="number")

            if not numeric.empty:
                summary = pd.DataFrame({
                    "parameter": numeric.columns,
                    "min": numeric.min().values,
                    "max": numeric.max().values,
                    "mean": numeric.mean().values,
                })
            else:
                summary = pd.DataFrame({
                    "parameter": [],
                    "min": [],
                    "max": [],
                    "mean": [],
                })

            summary_file = (
                ROOT / "output" / "analysis" / f"{name}_summary.csv"
            )
            summary_file.parent.mkdir(parents=True, exist_ok=True)
            summary.to_csv(summary_file, index=False)

            # Excel sheets.
            sheet_name = name[:31]
            summary_sheet = f"{name}_summary"[:31]

            df.to_excel(xw, sheet_name=sheet_name, index=False)
            summary.to_excel(xw, sheet_name=summary_sheet, index=False)

            # Power BI CSV.
            powerbi_file = ROOT / "powerbi" / f"{name}_powerbi.csv"
            powerbi_file.parent.mkdir(parents=True, exist_ok=True)
            df.to_csv(powerbi_file, index=False)

            # Visualization.
            if len(numeric.columns) >= 2:
                plot_file = ROOT / "output" / "plots" / f"{name}.png"
                plot_file.parent.mkdir(parents=True, exist_ok=True)

                plt.figure(figsize=(9, 5))
                plt.plot(df.iloc[:, 0], df.iloc[:, 1])
                plt.xlabel(df.columns[0])
                plt.ylabel(df.columns[1])
                plt.title(name.upper())
                plt.tight_layout()
                plt.savefig(plot_file, dpi=150)
                plt.close()

            processed += 1
            print(f"[OK] Processed: {name}")

    print()
    print("=" * 60)
    print("THERMAL ANALYSIS PIPELINE COMPLETED")
    print("=" * 60)
    print(f"Project : {ROOT}")
    print(f"Processed datasets : {processed}")
    print(f"Excel   : {excel_file}")
    print(f"Cleaned : {ROOT / 'output' / 'cleaned'}")
    print(f"Analysis: {ROOT / 'output' / 'analysis'}")
    print(f"Plots   : {ROOT / 'output' / 'plots'}")
    print(f"Power BI: {ROOT / 'powerbi'}")
    print("=" * 60)

if __name__ == "__main__":
    run_all()
