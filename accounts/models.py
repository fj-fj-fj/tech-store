from django.contrib.auth.models import AbstractUser
from django.db import models


class User(AbstractUser):

    curator = models.ForeignKey(
        'self',
        on_delete=models.SET_NULL,
        blank=True,
        null=True,
        related_name='subordinates',
        verbose_name='Идентификатор куратор'
    )
    last_update = models.DateTimeField('Обновлён', auto_now=True)
    avatar = models.ForeignKey(
        'task_manager.Avatar',
        on_delete=models.CASCADE,
        blank=True,
        null=True,
        verbose_name='Идентификатор аватара',
    )
    deleted = models.BooleanField('Удалён', default=False)
    rate = models.FloatField('Рэйтинг', default=0.)

    def __str__(self) -> str:
        return self.username

    class Meta(AbstractUser.Meta):
        indexes = [
            models.indexes.Index(
                fields=['avatar_id'],
                name='employee_avatar_idx',
            ),
            models.indexes.Index(
                fields=['curator_id'],
                name='employee_curator_idx',
            ),
        ]
