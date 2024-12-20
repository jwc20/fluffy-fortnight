-- Delete all data from the table
DELETE FROM patterns WHERE 1=1;

-- Reset the autoincrement sequence
DELETE FROM sqlite_sequence WHERE name='patterns';


-- Initial Data: Patterns
INSERT OR IGNORE INTO patterns (name) VALUES
('1d_dynamic_programming'),
('2d_dynamic_programming'),
('advanced_graph'),
('array'),
('backtracking'),
('binary'),
('binary_indexed_tree'),
('binary_search'),
('binary_search_tree'),
('bit_manipulation'),
('brainteaser'),
('breadth_first_search'),
('dequeue'),
('depth_first_search'),
('design'),
('divide_and_conquer'),
('dynamic_programming'),
('geometry'),
('graph'),
('greedy'),
('hash_table'),
('heap'),
('heap_priority_queue'),
('interval'),
('line_sweep'),
('linked_list'),
('math'),
('matrix'),
('meet_in_the_middle'),
('memoization'),
('minimax'),
('oop'),
('ordered_map'),
('queue'),
('random'),
('recursion'),
('rejection_sampling'),
('reservoir_sampling'),
('rolling_hash'),
('segment_tree'),
('sliding_window'),
('sort'),
('stack'),
('string'),
('suffix_array'),
('topological_sort'),
('tree'),
('trie'),
('two_pointers'),
('union_find');


-- INSERT OR IGNORE INTO problem_patterns (problem_id, pattern_id)
-- SELECT p.id, pat.id
-- FROM problem_pattern_data ppd
-- JOIN problems p ON p.leetcode_number = ppd.problem_number
-- JOIN patterns pat ON pat.name = ppd.pattern_name;