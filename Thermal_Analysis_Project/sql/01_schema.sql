-- Thermal Analysis + Rheology Laboratory Database
-- MySQL 8.x
CREATE DATABASE IF NOT EXISTS thermal_rheology_lab
  CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE thermal_rheology_lab;

CREATE TABLE instruments (
    instrument_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    manufacturer VARCHAR(100) NOT NULL,
    instrument_type ENUM('DSC','TGA','DMA','TMA','RHEOMETER') NOT NULL,
    model VARCHAR(150),
    serial_number VARCHAR(100),
    lab_location VARCHAR(150),
    calibration_due_date DATE,
    status ENUM('ACTIVE','MAINTENANCE','RETIRED') DEFAULT 'ACTIVE',
    UNIQUE KEY uq_serial(serial_number)
);

CREATE TABLE materials (
    material_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    material_code VARCHAR(80) NOT NULL UNIQUE,
    material_name VARCHAR(200) NOT NULL,
    material_type VARCHAR(100),
    supplier VARCHAR(200),
    lot_number VARCHAR(100),
    description TEXT
);

CREATE TABLE samples (
    sample_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    material_id BIGINT NOT NULL,
    sample_code VARCHAR(100) NOT NULL UNIQUE,
    preparation_date DATE,
    mass_mg DECIMAL(12,4),
    operator_name VARCHAR(150),
    notes TEXT,
    FOREIGN KEY (material_id) REFERENCES materials(material_id)
);

CREATE TABLE methods (
    method_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    method_name VARCHAR(200) NOT NULL,
    technique ENUM('DSC','TGA','DMA','TMA','RHEOLOGY') NOT NULL,
    standard_name VARCHAR(100),
    atmosphere VARCHAR(80),
    gas_flow_ml_min DECIMAL(10,3),
    heating_rate_c_min DECIMAL(10,3),
    start_temp_c DECIMAL(10,3),
    end_temp_c DECIMAL(10,3),
    notes TEXT
);

CREATE TABLE test_runs (
    run_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    sample_id BIGINT NOT NULL,
    instrument_id BIGINT NOT NULL,
    method_id BIGINT NOT NULL,
    run_datetime DATETIME NOT NULL,
    analyst_name VARCHAR(150),
    file_name VARCHAR(255),
    run_status ENUM('COMPLETED','FAILED','REVIEW','CANCELLED') DEFAULT 'COMPLETED',
    comments TEXT,
    FOREIGN KEY (sample_id) REFERENCES samples(sample_id),
    FOREIGN KEY (instrument_id) REFERENCES instruments(instrument_id),
    FOREIGN KEY (method_id) REFERENCES methods(method_id),
    INDEX idx_run_datetime(run_datetime),
    INDEX idx_run_sample(sample_id)
);

CREATE TABLE dsc_results (
    run_id BIGINT PRIMARY KEY,
    glass_transition_c DECIMAL(12,4),
    melting_peak_c DECIMAL(12,4),
    crystallization_peak_c DECIMAL(12,4),
    melting_enthalpy_j_g DECIMAL(12,4),
    crystallization_enthalpy_j_g DECIMAL(12,4),
    onset_melting_c DECIMAL(12,4),
    onset_crystallization_c DECIMAL(12,4),
    FOREIGN KEY (run_id) REFERENCES test_runs(run_id)
);

CREATE TABLE tga_results (
    run_id BIGINT PRIMARY KEY,
    initial_mass_mg DECIMAL(12,4),
    final_mass_mg DECIMAL(12,4),
    t5_c DECIMAL(12,4),
    t10_c DECIMAL(12,4),
    decomposition_onset_c DECIMAL(12,4),
    max_degradation_rate_c DECIMAL(12,4),
    residue_percent DECIMAL(12,4),
    FOREIGN KEY (run_id) REFERENCES test_runs(run_id)
);

CREATE TABLE dma_results (
    run_id BIGINT PRIMARY KEY,
    storage_modulus_mpa DECIMAL(14,5),
    loss_modulus_mpa DECIMAL(14,5),
    tan_delta DECIMAL(14,6),
    glass_transition_c DECIMAL(12,4),
    test_frequency_hz DECIMAL(12,5),
    strain_percent DECIMAL(12,5),
    FOREIGN KEY (run_id) REFERENCES test_runs(run_id)
);

CREATE TABLE tma_results (
    run_id BIGINT PRIMARY KEY,
    cte_um_m_mk DECIMAL(14,6),
    softening_temp_c DECIMAL(12,4),
    dimensional_change_percent DECIMAL(14,6),
    probe_force_mn DECIMAL(12,5),
    FOREIGN KEY (run_id) REFERENCES test_runs(run_id)
);

CREATE TABLE rheology_results (
    run_id BIGINT PRIMARY KEY,
    test_mode ENUM('FLOW','OSCILLATION','CREEP','RECOVERY','STRESS_RELAXATION') NOT NULL,
    viscosity_pa_s DECIMAL(18,8),
    shear_rate_s_1 DECIMAL(18,8),
    shear_stress_pa DECIMAL(18,8),
    storage_modulus_pa DECIMAL(18,8),
    loss_modulus_pa DECIMAL(18,8),
    tan_delta DECIMAL(14,8),
    frequency_hz DECIMAL(14,8),
    temperature_c DECIMAL(12,4),
    FOREIGN KEY (run_id) REFERENCES test_runs(run_id)
);

CREATE TABLE raw_measurements (
    measurement_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    run_id BIGINT NOT NULL,
    elapsed_s DECIMAL(16,6),
    temperature_c DECIMAL(16,6),
    mass_mg DECIMAL(16,8),
    heat_flow_mw DECIMAL(16,8),
    displacement_um DECIMAL(16,8),
    force_n DECIMAL(16,8),
    frequency_hz DECIMAL(16,8),
    shear_rate_s_1 DECIMAL(16,8),
    viscosity_pa_s DECIMAL(20,10),
    storage_modulus_pa DECIMAL(20,10),
    loss_modulus_pa DECIMAL(20,10),
    FOREIGN KEY (run_id) REFERENCES test_runs(run_id),
    INDEX idx_raw_run_time(run_id, elapsed_s)
);

CREATE TABLE users (
    user_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_name VARCHAR(150) NOT NULL,
    role_name VARCHAR(100),
    email VARCHAR(255),
    active BOOLEAN DEFAULT TRUE
);

CREATE TABLE audit_log (
    audit_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    table_name VARCHAR(100) NOT NULL,
    record_id BIGINT,
    action_name ENUM('INSERT','UPDATE','DELETE') NOT NULL,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    changed_by VARCHAR(150),
    details JSON
);

-- Useful views
CREATE OR REPLACE VIEW v_test_summary AS
SELECT
    tr.run_id, tr.run_datetime, s.sample_code, m.material_name,
    i.manufacturer, i.instrument_type, i.model,
    mt.method_name, tr.analyst_name, tr.run_status
FROM test_runs tr
JOIN samples s ON s.sample_id = tr.sample_id
JOIN materials m ON m.material_id = s.material_id
JOIN instruments i ON i.instrument_id = tr.instrument_id
JOIN methods mt ON mt.method_id = tr.method_id;

CREATE OR REPLACE VIEW v_latest_run_per_sample AS
SELECT *
FROM (
    SELECT v.*,
           ROW_NUMBER() OVER(PARTITION BY sample_code ORDER BY run_datetime DESC) AS rn
    FROM v_test_summary v
) x
WHERE rn = 1;
