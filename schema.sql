CREATE DATABASE IF NOT EXISTS oa_care CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE oa_care;

CREATE TABLE IF NOT EXISTS patients (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    external_id VARCHAR(190) NOT NULL UNIQUE,
    first_name VARCHAR(120) NOT NULL,
    birth_year SMALLINT UNSIGNED NOT NULL,
    sex VARCHAR(40) NOT NULL,
    affected_joint VARCHAR(80) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS assessments (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    patient_id BIGINT UNSIGNED NOT NULL,
    pain_score TINYINT UNSIGNED NOT NULL,
    stiffness_minutes SMALLINT UNSIGNED NOT NULL,
    mobility_score TINYINT UNSIGNED NOT NULL,
    sleep_quality TINYINT UNSIGNED NOT NULL,
    activity_minutes SMALLINT UNSIGNED NOT NULL,
    medication_adherence TINYINT UNSIGNED NOT NULL,
    swollen_hot_joint BOOLEAN NOT NULL DEFAULT FALSE,
    fever BOOLEAN NOT NULL DEFAULT FALSE,
    unable_to_bear_weight BOOLEAN NOT NULL DEFAULT FALSE,
    recent_trauma BOOLEAN NOT NULL DEFAULT FALSE,
    notes TEXT NULL,
    risk_score TINYINT UNSIGNED NOT NULL,
    risk_tier ENUM('low', 'moderate', 'high', 'urgent') NOT NULL,
    factors_json JSON NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_assessments_patient FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    INDEX idx_assessments_patient_created (patient_id, created_at),
    INDEX idx_assessments_risk (risk_tier, created_at)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS recommendations (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    assessment_id BIGINT UNSIGNED NOT NULL,
    recommendation_text TEXT NOT NULL,
    source_type ENUM('rule', 'clinician', 'external_ai') NOT NULL DEFAULT 'rule',
    approved BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_recommendations_assessment FOREIGN KEY (assessment_id) REFERENCES assessments(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS education_articles (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    external_id VARCHAR(190) NOT NULL UNIQUE,
    title VARCHAR(500) NOT NULL,
    source_name VARCHAR(190) NOT NULL,
    source_url VARCHAR(1000) NOT NULL,
    summary TEXT NULL,
    published_at DATETIME NULL,
    review_status ENUM('pending', 'approved', 'rejected') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_education_review_published (review_status, published_at)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS audit_logs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    action VARCHAR(190) NOT NULL,
    entity_type VARCHAR(120) NOT NULL,
    entity_id BIGINT UNSIGNED NULL,
    metadata_json JSON NULL,
    ip_address VARCHAR(64) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_audit_entity (entity_type, entity_id),
    INDEX idx_audit_created (created_at)
) ENGINE=InnoDB;
