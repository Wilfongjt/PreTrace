\c pt_db

-------------------------------

-- INSERT

---------

CREATE OR REPLACE FUNCTION

pt_schema.register(

  _token TEXT,

  _app_name TEXT,
  _row JSONB
) RETURNS TEXT

AS $$

    Declare rc TEXT;

    Declare role TEXT;

    Declare id int;

  BEGIN

    rc := '{"result":-1}';

    role := pt_schema.get_role(_token);

    BEGIN

      if pt_schema.is_valid_token(_token,'guest') then

        rc := '{"result",-2}';

        INSERT INTO pt_schema.register(

                reg_app_name, reg_row
          ) VALUES (

                _app_name, _row
          );

          rc := '{"result":1}';

      end if;

    EXCEPTION WHEN unique_violation THEN

      rc := '{"result",-3}';

    END;

    RETURN rc;

  END;

$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION

  pt_schema.register(

    TEXT,
    TEXT,
    JSONB
  ) TO anonymous;

