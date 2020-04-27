\c pt_db

--------------------------------------------

-- credential

-- Select AKA signin

-- logged in version

---------

-- credential(TEXT,int,TEXT,TEXT)

-- change while logged in

CREATE OR REPLACE FUNCTION

pt_schema.credential(_token TEXT, username TEXT, password TEXT) RETURNS TEXT

AS $$

  DECLARE rc TEXT;

  DECLARE payload TEXT;

  DECLARE secret varchar(500);

BEGIN

  -- requires a valid token

  -- returns a user token given the guest token, users pw and un

  --

  -- bad token: unknown role or unknown user

  rc := '{"result":-1}';

  if pt_schema.is_valid_token(_token, 'guest') then

    SELECT crd_row || format('{"id": %s}',crd_id)::jsonb

      into payload FROM pt_schema.credentials

      WHERE crd_email = lower(username)

      AND crd_password = crypt(password, crd_password);

    if FOUND then

      rc := format('{"token":"%s"}', sign(payload::json, current_setting('app.jwt_secret')));

    else

      -- username not found

      rc := '{"result":-2}';

    end if;

  end if;

  RETURN rc;

END;

$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION

  pt_schema.credential(

  TEXT, TEXT, TEXT

  ) TO anonymous;

/*

CREATE OR REPLACE FUNCTION

pt_schema.credential(_token TEXT, username TEXT, password TEXT) RETURNS TEXT

AS $$

  DECLARE rc TEXT;

  DECLARE payload TEXT;

  DECLARE secret varchar(500);

BEGIN

  -- requires a valid token

  -- returns a user token given the guest token, users pw and un

  --

  rc := '{"result":-1}';

  if pt_schema.is_valid_token(_token, 'guest') then

    SELECT '{"id":' || crd_id || ',"username":"' || crd_email || '","role":"' || crd_role || '"}'

      into payload FROM pt_schema.credentials

      WHERE crd_email = lower(username)

      AND crd_password = crypt(password, crd_password);

    if FOUND then

      rc := format('{"token":"%s"}', sign(payload::json, current_setting('app.jwt_secret')));

    else

      rc := '{"result":-2}';

    end if;

  end if;

  RETURN rc;

END;

$$ LANGUAGE plpgsql;

*/

