\c pt_db

select '##### Credential TESTS';

BEGIN;

SELECT plan(2);

--SELECT

-- credential(TEXT,TEXT)

-- credential(_token, user)

select '###### Credential Select';

--  #

--  #

--  #

select '############################################# * Insert bad token, bad user, bad password';

SELECT is(

  pt_schema.credential(

    sign('{"username":"guest@register.com","role":"badguest"}'::json,current_setting('app.jwt_secret')),

    '{"username":"bad_register.com","password":"xxxxx"}'::jsonb

  )::JSONB,

  '{"result":"0"}'::JSONB,

  'credential bad@register.com not found SELECT'::TEXT

)::TEXT;

--  ##

--   ##

--  ##

select '############################################# * Insert token, bad user, good password';

SELECT is(

  pt_schema.credential(

    sign(

      '{"username":"guest@register.com","role":"guest"}'::json,current_setting('app.jwt_secret')

    )::TEXT,

    '{"username":"bad-register.com","password":"xxxxxxxx"}'::jsonb

  )::JSONB,

  '{"result":"-1.2"}'::JSONB,

  'credential bad-register.com not found SELECT')::TEXT;

--  ###

--  ###

--  ###

select '############################################## * Insert good token, good user, bad password';

SELECT is(

  pt_schema.credential(

    sign(

      '{"username":"guest@register.com","role":"guest"}'::json,current_setting('app.jwt_secret')

    ),

    '{"username":"bad@register.com","password":"xxxxx"}'::jsonb

  )::JSONB,

  '{"result":"-1.4"}'::JSONB,

  'credential bad@register.com not found SELECT')::TEXT;

-- UPDATE

-- usr_id value isnt predictable

-- update credential

-- credential(TEXT, int, TEXT,TEXT)

--  # #

--  ####

--    #

/*

sign('{"username":"guest@register.com","role":"guest"}'::json,current_setting('app.jwt_secret'));

select '###### Credential User Upsert insert';

SELECT is(

  pt_schema.credential(

    ,

    '{"username": "testuser@register.com","email": "testuser@register.com", "password":"a1A!aaaa"}'::jsonb

  )::JSONB,

  '{"result":"1"}'::JSONB,

  'Credential guest@register.com UPSERT'

);

*/

--  #####

--  #####

--  #####

select '############################################## Update testuser password';

SELECT is(

  pt_schema.credential(

    sign('{"username":"testuser@register.com","role":"registrant"}'::json,current_setting('app.jwt_secret')),

    '{"id":1, "username": "testuser@register.com", "password":"a1A!aaaa"}'::jsonb

  )::JSONB,

  '{"result":"2"}'::JSONB,

  'Credential testuser@request.com UPSERT'

);

select '############################################# Update testuser username';

-- update username

SELECT is(

  pt_schema.credential(

    sign('{"username":"testuser@register.com","role":"registrant"}'::json,current_setting('app.jwt_secret')),

    '{"id":1, "username": "update-testuser@register.com"}'::jsonb

  )::JSONB,

  '{"result":"2"}'::JSONB,

  'Credential testuser@request.com >> update-testuser@register.com"UPSERT'

);

select '#############################################';

-- update email

-- update password

-- add role, SPECIAL CASE

-- remove role

-- add extra attributes

-- update all

SELECT * FROM finish();

select '##### Credential TESTS Done';

ROLLBACK;

