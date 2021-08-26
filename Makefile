PROJECT_ROOT = .
CMD = poetry run

db:
	sudo service postgresql start

run: db
	$(CMD) ./manage.py runserver

style:
	$(CMD) flake8 $(PROJECT_ROOT)

types:
	$(CMD) mypy $(PROJECT_ROOT)

isort:
	$(CMD) isort $(PROJECT_ROOT)

tests:
	$(CMD) ./manage.py test

check:
	make -j4 isort style types tests

migrations:
	$(CMD) ./manage.py makemigrations
	$(CMD) ./manage.py migrate

clean:
	rm -rf build dist *.egg-info
	find . -name '*.pyc' -delete
	find . -name __pycache__ -delete