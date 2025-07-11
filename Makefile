MEMBERS_DIR := members
TASK_DIRS := $(shell find $(MEMBERS_DIR) -maxdepth 2 -mindepth 2 -type d)
BUILD_DIR := build
CXX := g++
CXXFLAGS := -std=c++17 -Wall -Wextra

.PHONY: all build test clean format

all: build test

build: $(addprefix build-,$(notdir $(TASK_DIRS)))

test: $(addprefix test-,$(notdir $(TASK_DIRS)))

clean:
	rm -rf $(addsuffix /$(BUILD_DIR),$(TASK_DIRS))

format:
	find $(MEMBERS_DIR) -name '*.cpp' -o -name '*.hpp' | xargs clang-format -i --style=file

build-%:
	@echo "Building $*"
	@TASK_PATH=$(shell find $(MEMBERS_DIR) -name "$*" -type d); \
	if [ -d "$$TASK_PATH/src" ]; then \
		mkdir -p "$$TASK_PATH/$(BUILD_DIR)"; \
		$(CXX) $(CXXFLAGS) -I$$TASK_PATH/include $$TASK_PATH/src/*.cpp -o "$$TASK_PATH/$(BUILD_DIR)/solution" || exit 1; \
	else \
		echo "Error: src directory not found in $$TASK_PATH"; \
		exit 1; \
	fi

test-%: build-%
	@TASK_PATH=$(shell find $(MEMBERS_DIR) -name "$*" -type d); \
	if [ -d "$$TASK_PATH/tests" ]; then \
		echo "Compiling tests..."; \
		$(CXX) $(CXXFLAGS) -I$$TASK_PATH/include $$TASK_PATH/tests/*.cpp -o "$$TASK_PATH/$(BUILD_DIR)/tests" || exit 1; \
		echo "Running tests..."; \
		"$$TASK_PATH/$(BUILD_DIR)/tests" || exit 1; \
	else \
		echo "No tests found in $$TASK_PATH"; \
	fi
