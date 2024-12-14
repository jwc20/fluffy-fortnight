-- Delete all data from the table
DELETE FROM problem_status WHERE 1=1;

-- Initial Data: Problem Status
INSERT OR IGNORE INTO problem_status (solved, notes) VALUES
(FALSE, 'Problem not yet attempted'),
(FALSE, 'Currently working on the problem'),
(TRUE, 'Successfully solved'),
(TRUE, 'Solved but needs revision');
