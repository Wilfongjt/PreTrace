---- SET DB

\c pt_db

-- TABLE

create table if not exists

pt_schema.register (

  reg_id SERIAL PRIMARY KEY,

  reg_app_name varchar(256) not null check (length(reg_app_name) < 256),

  reg_version varchar(25) not null check (length(reg_version) < 25) DEFAULT '1.0.0',

  reg_row jsonb not null,

  reg_created timestamp without time zone DEFAULT CURRENT_TIMESTAMP,

  reg_updated timestamp without time zone DEFAULT CURRENT_TIMESTAMP,

  reg_active BOOLEAN NOT NULL DEFAULT true

);

-- INDEX

CREATE UNIQUE INDEX IF NOT EXISTS register_reg_id_pkey ON pt_schema.register(reg_id int4_ops);

-- TRIGGER FUNCTION

CREATE OR REPLACE FUNCTION reg_ins_upd_trigger_func() RETURNS trigger

AS $$

BEGIN

   -- create application token

    IF (TG_OP = 'INSERT') THEN

        NEW.reg_token = sign(format('{"app_name":"%s",

          "version":"%s",

          "role":"registrar"}',

          NEW.reg_app_name,

          NEW.reg_version)::json,

          current_setting('app.jwt_secret'), 'HS256'::text);

    ELSEIF (TG_OP = 'UPDATE') THEN

       NEW.reg_updated := CURRENT_TIMESTAMP;

    END IF;

    RETURN NEW;

END; $$ LANGUAGE plpgsql;

-- TRIGGER

CREATE TRIGGER reg_ins_upd_trigger

 BEFORE INSERT ON pt_schema.register

 FOR EACH ROW

 EXECUTE PROCEDURE reg_ins_upd_trigger_func();

