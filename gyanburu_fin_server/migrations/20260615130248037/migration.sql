BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "attachment" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "entryId" bigint NOT NULL,
    "kind" text NOT NULL,
    "storagePath" text NOT NULL,
    "fileName" text NOT NULL,
    "contentType" text NOT NULL,
    "sizeBytes" bigint NOT NULL,
    "uploadedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "attachment_entry_idx" ON "attachment" USING btree ("entryId");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "monthly_entry" ADD COLUMN "boletoCode" text;

--
-- MIGRATION VERSION FOR gyanburu_fin
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('gyanburu_fin', '20260615130248037', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260615130248037', "timestamp" = now();

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
