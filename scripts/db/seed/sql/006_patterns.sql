
-- Initial Data: Patterns
INSERT OR IGNORE INTO patterns (name) VALUES
('1d_dynamic_programming'),
('2d_dynamic_programming'),
('advanced_graph'),
('array'),
('backtracking'),
('binary'),
('bit_manipulation'),
('dynamic_programming'),
('graph'),
('greedy'),
('heap_priority_queue'),
('interval'),
('linked_list'),
('math'),
('matrix'),
('sliding_window'),
('stack'),
('string'),
('tree'),
('trie'),
('two_pointer');


-- INSERT OR IGNORE INTO problem_patterns (problem_id, pattern_id)
-- SELECT p.id, pat.id
-- FROM problem_pattern_data ppd
-- JOIN problems p ON p.leetcode_number = ppd.problem_number
-- JOIN patterns pat ON pat.name = ppd.pattern_name;