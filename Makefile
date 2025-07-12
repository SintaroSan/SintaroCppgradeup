CXX := g++
CXXFLAGS := -std=c++17 -Wall -Wextra
BUILD_DIR := build

TASKS := $(shell find members -type d -path "*/task*" | sed 's/members\///')

.PHONY: all build test format

all: build test

build: $(addprefix build-,$(notdir $(TASKS)))

test: $(addprefix test-,$(notdir $(TASKS)))

build-%:
	@echo "Building $*"
	@TASK_PATH=$(shell find members -name "$*" -type d); \
	mkdir -p $$TASK_PATH/$(BUILD_DIR); \
	$(CXX) $(CXXFLAGS) -I$$TASK_PATH/include $$TASK_PATH/src/*.cpp -o $$TASK_PATH/$(BUILD_DIR)/solution

test-%: build-%
	@TASK_PATH=$(shell find members -name "$*" -type d); \
	if [ -d "$$TASK_PATH/tests" ]; then \
		$(CXX) $(CXXFLAGS) -I$$TASK_PATH/include $$TASK_PATH/tests/*.cpp -o $$TASK_PATH/$(BUILD_DIR)/tests; \
		$$TASK_PATH/$(BUILD_DIR)/tests || exit 1; \
	else \
		echo "No tests for $*"; \
	fi

format:
	find members -name '*.cpp' -o -name '*.hpp' | xargs clang-format -i --style=file
