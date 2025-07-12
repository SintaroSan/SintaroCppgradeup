MEMBERS_DIR := members
TASKS := $(shell find $(MEMBERS_DIR) -type d -name 'task*' -exec basename {} \;)
BUILD_DIR := build
CXX := g++
CXXFLAGS := -std=c++17 -Wall

.PHONY: all build test format

all: $(addprefix build-,$(TASKS)) $(addprefix test-,$(TASKS))

build: $(addprefix build-,$(TASKS))
test: $(addprefix test-,$(TASKS))

build-%:
	@echo "Building $*"
	@TASK_DIR=$(shell find $(MEMBERS_DIR) -name "$*" -type d); \
	mkdir -p $$TASK_DIR/$(BUILD_DIR); \
	$(CXX) $(CXXFLAGS) $$TASK_DIR/src/*.cpp -o $$TASK_DIR/$(BUILD_DIR)/solution

test-%: build-%
	@TASK_DIR=$(shell find $(MEMBERS_DIR) -name "$*" -type d); \
	if [ -d "$$TASK_DIR/tests" ]; then \
		$(CXX) $(CXXFLAGS) $$TASK_DIR/tests/*.cpp -o $$TASK_DIR/$(BUILD_DIR)/tests; \
		$$TASK_DIR/$(BUILD_DIR)/tests || exit 1; \
	fi

format:
	find $(MEMBERS_DIR) -name '*.cpp' -o -name '*.hpp' | xargs clang-format -i --style=file
