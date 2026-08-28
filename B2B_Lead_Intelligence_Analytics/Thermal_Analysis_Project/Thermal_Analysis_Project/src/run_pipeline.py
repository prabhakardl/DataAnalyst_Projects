from pathlib import Path
import sys

PROJECT_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(Path(__file__).resolve().parent))

from thermal_analysis.pipeline import run_all

if __name__ == "__main__":
    run_all()
