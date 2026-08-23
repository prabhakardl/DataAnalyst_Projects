# Directory Error Fix

The pipeline now creates all required directories before `pandas.ExcelWriter` or `DataFrame.to_csv()` is called.

Required directories:

D:\DRDO\Thermal_Analysis_Project\excel
D:\DRDO\Thermal_Analysis_Project\powerbi
D:\DRDO\Thermal_Analysis_Project\output\cleaned
D:\DRDO\Thermal_Analysis_Project\output\analysis
D:\DRDO\Thermal_Analysis_Project\output\plots
D:\DRDO\Thermal_Analysis_Project\output\reports

It also writes a `Run_Info` worksheet first. This prevents the OpenPyXL error:

IndexError: At least one sheet must be visible

If a previous failed Excel file exists, the pipeline deletes it before starting.
Close the workbook in Excel before running the pipeline again.
