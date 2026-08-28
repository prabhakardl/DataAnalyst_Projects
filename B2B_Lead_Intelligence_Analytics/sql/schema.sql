CREATE DATABASE IF NOT EXISTS b2b_lead_analytics;
USE b2b_lead_analytics;

CREATE TABLE companies (
 company_id VARCHAR(20) PRIMARY KEY, company_name VARCHAR(200), website VARCHAR(300),
 country VARCHAR(100), industry VARCHAR(100), company_size VARCHAR(30),
 employee_count INT, revenue_range VARCHAR(50)
);

CREATE TABLE technologies (
 technology_id VARCHAR(20) PRIMARY KEY, technology_name VARCHAR(100),
 technology_category VARCHAR(100), vendor VARCHAR(100)
);

CREATE TABLE company_technology (
 company_id VARCHAR(20), technology_id VARCHAR(20), technology_version VARCHAR(50),
 technology_evidence VARCHAR(100), confidence_score DECIMAL(4,2), source VARCHAR(200),
 FOREIGN KEY(company_id) REFERENCES companies(company_id),
 FOREIGN KEY(technology_id) REFERENCES technologies(technology_id)
);

CREATE TABLE leads (
 lead_id VARCHAR(20) PRIMARY KEY, company_id VARCHAR(20), contact_name VARCHAR(100),
 designation VARCHAR(100), email VARCHAR(200), phone VARCHAR(50), country VARCHAR(100),
 industry VARCHAR(100), technology VARCHAR(100), lead_source VARCHAR(100),
 lead_score INT, lead_status VARCHAR(50), created_date DATE,
 FOREIGN KEY(company_id) REFERENCES companies(company_id)
);

CREATE TABLE campaigns (
 campaign_id VARCHAR(20) PRIMARY KEY, lead_id VARCHAR(20), email_template VARCHAR(100),
 scheduled_time DATETIME, sent_time DATETIME, delivery_status VARCHAR(30),
 opened TINYINT, replied TINYINT, reply_time DATETIME, follow_up_required TINYINT,
 FOREIGN KEY(lead_id) REFERENCES leads(lead_id)
);
