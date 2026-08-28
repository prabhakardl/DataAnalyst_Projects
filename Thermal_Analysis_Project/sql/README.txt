THERMAL + RHEOLOGY MYSQL PROJECT
================================

Scope
-----
A practical MySQL 8.x laboratory database design for storing and querying
results from:
- DSC (Differential Scanning Calorimetry)
- TGA (Thermogravimetric Analysis)
- DMA (Dynamic Mechanical Analysis)
- TMA (Thermomechanical Analysis)
- Rheometry / rheometer testing

Vendor context
--------------
The instrument table supports vendor/model metadata, including TA Instruments
for thermal-analysis instruments and Anton Paar for rheometers. It is intentionally
vendor-neutral so the same schema can store multiple models and laboratories.

Important
---------
This is a laboratory information/data-management schema, not an official vendor
database schema and does not claim to reproduce proprietary instrument file formats
or software internals. Map actual exported instrument columns to raw_measurements
and technique-specific result tables after validating the export format.

Files
-----
01_schema.sql       - database, tables, keys, indexes and views
02_queries.sql      - 22 practical SQL queries
03_sample_materials.csv - starter material master data
04_data_dictionary.csv - table/column descriptions

Typical workflow
----------------
1. Create the database using 01_schema.sql.
2. Load materials, samples, methods and instruments.
3. Insert one test_runs row per experiment.
4. Insert one technique result row for each completed run.
5. Optionally load point-by-point exported data into raw_measurements.
6. Run 02_queries.sql for analysis, QA and reporting.

Suggested extensions
--------------------
- Separate raw-data tables by technique if point-level datasets are very large.
- Add projects, customers, purchase orders and batch genealogy.
- Add calibration records and maintenance events.
- Add controlled vocabularies for standards, atmospheres and sample geometries.
- Add ETL staging tables for CSV exports from instrument software.
