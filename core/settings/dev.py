import socket
from typing import List

import snoop
from configurations import values

from core.settings.base import BaseConfiguration
from core.settings.mixins import UtilsDevMixin


class Development(BaseConfiguration, UtilsDevMixin):

    def __init__(self) -> None:
        super().__init__()
        # `snoop`, `pp`, and `spy` will be available in every file
        # without needing to import them
        snoop.install.__get__(object)(enabled=True, watch_extras=[self.type_watch, self.repr_value])

    SECRET_KEY = values.SecretValue(environ_name='SECRET_KEY')
    DEBUG = values.BooleanValue(True)
    ALLOWED_HOSTS = ['*']
    INTERNAL_IPS = values.ListValue([
        'localhost',
        '127.0.0.1',
        '[::1]',
        # tricks to have debug toolbar when developing with docker
        socket.gethostbyname(socket.gethostname())[:-1] + '1'
    ])

    EMAIL_BACKEND = values.Value('django.core.mail.backends.console.EmailBackend')

    @property
    def INSTALLED_APPS(self) -> List[str]:  # type: ignore
        return super().INSTALLED_APPS + [
            'debug_toolbar',
        ]

    @property
    def MIDDLEWARE(self) -> List[str]:  # type: ignore
        return super().MIDDLEWARE + [
            'debug_toolbar.middleware.DebugToolbarMiddleware',
        ]
