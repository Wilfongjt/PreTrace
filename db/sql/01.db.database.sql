\c postgres

DROP DATABASE IF EXISTS pt_db;

CREATE DATABASE pt_db;

-- SET DB

\c pt_db

create schema if not exists pt_schema;

create extension IF NOT EXISTS pgcrypto;

CREATE EXTENSION IF NOT EXISTS pgtap;

CREATE EXTENSION IF NOT EXISTS pgjwt;

SET search_path TO pt_schema, public; -- put everything in pt_schema;

-- the following should be set by the admin manually, it is set here for convenience

ALTER DATABASE pt_db SET "app.jwt_secret" TO 'PASSWORD.must.BE.AT.LEAST.32.CHARS.LONG';

ALTER DATABASE pt_db SET "app.lb_register_jwt" TO '{"username":"jwt@register.com","email":"jwt@register.com","password":"PASSWORD.must.BE.AT.LEAST.32.CHARS.LONG","role":"jwt"}';

ALTER DATABASE pt_db SET "app.lb_register_guest" TO '{"username":"guest@register.com","email":"guest@register.com","password":"g1G!gggg","role":"guest"}';

ALTER DATABASE pt_db SET "app.lb_register_editor" TO '{"username":"editor@register.com","email":"editor@register.com","password":"g1G!gggg","role":"editor"}';

ALTER DATABASE pt_db SET "app.lb_register_registrant" TO '{"username":"registrant@register.com","email":"registrant@register.com","password":"g1G!gggg","role":"registrant"}';

ALTER DATABASE pt_db SET "app.lb_register_registrar" TO '{"username":"registrar@register.com","email":"registrar@register.com","password":"g1G!gggg","role":"registrar"}';

ALTER DATABASE pt_db SET "app.lb_register_testuser" TO '{"username":"testuser@register.com","email":"test@register.com","password":"g1G!gggg"}';

ALTER DATABASE pt_db SET "app.lb_web_guest" TO '{"name":"guest@web.com","password":"g1G!gggg","role":"guest"}';

ALTER DATABASE pt_db SET "app.lb_web_guest_role" TO 'guest';

ALTER DATABASE pt_db SET "app.lb_web_guest_password" TO 'g1G!gggg';

ALTER DATABASE pt_db SET "app.lb_admin_registrar_password" TO 'r1R!rrrr';

/*

CREATE OR REPLACE FUNCTION log_last_name_changes()

  RETURNS trigger AS

$BODY$

BEGIN

   IF NEW.last_name <> OLD.last_name THEN

       INSERT INTO employee_audits(employee_id,last_name,changed_on)

       VALUES(OLD.id,OLD.last_name,now());

   END IF;

   RETURN NEW;

END;

$BODY$

*/

