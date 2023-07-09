-- Retrieve the team names and their corresponding project count.
SELECT
  team_name,
  COUNT(team_project.project_id) AS project_count
FROM
  teams
  LEFT JOIN team_project ON teams.id = team_project.team_id
GROUP BY
  team_name
ORDER BY
  team_name;

-- Retrieve the projects managed by the managers whose first name starts with "J" or "D".
SELECT DISTINCT
  p.name AS project_name,
  e.first_name AS manager_first_name,
  e.last_name AS manager_last_name
FROM
  projects p
  JOIN team_project tp ON p.id = tp.project_id
  JOIN teams t ON tp.team_id = t.id
  JOIN employees e ON t.id = e.team_id
WHERE
  e.title_id = 2
  AND (
    e.first_name LIKE 'J%'
    OR e.first_name LIKE 'D%'
  );

-- Retrieve all the employees (both directly and indirectly) working under Andrew Martin
WITH RECURSIVE
  employee_hierarchy AS (
    SELECT
      id,
      first_name,
      last_name,
      manager_id
    FROM
      employees
    WHERE
      first_name = 'Andrew'
      AND last_name = 'Martin'
    UNION
    SELECT
      e.id,
      e.first_name,
      e.last_name,
      e.manager_id
    FROM
      employees e
      JOIN employee_hierarchy eh ON e.manager_id = eh.id
  )
SELECT
  *
FROM
  employee_hierarchy;

-- Retrieve all the employees (both directly and indirectly) working under Robert Brown
WITH RECURSIVE
  employee_hierarchy AS (
    SELECT
      id,
      first_name,
      last_name,
      manager_id
    FROM
      employees
    WHERE
      first_name = 'Robert'
      AND last_name = 'Brown'
    UNION
    SELECT
      e.id,
      e.first_name,
      e.last_name,
      e.manager_id
    FROM
      employees e
      JOIN employee_hierarchy eh ON e.manager_id = eh.id
  )
SELECT
  *
FROM
  employee_hierarchy;

-- Retrieve the average hourly salary for each title.
SELECT
  titles.name,
  AVG(hourly_salary) AS average_salary
FROM
  employees
  JOIN titles ON title_id = titles.id
GROUP BY
  titles.name;

-- Retrieve the employees who have a higher hourly salary than their respective team's average hourly salary.
SELECT
  e.first_name,
  e.last_name,
  e.hourly_salary
FROM
  employees e
  JOIN (
    SELECT
      team_id,
      AVG(hourly_salary) AS avg_hourly_salary
    FROM
      employees
    GROUP BY
      team_id
  ) t ON e.team_id = t.team_id
WHERE
  e.hourly_salary > t.avg_hourly_salary;

-- Retrieve the projects that have more than 3 teams assigned to them.
SELECT
  p.name AS project_name,
  COUNT(DISTINCT tp.team_id) AS team_count
FROM
  projects p
  JOIN team_project tp ON p.id = tp.project_id
GROUP BY
  p.id,
  p.name
HAVING
  COUNT(DISTINCT tp.team_id) > 3;

-- Retrieve the total hourly salary expense for each team.
SELECT
  t.team_name,
  SUM(e.hourly_salary) AS total_salary_expense
FROM
  teams t
  JOIN employees e ON t.id = e.team_id
GROUP BY
  t.id,
  t.team_name;