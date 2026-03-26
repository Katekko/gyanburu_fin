BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "bill" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "merchantName" text NOT NULL,
    "amount" double precision NOT NULL,
    "dueAt" timestamp without time zone NOT NULL,
    "status" text NOT NULL,
    "recurrent" boolean NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "budget_category" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "name" text NOT NULL,
    "icon" text NOT NULL,
    "limitAmount" double precision NOT NULL,
    "month" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "financial_transaction" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "nubankAccountId" uuid,
    "merchantName" text NOT NULL,
    "category" text NOT NULL,
    "amount" double precision NOT NULL,
    "currency" text NOT NULL,
    "occurredAt" timestamp without time zone NOT NULL,
    "description" text
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "income_source" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "name" text NOT NULL,
    "type" text NOT NULL,
    "amount" double precision NOT NULL,
    "month" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "nubank_account" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "accountType" text NOT NULL,
    "lastSyncAt" timestamp without time zone,
    "syncStatus" text NOT NULL,
    "consentExpiresAt" timestamp without time zone
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "sync_log" (
    "id" bigserial PRIMARY KEY,
    "nubankAccountId" uuid NOT NULL,
    "syncedAt" timestamp without time zone NOT NULL,
    "status" text NOT NULL,
    "errorMessage" text
);


--
-- MIGRATION VERSION FOR gyanburu_fin
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('gyanburu_fin', '20260326222609811', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260326222609811', "timestamp" = now();

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
