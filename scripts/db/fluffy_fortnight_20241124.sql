delete from problems where deleted=0;

select * from problems;



select * from problem_tags;

select * from tags;

select * from problem_patterns;

select * from patterns;


DROP TABLE IF EXISTS patterns;
DROP TABLE IF EXISTS tags;

-- Problem Tags
CREATE TABLE IF NOT EXISTS tags (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,  -- e.g. "Neetcode 150", "Blind 75", "Grokking", "EPI", "Google", "Meta", ...
    endpoint VARCHAR(50),  -- e.g. "neetcode150", "blind75", "grokking", "epi", "google", "meta", ...
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    deleted BOOLEAN DEFAULT FALSE
);




select * from patterns

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





-- add column difficulty_id INTEGER to leetcode_dataset_no_companies_patterns_columns
-- add column is_premium_bool boolean to leetcode_dataset_no_companies_patterns_columns

ALTER TABLE leetcode_dataset_no_companies_patterns_columns ADD COLUMN difficulty_id INTEGER;
ALTER TABLE leetcode_dataset_no_companies_patterns_columns ADD COLUMN is_premium_bool BOOLEAN;




select * from leetcode_dataset_no_companies_patterns_columns;


update leetcode_dataset_no_companies_patterns_columns set difficulty_id = 1 where difficulty = "Easy";
update leetcode_dataset_no_companies_patterns_columns set difficulty_id = 2 where difficulty = "Medium";
update leetcode_dataset_no_companies_patterns_columns set difficulty_id = 3 where difficulty = "Hard";

update leetcode_dataset_no_companies_patterns_columns set is_premium_bool = 0 where is_premium = False;
update leetcode_dataset_no_companies_patterns_columns set is_premium_bool = 1 where is_premium = True;




select is_premium, is_premium_bool from leetcode_dataset_no_companies_patterns_columns;


select * from leetcode_dataset_no_companies_patterns_columns;



insert into problems
(
    id  -- id
  , leetcode_number -- id
  , title -- title
  , link -- link
--   , description
  , difficulty_id -- difficulty_id
--   , solution_notes
--   , time_complexity
--   , space_complexity
  , is_premium -- is_premium_bool
  , created_at -- now()
  , updated_at -- now()
  , deleted_at -- null
  , deleted -- 0
)
select
    id
  , id
  , title
  , url
--   , description
  , difficulty_id
--   , solution_notes
--   , time_complexity
--   , space_complexity
  , is_premium_bool
  , datetime()
  , datetime()
  , null
  ,  0
from leetcode_dataset_no_companies_patterns_columns;



select datetime();







-- select * from patterns;
--
--
-- delete from patterns where description is not null;



select * from leetcode_dataset_no_companies_patterns_columns;

select * from problems;


select * from leetcode_dataset_companies_patterns;

-- update leetcode_dataset_companies_patterns set companies =

-- update leetcode_dataset_companies_patterns set to lowercase and replace spaces with underscores
-- update leetcode_dataset_companies_patterns set companies = lower(replace(companies, ' ', '_'));
--
-- -- update leetcode_dataset_companies_patterns set to lowercase and replace dashes with underscores
-- update leetcode_dataset_companies_patterns set companies = lower(replace(companies, '-', '_'));
--
--
--
--
-- -- update leetcode_dataset_companies_patterns set to lowercase and replace spaces with underscores
-- update leetcode_dataset_companies_patterns set patterns = lower(replace(patterns, ' ', '_'));
--
-- -- update leetcode_dataset_companies_patterns set to lowercase and replace dashes with underscores
-- update leetcode_dataset_companies_patterns set patterns = lower(replace(patterns, '-', '_'));
--





select * from leetcode_dataset_companies_patterns;


select * from patterns
where name in (select patterns from leetcode_dataset_companies_patterns);




-- patterns=string,backtracking,depth_first_search,recursion

-- create a query that will return the id of leetcode_dataset_companies_patterns
-- where the name in pattern table is in the patterns column of leetcode_dataset_companies_patterns
-- the patterns column in leetcode_dataset_companies_patterns has data like 'string,backtracking,depth_first_search,recursion'

select id from leetcode_dataset_companies_patterns
where patterns like '%string%'


-- get the column names from leetcode_dataset_companies_patterns
PRAGMA table_info(leetcode_dataset_companies_patterns);

-- get the column names from patterns
PRAGMA table_info(patterns);



SELECT p.name, COUNT(DISTINCT ldcp.id) as count
FROM patterns p
LEFT JOIN leetcode_dataset_companies_patterns ldcp ON
    (
        ldcp.patterns LIKE p.name || ',%'
        OR ldcp.patterns LIKE '%,' || p.name || ',%'
        OR ldcp.patterns LIKE '%,' || p.name
        OR ldcp.patterns = p.name
    )
GROUP BY p.name
ORDER BY p.name;











SELECT p.name, *
FROM patterns p
LEFT JOIN leetcode_dataset_companies_patterns ldcp ON
    (
        ldcp.patterns LIKE p.name || ',%'
        OR ldcp.patterns LIKE '%,' || p.name || ',%'
        OR ldcp.patterns LIKE '%,' || p.name
        OR ldcp.patterns = p.name
    )
where ldcp.patterns is not null;





select * from patterns;

select * from problem_patterns;



insert into problem_patterns (problem_id, pattern_id, created_at, updated_at, deleted_at, deleted)
SELECT
    ldcp.id as problem_id
    , p.id as pattern_id
    , datetime()
    , datetime()
    , null
    , 0
FROM patterns p
LEFT JOIN leetcode_dataset_companies_patterns ldcp ON
    (
        ldcp.patterns LIKE p.name || ',%'
        OR ldcp.patterns LIKE '%,' || p.name || ',%'
        OR ldcp.patterns LIKE '%,' || p.name
        OR ldcp.patterns = p.name
    )
where ldcp.patterns is not null;

-- [2024-11-24 22:56:16] 2,562 rows affected in 48 ms




select * from blind75;
select * from neetcode150;



select * from tags;
select * from problem_tags;

pragma table_info(problems);
pragma table_info(tags);
pragma table_info(problem_tags);




select * from problems
inner join blind75
    on problems.link = blind75.link;

select * from problems
inner join neetcode150
    on problems.link = neetcode150.link;


-- Insert tags for Blind 75 problems
INSERT INTO problem_tags (problem_id, tag_id)
SELECT DISTINCT p.id, 2  -- 2 is the tag_id for Blind 75
FROM problems p
INNER JOIN blind75 b ON p.link = b.link
WHERE NOT EXISTS (
    SELECT 1
    FROM problem_tags pt
    WHERE pt.problem_id = p.id
    AND pt.tag_id = 2
    AND pt.deleted = FALSE
);

-- Insert tags for Neetcode 150 problems
INSERT INTO problem_tags (problem_id, tag_id)
SELECT DISTINCT p.id, 1  -- 1 is the tag_id for Neetcode 150
FROM problems p
INNER JOIN neetcode150 n ON p.link = n.link
WHERE NOT EXISTS (
    SELECT 1
    FROM problem_tags pt
    WHERE pt.problem_id = p.id
    AND pt.tag_id = 1
    AND pt.deleted = FALSE
);




select * from tags;


select * from problem_tags
inner join tags on problem_tags.tag_id = tags.id;



SELECT *, pa.name as pattern FROM problems p
JOIN problem_tags pt ON p.id = pt.problem_id
JOIN tags t ON pt.tag_id = t.id
JOIN problem_patterns pp ON p.id = pp.problem_id
JOIN patterns pa ON pp.pattern_id = pa.id
WHERE t.endpoint = 'neetcode150'




SELECT
    p.id,
    p.leetcode_number,
    p.title,
    p.link,
    p.description,
    p.difficulty_id,
    p.solution_notes,
    p.time_complexity,
    p.space_complexity,
    p.is_premium,
    p.created_at,
    p.updated_at,
    p.deleted_at,
    p.deleted,
    t.name as tag_name,
    GROUP_CONCAT(pa.name) as patterns
FROM problems p
JOIN problem_tags pt ON p.id = pt.problem_id
JOIN tags t ON pt.tag_id = t.id
JOIN problem_patterns pp ON p.id = pp.problem_id
JOIN patterns pa ON pp.pattern_id = pa.id
WHERE t.endpoint = 'neetcode150'
GROUP BY p.id
ORDER BY p.leetcode_number;






-- https://leetcode.com/problems/add-and-search-word-data-structure-design

select * from problems where link like '%design%';

select * from problems where leetcode_number=211;

select link , * from blind75
where link not in (
    select link from problems
    inner join problem_tags on problems.id = problem_tags.problem_id
    inner join tags on problem_tags.tag_id = tags.id
    where tags.endpoint = 'blind75'
    );


update blind75 set link = 'https://leetcode.com/problems/design-add-and-search-words-data-structure'
               where link = 'https://leetcode.com/problems/add-and-search-word-data-structure-design';


https://leetcode.com/problems/add-and-search-word-data-structure-design
https://leetcode.com/problems/design-add-and-search-words-data-structure





select * from problems
inner join problem_tags on problems.id = problem_tags.problem_id
inner join tags on problem_tags.tag_id = tags.id
where tags.name = 'Neetcode 150';





select * from problems
inner join problem_tags on problems.id = problem_tags.problem_id
inner join tags on problem_tags.tag_id = tags.id
where tags.id = 2;

select * from tags;


select * from problem_tags

insert into problem_tags (problem_id, tag_id)
values (211, 2);


select * from problems
inner join problem_patterns
    on problems.id = problem_patterns.problem_id
inner join patterns
    on problem_patterns.pattern_id = patterns.id
where problems.leetcode_number=211;

select * from leetcode_dataset_companies_patterns where id = 211;



select * from problems
inner join problem_patterns
    on problems.id = problem_patterns.problem_id
inner join patterns
    on problem_patterns.pattern_id = patterns.id
where problems.leetcode_number=211;

select * from leetcode_dataset_companies_patterns where id = 211;







SELECT
    p.id,
    p.leetcode_number,
    p.title,
    p.link,
    p.description,
    p.difficulty_id,
    p.solution_notes,
    p.time_complexity,
    p.space_complexity,
    p.is_premium,
    p.created_at,
    p.updated_at,
    p.deleted_at,
    p.deleted,
    t.name as tag_name,
    GROUP_CONCAT(pa.name) as patterns
FROM problems p
JOIN problem_tags pt ON p.id = pt.problem_id
JOIN tags t ON pt.tag_id = t.id
JOIN problem_patterns pp ON p.id = pp.problem_id
JOIN patterns pa ON pp.pattern_id = pa.id
WHERE t.endpoint = 'blind75'
GROUP BY p.id
ORDER BY p.leetcode_number;













SELECT count(*) as count FROM problems p
left JOIN problem_tags pt ON p.id = pt.problem_id
left JOIN tags t ON pt.tag_id = t.id
left JOIN problem_patterns pp ON p.id = pp.problem_id
left JOIN patterns pa ON pp.pattern_id = pa.id
WHERE t.endpoint = 'blind75'
GROUP BY p.id
ORDER BY p.leetcode_number;











select * from neetcode150;

-- delete from neetcode150 where pattern is null;
-- [2024-11-25 01:34:51] 856 rows affected in 4 ms

SELECT count(*) as count FROM problems p
left JOIN problem_tags pt ON p.id = pt.problem_id
left JOIN tags t ON pt.tag_id = t.id
left JOIN problem_patterns pp ON p.id = pp.problem_id
left JOIN patterns pa ON pp.pattern_id = pa.id
WHERE t.endpoint = 'neetcode150'
GROUP BY p.id
ORDER BY p.leetcode_number;


select * from problem_tags where tag_id = 1;




select distinct pattern from neetcode150;

-- update neetcode150 set pattern = 'two_pointers' where pattern = 'two_pointer';


select * from patterns
where name not in (
    select distinct pattern from neetcode150
    );


select * from patterns;











select * from patterns;
select * from problem_patterns;




delete from patterns;
delete from problem_patterns;


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










select * from leetcode_dataset_companies_patterns

delete from problem_patterns;




select * from patterns



insert into problem_patterns (problem_id, pattern_id, created_at, updated_at, deleted_at, deleted)
SELECT
    ldcp.id as problem_id
    , p.id as pattern_id
    , datetime()
    , datetime()
    , null
    , 0
FROM patterns p
LEFT JOIN leetcode_dataset_companies_patterns ldcp ON
    (
        ldcp.patterns LIKE p.name || ',%'
        OR ldcp.patterns LIKE '%,' || p.name || ',%'
        OR ldcp.patterns LIKE '%,' || p.name
        OR ldcp.patterns = p.name
    )
where ldcp.patterns is not null;






SELECT GROUP_CONCAT(pa.name) as patterns, p.id, p.leetcode_number, p.title, p.link, p.description, p.difficulty_id, p.solution_notes, p.time_complexity, p.space_complexity, p.is_premium, p.created_at, p.updated_at, p.deleted_at, p.deleted, t.name as tag_name, GROUP_CONCAT(pa.name) as patterns
FROM problems p
     left JOIN problem_tags pt ON p.id=pt.problem_id
     left JOIN tags t ON pt.tag_id=t.id
     left JOIN problem_patterns pp ON p.id=pp.problem_id
     left JOIN patterns pa ON pp.pattern_id=pa.id
WHERE t.endpoint='neetcode150'
GROUP BY p.id
ORDER BY p.leetcode_number;













select * from neetcode150
where link not in (
    SELECT p.link
    FROM problems p
         left JOIN problem_tags pt ON p.id=pt.problem_id
         left JOIN tags t ON pt.tag_id=t.id
         left JOIN problem_patterns pp ON p.id=pp.problem_id
         left JOIN patterns pa ON pp.pattern_id=pa.id
    WHERE t.endpoint='neetcode150'
    GROUP BY p.id
    );

-- https://leetcode.com/accounts/login/?next=/problems/encode-and-decode-strings -> https://leetcode.com/problems/encode-and-decode-strings
-- https://leetcode.com/problems/merge-triplets-to-form-target-triplet -> https://leetcode.com/problems/merge-triplets-to-form-target-triplet
-- https://leetcode.com/problems/minimum-interval-to-include-each-query ->
-- https://leetcode.com/problems/detect-squares


-- update neetcode150 set link = 'https://leetcode.com/problems/encode-and-decode-strings' where link = 'https://leetcode.com/accounts/login/?next=/problems/encode-and-decode-strings';


-- TODO
select * from problems where leetcode_number in (1899, 1851, 2013);



select * from problem_tags where problem_id=271

-- insert into problem_tags (problem_id, tag_id) values (271, 1);





PRAGMA table_info(problems);
-- 0,id,INTEGER,0,,1
-- 1,leetcode_number,INTEGER,1,,0
-- 2,title,VARCHAR(255),1,,0
-- 3,link,VARCHAR(512),0,,0
-- 4,description,TEXT,0,,0
-- 5,difficulty_id,INTEGER,1,,0
-- 6,solution_notes,TEXT,0,,0
-- 7,time_complexity,VARCHAR(50),0,,0
-- 8,space_complexity,VARCHAR(50),0,,0
-- 9,is_premium,BOOLEAN,0,FALSE,0
-- 10,created_at,TIMESTAMP,0,CURRENT_TIMESTAMP,0
-- 11,updated_at,TIMESTAMP,0,CURRENT_TIMESTAMP,0
-- 12,deleted_at,TIMESTAMP,0,,0
-- 13,deleted,BOOLEAN,0,FALSE,0














