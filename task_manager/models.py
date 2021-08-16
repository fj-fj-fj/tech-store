from django.db import models


class Avatar(models.Model):

    id = models.BigAutoField('Идентификатор', primary_key=True)
    name = models.CharField('Наименование', max_length=100)
    url = models.CharField('Ссылка', max_length=200)

    def __str__(self) -> str:
        return self.name

    class Meta:
        db_table = 'avatar'
        verbose_name = 'Аватар'
        verbose_name_plural = 'Аватары'


class Employee(models.Model):

    id = models.BigAutoField('Идентификатор', primary_key=True)
    name = models.CharField('Никнэйм', max_length=100, default='')
    username = models.CharField('Имя', max_length=200, default='')
    password = models.CharField('Пароль', max_length=250)
    date_create = models.DateTimeField('Дата создания', auto_now_add=True)
    curator = models.ForeignKey(
        'self',
        on_delete=models.DO_NOTHING,
        blank=True,
        null=True,
        verbose_name='Идентификатор куратор'
    )
    last_update = models.DateTimeField('Обновлён', auto_now=True)
    email = models.CharField('Почта', max_length=150, default='')
    avatar = models.ForeignKey(
        Avatar,
        on_delete=models.DO_NOTHING,
        verbose_name='Идентификатор аватара'
    )
    actived = models.BooleanField('Активен', default=True)
    deleted = models.BooleanField('Удалён', default=False)
    rate = models.FloatField('Рэйтинг', default=0.)

    def __str__(self) -> str:
        return f'Сотрудник: {self.username} | Ник: {self.name}'

    class Meta:
        db_table = 'employee'
        verbose_name = 'Сотрудник'
        verbose_name_plural = 'Сотрудники'
        indexes = [
            models.indexes.Index(fields=['avatar_id']),
            models.indexes.Index(
                fields=['curator_id'],
                name='curator_employee_id',
            ),
        ]


class EmployeeType(models.Model):

    id = models.BigAutoField('Идентификатор', primary_key=True)
    name = models.CharField('Наименование', max_length=100)

    def __str__(self) -> str:
        return self.name

    class Meta:
        db_table = 'employee_type'
        verbose_name = 'Должность'
        verbose_name_plural = 'Должности'


class Project(models.Model):

    id = models.BigAutoField('Идентификатор', primary_key=True)
    project_type = models.ForeignKey(
        'ProjectType',
        on_delete=models.DO_NOTHING,
        verbose_name='Тип проекта'
    )
    name = models.CharField('Наименование', max_length=100)
    prefix = models.CharField('Префикс задач', max_length=3)
    description = models.CharField('Описание', max_length=250)
    date_create = models.DateTimeField('Дата создания', auto_now_add=True)
    author = models.ForeignKey(
        Employee,
        on_delete=models.DO_NOTHING,
        verbose_name='Создатель сотрудник'
    )
    avatar = models.ForeignKey(
        Avatar,
        on_delete=models.DO_NOTHING,
        verbose_name='Аватар проекта'
    )
    actived = models.BooleanField('Активен', default=True)
    deleted = models.BooleanField('Удалён', default=False)
    last_update = models.DateTimeField('Обновлён', auto_now=True)

    def __str__(self) -> str:
        return f'Проект: {self.name}, автор: {self.author.name}'

    class Meta:
        db_table = 'project'
        verbose_name = 'Проект'
        verbose_name_plural = 'Проекты'
        indexes = [
            models.indexes.Index(fields=['avatar_id']),
            models.indexes.Index(
                fields=['author_id'],
                name='author_employee_id',
            ),
            models.indexes.Index(fields=['project_type_id']),
        ]


class ProjectEmployee(models.Model):

    project = models.OneToOneField(
        Project,
        on_delete=models.DO_NOTHING,
        verbose_name='Проект'
    )
    employee = models.ForeignKey(
        Employee,
        on_delete=models.DO_NOTHING,
        verbose_name='Сотрудник'
    )
    employee_type = models.ForeignKey(
        EmployeeType,
        on_delete=models.DO_NOTHING,
        verbose_name='Квалификация'
    )

    def __str__(self) -> str:
        return f'Сотрудник: {self.employee.name} в проекте: {self.project.name}'

    class Meta:
        db_table = 'project_employee'
        constraints = [
            models.UniqueConstraint(
                fields=['project', 'employee'],
                name='project_employee_id',
            ),
        ]
        verbose_name = 'Менеджер с доступным проектом'
        verbose_name_plural = 'Менеджеры с доступными проектами'
        indexes = [
            models.indexes.Index(fields=['employee_type_id']),
            models.indexes.Index(fields=['employee_id']),
        ]


class ProjectType(models.Model):

    id = models.BigAutoField('Идентификатор', primary_key=True)
    name = models.CharField('Наименование', max_length=100)
    description = models.CharField('Описание', max_length=250)

    def __str__(self) -> str:
        return f'Тип проекта: {self.name}'

    class Meta:
        db_table = 'project_type'
        verbose_name = 'Тип проекта'
        verbose_name_plural = 'Типы проектов'


class Tag(models.Model):

    name = models.CharField('Название тэга', primary_key=True, max_length=20)

    def __str__(self) -> str:
        return f'Тэг: {self.name}'

    class Meta:
        db_table = 'tag'
        verbose_name = 'Тэг'
        verbose_name_plural = 'Тэги'


class Task(models.Model):

    id = models.IntegerField('Идентификатор', primary_key=True)
    date_create = models.DateTimeField('Дата создания', auto_now_add=True)
    project = models.OneToOneField(
        ProjectEmployee,
        related_name='related_project',
        on_delete=models.DO_NOTHING,
        verbose_name='Идентификатор проекта'
    )
    parent = models.ForeignKey(
        'self',
        on_delete=models.DO_NOTHING,
        blank=True,
        null=True,
        verbose_name='Предыдущая задача'
    )
    name = models.CharField('Наименование задачи', max_length=150)
    description = models.CharField('Описание задачи', max_length=250)
    author = models.ForeignKey(
        ProjectEmployee,
        related_name='related_author',
        on_delete=models.DO_NOTHING,
        verbose_name='Автор задачи'
    )
    executor = models.ForeignKey(
        ProjectEmployee,
        on_delete=models.DO_NOTHING,
        verbose_name='Исполнитель'
    )
    task_status = models.ForeignKey(
        'TaskStatus', models.DO_NOTHING,
        verbose_name='Статус задачи'
    )
    last_update = models.DateTimeField('Обновлён', auto_now=True)

    def __str__(self) -> str:
        return (f'Задача: {self.name}, автор: {self.author.employee.name},'
                ' исполнитель: {self.executor.employee.name}')

    class Meta:
        db_table = 'task'
        constraints = [
            models.UniqueConstraint(
                fields=['project', 'id'],
                name='project_id',
            ),
        ]
        verbose_name = 'Задача'
        verbose_name_plural = 'Задачи'
        indexes = [
            models.indexes.Index(fields=['author_id']),
            models.indexes.Index(fields=['task_status_id']),
            models.indexes.Index(fields=['parent_id']),
            models.indexes.Index(fields=['project_id', 'parent_id']),
            models.indexes.Index(fields=['executor_id']),
            models.indexes.Index(
                fields=['project_id', 'author_id'],
                name='task_ibfk_2',
            ),
            models.indexes.Index(
                fields=['project_id', 'executor_id'],
                name='project_id_2',
            ),
        ]


class TaskComment(models.Model):

    id = models.PositiveIntegerField('Идентификатор', primary_key=True)
    date_create = models.DateTimeField('Дата создания', auto_now_add=True)
    project = models.ForeignKey(
        Project,
        on_delete=models.DO_NOTHING,
        verbose_name='Проект'
    )
    task = models.OneToOneField(
        Task,
        on_delete=models.DO_NOTHING,
        verbose_name='Задача'
    )
    comment = models.CharField('Комментарий', max_length=250)
    employee = models.ForeignKey(
        Employee,
        on_delete=models.DO_NOTHING,
        verbose_name='Сотрудник'
    )
    last_update = models.DateTimeField('Обновлено', auto_now=True)

    def __str__(self) -> str:
        return f'Комментарий {self.id} к задаче: "{self.task.name}" от {self.employee.name}'

    class Meta:
        db_table = 'task_comment'
        constraints = [
            models.UniqueConstraint(
                fields=['task', 'project', 'id'],
                name='task_project_id',
            ),
        ]
        verbose_name = 'Комментарий к задаче'
        verbose_name_plural = 'Комментарии к задачам'
        indexes = [
            models.indexes.Index(fields=['employee_id']),
            models.indexes.Index(
                fields=['project_id', 'task_id'],
                name='project_id',
            ),
        ]


class TaskEmployee(models.Model):

    project = models.OneToOneField(
        Project,
        on_delete=models.DO_NOTHING,
        verbose_name='Проект'
    )
    task = models.ForeignKey(
        Task,
        on_delete=models.DO_NOTHING,
        verbose_name='Задача'
    )
    employee = models.ForeignKey(
        Employee,
        on_delete=models.DO_NOTHING,
        verbose_name='Сотрудник'
    )

    def __str__(self) -> str:
        return f'Задача: {self.task.name} (проект:{self.project.name}) для {self.employee.name}'

    class Meta:
        db_table = 'task_employee'
        constraints = [
            models.UniqueConstraint(
                fields=['project', 'task', 'employee'],
                name='project_task_employee',
            ),
        ]
        verbose_name = 'Задача для сотрудников'
        verbose_name_plural = 'Задачи для сотрудников'
        indexes = [
            models.indexes.Index(fields=['project_id', 'employee_id']),
            models.indexes.Index(fields=['employee_id']),
        ]


class TaskFile(models.Model):

    id = models.BigAutoField('Идентификатор', primary_key=True)
    project = models.OneToOneField(
        TaskComment,
        on_delete=models.DO_NOTHING,
        verbose_name='Проект'
    )
    task = models.ForeignKey(
        TaskComment,
        related_name='related_task',
        on_delete=models.DO_NOTHING,
        verbose_name='Задача'
    )
    task_comment = models.ForeignKey(
        TaskComment,
        related_name='related_task_comment',
        on_delete=models.DO_NOTHING,
        blank=True,
        null=True,
        verbose_name='Комментарий')
    filename = models.CharField('Название файла', max_length=200)
    date_create = models.DateTimeField('Дата создания', auto_now_add=True)
    employee = models.ForeignKey(
        Employee,
        on_delete=models.DO_NOTHING,
        verbose_name='Сотрудник'
    )
    last_update = models.DateTimeField('Обновлено', auto_now=True)

    def __str__(self) -> str:
        return self.filename

    class Meta:
        db_table = 'task_file'
        constraints = [
            models.UniqueConstraint(
                fields=['project', 'task', 'id'],
                name='project_task_id',
            ),
        ]
        verbose_name = 'Файл с задачей'
        verbose_name_plural = 'Файлы с задачами'
        indexes = [
            models.indexes.Index(fields=['employee_id']),
            models.indexes.Index(fields=['task_comment_id']),
            models.indexes.Index(fields=['project_id', 'task_id', 'task_comment_id']),
        ]


class TaskStatus(models.Model):

    id = models.BigAutoField('Идентификатор', primary_key=True)
    name = models.CharField('Наименование', max_length=100)
    description = models.CharField(
        max_length=250,
        default='',
        verbose_name='Описание'
    )

    def __str__(self) -> str:
        return self.name

    class Meta:
        db_table = 'task_status'
        verbose_name = 'Статус задачи'
        verbose_name_plural = 'Статусы задач'


class TaskTag(models.Model):

    project = models.OneToOneField(
        Project,
        on_delete=models.DO_NOTHING,
        verbose_name='Проект'
    )
    task = models.ForeignKey(
        Task,
        on_delete=models.DO_NOTHING,
        verbose_name='Задача'
    )
    name = models.ForeignKey(
        Tag,
        on_delete=models.DO_NOTHING,
        db_column='name',
        verbose_name='Название'
    )

    def __str__(self) -> str:
        return f'Тэг: {self.name.name} для задачи: {self.task.name}'

    class Meta:
        db_table = 'task_tag'
        constraints = [
            models.UniqueConstraint(
                fields=['project', 'task', 'name'],
                name='project_task_name',
            ),
        ]
        verbose_name = 'Тэг задачи'
        verbose_name_plural = 'Тэги задач'
        indexes = [
            models.indexes.Index(fields=['name']),
        ]
