\c pt_db

CREATE OR REPLACE FUNCTION

reg_schema.credential(_json JSONB) RETURNS JSONB

AS $$

DECLARE _token TEXT;

DECLARE _jwt TEXT;

DECLARE _guest jsonb;

BEGIN

    _guest := current_setting('app.lb_register_guest')::JSONB-'password';

	_jwt := current_setting('app.lb_register_jwt')::JSONB ->> 'password';

	_token := sign(_guest::JSON, _jwt) ;

	return reg_schema.credential(_token, _json);

END;

$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION

  pt_schema.credential(

  JSONB

  ) TO anonymous;

--------------------------------------------

-- Upsert credential

---------

-- credential(TEXT,int,JSONB)

-- update username

-- select jsonb_set('{"username":"b@a.com", "email": "b@a.com", "roles":[]}'::JSONB,'{username}'::TEXT[], '{"username": "a@a.com"}'::JSONB -> 'username' );

-- update email

-- select jsonb_set('{"username":"b@a.com", "email": "b@a.com", "roles":[]}'::JSONB,'{email}'::TEXT[], '{"email": "a@a.com"}'::JSONB -> 'email' );

-- update password

-- select jsonb_set('{"username":"b@a.com", "email": "b@a.com", "roles":[]}'::JSONB,'{email}'::TEXT[], '{"password": "a1A!aaaa"}'::JSONB -> 'password' );

-- add role, SPECIAL CASE

-- select jsonb_insert('{"username":"b@a.com", "email": "b@a.com", "roles":[]}'::JSONB,'{roles, 999}'::TEXT[], '{"role": "guest"}'::JSONB -> 'role' );

-- remove role

--select jsonb_set(

--	'{"username":"b@a.com", "email": "b@a.com", "roles":["guest","reg"]}'::JSONB,

--	'{roles}'::TEXT[],

--	('{"roles":["guest","reg"]}'::jsonb->'roles') - 'guest'

--);

-- add extra attributes

--select jsonb_set(

--	'{"username":"b@a.com", "email": "b@a.com", "roles":["guest","reg"]}'::JSONB,

--	'{roles}'::TEXT[],

--	('{"roles":["guest","reg"]}'::jsonb->'roles') - 'guest'

--);

CREATE OR REPLACE FUNCTION

reg_schema.credential(_token TEXT, _json JSONB) RETURNS JSONB

AS $$

	-- insert {username:"AA@AA.AAA", password:""}

    -- update {id:N, username:"AA@AA.AAA", password: ""}

    Declare rc jsonb;

    Declare _cur_row JSONB;

    -- Declare _username TEXT;

    -- Declare _password TEXT;

    Declare _guest JSONB;

    Declare _registrant JSONB;

Declare _id INTEGER;
Declare _username TEXT;
Declare _password TEXT;
Declare _row JSONB;
Declare _roles JSONB;
Declare _created TIMESTAMP;
Declare _updated TIMESTAMP;
Declare _active BOOLEAN;
  BEGIN

    _guest := current_setting('app.lb_register_guest')::jsonb;

    _registrant :=  current_setting('app.lb_register_registrant')::jsonb;

    -- insert and update tokens are different

    -- insert tokens are an application token

    -- update tokens are a user token

    -- figure out which token: app-token or user-token

    if pt_schema.is_valid_token(_token, _registrant ->> 'role') then

		rc := '{"result":"2"}'::JSONB;

	elsif pt_schema.is_valid_token(_token, _guest ->> 'role') then

		rc := '{"result":"1"}'::JSONB;

    else

        return '{"result": "0"}'::JSONB;

    end if;

    -- required _json insert attributes

    -- update or insert

    if

    	_json ? 'id'

    then

    	--update

    	rc := '{"result":"-2"}'::JSONB;

		-- get current json object

		select crd_row as _usr

		  into _cur_row

		  from pt_schema.credentials

		  where

            crd_id= cast(_json::jsonb ->> 'id' as integer) and crd_username=pt_schema.get_username(_token)::TEXT
            ;
        rc := '{"result":"-2.1"}'::JSONB;

		-- update existing json object

		if _cur_row ? 'username' and _json ? 'username' then

		   _cur_row := jsonb_set(_cur_row, '{username}'::TEXT[], format('"%s"',_username)::jsonb, TRUE) ;

        end if;

		-- if then

		--   _cur_row := jsonb_set(_cur_row, '{email}'::TEXT[], format('"%s"',_email)::jsonb, TRUE) ;

        if _json ? 'username' then

            _username = _json ->> 'username';

        end if;

        _row = _json - 'password';

        -- sync json values to table values

            _username := _json ->> 'username';
            _password := _json ->> 'password';

        BEGIN

            -- update

            ---- expect id in _json

            ---- remove password from _json before updating

            ---- merge roles when needed

            /*

            update pt_schema.credentials

              set

              set-clause

              where

            crd_id= cast(_json::jsonb ->> 'id' as integer) and crd_username=pt_schema.get_username(_token)::TEXT
            ;
            */

            -- update the record

            if

                _json ? 'username' and _json ? 'password'

            then

                update crd_schema.credentials

                  set

                    crd_username=_username, crd_password=_password, crd_row=_row

                  where

            crd_id= cast(_json::jsonb ->> 'id' as integer) and crd_username=pt_schema.get_username(_token)::TEXT
            ;
                    ;

            elsif

                _json ? 'username'

            then

                update crd_schema.credentials

                  set

                    crd_username=_username, crd_row=_row

                  where

            crd_id= cast(_json::jsonb ->> 'id' as integer) and crd_username=pt_schema.get_username(_token)::TEXT
            ;
                    ;

            elsif

                _json ? 'password'

            then

                update crd_schema.credentials

                  set

                    crd_username=_username, crd_password=_password, crd_row=_row

                  where

            crd_id= cast(_json::jsonb ->> 'id' as integer) and crd_username=pt_schema.get_username(_token)::TEXT
            ;
                    ;

            else

                update crd_schema.credentials

                  set

                    crd_row=_row

                  where

            crd_id= cast(_json::jsonb ->> 'id' as integer) and crd_username=pt_schema.get_username(_token)::TEXT
            ;
                    ;

            end if;

        EXCEPTION

		    WHEN check_violation then

		        rc := '{"result":"-2.2"}'::JSONB;

		    WHEN other then

		        rc := '{"result":"-2.2"}'::JSONB;

        END;

		if not FOUND then

		  return format('{"result":"-2.2"}')::JSONB;

		end if;

	    rc := '{"result":"2"}'::JSONB;

    else

    	-- insert

    	-- username

    	-- password

    	-- roles start with registrant

    	-- add user data

    	BEGIN

    	    -- check required attributes

if not(_json ? 'username') then return '{"result":"-1.3"}'::JSONB; end if;
if not(_json ? 'password') then return '{"result":"-1.3"}'::JSONB; end if;
    	    -- set defaults just in case

            _active = true;
            _roles = '["registrant"]'::JSONB;

            -- sync json values to table values

            _username := _json ->> 'username';
            _password := _json ->> 'password';

            -- validate

            if length(_password) < 8 then

                return '{"result":"-1.4"}'::JSONB;

            end if;

            -- remove pw before inserting

    	    _row = _json - 'password';

			rc := '{"result":"1"}'::JSONB;

			--insert-statement

			INSERT

              INTO pt_schema.credentials

              (

                crd_username, crd_password, crd_row
              ) VALUES (

                _username, _password, _row
              );

		EXCEPTION

		    WHEN unique_violation THEN

		        rc := '{"result":"-1.1"}'::JSONB;

		    WHEN check_violation then

		        rc := '{"result":"-1.2"}'::JSONB;

		    WHEN others then

		        rc := '{"result":"-1.3"}'::JSONB;

		END;

    end if;

    RETURN rc;

  END;

$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION

  pt_schema.credential(

  TEXT, JSONB

  ) TO anonymous;

