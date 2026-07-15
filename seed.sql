USE oa_care;

INSERT INTO patients (external_id, first_name, birth_year, sex, affected_joint)
VALUES ('demo-patient-001', 'Demo', 1965, 'female', 'knee')
ON DUPLICATE KEY UPDATE first_name = VALUES(first_name);

INSERT INTO education_articles
(external_id, title, source_name, source_url, summary, published_at, review_status)
VALUES
('seed-001', 'Understanding osteoarthritis self-management', 'OA Care Editorial', 'https://example.org/oa-self-management', 'General education on pacing, activity, symptom tracking, and seeking professional support.', '2026-01-10 10:00:00', 'approved'),
('seed-002', 'Preparing for a joint-pain appointment', 'OA Care Editorial', 'https://example.org/prepare-appointment', 'A checklist of symptoms, questions, and medication information to bring to a clinical appointment.', '2026-02-15 10:00:00', 'approved')
ON DUPLICATE KEY UPDATE title = VALUES(title);
