-- Delete all data from the table
DELETE FROM tags WHERE 1=1;

-- Reset the autoincrement sequence
DELETE FROM sqlite_sequence WHERE name='tags';

INSERT OR IGNORE INTO tags (name, endpoint, description) VALUES
('Neetcode 150', 'neetcode150', 'Problems from the Neetcode 150 list'),
('Blind 75', 'blind75', 'Problems from the Blind 75 list'),
('Grokking', 'grokking', 'Problems from the Grokking the Coding Interview course'),
('EPI', 'epi', 'Problems from the Elements of Programming Interviews (Python) book'),
('Google', 'google', 'Problems asked in Google interviews'),
('Meta', 'meta', 'Problems asked in Meta interviews');

-- INSERT INTO problem_tags (problem_id, tag_id)
-- SELECT p.id, t.id
-- FROM problems p
-- JOIN tags t ON t.name = 'neetcode';