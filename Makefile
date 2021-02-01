.DEFAULT_GOAL := help
DOCKER_COMPOSER_PN = local

help:
	@echo "$(YELLOW)Available commands:$(END)\n"
	@echo "$(GREEN)serve$(END) Up server"
	@echo "$(GREEN)fresh-start$(END) Build images and up server automatically"
	@echo "$(GREEN)setup$(END) Prepare project for development"
	@echo "$(GREEN)unit-tests$(END) Run all unit tests"
	@echo "$(GREEN)tests$(END) Run all tests"
	@echo "$(GREEN)db-migrate$(END) Run pending database migrations to latest version"
	@echo "$(GREEN)show-routes-calendar$(END) Show routes of project calendar"
.PHONY: help

fresh-start:
	docker-compose -p $(DOCKER_COMPOSER_PN) down -v --remove-orphans \
	&& docker-compose -p $(DOCKER_COMPOSER_PN) stop \
	&& docker-compose build --no-cache --pull
	&& wget https://get.symfony.com/cli/installer -O - | bash
	$(MAKE) composer-install
	$(MAKE) serve
.PHONY: fresh-start

composer:
	docker run --rm --interactive --volume $(PWD):/app --workdir=/app composer $(cmd) --ignore-platform-reqs
.PHONY: composer

composer-install:
	$(MAKE) composer cmd="install"
.PHONY: composer-install

serve:
	$(MAKE) docker-compose cmd="down -v --remove-orphans" \
	&& $(MAKE) docker-compose cmd=stop \
	&& $(MAKE) docker-compose cmd="up -d"
	@echo "$(YELLOW)Calendar: $(END) '$(BLUE)$(APP_BASE_URL):$(CALENDAR_APP_PORT)$(END)'";
.PHONY: serve
