MEMBERS_DIR := members
TASKS := $(wildcard $(MEMBERS_DIR)/*/*)
BUILD_DIR := build

CXX := g++
CXXFLAGS := -std=c++17 -Wall -Wextra -Iinclude

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
	$(CXX) $(CXXFLAGS) $*/src/*.cpp -o $*/$(BUILD_DIR)/solution

test-%: build-%
	@if [ -d "$*/tests" ]; then \
		echo "Testing $*..."; \
		$(CXX) $(CXXFLAGS) $*/tests/*.cpp -o $*/$(BUILD_DIR)/tests && $*/$(BUILD_DIR)/tests; \
	else \
		echo "No tests found for $*"; \
	fi
