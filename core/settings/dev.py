from typing import List

from configurations import values

from core.settings.base import BaseConfiguration


class Development(BaseConfiguration):

    SECRET_KEY = values.SecretValue(environ_name='SECRET_KEY')

    ALLOWED_HOSTS = ['*']

    EMAIL_BACKEND = values.Value('django.core.mail.backends.console.EmailBackend')
