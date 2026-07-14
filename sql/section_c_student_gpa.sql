-- Section C: Student GPA calculation

ALTER TABLE student
    ADD COLUMN gpa NUMERIC(4,2),
    ADD COLUMN gpa_last_updated DATE;

CREATE OR REPLACE FUNCTION get_grade_point(grade_input CHAR(2))
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
BEGIN
    CASE TRIM(grade_input)
        WHEN 'AD' THEN RETURN 4.0;
        WHEN 'A' THEN RETURN 4.0;
        WHEN 'B+' THEN RETURN 3.5;
        WHEN 'B' THEN RETURN 3.0;
        WHEN 'C+' THEN RETURN 2.5;
        WHEN 'C' THEN RETURN 2.0;
        WHEN 'D+' THEN RETURN 1.5;
        WHEN 'D' THEN RETURN 1.0;
        WHEN 'F' THEN RETURN 0.0;
        ELSE
            RAISE EXCEPTION 'Invalid grade: %', grade_input;
    END CASE;
END;
$$;

CREATE OR REPLACE PROCEDURE calculate_students_gpa()
LANGUAGE plpgsql
AS $$
DECLARE
    v_student RECORD;
    v_perf RECORD;
    v_total_points NUMERIC;
    v_total_credits NUMERIC;
    v_grade_point NUMERIC;
    v_gpa NUMERIC(4,2);
BEGIN
    FOR v_student IN
        SELECT DISTINCT adm_no FROM stud_mod_performance
    LOOP
        v_total_points := 0;
        v_total_credits := 0;

        FOR v_perf IN
            SELECT smp.grade, m.credit_unit
            FROM stud_mod_performance smp
            JOIN module m ON smp.mod_registered = m.mod_code
            WHERE smp.adm_no = v_student.adm_no
        LOOP
            v_grade_point := get_grade_point(v_perf.grade);
            v_total_points := v_total_points + (v_grade_point * v_perf.credit_unit);
            v_total_credits := v_total_credits + v_perf.credit_unit;
        END LOOP;

        IF v_total_credits > 0 THEN
            v_gpa := v_total_points / v_total_credits;

            UPDATE student
            SET gpa = v_gpa, gpa_last_updated = CURRENT_DATE
            WHERE adm_no = v_student.adm_no;
        END IF;
    END LOOP;
END;
$$;
