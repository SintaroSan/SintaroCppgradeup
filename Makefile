MEMBERS_DIR := members
TASKS := $(wildcard $(MEMBERS_DIR)/*/*)
BUILD_DIRS := $(addsuffix /build,$(TASKS))

.PHONY: all build test clean format analyze docs help

all: build test

build: $(addprefix build-,$(TASKS))

test: $(addprefix test-,$(TASKS))

clean:
	find $(MEMBERS_DIR) -type d -name "build" -exec rm -rf {} +

format:
	@./scripts/format.sh

analyze:
	@./scripts/analyze.sh

docs:
	@./scripts/docs.sh

help:
	@echo "Основные команды:"
	@echo "make all         - Собрать и протестировать все задания"
	@echo "make build       - Собрать все задания"
	@echo "make test        - Запустить тесты"
	@echo "make clean       - Удалить собранные файлы"
	@echo "make format      - Форматировать код"
	@echo "make analyze     - Статический анализ"
	@echo "make docs        - Генерация документации"
	@echo ""
	@echo "Команды для конкретных заданий:"
	@echo "make build-members/user/taskX  - Собрать конкретное задание"
	@echo "make test-members/user/taskX   - Протестировать конкретное задание"

build-%:
	@echo "Сборка $*..."
	@mkdir -p $*/build && cd $*/build && cmake .. && make

test-%: build-%
	@if [ -f "$*/build/tests" ]; then \
		echo "Тестирование $*..."; \
		cd $*/build && ./tests; \
	else \
		echo "Тесты для $* не найдены"; \
	fi
