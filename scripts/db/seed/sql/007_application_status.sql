-- Delete all data from the table
DELETE FROM application_status WHERE 1=1;

-- Initial Data: Application Status
INSERT OR IGNORE INTO application_status (name) VALUES
('APPLIED'),
('IN_PROGRESS'),
('REJECTED'),
('ACCEPTED'),
('WITHDRAWN');