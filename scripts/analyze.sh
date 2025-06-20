#!/bin/bash

set -e

echo " Запуск статического анализа"

for task_dir in members/*/task*; do
    echo "Анализ $task_dir..."
    mkdir -p "$task_dir/build"
    cd "$task_dir/build" || exit

    cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..

    find ../src -name "*.cpp" | while read -r src_file; do
        echo "Проверка $src_file"
        clang-tidy -p . "$src_file"
    done
    
    cd ../../..
done

echo "Анализ завершён"
