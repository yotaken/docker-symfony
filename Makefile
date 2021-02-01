-include Makefile.parameters

.DEFAULT_GOAL := help

help:
	@echo "$(YELLOW)Available commands:$(END)\n"
	@echo "$(GREEN)serve$(END) Up server"
	@echo "$(GREEN)unit-tests$(END) Run all unit tests"
	@echo "$(GREEN)composer$(END) Run composer commands"
	@echo "$(GREEN)generate-api-project$(END) Generate api project structure"
	@echo "$(GREEN)generate-web-project$(END) Generate web project structure"
	@echo "$(GREEN)tests$(END) Run all tests"
	@echo "$(GREEN)db-migrate$(END) Run pending database migrations to latest version"
.PHONY: help

composer:
	docker exec -it php-fpm composer $(cmd) --ignore-platform-reqs
.PHONY: composer

composer-install:
	$(MAKE) composer cmd="install"
.PHONY: composer-install

composer-update:
	$(MAKE) composer cmd="update"
.PHONY: composer-install

generate-api-project:
	$(MAKE) composer cmd="create-project symfony/skeleton api"
	-mkdir -pv ./symfony/api/var/cache \
	&& chmod -R ugo+w ./symfony/api
.PHONY: generate-api-project

generate-web-project:
	$(MAKE) composer cmd="create-project symfony/website-skeleton symfony"
.PHONY: generate-web-project

serve:
	docker-compose down -v --remove-orphans \
    	&& docker-compose stop \
    	&& docker-compose up -d
	@echo "$(YELLOW)App: $(END) '$(BLUE)$(APP_BASE_URL)$(END)'";
	@echo "$(YELLOW)Kibana: $(END) '$(BLUE)$(APP_BASE_URL):$(KIBANA_APP_PORT)$(END)'";
.PHONY: serve
