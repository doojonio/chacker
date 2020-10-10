-- 1 up
BEGIN;

CREATE TYPE challenge_state AS ENUM ('completed', 'in progress', 'new', 'failed');

CREATE TABLE challenges (
  id          SERIAL          PRIMARY KEY,
  title       VARCHAR(100)    NOT NULL,
  description VARCHAR(300)    NOT NULL,
  state       challenge_state NOT NULL
);

CREATE TYPE task_type  AS ENUM ('days', 'once');
CREATE TYPE task_state AS ENUM ('completed', 'in progress', 'new', 'failed');

CREATE TABLE tasks (
  id           SERIAL       PRIMARY KEY,
  challenge_id INT          NOT NULL REFERENCES challenges(id),
  title        VARCHAR(100) NOT NULL,
  type         task_type    NOT NULL,
  state        task_state   NOT NULL
);

CREATE TABLE day_task_records (
  task_id    INT  NOT NULL REFERENCES tasks(id),
  day        DATE NOT NULL,
  UNIQUE(task_id, day)
);

END;
-- 1 down
BEGIN;

DROP TABLE day_task_records;
DROP TABLE tasks;
DROP TYPE  task_state;
DROP TYPE  task_type;
DROP TABLE challenges;
DROP TYPE challenge_state;

END;
