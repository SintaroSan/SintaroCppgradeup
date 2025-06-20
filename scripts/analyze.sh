#!/bin/bash
for task in members/*/*; do
    echo "Анализ $task..."
    cd "$task" && mkdir -p build && cd build
    cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..
    clang-tidy -p . ../src/*.cpp
    cd ../../..
done
