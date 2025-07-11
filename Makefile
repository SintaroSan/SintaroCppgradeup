MEMBERS_DIR := members
TASKS := $(wildcard $(MEMBERS_DIR)/*/*)
BUILD_DIR := build
CXX := g++
CXXFLAGS := -std=c++17 -Wall -Wextra

.PHONY: all build test clean format

all: build test

build: $(addprefix build-,$(TASKS))

test: $(addprefix test-,$(TASKS))

clean:
	rm -rf $(MEMBERS_DIR)/*/$(BUILD_DIR)

format:
	find $(MEMBERS_DIR) -name '*.cpp' -o -name '*.hpp' | xargs clang-format -i --style=file

build-%:
	@echo "Building $*..."
	@mkdir -p $*/$(BUILD_DIR)
	@if [ -d "$*/src" ]; then \
		$(CXX) $(CXXFLAGS) -I$*/include $*/src/*.cpp -o $*/$(BUILD_DIR)/solution; \
	else \
		echo "Error: src directory not found in $*"; \
		exit 1; \
	fi

test-%: build-%
	@if [ -d "$*/tests" ]; then \
		echo "Testing $*..."; \
		$(CXX) $(CXXFLAGS) -I$*/include $*/tests/*.cpp -o $*/$(BUILD_DIR)/tests; \
		$*/$(BUILD_DIR)/tests || exit 1; \
	else \
		echo "No tests found for $*"; \
	fi
