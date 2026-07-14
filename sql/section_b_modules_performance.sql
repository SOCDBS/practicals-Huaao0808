-- Section B: Modules performance report function

CREATE OR REPLACE FUNCTION get_modules_performance()
RETURNS TABLE (
    mod_registered VARCHAR(10),
    grade CHAR(2),
    grade_count BIGINT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        smp.mod_registered,
        smp.grade,
        COUNT(*) AS grade_count
    FROM stud_mod_performance smp
    GROUP BY smp.mod_registered, smp.grade
    ORDER BY smp.grade, grade_count;
END;
$$;
