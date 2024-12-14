
-- Delete all data from the table
DELETE FROM interview_status WHERE 1=1;

-- Initial Data: Interview Status
INSERT OR IGNORE INTO interview_status (name) VALUES
('SCHEDULED'),
('COMPLETED'),
('CANCELLED'),
('RESCHEDULED'),
('NO_SHOW'),
('PENDING_FEEDBACK');
