\c pt_db

---------------------------------------------

CREATE OR REPLACE FUNCTION

pt_schema.is_valid_token(_token TEXT, role TEXT) RETURNS Boolean

AS $$

  DECLARE good Boolean;

  DECLARE actual_role TEXT;

BEGIN

  -- does role in token match expected role

  -- use db parameter app.jwt_secret

  -- process the token

  -- return true/false

  good:=false;

  select payload ->> 'role' as role into actual_role  from verify(_token, current_setting('app.jwt_secret'));

  if role = actual_role then

    good := true;

  end if;

  RETURN good;

END;  $$ LANGUAGE plpgsql;

--------------------------------------------

/*

CREATE OR REPLACE FUNCTION

pt_schema.is_valid_token(_token text) RETURNS Boolean

AS $$

  DECLARE good Boolean;

  DECLARE secret TEXT;

BEGIN

  -- cloak the secret

  -- process the token

  -- return true/false

  good:=false;

  select valid into good from verify(token, current_setting('app.jwt_secret'));

  RETURN good;

END;  $$ LANGUAGE plpgsql;

*/

