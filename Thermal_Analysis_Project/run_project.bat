@echo off
setlocal

cd /d "%~dp0"

echo ============================================================
echo Thermal Analysis and Rheology Project
echo ============================================================
echo Project Root: %CD%
echo.

if not exist ".venv\Scripts\python.exe" (
    echo Creating project virtual environment...
    python -m venv .venv
)

call ".venv\Scripts\activate.bat"

echo Installing required packages...
python -m pip install -r requirements.txt

echo.
echo Running pipeline...
python "src\run_pipeline.py"

echo.
if %ERRORLEVEL% EQU 0 (
    echo ============================================================
    echo SUCCESS
    echo ============================================================
) else (
    echo ============================================================
    echo PIPELINE FAILED - READ THE ERROR ABOVE
    echo ============================================================
)

pause
endlocal
