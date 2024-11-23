-- Description: SQL script to create the database schema

-- Drop tables if they exist
-- DROP TABLE IF EXISTS difficulty;
-- DROP TABLE IF EXISTS problems;
-- DROP TABLE IF EXISTS users;
-- DROP TABLE IF EXISTS status;
-- DROP TABLE IF EXISTS problem_attempts;
-- DROP TABLE IF EXISTS patterns;
-- DROP TABLE IF EXISTS problem_patterns;
-- DROP TABLE IF EXISTS companies;
-- DROP TABLE IF EXISTS problem_companies;
-- DROP TABLE IF EXISTS tags;
-- DROP TABLE IF EXISTS problem_tags;




-- Create tables
CREATE TABLE IF NOT EXISTS difficulty (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    priority INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS problems (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    leetcode_number INTEGER UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    difficulty_id INTEGER NOT NULL,
    solution_notes TEXT,
    time_complexity VARCHAR(50),
    space_complexity VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (difficulty_id) REFERENCES difficulty (id)
);

CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS status (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255)
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
    FOREIGN KEY (problem_id) REFERENCES problems (id),
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (status_id) REFERENCES status (id)
);

CREATE TABLE IF NOT EXISTS patterns (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE IF NOT EXISTS problem_patterns (
    problem_id INTEGER NOT NULL,
    pattern_id INTEGER NOT NULL,
    PRIMARY KEY (problem_id, pattern_id),
    FOREIGN KEY (problem_id) REFERENCES problems (id),
    FOREIGN KEY (pattern_id) REFERENCES patterns (id)
);

CREATE TABLE IF NOT EXISTS companies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    industry VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS problem_companies (
    problem_id INTEGER NOT NULL,
    company_id INTEGER NOT NULL,
    last_asked TIMESTAMP,
    PRIMARY KEY (problem_id, company_id),
    FOREIGN KEY (problem_id) REFERENCES problems (id),
    FOREIGN KEY (company_id) REFERENCES companies (id)
);

CREATE TABLE IF NOT EXISTS tags (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE IF NOT EXISTS problem_tags (
    problem_id INTEGER NOT NULL,
    tag_id INTEGER NOT NULL,
    PRIMARY KEY (problem_id, tag_id),
    FOREIGN KEY (problem_id) REFERENCES problems (id),
    FOREIGN KEY (tag_id) REFERENCES tags (id)
);

-- Initial Data
INSERT OR IGNORE INTO difficulty (name, priority) VALUES
('Easy', 1),
('Medium', 2),
('Hard', 3);

INSERT OR IGNORE INTO status (name, description) VALUES
('Not Started', 'Problem not yet attempted'),
('In Progress', 'Currently working on the problem'),
('Solved', 'Successfully solved'),
('Need Review', 'Solved but needs revision');