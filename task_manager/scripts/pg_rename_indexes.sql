BEGIN;
--
-- Remove index employee_avatar from employee
--
DROP INDEX IF EXISTS "employee_avatar";
--
-- Remove index employee_curator from employee
--
DROP INDEX IF EXISTS "employee_curator";
--
-- Remove index project_avatar, from project
--
DROP INDEX IF EXISTS "project_avatar,";
--
-- Remove index project_author from project
--
DROP INDEX IF EXISTS "project_author";
--
-- Remove index project_projecttype, from project
--
DROP INDEX IF EXISTS "project_projecttype,";
--
-- Remove index projectemployee_employeetype from projectemployee
--
DROP INDEX IF EXISTS "projectemployee_employeetype";
--
-- Remove index projectemployee_employee from projectemployee
--
DROP INDEX IF EXISTS "projectemployee_employee";
--
-- Remove index task_author from task
--
DROP INDEX IF EXISTS "task_author";
--
-- Remove index task_taskstatus from task
--
DROP INDEX IF EXISTS "task_taskstatus";
--
-- Remove index task_parent from task
--
DROP INDEX IF EXISTS "task_parent";
--
-- Remove index task_project_parent from task
--
DROP INDEX IF EXISTS "task_project_parent";
--
-- Remove index task_executor from task
--
DROP INDEX IF EXISTS "task_executor";
--
-- Remove index task_project_author from task
--
DROP INDEX IF EXISTS "task_project_author";
--
-- Remove index task_project_executor from task
--
DROP INDEX IF EXISTS "task_project_executor";
--
-- Remove index taskcomment_employee from taskcomment
--
DROP INDEX IF EXISTS "taskcomment_employee";
--
-- Remove index taskcomment_project_task from taskcomment
--
DROP INDEX IF EXISTS "taskcomment_project_task";
--
-- Remove index taskemployee_project_employee from taskemployee
--
DROP INDEX IF EXISTS "taskemployee_project_employee";
--
-- Remove index taskemployee_employee from taskemployee
--
DROP INDEX IF EXISTS "taskemployee_employee";
--
-- Remove index taskfile_employee from taskfile
--
DROP INDEX IF EXISTS "taskfile_employee";
--
-- Remove index taskfile_task_comment from taskfile
--
DROP INDEX IF EXISTS "taskfile_task_comment";
--
-- Remove index taskfile_project_task_taskcom from taskfile
--
DROP INDEX IF EXISTS "taskfile_project_task_taskcom";
--
-- Remove index taskstag_name from tasktag
--
DROP INDEX IF EXISTS "taskstag_name";
--
-- Create index employee_avatar_idx on field(s) avatar_id of model employee
--
CREATE INDEX "employee_avatar_idx" ON "employee" ("avatar_id");
--
-- Create index employee_curator_idx on field(s) curator_id of model employee
--
CREATE INDEX "employee_curator_idx" ON "employee" ("curator_id");
--
-- Create index project_avatar_idx, on field(s) avatar_id of model project
--
CREATE INDEX "project_avatar_idx," ON "project" ("avatar_id");
--
-- Create index project_author_idx on field(s) author_id of model project
--
CREATE INDEX "project_author_idx" ON "project" ("author_id");
--
-- Create index project_projecttype_idx, on field(s) project_type_id of model project
--
CREATE INDEX "project_projecttype_idx," ON "project" ("project_type_id");
--
-- Create index projectemployee_employeetype_idx on field(s) employee_type_id of model projectemployee
--
CREATE INDEX "projectemployee_employeetype_idx" ON "project_employee" ("employee_type_id");
--
-- Create index projectemployee_employee_idx on field(s) employee_id of model projectemployee
--
CREATE INDEX "projectemployee_employee_idx" ON "project_employee" ("employee_id");
--
-- Create index task_author_idx on field(s) author_id of model task
--
CREATE INDEX "task_author_idx" ON "task" ("author_id");
--
-- Create index task_taskstatus_idx on field(s) task_status_id of model task
--
CREATE INDEX "task_taskstatus_idx" ON "task" ("task_status_id");
--
-- Create index task_parent_idx on field(s) parent_id of model task
--
CREATE INDEX "task_parent_idx" ON "task" ("parent_id");
--
-- Create index task_project_parent_idx on field(s) project_id, parent_id of model task
--
CREATE INDEX "task_project_parent_idx" ON "task" ("project_id", "parent_id");
--
-- Create index task_executor_idx on field(s) executor_id of model task
--
CREATE INDEX "task_executor_idx" ON "task" ("executor_id");
--
-- Create index task_project_author_idx on field(s) project_id, author_id of model task
--
CREATE INDEX "task_project_author_idx" ON "task" ("project_id", "author_id");
--
-- Create index task_project_executor_idx on field(s) project_id, executor_id of model task
--
CREATE INDEX "task_project_executor_idx" ON "task" ("project_id", "executor_id");
--
-- Create index taskcomment_employee_idx on field(s) employee_id of model taskcomment
--
CREATE INDEX "taskcomment_employee_idx" ON "task_comment" ("employee_id");
--
-- Create index taskcomment_project_task_idx on field(s) project_id, task_id of model taskcomment
--
CREATE INDEX "taskcomment_project_task_idx" ON "task_comment" ("project_id", "task_id");
--
-- Create index taskemployee_project_employee_idx on field(s) project_id, employee_id of model taskemployee
--
CREATE INDEX "taskemployee_project_employee_idx" ON "task_employee" ("project_id", "employee_id");
--
-- Create index taskemployee_employee_idx on field(s) employee_id of model taskemployee
--
CREATE INDEX "taskemployee_employee_idx" ON "task_employee" ("employee_id");
--
-- Create index taskfile_employee_idx on field(s) employee_id of model taskfile
--
CREATE INDEX "taskfile_employee_idx" ON "task_file" ("employee_id");
--
-- Create index taskfile_task_comment_idx on field(s) task_comment_id of model taskfile
--
CREATE INDEX "taskfile_task_comment_idx" ON "task_file" ("task_comment_id");
--
-- Create index taskfile_project_task_taskcomment_idx on field(s) project_id, task_id, task_comment_id of model taskfile
--
CREATE INDEX "taskfile_project_task_taskcomment_idx" ON "task_file" ("project_id", "task_id", "task_comment_id");
--
-- Create index taskstag_name_idx on field(s) name of model tasktag
--
CREATE INDEX "taskstag_name_idx" ON "task_tag" ("name");
COMMIT;
