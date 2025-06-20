#!/bin/bash

find members -type f \( -name "*.cpp" -o -name "*.hpp" \) -print0 | while IFS= read -r -d '' file; do
    echo "Форматирование $file"
    clang-format -i --style=file "$file"
done

echo "Все файлы отформатированы"
