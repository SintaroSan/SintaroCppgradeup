#!/bin/bash
find members -name '*.cpp' -o -name '*.hpp' | xargs clang-format -i --style=file
echo "Форматирование завершено"
