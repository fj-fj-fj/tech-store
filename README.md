# Tech store

Tech store

### Prerequisites

1. Install git
2. Install envrc

### Installing

Add environment DJANGO_SECRET_KEY in .envrc file:
```sh
export DJANGO_SECRET_KEY='your_django_key'
```

Make migrations:
```sh
make migrations
```

## Commands

To run project use:
```sh
python manage.py runserver
```

To start flake8, isort, mypy and pytest use:
```sh
make check
```
