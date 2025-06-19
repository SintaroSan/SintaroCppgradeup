CXX := g++
CXX_STANDARD := 20
CXXFLAGS := -std=$(CXX_STANDARD) -Wall -Wextra -Werror -pedantic -Iinclude/
LDFLAGS := -Llibs/ -lgtest

TASKS := $(wildcard tasks/task*)

.PHONY: all build test clean format

all: build test

build:
	@for task in $(TASKS); do \
		echo "🔨 Building $$task..."; \
		$(MAKE) -C $$task build || exit 1; \
	done

test:
	@for task in $(TASKS); do \
		echo "🧪 Testing $$task..."; \
		$(MAKE) -C $$task test || exit 1; \
	done

clean:
	@for task in $(TASKS); do \
		$(MAKE) -C $$task clean; \
	done

format:
	find labs -name '*.cpp' -o -name '*.hpp' | xargs clang-format -i --style=file
