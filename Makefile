MEMBERS_DIR := members
TASKS := $(wildcard $(MEMBERS_DIR)/*/*)
BUILD_DIRS := $(addsuffix /build,$(TASKS))

.PHONY: all build test clean format

all: build test

build: $(addprefix build-,$(TASKS))

test: $(addprefix test-,$(TASKS))

format:
	find $(MEMBERS_DIR) -name '*.cpp' -o -name '*.hpp' | xargs clang-format -i --style=file

build-%:
	@echo "Building $*..."
	@mkdir -p $*/build && cd $*/build && \
	cmake .. && \
	make

test-%: build-%
	@if [ -f "$*/build/tests" ]; then \
		echo "Testing $*..."; \
		cd $*/build && ./tests; \
	else \
		echo "ℹNo tests found for $*"; \
	fi
