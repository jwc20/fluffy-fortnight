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

  - [ ] auto_regulation
  - [ ] attempt_auto_regulation

- [ ] remove difficulty table
- [ ] change difficulty_id column in problems table to difficulty

- [ ] add indexes for problems table

```sql
CREATE INDEX idx_tags_endpoint ON tags(endpoint);
CREATE INDEX idx_problem_tags ON problem_tags(problem_id, tag_id);
CREATE INDEX idx_problems_number ON problems(leetcode_number);
CREATE INDEX idx_problems_difficulty ON problems(difficulty);
```

## deploy

- [ ] add Docker, docker-compose files
