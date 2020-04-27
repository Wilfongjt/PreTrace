\c pt_db

----------------------------------------------

/*

CREATE OR REPLACE FUNCTION

pt_schema.validate_password(password text) RETURNS BOOLEAN

AS $$

  DECLARE rc BOOLEAN;

BEGIN

  if length(password) < 8 then

    return false;

  end if;

  if length(password) >512 then

    return false;

  end if;

  RETURN true;

END;  $$ LANGUAGE plpgsql;

*/

