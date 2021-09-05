from pathlib import Path
from typing import List

from configurations import Configuration, values


class BaseConfiguration(Configuration):

    BASE_DIR = Path(__file__).resolve().parent.parent.parent

    DEBUG = values.BooleanValue(True)

    ALLOWED_HOSTS: List[str] = []

    AUTH_USER_MODEL = 'accounts.User'
    LOGIN_REDIRECT_URL = 'task_manager:index'
    LOGOUT_REDIRECT_URL = 'task_manager:entry'
    LOGIN_URL = 'task_manager:entry'

    DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'
    DATABASES = values.DatabaseURLValue(environ_name='DATABASE_URL')

    DJANGO_APPS = [
        'django.contrib.admin',
        'django.contrib.auth',
        'django.contrib.contenttypes',
        'django.contrib.sessions',
        'django.contrib.messages',
        'django.contrib.staticfiles',
    ]
    THIRD_PARTY_APPS = [
        'django_extensions',
    ]
    LOCAL_APPS = [
        'accounts',
        'task_manager',
    ]
    INSTALLED_APPS = DJANGO_APPS + THIRD_PARTY_APPS + LOCAL_APPS

    MIDDLEWARE = [
        'django.middleware.security.SecurityMiddleware',
        'django.contrib.sessions.middleware.SessionMiddleware',
        'django.middleware.common.CommonMiddleware',
        'django.middleware.csrf.CsrfViewMiddleware',
        'django.contrib.auth.middleware.AuthenticationMiddleware',
        'django.contrib.messages.middleware.MessageMiddleware',
        'django.middleware.clickjacking.XFrameOptionsMiddleware',
    ]

    ROOT_URLCONF = 'core.urls'

    TEMPLATES = [
        {
            'BACKEND': 'django.template.backends.django.DjangoTemplates',
            'DIRS': ['templates'],
            'APP_DIRS': True,
            'OPTIONS': {
                'context_processors': [
                    'django.template.context_processors.debug',
                    'django.template.context_processors.request',
                    'django.contrib.auth.context_processors.auth',
                    'django.contrib.messages.context_processors.messages',
                ],
            },
        },
    ]

    WSGI_APPLICATION = 'core.wsgi.application'

    AUTH_PASSWORD_VALIDATORS = [
        {
            'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
        },
        {
            'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
        },
        {
            'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
        },
        {
            'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
        },
    ]

    LANGUAGE_CODE = 'en-us'
    TIME_ZONE = 'UTC'
    USE_I18N = True
    USE_L10N = True
    USE_TZ = True

    STATIC_URL = '/static/'
    STATIC_ROOT = BASE_DIR / 'staticfiles'
    MEDIA_URL = '/media/'
    MEDIA_root = BASE_DIR / 'mediafiles'
    STATICFILES_DIRS = (
        BASE_DIR / 'static',
    )

    SILENCED_SYSTEM_CHECKS = [
        # Allow index names >30 characters, because we aren’t using Oracle
        'models.E034',
    ]
