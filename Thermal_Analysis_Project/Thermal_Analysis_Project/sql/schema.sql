CREATE TABLE thermal_measurement (
 measurement_id INTEGER PRIMARY KEY,
 instrument_type VARCHAR(30) NOT NULL,
 sample_id VARCHAR(100),
 temperature_c DECIMAL(12,4),
 signal_1 DECIMAL(18,8),
 signal_2 DECIMAL(18,8),
 unit_1 VARCHAR(30),
 unit_2 VARCHAR(30),
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_thermal_instrument ON thermal_measurement(instrument_type);
