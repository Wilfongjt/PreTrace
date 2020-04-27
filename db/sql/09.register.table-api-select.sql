\c pt_db

-------------------------------

-- Select

---------

CREATE OR REPLACE FUNCTION

pt_schema.register(_token text, id int) RETURNS TEXT

AS $$

  DECLARE rc TEXT;

  DECLARE secret TEXT;

BEGIN

  -- returns a single user's info

  -- need to figure out postgres environment variables

  rc := '{"result":-1}';

  if pt_schema.is_valid_token(_token) then

    select

'"id":"' || reg_id || '",' || '"app_name":"' || reg_app_name || '",' || '"version":"' || reg_version || '",' || '"row":"' || reg_row || '",' || '"created":"' || reg_created || '",' || '"updated":"' || reg_updated || '",' || '"active":"' || reg_active || '"'
    into rc from

    pt_schema.register

    where reg_id=id;

    if rc is NULL then

      rc := '{"result":-1}';

    end if;

  end if;

  RETURN rc;

END;  $$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION

  pt_schema.register(

    TEXT,
    INT
  ) TO anonymous;

