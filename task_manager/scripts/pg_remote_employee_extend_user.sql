BEGIN;
--
-- Alter field author on project
--
SET CONSTRAINTS "project_author_id_c601d117_fk_accounts_user_id" IMMEDIATE; ALTER TABLE "project" DROP CONSTRAINT "project_author_id_c601d117_fk_accounts_user_id";
ALTER TABLE "project" ADD CONSTRAINT "project_author_id_c601d117_fk_accounts_user_id" FOREIGN KEY ("author_id") REFERENCES "accounts_user" ("id") DEFERRABLE INITIALLY DEFERRED;
--
-- Alter field employee on projectemployee
--
SET CONSTRAINTS "project_employee_employee_id_b6626ada_fk_accounts_user_id" IMMEDIATE; ALTER TABLE "project_employee" DROP CONSTRAINT "project_employee_employee_id_b6626ada_fk_accounts_user_id";
ALTER TABLE "project_employee" ADD CONSTRAINT "project_employee_employee_id_b6626ada_fk_accounts_user_id" FOREIGN KEY ("employee_id") REFERENCES "accounts_user" ("id") DEFERRABLE INITIALLY DEFERRED;
--
-- Alter field employee on taskcomment
--
SET CONSTRAINTS "task_comment_employee_id_6b9554c0_fk_accounts_user_id" IMMEDIATE; ALTER TABLE "task_comment" DROP CONSTRAINT "task_comment_employee_id_6b9554c0_fk_accounts_user_id";
ALTER TABLE "task_comment" ADD CONSTRAINT "task_comment_employee_id_6b9554c0_fk_accounts_user_id" FOREIGN KEY ("employee_id") REFERENCES "accounts_user" ("id") DEFERRABLE INITIALLY DEFERRED;
--
-- Alter field employee on taskemployee
--
SET CONSTRAINTS "task_employee_employee_id_9dec7d10_fk_accounts_user_id" IMMEDIATE; ALTER TABLE "task_employee" DROP CONSTRAINT "task_employee_employee_id_9dec7d10_fk_accounts_user_id";
ALTER TABLE "task_employee" ADD CONSTRAINT "task_employee_employee_id_9dec7d10_fk_accounts_user_id" FOREIGN KEY ("employee_id") REFERENCES "accounts_user" ("id") DEFERRABLE INITIALLY DEFERRED;
--
-- Alter field employee on taskfile
--
SET CONSTRAINTS "task_file_employee_id_20764fa4_fk_accounts_user_id" IMMEDIATE; ALTER TABLE "task_file" DROP CONSTRAINT "task_file_employee_id_20764fa4_fk_accounts_user_id";
ALTER TABLE "task_file" ADD CONSTRAINT "task_file_employee_id_20764fa4_fk_accounts_user_id" FOREIGN KEY ("employee_id") REFERENCES "accounts_user" ("id") DEFERRABLE INITIALLY DEFERRED;
--
-- Delete model Employee
--
DROP TABLE "employee" CASCADE;
COMMIT;
