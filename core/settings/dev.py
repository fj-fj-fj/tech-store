import socket
from typing import List

from configurations import values

from core.settings.base import BaseConfiguration


class Development(BaseConfiguration):

    SECRET_KEY = values.SecretValue(environ_name='SECRET_KEY')

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
