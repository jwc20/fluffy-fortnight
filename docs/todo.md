# todo

## web app

- [ ] Add new problems

  - [ ] Leetcode (>1825)
    - (use this link https://leetcode.com/api/problems/algorithms/)
  - [ ] Grokking
  - [ ] EPI

- [ ] Add progress page

  - [ ] add menu for problems
  - [ ] add menu for job applications

- [ ] Add settings page
  - [ ] add feature to add/remove/edit problems

### api

- [ ] Add caching to api (lru_cache)

## db

- [ ] update seed data (use jetbrains db tools to generate insert queries)

- [ ] add new tables

  - [x] auto_regulation -> rating
  - [x] attempt_auto_regulation

- [x] remove difficulty table
- [x] change difficulty_id column in problems table to difficulty_rating

- [ ] add indexes for problems table

```sql
CREATE INDEX idx_tags_endpoint ON tags(endpoint);
CREATE INDEX idx_problem_tags ON problem_tags(problem_id, tag_id);
CREATE INDEX idx_problems_number ON problems(leetcode_number);
```

- [x] add rating column to problems table
- [x] add difficulty_rating column for job_listings table
- [x] add job_listings table
- [x] remove time_complexity and space_complexity columns from problems table
- [x] change solution_notes to notes in problems table

-> Update schema.sql and dbdiagram.txt when updating db.


## deploy

- [ ] add Docker, docker-compose files
