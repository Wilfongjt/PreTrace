---- SET DB

\c pt_db

/*

-- Create Table

-- c: email, password, access, active

-- Alter access default  {roles:[]}

-- Create Index for primary key

-- Create Index for unique email

-- Create Insert Trigger, intercept new password and encrypt

-- Create Update Trigger, intercept new password and encrypt, set update to current time

*/

create table if not exists

pt_schema.credentials (

  crd_id SERIAL PRIMARY KEY,

  crd_username varchar(256) check ( crd_username ~* '^.+@.+\..+$' ),

  crd_password varchar(256) not null,

  crd_row jsonb not null,

  crd_created timestamp without time zone DEFAULT CURRENT_TIMESTAMP,

  crd_updated timestamp without time zone DEFAULT CURRENT_TIMESTAMP,

  crd_active BOOLEAN NOT NULL DEFAULT true

);

CREATE UNIQUE INDEX IF NOT EXISTS credentials_crd_id_pkey ON pt_schema.credentials(crd_id int4_ops);

CREATE UNIQUE INDEX IF NOT EXISTS index_credentials_on_crd_username ON pt_schema.credentials(crd_username text_ops);

-- add default value

ALTER TABLE pt_schema.credentials ALTER COLUMN crd_row SET DEFAULT '{"username": "", "email":"", "roles":["registrant"]}'::JSONB;

-- insert update trigger

CREATE OR REPLACE FUNCTION crd_ins_upd_trigger_func() RETURNS trigger

AS $$

BEGIN

   -- encrypt password

   IF (TG_OP = 'INSERT') THEN

       NEW.crd_password := crypt(NEW.crd_password, gen_salt('bf', 8));

       NEW.crd_row := NEW.crd_row::JSONB - 'password';

   ELSEIF (TG_OP = 'UPDATE') THEN

       -- NEW.crd_password := crypt(NEW.crd_password, gen_salt('bf', 8));

       NEW.crd_updated := CURRENT_TIMESTAMP;

   END IF;

   RETURN NEW;

END; $$ LANGUAGE plpgsql;

-- set insert trigger

CREATE TRIGGER crd_ins_upd_trigger

 BEFORE INSERT OR UPDATE ON pt_schema.credentials

 FOR EACH ROW

 EXECUTE PROCEDURE crd_ins_upd_trigger_func();

-- insert trigger

/*

CREATE OR REPLACE FUNCTION crd_ins_trigger_func() RETURNS trigger

AS $$

BEGIN

   -- encrypt password

   NEW.crd_password := crypt(NEW.crd_password, gen_salt('bf', 8));

   NEW.crd_active := false;

   RETURN NEW;

END; $$ LANGUAGE plpgsql;

-- set insert trigger

CREATE TRIGGER crd_ins_trigger

 BEFORE INSERT ON pt_schema.credentials

 FOR EACH ROW

 EXECUTE PROCEDURE crd_ins_trigger_func();

 -- Create UPDATE trigger

CREATE OR REPLACE FUNCTION crd_upd_trigger_func() RETURNS trigger

AS $$

BEGIN

   -- encrypt password

   NEW.crd_password := crypt(NEW.crd_password, gen_salt('bf', 8));

   NEW.crd_updated := CURRENT_TIMESTAMP;

   NEW.crd_active := false;

   RETURN NEW;

END; $$ LANGUAGE plpgsql;

-- set UPDATE trigger

CREATE TRIGGER crd_upd_trigger

 BEFORE UPDATE ON pt_schema.credentials

 FOR EACH ROW

 EXECUTE PROCEDURE crd_upd_trigger_func();

 */

