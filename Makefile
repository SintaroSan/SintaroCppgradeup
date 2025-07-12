CXX := g++
CXXFLAGS := -std=c++17 -Wall -Wextra
BUILD_DIR := build

TASKS := $(shell find members -mindepth 3 -maxdepth 3 -type d -name 'task*')

.PHONY: all build test

all: $(addprefix build-,$(TASKS))

build-%:
	@echo "Building $*"
	@mkdir -p $*/$(BUILD_DIR)
	@$(CXX) $(CXXFLAGS) \
		-I$*/include \
		$*/src/*.cpp \
		-o $*/$(BUILD_DIR)/solution

test-%: build-%
	@if [ -d "$*/tests" ]; then \
		echo "Testing $*"; \
		$(CXX) $(CXXFLAGS) \
			-I$*/include \
			$*/tests/*.cpp \
			-o $*/$(BUILD_DIR)/tests; \
		$*/$(BUILD_DIR)/tests || exit 1; \
	fi

format:
	find members -name '*.cpp' -o -name '*.hpp' | xargs clang-format -i --style=file
