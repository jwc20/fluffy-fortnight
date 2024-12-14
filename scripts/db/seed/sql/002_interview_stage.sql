-- Delete all data from the table
DELETE FROM interview_stage WHERE 1=1;

-- Initial Data: Interview Stage
INSERT OR IGNORE INTO interview_stage (name) VALUES
('ONLINE_ASSESSMENT'),
('PHONE_SCREEN'),
('TECHNICAL_SCREEN'),
('VIRTUAL_ONSITE'),
('ONSITE'),
('HR_SCREEN'),
('BEHAVIORAL'),
('TEAM_MATCHING'),
('OFFER_DISCUSSION');
