BEGIN;

--
-- Class Attachment as table attachment
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
-- Class BenefitWallet as table benefit_wallet
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
-- Class Bill as table bill
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
-- Class BudgetCategory as table budget_category
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
-- Class Category as table category
--
CREATE TABLE "category" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "name" text NOT NULL,
    "icon" text NOT NULL,
    "color" text NOT NULL
);

--
-- Class CategoryRule as table category_rule
--
CREATE TABLE "category_rule" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "merchantPattern" text NOT NULL,
    "categoryId" bigint,
    "displayName" text
);

--
-- Class FinancialTransaction as table financial_transaction
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
    "description" text,
    "externalId" text,
    "installmentCurrent" bigint,
    "installmentTotal" bigint,
    "displayName" text,
    "billingMonth" text,
    "source" text,
    "kind" text,
    "walletId" bigint
);

--
-- Class ImportHistory as table import_history
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
-- Class IncomeSource as table income_source
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
-- Class MonthlyEntry as table monthly_entry
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
    "paymentNote" text,
    "boletoCode" text
);

--
-- Class NubankAccount as table nubank_account
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
-- Class SyncLog as table sync_log
--
CREATE TABLE "sync_log" (
    "id" bigserial PRIMARY KEY,
    "nubankAccountId" uuid NOT NULL,
    "syncedAt" timestamp without time zone NOT NULL,
    "status" text NOT NULL,
    "errorMessage" text
);

--
-- Class CloudStorageEntry as table serverpod_cloud_storage
--
CREATE TABLE "serverpod_cloud_storage" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "addedTime" timestamp without time zone NOT NULL,
    "expiration" timestamp without time zone,
    "byteData" bytea NOT NULL,
    "verified" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_path_idx" ON "serverpod_cloud_storage" USING btree ("storageId", "path");
CREATE INDEX "serverpod_cloud_storage_expiration" ON "serverpod_cloud_storage" USING btree ("expiration");

--
-- Class CloudStorageDirectUploadEntry as table serverpod_cloud_storage_direct_upload
--
CREATE TABLE "serverpod_cloud_storage_direct_upload" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL,
    "authKey" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_direct_upload_storage_path" ON "serverpod_cloud_storage_direct_upload" USING btree ("storageId", "path");

--
-- Class FutureCallEntry as table serverpod_future_call
--
CREATE TABLE "serverpod_future_call" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "serializedObject" text,
    "serverId" text NOT NULL,
    "identifier" text
);

-- Indexes
CREATE INDEX "serverpod_future_call_time_idx" ON "serverpod_future_call" USING btree ("time");
CREATE INDEX "serverpod_future_call_serverId_idx" ON "serverpod_future_call" USING btree ("serverId");
CREATE INDEX "serverpod_future_call_identifier_idx" ON "serverpod_future_call" USING btree ("identifier");

--
-- Class ServerHealthConnectionInfo as table serverpod_health_connection_info
--
CREATE TABLE "serverpod_health_connection_info" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "active" bigint NOT NULL,
    "closing" bigint NOT NULL,
    "idle" bigint NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_connection_info_timestamp_idx" ON "serverpod_health_connection_info" USING btree ("timestamp", "serverId", "granularity");

--
-- Class ServerHealthMetric as table serverpod_health_metric
--
CREATE TABLE "serverpod_health_metric" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "isHealthy" boolean NOT NULL,
    "value" double precision NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_metric_timestamp_idx" ON "serverpod_health_metric" USING btree ("timestamp", "serverId", "name", "granularity");

--
-- Class LogEntry as table serverpod_log
--
CREATE TABLE "serverpod_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "reference" text,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "logLevel" bigint NOT NULL,
    "message" text NOT NULL,
    "error" text,
    "stackTrace" text,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_log_sessionLogId_idx" ON "serverpod_log" USING btree ("sessionLogId");

--
-- Class MessageLogEntry as table serverpod_message_log
--
CREATE TABLE "serverpod_message_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "serverId" text NOT NULL,
    "messageId" bigint NOT NULL,
    "endpoint" text NOT NULL,
    "messageName" text NOT NULL,
    "duration" double precision NOT NULL,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

--
-- Class MethodInfo as table serverpod_method
--
CREATE TABLE "serverpod_method" (
    "id" bigserial PRIMARY KEY,
    "endpoint" text NOT NULL,
    "method" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_method_endpoint_method_idx" ON "serverpod_method" USING btree ("endpoint", "method");

--
-- Class DatabaseMigrationVersion as table serverpod_migrations
--
CREATE TABLE "serverpod_migrations" (
    "id" bigserial PRIMARY KEY,
    "module" text NOT NULL,
    "version" text NOT NULL,
    "timestamp" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_migrations_ids" ON "serverpod_migrations" USING btree ("module");

--
-- Class QueryLogEntry as table serverpod_query_log
--
CREATE TABLE "serverpod_query_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "query" text NOT NULL,
    "duration" double precision NOT NULL,
    "numRows" bigint,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_query_log_sessionLogId_idx" ON "serverpod_query_log" USING btree ("sessionLogId");

--
-- Class ReadWriteTestEntry as table serverpod_readwrite_test
--
CREATE TABLE "serverpod_readwrite_test" (
    "id" bigserial PRIMARY KEY,
    "number" bigint NOT NULL
);

--
-- Class RuntimeSettings as table serverpod_runtime_settings
--
CREATE TABLE "serverpod_runtime_settings" (
    "id" bigserial PRIMARY KEY,
    "logSettings" json NOT NULL,
    "logSettingsOverrides" json NOT NULL,
    "logServiceCalls" boolean NOT NULL,
    "logMalformedCalls" boolean NOT NULL
);

--
-- Class SessionLogEntry as table serverpod_session_log
--
CREATE TABLE "serverpod_session_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "module" text,
    "endpoint" text,
    "method" text,
    "duration" double precision,
    "numQueries" bigint,
    "slow" boolean,
    "error" text,
    "stackTrace" text,
    "authenticatedUserId" bigint,
    "userId" text,
    "isOpen" boolean,
    "touched" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_session_log_serverid_idx" ON "serverpod_session_log" USING btree ("serverId");
CREATE INDEX "serverpod_session_log_time_idx" ON "serverpod_session_log" USING btree ("time");
CREATE INDEX "serverpod_session_log_touched_idx" ON "serverpod_session_log" USING btree ("touched");
CREATE INDEX "serverpod_session_log_isopen_idx" ON "serverpod_session_log" USING btree ("isOpen");

--
-- Foreign relations for "serverpod_log" table
--
ALTER TABLE ONLY "serverpod_log"
    ADD CONSTRAINT "serverpod_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_message_log" table
--
ALTER TABLE ONLY "serverpod_message_log"
    ADD CONSTRAINT "serverpod_message_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_query_log" table
--
ALTER TABLE ONLY "serverpod_query_log"
    ADD CONSTRAINT "serverpod_query_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


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


COMMIT;
