-- Create a function track_working_hours(employee_id, project_id, total_hours) to insert data into the hour_tracking table to track the working hours for each employee on specific projects. Make sure that data need to be validated before the insertion. Test this function
CREATE OR REPLACE FUNCTION track_working_hours(employee_id INT, project_id INT, total_hours NUMERIC)
RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM employees WHERE id = employee_id) THEN
        RAISE EXCEPTION 'Invalid employee_id: %', employee_id;
    END IF;
    IF NOT EXISTS(SELECT 1 FROM projects WHERE id = project_id) THEN
        RAISE EXCEPTION 'Invalid project_id: %', project_id;
    END IF;
    IF total_hours <= 0 THEN
        RAISE EXCEPTION 'Invalid total_hours: %', total_hours;
    END IF;
    INSERT INTO hour_tracking (employee_id, project_id, total_hours)
    VALUES (employee_id, project_id, total_hours);
    RAISE NOTICE 'Data inserted successfully.';
END;
$$ LANGUAGE plpgsql;
