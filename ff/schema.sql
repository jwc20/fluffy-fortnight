-- Description: SQL script to create the database schema

-- Drop tables if they exist (in reverse order of dependencies)
DROP TABLE IF EXISTS problem_tags;
DROP TABLE IF EXISTS problem_patterns;
DROP TABLE IF EXISTS problem_companies;
DROP TABLE IF EXISTS problem_attempts;
DROP TABLE IF EXISTS interview_loops;
DROP TABLE IF EXISTS job_applications;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS patterns;
DROP TABLE IF EXISTS problems;
DROP TABLE IF EXISTS difficulty;
DROP TABLE IF EXISTS problem_status;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS companies;

-- Drop enum tables
DROP TABLE IF EXISTS application_status;
DROP TABLE IF EXISTS interview_stage;
DROP TABLE IF EXISTS interview_status;

-- Create enum tables (SQLite doesn't support ENUM)
CREATE TABLE IF NOT EXISTS application_status (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    deleted BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS interview_stage (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    deleted BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS interview_status (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    deleted BOOLEAN DEFAULT FALSE
);

-- Company Related Tables
CREATE TABLE IF NOT EXISTS companies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    industry VARCHAR(100),
    location VARCHAR(255),
    website VARCHAR(512),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    deleted BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS problem_companies (
    problem_id INTEGER NOT NULL,
    company_id INTEGER NOT NULL,
    last_asked TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    deleted BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (problem_id, company_id),
    FOREIGN KEY (problem_id) REFERENCES problems (id),
    FOREIGN KEY (company_id) REFERENCES companies (id)
);

-- Job Application Tables
CREATE TABLE IF NOT EXISTS job_applications (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    company_id INTEGER NOT NULL,
    title VARCHAR(255) NOT NULL,
    level VARCHAR(50),
    link VARCHAR(512),
    description TEXT,
    salary_range VARCHAR(100),
    location VARCHAR(255),
    job_type VARCHAR(50),
    remote BOOLEAN DEFAULT FALSE,
    status VARCHAR(50) NOT NULL DEFAULT 'APPLIED',
    notes TEXT,
    date_posted DATE,
    date_applied DATE NOT NULL,
    date_rejected DATE,
    date_accepted DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (company_id) REFERENCES companies (id),
    FOREIGN KEY (status) REFERENCES application_status (name)
);

CREATE TABLE IF NOT EXISTS interview_loops (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    loop_number INTEGER,
    job_application_id INTEGER NOT NULL,
    stage VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'SCHEDULED',
    scheduled_date TIMESTAMP,
    duration_minutes INTEGER,
    interviewer_name VARCHAR(255),
    interviewer_title VARCHAR(255),
    location VARCHAR(512),
    feedback TEXT,
    notes TEXT,
    problems_asked TEXT,
    coding_platform VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (job_application_id) REFERENCES job_applications (id),
    FOREIGN KEY (stage) REFERENCES interview_stage (name),
    FOREIGN KEY (status) REFERENCES interview_status (name)
);

-- Core Problem Tables
CREATE TABLE IF NOT EXISTS difficulty (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    priority INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    deleted BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS problems (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    leetcode_number INTEGER UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    link VARCHAR(512),
    description TEXT,
    difficulty_id INTEGER NOT NULL,
    solution_notes TEXT,
    time_complexity VARCHAR(50),
    space_complexity VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (difficulty_id) REFERENCES difficulty (id)
);

-- Problem Status and Attempts
CREATE TABLE IF NOT EXISTS problem_status (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    solved BOOLEAN DEFAULT FALSE,
    notes VARCHAR,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    deleted BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    deleted BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS problem_attempts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    problem_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    status_id INTEGER NOT NULL,
    attempt_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    code TEXT,
    time_taken_minutes INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (problem_id) REFERENCES problems (id),
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (status_id) REFERENCES problem_status (id)
);

-- Problem Patterns
CREATE TABLE IF NOT EXISTS patterns (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    deleted BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS problem_patterns (
    problem_id INTEGER NOT NULL,
    pattern_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    deleted BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (problem_id, pattern_id),
    FOREIGN KEY (problem_id) REFERENCES problems (id),
    FOREIGN KEY (pattern_id) REFERENCES patterns (id)
);


-- Problem Tags
CREATE TABLE IF NOT EXISTS tags (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,  -- e.g. "Neetcode 150", "Blind 75", "Grokking", "EPI", "Google", "Meta", ...
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    deleted BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS problem_tags (
    problem_id INTEGER NOT NULL,
    tag_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    deleted BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (problem_id, tag_id),
    FOREIGN KEY (problem_id) REFERENCES problems (id),
    FOREIGN KEY (tag_id) REFERENCES tags (id)
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_job_applications_company ON job_applications(company_id, date_applied) WHERE deleted = FALSE;
CREATE INDEX IF NOT EXISTS idx_interview_loops_application ON interview_loops(job_application_id, stage) WHERE deleted = FALSE;
CREATE INDEX IF NOT EXISTS idx_interview_loops_date ON interview_loops(scheduled_date) WHERE deleted = FALSE;
CREATE INDEX IF NOT EXISTS idx_problems_leetcode ON problems(leetcode_number) WHERE deleted = FALSE;

-- Initial Data: Application Status
INSERT OR IGNORE INTO application_status (name) VALUES
('APPLIED'),
('IN_PROGRESS'),
('REJECTED'),
('ACCEPTED'),
('WITHDRAWN');

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

-- Initial Data: Interview Status
INSERT OR IGNORE INTO interview_status (name) VALUES
('SCHEDULED'),
('COMPLETED'),
('CANCELLED'),
('RESCHEDULED'),
('NO_SHOW'),
('PENDING_FEEDBACK');

-- Initial Data: Difficulty Levels
INSERT OR IGNORE INTO difficulty (name, priority) VALUES
('Easy', 1),
('Medium', 2),
('Hard', 3);

-- Initial Data: Problem Status
-- INSERT OR IGNORE INTO problem_status (solved, notes) VALUES
-- (FALSE, 'Problem not yet attempted'),
-- (FALSE, 'Currently working on the problem'),
-- (TRUE, 'Successfully solved'),
-- (TRUE, 'Solved but needs revision');

-- Sample Data: Companies
INSERT OR IGNORE INTO companies (name, industry, location) VALUES
('Ligma Co.', 'Technology', 'San Francisco, CA');









-- Neetcode 150 problems

INSERT OR IGNORE INTO patterns (name, description) VALUES
('Arrays', 'Array manipulation problems'),
('Two Pointers', 'Two pointer technique problems'),
('Sliding Window', 'Sliding window technique problems'),
('Stack', 'Stack data structure problems'),
('Binary Search', 'Binary search algorithm problems'),
('Linked List', 'Linked list data structure problems'),
('Trees', 'Tree data structure problems'),
('Tries', 'Trie data structure problems'),
('Heap / Priority Queue', 'Heap and priority queue problems'),
('Backtracking', 'Backtracking algorithm problems'),
('Graphs', 'Graph theory problems'),
('Advanced Graphs', 'Advanced graph algorithms'),
('1-D Dynamic Programming', 'One-dimensional dynamic programming'),
('2-D Dynamic Programming', 'Two-dimensional dynamic programming'),
('Greedy', 'Greedy algorithm problems');

-- Insert all problems with links
INSERT OR IGNORE INTO problems (leetcode_number, title, difficulty_id, link) VALUES
-- Arrays
(217, 'Contains Duplicate', 1, 'https://leetcode.com/problems/contains-duplicate/'),
(242, 'Valid Anagram', 1, 'https://leetcode.com/problems/valid-anagram/'),
(1, 'Two Sum', 1, 'https://leetcode.com/problems/two-sum/'),
(49, 'Group Anagrams', 2, 'https://leetcode.com/problems/group-anagrams/'),
(347, 'Top K Frequent Elements', 2, 'https://leetcode.com/problems/top-k-frequent-elements/'),
(238, 'Product of Array Except Self', 2, 'https://leetcode.com/problems/product-of-array-except-self/'),
(36, 'Valid Sudoku', 2, 'https://leetcode.com/problems/valid-sudoku/'),
(271, 'Encode and Decode Strings', 2, 'https://leetcode.com/problems/encode-and-decode-strings/'),
(128, 'Longest Consecutive Sequence', 2, 'https://leetcode.com/problems/longest-consecutive-sequence/'),

-- Two Pointers
(125, 'Valid Palindrome', 1, 'https://leetcode.com/problems/valid-palindrome/'),
(167, 'Two Sum II', 2, 'https://leetcode.com/problems/two-sum-ii-input-array-is-sorted/'),
(15, '3Sum', 2, 'https://leetcode.com/problems/3sum/'),
(11, 'Container with Most Water', 2, 'https://leetcode.com/problems/container-with-most-water/'),
(42, 'Trapping Rain Water', 3, 'https://leetcode.com/problems/trapping-rain-water/'),

-- Sliding Window
(121, 'Best Time to Buy & Sell Stock', 1, 'https://leetcode.com/problems/best-time-to-buy-and-sell-stock/'),
(3, 'Longest Substring Without Repeating Characters', 2, 'https://leetcode.com/problems/longest-substring-without-repeating-characters/'),
(424, 'Longest Repeating Character Replacement', 2, 'https://leetcode.com/problems/longest-repeating-character-replacement/'),
(567, 'Permutation in String', 2, 'https://leetcode.com/problems/permutation-in-string/'),
(76, 'Minimum Window Substring', 3, 'https://leetcode.com/problems/minimum-window-substring/'),
(239, 'Sliding Window Maximum', 3, 'https://leetcode.com/problems/sliding-window-maximum/'),

-- Stack
(20, 'Valid Parentheses', 1, 'https://leetcode.com/problems/valid-parentheses/'),
(155, 'Min Stack', 2, 'https://leetcode.com/problems/min-stack/'),
(150, 'Evaluate Reverse Polish Notation', 2, 'https://leetcode.com/problems/evaluate-reverse-polish-notation/'),
(22, 'Generate Parentheses', 2, 'https://leetcode.com/problems/generate-parentheses/'),
(739, 'Daily Temperatures', 2, 'https://leetcode.com/problems/daily-temperatures/'),
(853, 'Car Fleet', 2, 'https://leetcode.com/problems/car-fleet/'),
(84, 'Largest Rectangle in Histogram', 3, 'https://leetcode.com/problems/largest-rectangle-in-histogram/'),

-- Binary Search
(704, 'Binary Search', 1, 'https://leetcode.com/problems/binary-search/'),
(74, 'Search a 2D Matrix', 2, 'https://leetcode.com/problems/search-a-2d-matrix/'),
(875, 'Koko Eating Bananas', 2, 'https://leetcode.com/problems/koko-eating-bananas/'),
(33, 'Search Rotated Sorted Array', 2, 'https://leetcode.com/problems/search-in-rotated-sorted-array/'),
(153, 'Find Minimum in Rotated Sorted Array', 2, 'https://leetcode.com/problems/find-minimum-in-rotated-sorted-array/'),
(981, 'Time Based Key-Value Store', 2, 'https://leetcode.com/problems/time-based-key-value-store/'),
(4, 'Find Median of Two Sorted Arrays', 3, 'https://leetcode.com/problems/median-of-two-sorted-arrays/'),

-- Linked List
(206, 'Reverse Linked List', 1, 'https://leetcode.com/problems/reverse-linked-list/'),
(21, 'Merge Two Linked Lists', 1, 'https://leetcode.com/problems/merge-two-sorted-lists/'),
(143, 'Reorder List', 2, 'https://leetcode.com/problems/reorder-list/'),
(19, 'Remove Nth Node from End of List', 2, 'https://leetcode.com/problems/remove-nth-node-from-end-of-list/'),
(138, 'Copy List with Random Pointer', 2, 'https://leetcode.com/problems/copy-list-with-random-pointer/'),
(2, 'Add Two Numbers', 2, 'https://leetcode.com/problems/add-two-numbers/'),
(141, 'Linked List Cycle', 1, 'https://leetcode.com/problems/linked-list-cycle/'),
(287, 'Find the Duplicate Number', 2, 'https://leetcode.com/problems/find-the-duplicate-number/'),
(146, 'LRU Cache', 2, 'https://leetcode.com/problems/lru-cache/'),
(23, 'Merge K Sorted Lists', 3, 'https://leetcode.com/problems/merge-k-sorted-lists/'),
(25, 'Reverse Nodes in K-Group', 3, 'https://leetcode.com/problems/reverse-nodes-in-k-group/'),

-- Trees
(226, 'Invert Binary Tree', 1, 'https://leetcode.com/problems/invert-binary-tree/'),
(104, 'Maximum Depth of Binary Tree', 1, 'https://leetcode.com/problems/maximum-depth-of-binary-tree/'),
(543, 'Diameter of a Binary Tree', 1, 'https://leetcode.com/problems/diameter-of-binary-tree/'),
(110, 'Balanced Binary Tree', 1, 'https://leetcode.com/problems/balanced-binary-tree/'),
(100, 'Same Tree', 1, 'https://leetcode.com/problems/same-tree/'),
(572, 'Subtree of Another Tree', 1, 'https://leetcode.com/problems/subtree-of-another-tree/'),
(235, 'Lowest Common Ancestor of a BST', 2, 'https://leetcode.com/problems/lowest-common-ancestor-of-a-binary-search-tree/'),
(102, 'Binary Tree Level Order Traversal', 2, 'https://leetcode.com/problems/binary-tree-level-order-traversal/'),
(199, 'Binary Tree Right Side View', 2, 'https://leetcode.com/problems/binary-tree-right-side-view/'),
(1448, 'Count Good Nodes in a Binary Tree', 2, 'https://leetcode.com/problems/count-good-nodes-in-binary-tree/'),
(98, 'Validate Binary Search Tree', 2, 'https://leetcode.com/problems/validate-binary-search-tree/'),
(230, 'Kth Smallest Element in a BST', 2, 'https://leetcode.com/problems/kth-smallest-element-in-a-bst/'),
(105, 'Construct Tree from Preorder and Inorder Traversal', 2, 'https://leetcode.com/problems/construct-binary-tree-from-preorder-and-inorder-traversal/'),
(124, 'Binary Tree Max Path Sum', 3, 'https://leetcode.com/problems/binary-tree-maximum-path-sum/'),
(297, 'Serialize and Deserialize Binary Tree', 3, 'https://leetcode.com/problems/serialize-and-deserialize-binary-tree/'),

-- Tries
(208, 'Implement Trie', 2, 'https://leetcode.com/problems/implement-trie-prefix-tree/'),
(211, 'Design Add and Search Word Data Structure', 2, 'https://leetcode.com/problems/design-add-and-search-words-data-structure/'),
(212, 'Word Search II', 3, 'https://leetcode.com/problems/word-search-ii/'),

-- Heap/Priority Queue
(703, 'Kth Largest Element in a Stream', 1, 'https://leetcode.com/problems/kth-largest-element-in-a-stream/'),
(1046, 'Last Stone Weight', 1, 'https://leetcode.com/problems/last-stone-weight/'),
(973, 'K Closest Points to Origin', 2, 'https://leetcode.com/problems/k-closest-points-to-origin/'),
(215, 'Kth Largest Element in an Array', 2, 'https://leetcode.com/problems/kth-largest-element-in-an-array/'),
(621, 'Task Scheduler', 2, 'https://leetcode.com/problems/task-scheduler/'),
(355, 'Design Twitter', 2, 'https://leetcode.com/problems/design-twitter/'),
(295, 'Find Median from Data Stream', 3, 'https://leetcode.com/problems/find-median-from-data-stream/'),

-- Backtracking
(78, 'Subsets', 2, 'https://leetcode.com/problems/subsets/'),
(39, 'Combination Sum', 2, 'https://leetcode.com/problems/combination-sum/'),
(46, 'Permutations', 2, 'https://leetcode.com/problems/permutations/'),
(90, 'Subsets II', 2, 'https://leetcode.com/problems/subsets-ii/'),
(40, 'Combination Sum II', 2, 'https://leetcode.com/problems/combination-sum-ii/'),
(79, 'Word Search', 2, 'https://leetcode.com/problems/word-search/'),
(131, 'Palindrome Partitioning', 2, 'https://leetcode.com/problems/palindrome-partitioning/'),
(17, 'Letter Combinations of a Phone Number', 2, 'https://leetcode.com/problems/letter-combinations-of-a-phone-number/'),
(51, 'N-Queens', 3, 'https://leetcode.com/problems/n-queens/'),

-- Graphs
(200, 'Number of Islands', 2, 'https://leetcode.com/problems/number-of-islands/'),
(133, 'Clone Graph', 2, 'https://leetcode.com/problems/clone-graph/'),
(695, 'Max Area of Island', 2, 'https://leetcode.com/problems/max-area-of-island/'),
(417, 'Pacific Atlantic Waterflow', 2, 'https://leetcode.com/problems/pacific-atlantic-water-flow/'),
(130, 'Surrounded Regions', 2, 'https://leetcode.com/problems/surrounded-regions/'),
(994, 'Rotting Oranges', 2, 'https://leetcode.com/problems/rotting-oranges/'),
(286, 'Walls and Gates', 2, 'https://leetcode.com/problems/walls-and-gates/'),
(207, 'Course Schedule', 2, 'https://leetcode.com/problems/course-schedule/'),
(210, 'Course Schedule II', 2, 'https://leetcode.com/problems/course-schedule-ii/'),
(684, 'Redundant Connection', 2, 'https://leetcode.com/problems/redundant-connection/'),
(323, 'Number of Connected Components in Graph', 2, 'https://leetcode.com/problems/number-of-connected-components-in-an-undirected-graph/'),
(261, 'Graph Valid Tree', 2, 'https://leetcode.com/problems/graph-valid-tree/'),
(127, 'Word Ladder', 3, 'https://leetcode.com/problems/word-ladder/'),

-- Advanced Graphs
(332, 'Reconstruct Itinerary', 3, 'https://leetcode.com/problems/reconstruct-itinerary/'),
(1584, 'Min Cost to Connect all Points', 2, 'https://leetcode.com/problems/min-cost-to-connect-all-points/'),
(743, 'Network Delay Time', 2, 'https://leetcode.com/problems/network-delay-time/'),
(778, 'Swim in Rising Water', 3, 'https://leetcode.com/problems/swim-in-rising-water/'),
(269, 'Alien Dictionary', 3, 'https://leetcode.com/problems/alien-dictionary/'),
(787, 'Cheapest Flights with K Stops', 2, 'https://leetcode.com/problems/cheapest-flights-within-k-stops/'),

-- 1-D Dynamic Programming
(70, 'Climbing Stairs', 1, 'https://leetcode.com/problems/climbing-stairs/'),
(746, 'Min Cost Climbing Stairs', 1, 'https://leetcode.com/problems/min-cost-climbing-stairs/'),
(198, 'House Robber', 2, 'https://leetcode.com/problems/house-robber/'),
(213, 'House Robber II', 2, 'https://leetcode.com/problems/house-robber-ii/'),
(5, 'Longest Palindromic Substring', 2, 'https://leetcode.com/problems/longest-palindromic-substring/'),
(647, 'Palindromic Substrings', 2, 'https://leetcode.com/problems/palindromic-substrings/'),
(91, 'Decode Ways', 2, 'https://leetcode.com/problems/decode-ways/'),
(322, 'Coin Change', 2, 'https://leetcode.com/problems/coin-change/'),
(152, 'Maximum Product Subarray', 2, 'https://leetcode.com/problems/maximum-product-subarray/'),
(139, 'Word Break', 2, 'https://leetcode.com/problems/word-break/'),
(300, 'Longest Increasing Subsequence', 2, 'https://leetcode.com/problems/longest-increasing-subsequence/'),
(416, 'Partition Equal Subset Sum', 2, 'https://leetcode.com/problems/partition-equal-subset-sum/'),

-- 2-D Dynamic Programming
(62, 'Unique Paths', 2, 'https://leetcode.com/problems/unique-paths/'),
(1143, 'Longest Common Subsequence', 2, 'https://leetcode.com/problems/longest-common-subsequence/'),
(309, 'Best Time to Buy/Sell Stock With Cooldown', 2, 'https://leetcode.com/problems/best-time-to-buy-and-sell-stock-with-cooldown/'),
(518, 'Coin Change II', 2, 'https://leetcode.com/problems/coin-change-2/'),
(494, 'Target Sum', 2, 'https://leetcode.com/problems/target-sum/'),
(97, 'Interleaving String', 2, 'https://leetcode.com/problems/interleaving-string/'),
(329, 'Longest Increasing Path in a Matrix', 3, 'https://leetcode.com/problems/longest-increasing-path-in-a-matrix/'),
(115, 'Distinct Subsequences', 3, 'https://leetcode.com/problems/distinct-subsequences/'),
(72, 'Edit Distance', 3, 'https://leetcode.com/problems/edit-distance/'),
(312, 'Burst Balloons', 3, 'https://leetcode.com/problems/burst-balloons/'),
(10, 'Regular Expression Matching', 3, 'https://leetcode.com/problems/regular-expression-matching/'),

-- Greedy
(53, 'Maximum Subarray', 2, 'https://leetcode.com/problems/maximum-subarray/'),
(55, 'Jump Game', 2, 'https://leetcode.com/problems/jump-game/'),
(45, 'Jump Game II', 2, 'https://leetcode.com/problems/jump-game-ii/'),
(134, 'Gas Station', 2, 'https://leetcode.com/problems/gas-station/'),
(846, 'Hand of Straights', 2, 'https://leetcode.com/problems/hand-of-straights/');

-- problem-pattern relationships
WITH problem_pattern_data(problem_number, pattern_name) AS (
  VALUES
    -- Arrays
    (217, 'Arrays'),
    (242, 'Arrays'),
    (1, 'Arrays'),
    (49, 'Arrays'),
    (347, 'Arrays'),
    (238, 'Arrays'),
    (36, 'Arrays'),
    (271, 'Arrays'),
    (128, 'Arrays'),

    -- Two Pointers
    (125, 'Two Pointers'),
    (167, 'Two Pointers'),
    (15, 'Two Pointers'),
    (11, 'Two Pointers'),
    (42, 'Two Pointers'),

    -- Sliding Window
    (121, 'Sliding Window'),
    (3, 'Sliding Window'),
    (424, 'Sliding Window'),
    (567, 'Sliding Window'),
    (76, 'Sliding Window'),
    (239, 'Sliding Window'),

    -- Stack
    (20, 'Stack'),
    (155, 'Stack'),
    (150, 'Stack'),
    (22, 'Stack'),
    (739, 'Stack'),
    (853, 'Stack'),
    (84, 'Stack'),

    -- Binary Search
    (704, 'Binary Search'),
    (74, 'Binary Search'),
    (875, 'Binary Search'),
    (33, 'Binary Search'),
    (153, 'Binary Search'),
    (981, 'Binary Search'),
    (4, 'Binary Search'),

    -- Linked List
    (206, 'Linked List'),
    (21, 'Linked List'),
    (143, 'Linked List'),
    (19, 'Linked List'),
    (138, 'Linked List'),
    (2, 'Linked List'),
    (141, 'Linked List'),
    (287, 'Linked List'),
    (146, 'Linked List'),
    (23, 'Linked List'),
    (25, 'Linked List'),

    -- Trees
    (226, 'Trees'),
    (104, 'Trees'),
    (543, 'Trees'),
    (110, 'Trees'),
    (100, 'Trees'),
    (572, 'Trees'),
    (235, 'Trees'),
    (102, 'Trees'),
    (199, 'Trees'),
    (1448, 'Trees'),
    (98, 'Trees'),
    (230, 'Trees'),
    (105, 'Trees'),
    (124, 'Trees'),
    (297, 'Trees'),

    -- Tries
    (208, 'Tries'),
    (211, 'Tries'),
    (212, 'Tries'),

    -- Heap / Priority Queue
    (703, 'Heap / Priority Queue'),
    (1046, 'Heap / Priority Queue'),
    (973, 'Heap / Priority Queue'),
    (215, 'Heap / Priority Queue'),
    (621, 'Heap / Priority Queue'),
    (355, 'Heap / Priority Queue'),
    (295, 'Heap / Priority Queue'),

    -- Backtracking
    (78, 'Backtracking'),
    (39, 'Backtracking'),
    (46, 'Backtracking'),
    (90, 'Backtracking'),
    (40, 'Backtracking'),
    (79, 'Backtracking'),
    (131, 'Backtracking'),
    (17, 'Backtracking'),
    (51, 'Backtracking'),

    -- Graphs
    (200, 'Graphs'),
    (133, 'Graphs'),
    (695, 'Graphs'),
    (417, 'Graphs'),
    (130, 'Graphs'),
    (994, 'Graphs'),
    (286, 'Graphs'),
    (207, 'Graphs'),
    (210, 'Graphs'),
    (684, 'Graphs'),
    (323, 'Graphs'),
    (261, 'Graphs'),
    (127, 'Graphs'),

    -- Advanced Graphs
    (332, 'Advanced Graphs'),
    (1584, 'Advanced Graphs'),
    (743, 'Advanced Graphs'),
    (778, 'Advanced Graphs'),
    (269, 'Advanced Graphs'),
    (787, 'Advanced Graphs'),

    -- 1-D Dynamic Programming
    (70, '1-D Dynamic Programming'),
    (746, '1-D Dynamic Programming'),
    (198, '1-D Dynamic Programming'),
    (213, '1-D Dynamic Programming'),
    (5, '1-D Dynamic Programming'),
    (647, '1-D Dynamic Programming'),
    (91, '1-D Dynamic Programming'),
    (322, '1-D Dynamic Programming'),
    (152, '1-D Dynamic Programming'),
    (139, '1-D Dynamic Programming'),
    (300, '1-D Dynamic Programming'),
    (416, '1-D Dynamic Programming'),

    -- 2-D Dynamic Programming
    (62, '2-D Dynamic Programming'),
    (1143, '2-D Dynamic Programming'),
    (309, '2-D Dynamic Programming'),
    (518, '2-D Dynamic Programming'),
    (494, '2-D Dynamic Programming'),
    (97, '2-D Dynamic Programming'),
    (329, '2-D Dynamic Programming'),
    (115, '2-D Dynamic Programming'),
    (72, '2-D Dynamic Programming'),
    (312, '2-D Dynamic Programming'),
    (10, '2-D Dynamic Programming'),

    -- Greedy
    (53, 'Greedy'),
    (55, 'Greedy'),
    (45, 'Greedy'),
    (134, 'Greedy'),
    (846, 'Greedy')
)


INSERT OR IGNORE INTO problem_patterns (problem_id, pattern_id)
SELECT p.id, pat.id
FROM problem_pattern_data ppd
JOIN problems p ON p.leetcode_number = ppd.problem_number
JOIN patterns pat ON pat.name = ppd.pattern_name;



-- Initial Data: Application Status
INSERT OR IGNORE INTO tags (name, description) VALUES
('neetcode', 'Problems from the Neetcode 150 list'),
('blind', 'Problems from the Blind 75 list'),
('grokking', 'Problems from the Grokking the Coding Interview course'),
('epi', 'Problems from the Elements of Programming Interviews (Python) book'),
('google', 'Problems asked in Google interviews'),
('meta', 'Problems asked in Meta interviews');


-- TODO: Add tags and problem_tags relationships
INSERT INTO problem_tags (problem_id, tag_id)
SELECT p.id, t.id
FROM problems p
JOIN tags t ON t.name = 'neetcode';










