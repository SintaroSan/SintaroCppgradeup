#!/bin/bash

set -e

echo "Генерация документации"

cat > Doxyfile.tmp << 'EOF'
INPUT                  = members
FILE_PATTERNS          = *.cpp *.hpp
OUTPUT_DIRECTORY       = docs
GENERATE_HTML          = YES
GENERATE_TREEVIEW      = YES
RECURSIVE              = YES
QUIET                  = YES
EOF

doxygen Doxyfile.tmp
rm Doxyfile.tmp

echo "Документация сгенерирована в папке docs/"
