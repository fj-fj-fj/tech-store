PROJECT_ROOT = .

run:
	poetry run ipython

style:
	poetry run flake8 $(PROJECT_ROOT)

types:
	poetry run mypy $(PROJECT_ROOT)

isort:
	poetry run isort $(PROJECT_ROOT)

tests:
	poetry run ./manage.py test

check:
	make -j4 isort style types tests

migrations:
	python3 manage.py makemigrations
	python3 manage.py migrate