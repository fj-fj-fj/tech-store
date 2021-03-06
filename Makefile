PROJECT_ROOT := .
DATABASE := postgresql
DOCKER_SERVICE := web
CMD := poetry run
PYTHON := python3

.PHONY: help
help: ## Show help message
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / \
		{printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

.PHONY: start-service
start-service: ## service <SERVICE> start if <SERVICE> not starting
	sudo -i service $(SERVICE) status > /dev/null || sudo service $(SERVICE) start

# see https://github.com/python-poetry/poetry/issues/461#issuecomment-920663114
.PHONY: req
req: ## poetry update requirements(all)
	@poetry show -o -t --no-dev | grep -v -e "--" | cut -d " " -f 1 | sed 's/$$/\@latest/g' > ../no_dev.txt &&\
	poetry show -o -t | grep -v -e "--" | cut -d " " -f 1 | sed 's/$$/\@latest/g' > ../all.txt &&\
	join --nocheck-order -v1 -v2 ../all.txt ../no_dev.txt > ../dev.txt &&\
	cat ../no_dev.txt | xargs poetry add &&\
	cat ../dev.txt | xargs poetry add --dev &&\
	./run freeze

# ------------------------------------ Database ------------------------------------

.PHONY: db-start
db-start: ## Database engine start
	make start-service SERVICE=$(DATABASE)

.PHONY: migrations
migrations: ## makemigrations with descriptive name (e.g make migrations "do_something")
	$(CMD) ./manage.py makemigrations --name $(filter-out $@, $(MAKECMDGOALS))

.PHONY: migrate
migrate: ## manage.py migrate
	$(CMD) ./manage.py migrate

.PHONY: dbshell
dbshell: ## manage.py dbshell
	$(CMD) ./manage.py dbshell

# ------------------------------------ Run Server ------------------------------------

.PHONY: run
run: db-start ## Django runserver
	$(CMD) ./manage.py runserver

# ------------------------------------ Security ------------------------------------

warnings: ## find temporary fixes, forgotten notes and/or possible issues with `grep`
	grep --color="always" --include="*.py" -i -r -n -w $(PROJECT_ROOT) \
		-e 'FIXME\|issue\|problem\|nosec'

# NOTE: installme (see ./requirements/make.txt)
gitleaks: ## audit Git repository for sercrets with `Gitleaks`
	gitleaks --path=$(PROJECT_ROOT) --verbose

# NOTE: `-r`(`--recursive`) arguments ignore `exclude:` in `.bandit` file
# but `-x`(`--exclude`) arguments work here.
bandit: ## find common security issues in Python code with `Bandit`
	$(CMD) bandit --recursive $(PROJECT_ROOT)

safety: ## check installed dependencies for known vulnerabilities with `Safety`
	$(CMD) safety check -r requirements/locals.txt --full-report

.PHONY: security
security: gitleaks bandit safety ## `make gitlieaks bandit safety`

security-full: security warnings ## `make security warnings`

.PHONY: sec
sec: security-full ## shortcat for `security-full`

# ------------------------------------ Code Style ------------------------------------

# NOTE: installme (see ./requirements/make.txt)
self: ## linting and checking Makefile (see https://github.com/mrtazz/checkmake)
	go run ~/go/src/github.com/mrtazz/checkmake Makefile

style: ## check style with `flake8`
	$(CMD) flake8 $(PROJECT_ROOT)

types: ## check types with `mypy`
	$(CMD) mypy $(PROJECT_ROOT)

isort: ## sort imports with `isort`
	$(CMD) isort $(PROJECT_ROOT) --color --diff --check-only

unit-tests: ## run Django unit tests
	$(CMD) ./manage.py test

.PHONY: check
check: self ## do a full check (self, isort, style, types, unit-tests)
	make -j4 isort style types unit-tests

# ------------------------------------ Test Coverage ------------------------------------

.PHONY: coverage
coverage: ## Run tests with coverage
	$(CMD) coverage run --source='.' ./manage.py test .
	$(CMD) coverage report -m
	$(CMD) coverage html

.PHONY: view-coverage
view-coverage:  ## View code coverage
	$(PYTHON) -m webbrowser htmlcov/index.html

# ------------------------------------ Clean Up ------------------------------------

.PHONY: clean
clean: clean-pyc, clean-test ## remove all, test, coverage and Python artifacts

clean-pyc: ## remove Python file artifacts
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

clean-test: ## remove test and coverage artifacts
	GLOBIGNORE=.gitkeep
	rm -fv ./reports/.coverage
	rm -fv reports/cover/*
	unset GLOBIGNORE

# ------------------------------------ Docker ------------------------------------

.PHONY: docker-start
docker-start: ## Docker engine start
	make start-service SERVICE=docker

.PHONY: docker-build
docker-build: docker-start ## Build the container
	docker-compose build --build-arg GIT_COMMIT=$$(git rev-parse --short HEAD 2>/dev/null)

.PHONY: docker-run
docker-run: ## Run the container
	docker-compose up -d

.PHONY: docker-up
docker-up: docker-build docker-run ## Build the container and run

.PHONY: docker-cli
docker-cli: ## get into console of container
	docker-compose exec $(DOCKER_SERVICE) bash

.PHONY: docker-stop
docker-stop: ## stop all containers
	docker stop $$(docker ps -aq)

.PHONY: docker-rm-stopped
docker-rm-stopped: ## remove all stopped containers
	docker rm $$(docker ps -aqf status=exited)

.PHONY: docker-rm-none
docker-rm-none: ## remove all dangling images (tagged as <none>)
	docker rmi $$(docker images -qf dangling=true)

.PHONY: docker-clean
docker-clean: ## delete all containers and images
	docker rm -f $$(docker ps -aq)
	docker rmi -f $$(docker images -q)

# ------------------------------------ Base Targets ------------------------------------

.PHONY: all
all: migrate run ## make migrate and run `Django` runserver

.PHONY: test
test: coverage view-coverage ## run `coverage` and view report
