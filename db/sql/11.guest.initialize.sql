\c pt_db

-- select pt_schema.credential(current_setting('app.lb_register_guest')::jsonb);

/*

INSERT INTO pt_schema.credentials(

    crd_email,

    crd_password,

    crd_row

) VALUES (

    'guest@pt.com',

    current_setting('app.lb_web_guest_password'),

    '{"username":"guest@pt.com", "roles": ["guest"]}'::jsonb

);

*/

