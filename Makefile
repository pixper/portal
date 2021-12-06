.PHONY: clean clean-pyc clean-build help
.DEFAULT_GOAL := help


define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
		match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
		if match:
				target, help = match.groups()
				print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT




help:
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

edit-env: ## edit env file
	[ -f .env ] || cp env-example .env
	editor .env

deploy: edit-env refresh ## deploy

reload: ## reload nginx config files
	docker-compose --compatibility exec nginx nginx -s reload

pull: ## pull new images
	docker-compose --compatibility pull

build: ## build services
	docker-compose --compatibility build

build-pull: ## build services and pull new images if any
	docker-compose --compatibility build --pull

up: ## create and start containers in the background
	docker-compose --compatibility up --detach --remove-orphans

down: ## stop and remove containers and networks
	docker-compose --compatibility down --remove-orphans

start: ## start services
	docker-compose --compatibility start

stop: ## stop services
	docker-compose --compatibility stop

kill: ## kill services
	docker-compose --compatibility kill

rm: ## remove containers
	docker-compose --compatibility rm --stop --force -v

restart: ## restart services
	docker-compose --compatibility restart

refresh: stop rm build up ## stop, rebuild and start containers

update: ## update containers
	docker-compose --compatibility up --detach --no-deps --remove-orphans

status: ## list containers status
	docker-compose --compatibility ps

stats: ## containers stats
	docker-compose --compatibility ps --quiet | xargs docker stats

logs: ## tail containers logs
	docker-compose --compatibility logs --follow --timestamps --tail=100
