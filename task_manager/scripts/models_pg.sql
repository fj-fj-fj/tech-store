BEGIN;
--
-- Create model Avatar
--
CREATE TABLE "avatar" ("id" bigserial NOT NULL PRIMARY KEY, "name" varchar(100) NOT NULL, "url" varchar(200) NOT NULL);
--
-- Create model Employee
--
CREATE TABLE "employee" ("id" bigserial NOT NULL PRIMARY KEY, "name" varchar(100) NOT NULL, "username" varchar(200) NOT NULL, "password" varchar(250) NOT NULL, "date_create" timestamp with time zone NOT NULL, "last_update" timestamp with time zone NOT NULL, "email" varchar(150) NOT NULL, "actived" boolean NOT NULL, "deleted" boolean NOT NULL, "rate" double precision NOT NULL, "avatar_id" bigint NOT NULL, "curator_id" bigint NULL);
--
-- Create model EmployeeType
--
CREATE TABLE "employee_type" ("id" bigserial NOT NULL PRIMARY KEY, "name" varchar(100) NOT NULL);
--
-- Create model Project
--
CREATE TABLE "project" ("id" bigserial NOT NULL PRIMARY KEY, "name" varchar(100) NOT NULL, "prefix" varchar(3) NOT NULL, "description" varchar(250) NOT NULL, "date_create" timestamp with time zone NOT NULL, "actived" boolean NOT NULL, "deleted" boolean NOT NULL, "last_update" timestamp with time zone NOT NULL, "author_id" bigint NOT NULL, "avatar_id" bigint NOT NULL);
--
-- Create model ProjectEmployee
--
CREATE TABLE "project_employee" ("id" bigserial NOT NULL PRIMARY KEY, "employee_id" bigint NOT NULL, "employee_type_id" bigint NOT NULL, "project_id" bigint NOT NULL UNIQUE);
--
-- Create model ProjectType
--
CREATE TABLE "project_type" ("id" bigserial NOT NULL PRIMARY KEY, "name" varchar(100) NOT NULL, "description" varchar(250) NOT NULL);
--
-- Create model Tag
--
CREATE TABLE "tag" ("name" varchar(20) NOT NULL PRIMARY KEY);
--
-- Create model Task
--
CREATE TABLE "task" ("id" bigserial NOT NULL PRIMARY KEY, "date_create" timestamp with time zone NOT NULL, "name" varchar(150) NOT NULL, "description" varchar(250) NOT NULL, "last_update" timestamp with time zone NOT NULL, "author_id" bigint NOT NULL, "executor_id" bigint NOT NULL, "parent_id" bigint NULL, "project_id" bigint NOT NULL UNIQUE);
--
-- Create model TaskComment
--
CREATE TABLE "task_comment" ("id" bigserial NOT NULL PRIMARY KEY, "date_create" timestamp with time zone NOT NULL, "comment" varchar(250) NOT NULL, "last_update" timestamp with time zone NOT NULL, "employee_id" bigint NOT NULL, "project_id" bigint NOT NULL, "task_id" bigint NOT NULL UNIQUE);
--
-- Create model TaskStatus
--
CREATE TABLE "task_status" ("id" bigserial NOT NULL PRIMARY KEY, "name" varchar(100) NOT NULL, "description" varchar(250) NOT NULL);
--
-- Create model TaskTag
--
CREATE TABLE "task_tag" ("id" bigserial NOT NULL PRIMARY KEY, "name" varchar(20) NOT NULL, "project_id" bigint NOT NULL UNIQUE, "task_id" bigint NOT NULL);
--
-- Create model TaskFile
--
CREATE TABLE "task_file" ("id" bigserial NOT NULL PRIMARY KEY, "filename" varchar(200) NOT NULL, "date_create" timestamp with time zone NOT NULL, "last_update" timestamp with time zone NOT NULL, "employee_id" bigint NOT NULL, "project_id" bigint NOT NULL UNIQUE, "task_id" bigint NOT NULL, "task_comment_id" bigint NULL);
--
-- Create model TaskEmployee
--
CREATE TABLE "task_employee" ("id" bigserial NOT NULL PRIMARY KEY, "employee_id" bigint NOT NULL, "project_id" bigint NOT NULL UNIQUE, "task_id" bigint NOT NULL);
--
-- Add field task_status to task
--
ALTER TABLE "task" ADD COLUMN "task_status_id" bigint NOT NULL CONSTRAINT "task_task_status_id_faabfc30_fk_task_status_id" REFERENCES "task_status"("id") DEFERRABLE INITIALLY DEFERRED; SET CONSTRAINTS "task_task_status_id_faabfc30_fk_task_status_id" IMMEDIATE;
--
-- Add field project_type to project
--
ALTER TABLE "project" ADD COLUMN "project_type_id" bigint NOT NULL CONSTRAINT "project_project_type_id_44f37a37_fk_project_type_id" REFERENCES "project_type"("id") DEFERRABLE INITIALLY DEFERRED; SET CONSTRAINTS "project_project_type_id_44f37a37_fk_project_type_id" IMMEDIATE;
--
-- Create index taskstag_name on field(s) name of model tasktag
--
CREATE INDEX "taskstag_name" ON "task_tag" ("name");
--
-- Create constraint uk_project_task_name on model tasktag
--
ALTER TABLE "task_tag" ADD CONSTRAINT "uk_project_task_name" UNIQUE ("project_id", "task_id", "name");
--
-- Create index taskfile_employee on field(s) employee_id of model taskfile
--
CREATE INDEX "taskfile_employee" ON "task_file" ("employee_id");
--
-- Create index taskfile_task_comment on field(s) task_comment_id of model taskfile
--
CREATE INDEX "taskfile_task_comment" ON "task_file" ("task_comment_id");
--
-- Create index taskfile_project_task_taskcom on field(s) project_id, task_id, task_comment_id of model taskfile
--
CREATE INDEX "taskfile_project_task_taskcom" ON "task_file" ("project_id", "task_id", "task_comment_id");
--
-- Create constraint uk_project_task_id on model taskfile
--
ALTER TABLE "task_file" ADD CONSTRAINT "uk_project_task_id" UNIQUE ("project_id", "task_id", "id");
--
-- Create index taskemployee_project_employee on field(s) project_id, employee_id of model taskemployee
--
CREATE INDEX "taskemployee_project_employee" ON "task_employee" ("project_id", "employee_id");
--
-- Create index taskemployee_employee on field(s) employee_id of model taskemployee
--
CREATE INDEX "taskemployee_employee" ON "task_employee" ("employee_id");
--
-- Create constraint uk_project_task_employee on model taskemployee
--
ALTER TABLE "task_employee" ADD CONSTRAINT "uk_project_task_employee" UNIQUE ("project_id", "task_id", "employee_id");
--
-- Create index taskcomment_employee on field(s) employee_id of model taskcomment
--
CREATE INDEX "taskcomment_employee" ON "task_comment" ("employee_id");
--
-- Create index taskcomment_project_task on field(s) project_id, task_id of model taskcomment
--
CREATE INDEX "taskcomment_project_task" ON "task_comment" ("project_id", "task_id");
--
-- Create constraint uk_task_project_id on model taskcomment
--
ALTER TABLE "task_comment" ADD CONSTRAINT "uk_task_project_id" UNIQUE ("task_id", "project_id", "id");
--
-- Create index task_author on field(s) author_id of model task
--
CREATE INDEX "task_author" ON "task" ("author_id");
--
-- Create index task_taskstatus on field(s) task_status_id of model task
--
CREATE INDEX "task_taskstatus" ON "task" ("task_status_id");
--
-- Create index task_parent on field(s) parent_id of model task
--
CREATE INDEX "task_parent" ON "task" ("parent_id");
--
-- Create index task_project_parent on field(s) project_id, parent_id of model task
--
CREATE INDEX "task_project_parent" ON "task" ("project_id", "parent_id");
--
-- Create index task_executor on field(s) executor_id of model task
--
CREATE INDEX "task_executor" ON "task" ("executor_id");
--
-- Create index task_project_author on field(s) project_id, author_id of model task
--
CREATE INDEX "task_project_author" ON "task" ("project_id", "author_id");
--
-- Create index task_project_executor on field(s) project_id, executor_id of model task
--
CREATE INDEX "task_project_executor" ON "task" ("project_id", "executor_id");
--
-- Create constraint uk_project_project_id on model task
--
ALTER TABLE "task" ADD CONSTRAINT "uk_project_project_id" UNIQUE ("project_id", "id");
--
-- Create index projectemployee_employeetype on field(s) employee_type_id of model projectemployee
--
CREATE INDEX "projectemployee_employeetype" ON "project_employee" ("employee_type_id");
--
-- Create index projectemployee_employee on field(s) employee_id of model projectemployee
--
CREATE INDEX "projectemployee_employee" ON "project_employee" ("employee_id");
--
-- Create constraint uk_project_employee on model projectemployee
--
ALTER TABLE "project_employee" ADD CONSTRAINT "uk_project_employee" UNIQUE ("project_id", "employee_id");
--
-- Create index project_avatar, on field(s) avatar_id of model project
--
CREATE INDEX "project_avatar," ON "project" ("avatar_id");
--
-- Create index project_author on field(s) author_id of model project
--
CREATE INDEX "project_author" ON "project" ("author_id");
--
-- Create index project_projecttype, on field(s) project_type_id of model project
--
CREATE INDEX "project_projecttype," ON "project" ("project_type_id");
--
-- Create index employee_avatar on field(s) avatar_id of model employee
--
CREATE INDEX "employee_avatar" ON "employee" ("avatar_id");
--
-- Create index employee_curator on field(s) curator_id of model employee
--
CREATE INDEX "employee_curator" ON "employee" ("curator_id");
ALTER TABLE "employee" ADD CONSTRAINT "employee_avatar_id_e759a511_fk_avatar_id" FOREIGN KEY ("avatar_id") REFERENCES "avatar" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "employee" ADD CONSTRAINT "employee_curator_id_2e928131_fk_employee_id" FOREIGN KEY ("curator_id") REFERENCES "employee" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "employee_avatar_id_e759a511" ON "employee" ("avatar_id");
CREATE INDEX "employee_curator_id_2e928131" ON "employee" ("curator_id");
ALTER TABLE "project" ADD CONSTRAINT "project_author_id_c601d117_fk_employee_id" FOREIGN KEY ("author_id") REFERENCES "employee" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "project" ADD CONSTRAINT "project_avatar_id_99346b3e_fk_avatar_id" FOREIGN KEY ("avatar_id") REFERENCES "avatar" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "project_author_id_c601d117" ON "project" ("author_id");
CREATE INDEX "project_avatar_id_99346b3e" ON "project" ("avatar_id");
ALTER TABLE "project_employee" ADD CONSTRAINT "project_employee_employee_id_b6626ada_fk_employee_id" FOREIGN KEY ("employee_id") REFERENCES "employee" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "project_employee" ADD CONSTRAINT "project_employee_employee_type_id_66922d34_fk_employee_type_id" FOREIGN KEY ("employee_type_id") REFERENCES "employee_type" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "project_employee" ADD CONSTRAINT "project_employee_project_id_c8066c65_fk_project_id" FOREIGN KEY ("project_id") REFERENCES "project" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "project_employee_employee_id_b6626ada" ON "project_employee" ("employee_id");
CREATE INDEX "project_employee_employee_type_id_66922d34" ON "project_employee" ("employee_type_id");
CREATE INDEX "tag_name_614c79eb_like" ON "tag" ("name" varchar_pattern_ops);
ALTER TABLE "task" ADD CONSTRAINT "task_author_id_e7718337_fk_project_employee_id" FOREIGN KEY ("author_id") REFERENCES "project_employee" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "task" ADD CONSTRAINT "task_executor_id_24a67329_fk_project_employee_id" FOREIGN KEY ("executor_id") REFERENCES "project_employee" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "task" ADD CONSTRAINT "task_parent_id_6630f82a_fk_task_id" FOREIGN KEY ("parent_id") REFERENCES "task" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "task" ADD CONSTRAINT "task_project_id_963d6354_fk_project_employee_id" FOREIGN KEY ("project_id") REFERENCES "project_employee" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "task_author_id_e7718337" ON "task" ("author_id");
CREATE INDEX "task_executor_id_24a67329" ON "task" ("executor_id");
CREATE INDEX "task_parent_id_6630f82a" ON "task" ("parent_id");
ALTER TABLE "task_comment" ADD CONSTRAINT "task_comment_employee_id_6b9554c0_fk_employee_id" FOREIGN KEY ("employee_id") REFERENCES "employee" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "task_comment" ADD CONSTRAINT "task_comment_project_id_bcfcc52b_fk_project_id" FOREIGN KEY ("project_id") REFERENCES "project" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "task_comment" ADD CONSTRAINT "task_comment_task_id_945d80b8_fk_task_id" FOREIGN KEY ("task_id") REFERENCES "task" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "task_comment_employee_id_6b9554c0" ON "task_comment" ("employee_id");
CREATE INDEX "task_comment_project_id_bcfcc52b" ON "task_comment" ("project_id");
ALTER TABLE "task_tag" ADD CONSTRAINT "task_tag_name_b591733e_fk_tag_name" FOREIGN KEY ("name") REFERENCES "tag" ("name") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "task_tag" ADD CONSTRAINT "task_tag_project_id_81e334e4_fk_project_id" FOREIGN KEY ("project_id") REFERENCES "project" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "task_tag" ADD CONSTRAINT "task_tag_task_id_0161b04e_fk_task_id" FOREIGN KEY ("task_id") REFERENCES "task" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "task_tag_name_b591733e" ON "task_tag" ("name");
CREATE INDEX "task_tag_name_b591733e_like" ON "task_tag" ("name" varchar_pattern_ops);
CREATE INDEX "task_tag_task_id_0161b04e" ON "task_tag" ("task_id");
ALTER TABLE "task_file" ADD CONSTRAINT "task_file_employee_id_20764fa4_fk_employee_id" FOREIGN KEY ("employee_id") REFERENCES "employee" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "task_file" ADD CONSTRAINT "task_file_project_id_775eeedc_fk_task_comment_id" FOREIGN KEY ("project_id") REFERENCES "task_comment" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "task_file" ADD CONSTRAINT "task_file_task_id_12d88af7_fk_task_comment_id" FOREIGN KEY ("task_id") REFERENCES "task_comment" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "task_file" ADD CONSTRAINT "task_file_task_comment_id_b4d20d5f_fk_task_comment_id" FOREIGN KEY ("task_comment_id") REFERENCES "task_comment" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "task_file_employee_id_20764fa4" ON "task_file" ("employee_id");
CREATE INDEX "task_file_task_id_12d88af7" ON "task_file" ("task_id");
CREATE INDEX "task_file_task_comment_id_b4d20d5f" ON "task_file" ("task_comment_id");
ALTER TABLE "task_employee" ADD CONSTRAINT "task_employee_employee_id_9dec7d10_fk_employee_id" FOREIGN KEY ("employee_id") REFERENCES "employee" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "task_employee" ADD CONSTRAINT "task_employee_project_id_f4d2b811_fk_project_id" FOREIGN KEY ("project_id") REFERENCES "project" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "task_employee" ADD CONSTRAINT "task_employee_task_id_049f608d_fk_task_id" FOREIGN KEY ("task_id") REFERENCES "task" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "task_employee_employee_id_9dec7d10" ON "task_employee" ("employee_id");
CREATE INDEX "task_employee_task_id_049f608d" ON "task_employee" ("task_id");
CREATE INDEX "task_task_status_id_faabfc30" ON "task" ("task_status_id");
CREATE INDEX "project_project_type_id_44f37a37" ON "project" ("project_type_id");
COMMIT;
