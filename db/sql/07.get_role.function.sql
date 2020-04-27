\c pt_db

----------------------------------------------

CREATE OR REPLACE FUNCTION

pt_schema.get_role(_token text) RETURNS TEXT

AS $$

  DECLARE data TEXT;

  DECLARE secret TEXT;

BEGIN

  select payload ->> 'role' as role into data  from verify(_token, current_setting('app.jwt_secret'));

  RETURN data;

END;  $$ LANGUAGE plpgsql;

