\c pt_db

-- insert a test user

select pt_schema.credential(

	format('{"username":"%s", "password":"%s"}'::TEXT,

			current_setting('app.lb_register_testuser')::jsonb->>'username',

			current_setting('app.lb_register_testuser')::jsonb->>'password'

		  )::JSONB

);

--select pt_schema.credential('"username":(current_setting('app.lb_register_testuser')::jsonb-'password')::jsonb - 'role');

--select pt_schema.credential(current_setting('app.lb_register_guest')::jsonb);

--select pt_schema.credential(current_setting('app.lb_register_jwt')::jsonb);

--select pt_schema.credential(current_setting('app.lb_register_editor')::jsonb);

--select pt_schema.credential(current_setting('app.lb_register_registrant')::jsonb);

--select pt_schema.credential(current_setting('app.lb_register_registrar')::jsonb);

