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





