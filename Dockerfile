# syntax=docker/dockerfile:1

FROM python:3.9-slim-buster AS python_base

ARG GIT_COMMIT=unspecified
LABEL git_commit=$GIT_COMMIT

ARG DJANGO_CONFIGURATION
ENV DJANGO_CONFIGURATION=$DJANGO_CONFIGURATION \
    VENV_PATH=/opt/.venv \
    # python
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    # pip
    PIP_DEFAULT_TIMEOUT=100 \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_NO_CACHE_DIR=off \
    # poetry
    POETRY_PATH=/opt/poetry \
    POETRY_VERSION=1.1.8 \
    POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_CREATE=false \
    POETRY_CACHE_DIR="/var/cache/pypoetry"

ENV PATH="$POETRY_PATH/bin:$VENV_PATH/bin:$PATH"

FROM python_base AS builder

RUN apt update && apt install -y --no-install-recommends \
        # deps for installing poetry
        curl \
    # install poetry - uses $POETRY_VERSION internally
    && curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py \
        | python - --version "${POETRY_VERSION}" \
    && mv /root/.poetry $POETRY_PATH \
    # configure poetry & make a virtualenv ahead of time since we only need one
    && python -m venv $VENV_PATH \
    && poetry config virtualenvs.create false \
    # cleanup
    && apt purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/apt/lists/*

COPY pyproject.toml poetry.lock ./
RUN poetry install --no-interaction --no-ansi --no-root -vvv \
        $(if [ "$DJANGO_CONFIGURATION" = 'Production' ]; then echo "--no-dev"; fi) \
    && if [ "$DJANGO_CONFIGURATION" = 'Production' ]; then rm -rf "$POETRY_CACHE_DIR"; fi \
    && pip uninstall --yes poetry \
    && rm pyproject.toml poetry.lock

FROM python_base AS runtime

WORKDIR /usr/src/app

RUN addgroup --system django \
    && adduser --system --ingroup django django

COPY --chown=django:django --from=builder $VENV_PATH $VENV_PATH
COPY --chown=django:django . .

USER django
