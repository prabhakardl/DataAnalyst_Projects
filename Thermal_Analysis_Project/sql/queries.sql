SELECT instrument_type, COUNT(*) AS record_count
FROM thermal_measurement
GROUP BY instrument_type
ORDER BY instrument_type;
