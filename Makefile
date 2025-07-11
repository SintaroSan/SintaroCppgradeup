MEMBERS_DIR := members
TASK_DIRS := $(wildcard $(MEMBERS_DIR)/*/*)
BUILD_DIR := build
CXX := g++
CXXFLAGS := -std=c++17 -Wall -Wextra

.PHONY: all build test clean format

all: build test

build: $(patsubst %,build-%,$(TASK_DIRS))

test: $(patsubst %,test-%,$(TASK_DIRS))

clean:
	rm -rf $(MEMBERS_DIR)/*/$(BUILD_DIR)

format:
	find $(MEMBERS_DIR) -name '*.cpp' -o -name '*.hpp' | xargs clang-format -i --style=file

build-%:
	@echo "Building $*"
	@mkdir -p $*/$(BUILD_DIR)
	@if [ -d "$*/src" ]; then \
		echo "Compiling solution..."; \
		$(CXX) $(CXXFLAGS) -I$*/include $*/src/*.cpp -o $*/$(BUILD_DIR)/solution || exit 1; \
	else \
		echo "Error: src directory not found in $*"; \
		exit 1; \
	fi

test-%: build-%
	@if [ -d "$*/tests" ]; then \
		echo "Compiling tests..."; \
		$(CXX) $(CXXFLAGS) -I$*/include $*/tests/*.cpp -o $*/$(BUILD_DIR)/tests || exit 1; \
		echo "Running tests..."; \
		$*/$(BUILD_DIR)/tests || exit 1; \
	else \
		echo "No tests found in $*"; \
	fi
