BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "category_rule" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "merchantPattern" text NOT NULL,
    "categoryId" bigint NOT NULL
);

--
-- ACTION ALTER TABLE
--
ALTER TABLE "financial_transaction" ADD COLUMN "externalId" text;
ALTER TABLE "financial_transaction" ADD COLUMN "installmentCurrent" bigint;
ALTER TABLE "financial_transaction" ADD COLUMN "installmentTotal" bigint;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "import_history" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "importedAt" timestamp without time zone NOT NULL,
    "fileName" text NOT NULL,
    "statementStart" timestamp without time zone NOT NULL,
    "statementEnd" timestamp without time zone NOT NULL,
    "totalTransactions" bigint NOT NULL,
    "newTransactions" bigint NOT NULL,
    "skippedDuplicates" bigint NOT NULL,
    "skippedCredits" bigint NOT NULL
);


--
-- MIGRATION VERSION FOR gyanburu_fin
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('gyanburu_fin', '20260331132322289', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260331132322289', "timestamp" = now();

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
