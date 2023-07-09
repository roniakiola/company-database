CREATE DATABASE IF NOT EXISTS company
WITH
  OWNER roni;

CREATE TABLE
  IF NOT EXISTS titles (id SERIAL PRIMARY KEY, name VARCHAR(30));

CREATE TABLE
  IF NOT EXISTS teams (
    id SERIAL PRIMARY KEY,
    team_name VARCHAR(30) NOT NULL,
    location VARCHAR(30) NOT NULL
  );

CREATE TABLE
  IF NOT EXISTS employees (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    hire_date DATE NOT NULL,
    hourly_salary NUMERIC(10, 2) NOT NULL,
    title_id INT REFERENCES titles (id) ON UPDATE CASCADE ON DELETE SET NULL,
    manager_id INT REFERENCES employees (id) ON UPDATE CASCADE ON DELETE SET NULL,
    team_id INT REFERENCES teams (id) ON UPDATE CASCADE ON DELETE SET NULL
  );

CREATE TABLE
  IF NOT EXISTS projects (
    id SERIAL PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    client VARCHAR(30) NOT NULL,
    start_date DATE NOT NULL,
    deadline DATE NOT NULL
  );

CREATE TABLE
  IF NOT EXISTS team_project (
    team_id INT REFERENCES teams (id) ON UPDATE CASCADE ON DELETE CASCADE,
    project_id INT REFERENCES projects (id) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (team_id, project_id)
  );

CREATE TABLE
  IF NOT EXISTS hour_tracking (
    employee_id INT REFERENCES employees (id) ON UPDATE CASCADE ON DELETE CASCADE,
    project_id INT REFERENCES projects (id) ON UPDATE CASCADE ON DELETE CASCADE,
    total_hours INT NOT NULL,
    PRIMARY KEY (employee_id, project_id)
  );