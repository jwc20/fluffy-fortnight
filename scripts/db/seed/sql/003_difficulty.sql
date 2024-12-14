-- Delete all data from the table
DELETE FROM difficulty WHERE 1=1;

-- Initial Data: Difficulty Levels
INSERT OR IGNORE INTO difficulty (name, priority) VALUES
('Easy', 1),
('Medium', 2),
('Hard', 3);