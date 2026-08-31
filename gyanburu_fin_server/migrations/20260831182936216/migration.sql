BEGIN;

--
-- The generated DROP TABLE statements for the serverpod_auth_* tables were
-- removed by hand: those tables were intentionally left in place when the
-- identity provider was replaced by a shared secret (commit d444e70) —
-- nothing references them, but dropping them is irreversible. They are
-- absent from this migration's definition.json, so future migrations will
-- not try to drop them again.
--

--
-- ACTION CREATE TABLE
--
CREATE TABLE "benefit_wallet" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "provider" text NOT NULL,
    "slug" text NOT NULL,
    "name" text NOT NULL,
    "anchorBalance" double precision NOT NULL,
    "anchorDate" timestamp without time zone NOT NULL,
    "monthlyTopupAmount" double precision
);

--
-- ACTION ALTER TABLE
--
ALTER TABLE "financial_transaction" ADD COLUMN "walletId" bigint;

--
-- MIGRATION VERSION FOR gyanburu_fin
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('gyanburu_fin', '20260831182936216', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260831182936216', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();


--
-- MIGRATION VERSION FOR 'serverpod_auth_idp', 'serverpod_auth_core'
--
DELETE FROM "serverpod_migrations"WHERE "module" IN ('serverpod_auth_idp', 'serverpod_auth_core');

COMMIT;
