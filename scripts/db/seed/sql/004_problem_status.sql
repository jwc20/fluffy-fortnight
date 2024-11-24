-- Initial Data: Problem Status
INSERT OR IGNORE INTO problem_status (solved, notes) VALUES
(FALSE, 'Problem not yet attempted'),
(FALSE, 'Currently working on the problem'),
(TRUE, 'Successfully solved'),
(TRUE, 'Solved but needs revision');
