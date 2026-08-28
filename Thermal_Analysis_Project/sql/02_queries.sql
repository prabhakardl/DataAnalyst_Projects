USE thermal_rheology_lab;

-- 1. All completed tests by technique
SELECT instrument_type, COUNT(*) AS completed_tests
FROM v_test_summary
WHERE run_status='COMPLETED'
GROUP BY instrument_type
ORDER BY completed_tests DESC;

-- 2. Recent runs
SELECT * FROM v_test_summary
ORDER BY run_datetime DESC
LIMIT 100;

-- 3. DSC: samples with Tg above 100 C
SELECT v.sample_code, v.material_name, d.glass_transition_c
FROM v_test_summary v
JOIN dsc_results d ON d.run_id=v.run_id
WHERE d.glass_transition_c > 100
ORDER BY d.glass_transition_c DESC;

-- 4. DSC: melting enthalpy
SELECT v.sample_code, d.melting_peak_c, d.melting_enthalpy_j_g
FROM v_test_summary v
JOIN dsc_results d ON d.run_id=v.run_id
ORDER BY d.melting_enthalpy_j_g DESC;

-- 5. TGA: thermal stability at 5% mass loss
SELECT v.sample_code, t.t5_c, t.decomposition_onset_c, t.residue_percent
FROM v_test_summary v
JOIN tga_results t ON t.run_id=v.run_id
ORDER BY t.t5_c DESC;

-- 6. TGA: highest residue
SELECT v.sample_code, t.residue_percent
FROM v_test_summary v
JOIN tga_results t ON t.run_id=v.run_id
ORDER BY t.residue_percent DESC
LIMIT 20;

-- 7. DMA: highest storage modulus
SELECT v.sample_code, d.storage_modulus_mpa, d.loss_modulus_mpa, d.tan_delta
FROM v_test_summary v
JOIN dma_results d ON d.run_id=v.run_id
ORDER BY d.storage_modulus_mpa DESC;

-- 8. DMA: Tg comparison
SELECT v.sample_code, d.glass_transition_c, d.test_frequency_hz
FROM v_test_summary v
JOIN dma_results d ON d.run_id=v.run_id
ORDER BY d.glass_transition_c;

-- 9. TMA: CTE comparison
SELECT v.sample_code, t.cte_um_m_mk, t.softening_temp_c
FROM v_test_summary v
JOIN tma_results t ON t.run_id=v.run_id
ORDER BY t.cte_um_m_mk;

-- 10. Rheology: viscosity vs shear rate
SELECT v.sample_code, r.shear_rate_s_1, r.viscosity_pa_s, r.temperature_c
FROM v_test_summary v
JOIN rheology_results r ON r.run_id=v.run_id
WHERE r.test_mode='FLOW'
ORDER BY v.sample_code, r.shear_rate_s_1;

-- 11. Rheology: viscoelasticity
SELECT v.sample_code, r.frequency_hz, r.storage_modulus_pa,
       r.loss_modulus_pa, r.tan_delta
FROM v_test_summary v
JOIN rheology_results r ON r.run_id=v.run_id
WHERE r.test_mode='OSCILLATION'
ORDER BY v.sample_code, r.frequency_hz;

-- 12. Find possible repeat tests of the same sample
SELECT sample_code, COUNT(*) AS run_count
FROM v_test_summary
GROUP BY sample_code
HAVING COUNT(*) > 1
ORDER BY run_count DESC;

-- 13. Latest result for each sample
SELECT * FROM v_latest_run_per_sample ORDER BY sample_code;

-- 14. Instrument utilization by month
SELECT DATE_FORMAT(run_datetime,'%Y-%m') AS month,
       manufacturer, instrument_type, COUNT(*) AS runs
FROM v_test_summary
GROUP BY month, manufacturer, instrument_type
ORDER BY month, manufacturer, instrument_type;

-- 15. Analyst productivity
SELECT analyst_name, COUNT(*) AS completed_runs
FROM v_test_summary
WHERE run_status='COMPLETED'
GROUP BY analyst_name
ORDER BY completed_runs DESC;

-- 16. Runs needing review
SELECT * FROM v_test_summary
WHERE run_status='REVIEW'
ORDER BY run_datetime DESC;

-- 17. Combine key thermal indicators
SELECT v.sample_code, v.material_name,
       d.glass_transition_c AS dsc_tg,
       d.melting_peak_c,
       t.t5_c,
       t.residue_percent,
       dm.storage_modulus_mpa,
       dm.tan_delta,
       tm.cte_um_m_mk
FROM v_test_summary v
LEFT JOIN dsc_results d ON d.run_id=v.run_id
LEFT JOIN tga_results t ON t.run_id=v.run_id
LEFT JOIN dma_results dm ON dm.run_id=v.run_id
LEFT JOIN tma_results tm ON tm.run_id=v.run_id
ORDER BY v.sample_code;

-- 18. Average DSC melting enthalpy by material
SELECT material_name, AVG(d.melting_enthalpy_j_g) AS avg_melting_enthalpy_j_g
FROM v_test_summary v
JOIN dsc_results d ON d.run_id=v.run_id
GROUP BY material_name
ORDER BY avg_melting_enthalpy_j_g DESC;

-- 19. Average TGA residue by material
SELECT material_name, AVG(t.residue_percent) AS avg_residue_percent
FROM v_test_summary v
JOIN tga_results t ON t.run_id=v.run_id
GROUP BY material_name
ORDER BY avg_residue_percent DESC;

-- 20. Data-quality check: raw measurements without a parent run
SELECT rm.measurement_id
FROM raw_measurements rm
LEFT JOIN test_runs tr ON tr.run_id=rm.run_id
WHERE tr.run_id IS NULL;

-- 21. Data-quality check: completed runs missing technique result
SELECT tr.run_id, i.instrument_type
FROM test_runs tr
JOIN instruments i ON i.instrument_id=tr.instrument_id
LEFT JOIN dsc_results d ON d.run_id=tr.run_id
LEFT JOIN tga_results t ON t.run_id=tr.run_id
LEFT JOIN dma_results dm ON dm.run_id=tr.run_id
LEFT JOIN tma_results tm ON tm.run_id=tr.run_id
LEFT JOIN rheology_results r ON r.run_id=tr.run_id
WHERE tr.run_status='COMPLETED'
  AND (
    (i.instrument_type='DSC' AND d.run_id IS NULL) OR
    (i.instrument_type='TGA' AND t.run_id IS NULL) OR
    (i.instrument_type='DMA' AND dm.run_id IS NULL) OR
    (i.instrument_type='TMA' AND tm.run_id IS NULL) OR
    (i.instrument_type='RHEOMETER' AND r.run_id IS NULL)
  );

-- 22. Parameterized-style example: runs for a material
-- Replace :material_name with a value in application code.
SELECT *
FROM v_test_summary
WHERE material_name = :material_name
ORDER BY run_datetime DESC;
