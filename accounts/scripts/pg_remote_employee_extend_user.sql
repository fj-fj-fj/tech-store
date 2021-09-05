BEGIN;
--
-- Add field avatar to user
--
ALTER TABLE "accounts_user" ADD COLUMN "avatar_id" bigint NULL CONSTRAINT "accounts_user_avatar_id_5ce2f0b3_fk_avatar_id" REFERENCES "avatar"("id") DEFERRABLE INITIALLY DEFERRED; SET CONSTRAINTS "accounts_user_avatar_id_5ce2f0b3_fk_avatar_id" IMMEDIATE;
--
-- Add field curator to user
--
ALTER TABLE "accounts_user" ADD COLUMN "curator_id" bigint NULL CONSTRAINT "accounts_user_curator_id_6f1897a5_fk_accounts_user_id" REFERENCES "accounts_user"("id") DEFERRABLE INITIALLY DEFERRED; SET CONSTRAINTS "accounts_user_curator_id_6f1897a5_fk_accounts_user_id" IMMEDIATE;
--
-- Add field deleted to user
--
ALTER TABLE "accounts_user" ADD COLUMN "deleted" boolean DEFAULT false NOT NULL;
ALTER TABLE "accounts_user" ALTER COLUMN "deleted" DROP DEFAULT;
--
-- Add field last_update to user
--
ALTER TABLE "accounts_user" ADD COLUMN "last_update" timestamp with time zone DEFAULT '2021-09-05T21:11:34.833413+00:00'::timestamptz NOT NULL;
ALTER TABLE "accounts_user" ALTER COLUMN "last_update" DROP DEFAULT;
--
-- Add field rate to user
--
ALTER TABLE "accounts_user" ADD COLUMN "rate" double precision DEFAULT 0.0 NOT NULL;
ALTER TABLE "accounts_user" ALTER COLUMN "rate" DROP DEFAULT;
--
-- Create index employee_avatar_idx on field(s) avatar_id of model user
--
CREATE INDEX "employee_avatar_idx" ON "accounts_user" ("avatar_id");
--
-- Create index employee_curator_idx on field(s) curator_id of model user
--
CREATE INDEX "employee_curator_idx" ON "accounts_user" ("curator_id");
CREATE INDEX "accounts_user_avatar_id_5ce2f0b3" ON "accounts_user" ("avatar_id");
CREATE INDEX "accounts_user_curator_id_6f1897a5" ON "accounts_user" ("curator_id");
COMMIT;
