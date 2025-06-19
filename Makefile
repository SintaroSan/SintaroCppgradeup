VERSION := 3.1
SHELL := /bin/bash
.DEFAULT_GOAL := help

GREEN := \033[0;32m
RED := \033[0;31m
NC := \033[0m

CXX := g++
CXX_STANDARD := 20
BUILD_TYPE := Release

WARNINGS := -Wall -Wextra -Wpedantic -Wconversion -Wshadow \
            -Wnull-dereference -Wold-style-cast -Werror

BASE_FLAGS := -std=c++$(CXX_STANDARD) $(WARNINGS) \
              -fdiagnostics-color=always

ifeq ($(BUILD_TYPE), Debug)
BASE_FLAGS += -g -O0 -fsanitize=address,undefined -fno-omit-frame-pointer
else
BASE_FLAGS += -O3 -march=native -DNDEBUG
endif

MODULE_FLAGS := -fmodules-ts -fimplicit-modules

SRC_DIR := src
BUILD_DIR := build
TESTS_DIR := tests
DOCS_DIR := docs
MEMBERS_DIR := members

TASKS := $(wildcard $(MEMBERS_DIR)/*/task*)
MEMBERS := $(sort $(dir $(TASKS)))

define run-with-timeout
	@timeout 10s $(1) || (echo -e "$(RED)⏱ Timeout in $(2)$(NC)" && exit 1)
endef

.PHONY: all build test clean docs format analyze

all: build test

build: $(addprefix build-,$(TASKS))

test: $(addprefix test-,$(TASKS))

define TASK_TEMPLATE
build-$(1): $(BUILD_DIR)/$(1)/.build-done

test-$(1): $(BUILD_DIR)/$(1)/.test-done

$(BUILD_DIR)/$(1)/.build-done: $$(wildcard $(1)/*.cpp) $$(wildcard $(1)/*.hpp)
	@mkdir -p $$(@D)
	@echo -e "$(GREEN) Building $(subst $(MEMBERS_DIR)/,,$(1))...$(NC)"
	@$(CXX) $(BASE_FLAGS) $(MODULE_FLAGS) -I$(1) $$(wildcard $(1)/*.cpp) -o $(BUILD_DIR)/$(1)/program
	@touch $$@

$(BUILD_DIR)/$(1)/.test-done: $(BUILD_DIR)/$(1)/.build-done $$(wildcard $(1)/$(TESTS_DIR)/*.cpp)
	@if [ -d "$(1)/$(TESTS_DIR)" ]; then \
		echo -e "$(GREEN) Testing $(subst $(MEMBERS_DIR)/,,$(1))...$(NC)"; \
		$(CXX) $(BASE_FLAGS) -I$(1) $$(wildcard $(1)/$(TESTS_DIR)/*.cpp) -o $(BUILD_DIR)/$(1)/test-program; \
		$(call run-with-timeout,./$(BUILD_DIR)/$(1)/test-program,$(1)); \
	fi
	@touch $$@
endef

$(foreach task,$(TASKS),$(eval $(call TASK_TEMPLATE,$(task))))

clean:
	@rm -rf $(BUILD_DIR)
	@echo -e "$(GREEN) Build directory cleaned$(NC)"

docs:
	@doxygen Doxyfile 2>/dev/null
	@echo -e "$(GREEN) Documentation generated in $(DOCS_DIR)$(NC)"

format:
	@find . -name '*.cpp' -o -name '*.hpp' | xargs clang-format -i --style=file
	@echo -e "$(GREEN) Code formatted$(NC)"

analyze:
	@for task in $(TASKS); do \
		echo -e "$(GREEN) Analyzing $$task...$(NC)"; \
		clang-tidy $$task/*.cpp -- $(BASE_FLAGS); \
	done

help:
	@echo -e "$(GREEN)C++ Tasks Management System v$(VERSION)$(NC)"
	@echo "Available targets:"
	@echo "  all       - Build and test all tasks (default)"
	@echo "  build     - Build all tasks"
	@echo "  test      - Run tests for all tasks"
	@echo "  clean     - Remove build artifacts"
	@echo "  docs      - Generate documentation"
	@echo "  format    - Format all source files"
	@echo "  analyze   - Run static analysis"
	@echo ""
	@echo "Per-task targets:"
	@for task in $(TASKS); do \
		echo "  build-$$task"; \
		echo "  test-$$task"; \
	done
	@echo ""
	@echo "Examples:"
	@echo "  make build-members/alice/task1"
	@echo "  make test-members/bob/task2"
