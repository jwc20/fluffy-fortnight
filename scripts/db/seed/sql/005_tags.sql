-- Initial Data: Tags (Problem Categories)
INSERT OR IGNORE INTO tags (name, description) VALUES
('neetcode', 'Problems from the Neetcode 150 list'),
('blind', 'Problems from the Blind 75 list'),
('grokking', 'Problems from the Grokking the Coding Interview course'),
('epi', 'Problems from the Elements of Programming Interviews (Python) book'),
('google', 'Problems asked in Google interviews'),
('meta', 'Problems asked in Meta interviews');

-- INSERT INTO problem_tags (problem_id, tag_id)
-- SELECT p.id, t.id
-- FROM problems p
-- JOIN tags t ON t.name = 'neetcode';