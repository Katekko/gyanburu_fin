BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "monthly_entry" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "monthly_entry" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "categoryId" bigint NOT NULL,
    "name" text NOT NULL,
    "type" text NOT NULL,
    "amount" double precision NOT NULL,
    "month" text NOT NULL,
    "recurrent" boolean NOT NULL,
    "variable" boolean NOT NULL,
    "confirmed" boolean NOT NULL,
    "dueDate" timestamp without time zone,
    "paid" boolean NOT NULL,
    "paidAt" timestamp without time zone,
    "paidAmount" double precision,
    "paymentMethod" text,
    "paymentNote" text
);


--
-- MIGRATION VERSION FOR gyanburu_fin
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('gyanburu_fin', '20260330203448058', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260330203448058', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260213194423028', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260213194423028', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260129181112269', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181112269', "timestamp" = now();


COMMIT;
