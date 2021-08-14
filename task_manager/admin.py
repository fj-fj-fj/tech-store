from django.contrib import admin

from .models import (
    Avatar,
    Employee,
    EmployeeType,
    Project,
    ProjectEmployee,
    ProjectType,
    Tag,
    Task,
    TaskComment,
    TaskEmployee,
    TaskFile,
    TaskStatus,
    TaskTag,
)


@admin.register(Avatar)
class AvatarAdmin(admin.ModelAdmin):
    pass


@admin.register(Employee)
class EmployeeAdmin(admin.ModelAdmin):
    readonly_fields = ('last_update', 'date_create')


@admin.register(EmployeeType)
class EmployeeTypeAdmin(admin.ModelAdmin):
    pass


@admin.register(Project)
class ProjectAdmin(admin.ModelAdmin):
    readonly_fields = ('last_update', 'date_create')


@admin.register(ProjectEmployee)
class ProjectEmployeeAdmin(admin.ModelAdmin):
    pass


@admin.register(ProjectType)
class ProjectTypeAdmin(admin.ModelAdmin):
    pass


@admin.register(Tag)
class TagAdmin(admin.ModelAdmin):
    pass


@admin.register(Task)
class TaskAdmin(admin.ModelAdmin):
    readonly_fields = ('last_update', 'date_create')


@admin.register(TaskComment)
class TaskCommentAdmin(admin.ModelAdmin):
    readonly_fields = ('last_update', 'date_create')


@admin.register(TaskEmployee)
class TaskEmployeeAdmin(admin.ModelAdmin):
    pass


@admin.register(TaskFile)
class TaskFileAdmin(admin.ModelAdmin):
    readonly_fields = ('last_update', 'date_create')


@admin.register(TaskStatus)
class TaskStatusAdmin(admin.ModelAdmin):
    pass


@admin.register(TaskTag)
class TaskTagAdmin(admin.ModelAdmin):
    pass
