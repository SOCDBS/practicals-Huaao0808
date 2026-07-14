-- Section A: Module CRUD stored procedures

CREATE OR REPLACE PROCEDURE create_module(
    p_code VARCHAR(10),
    p_name VARCHAR(100),
    p_credit INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM module WHERE mod_code = p_code) THEN
        RAISE EXCEPTION 'Module % already exists', p_code;
    END IF;

    INSERT INTO module (mod_code, mod_name, credit_unit)
    VALUES (p_code, p_name, p_credit);
END;
$$;

CREATE OR REPLACE PROCEDURE update_module(
    p_code VARCHAR(10),
    p_credit INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM module WHERE mod_code = p_code) THEN
        RAISE EXCEPTION 'Module % not found', p_code;
    END IF;

    UPDATE module SET credit_unit = p_credit WHERE mod_code = p_code;
END;
$$;

CREATE OR REPLACE PROCEDURE delete_module(
    p_code VARCHAR(10)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM module WHERE mod_code = p_code) THEN
        RAISE EXCEPTION 'Module % not found', p_code;
    END IF;

    DELETE FROM module WHERE mod_code = p_code;
END;
$$;
