BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "category_rule" ADD COLUMN "displayName" text;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "financial_transaction" ADD COLUMN "displayName" text;

--
-- MIGRATION VERSION FOR gyanburu_fin
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('gyanburu_fin', '20260331141539427', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260331141539427', "timestamp" = now();

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
