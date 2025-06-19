# Пошаговый процесс работы с системой проверки заданий

## Полный workflow от создания кода до мержа PR

### 1. Подготовка окружения участником
```bash
# Клонируем репозиторий
git clone https://github.com/SEIka1/cppgradeup.git
cd cppgradeup

# Создаем ветку для работы
git checkout -b username-taskN

# Создаем папку для задания
mkdir -p members/surname-name/taskN/src
# Аналогично для /tests

# Создаем основной файл с решением
touch members/username/taskN/src/main.cpp

# Создаем CMakeLists.txt
touch members/username/taskN/CMakeLists.txt

# Опционально: создаем тесты
touch members/username/taskN/tests/testN.cpp
```

### Локальная проверка
```bash
# Форматирование кода
make format

# Сборка и тестирование
make build-members/username/taskN
make test-members/username/taskN

# Статический анализ
make analyze-members/username/taskN
```

### Фиксация изменений
```bash
git add .
git commit -m "Реализация задания 1"
git push origin username-taskN
```

### 5. Пример минимального CMakeLists.txt:
```cmake
cmake_minimum_required(VERSION 3.10)
project(taskN)

set(CMAKE_CXX_STANDARD 20)
add_executable(solution src/main.cpp)
```

### Создание Pull Request

1) Перейти на GitHub в форк репозитория
2) Нажать "New Pull Request"
3) Выбрать ветку с заданием
4) Заполнить описание:

      i. Какое задание выполнено

      ii. Особенности реализации

      iii. Какие тесты добавлены

# Правила для участников

-Всегда запускайте make format перед коммитом

-Добавляйте тесты для всех случаев

-Комментируйте сложные места в коде

-Отвечайте на комментарии ревьювера в течение 24 часов

## Структура:
members/ivanov-ivan/taskN/src/main.cpp

members/ivanov-ivan/taskN/tests/testN.cpp

members/ivanov-ivan/taskN/CMakeLists.txt          

## Минимальная структура:

members/username/taskN/src/main.cpp

members/username/taskN/CMakeLists.txt

## Ветки Git:

1) Формат: surname-name-taskX
2) Где X = e1..e10, m1..m10, h1..h10
3) Пример: ivanov-ivan-taskm3

## Папки с заданиями:

1. Должны точно соответствовать имени из ветки

Пример: для ветки petrov-peter-taskh4 → папка taskh4

# Основные команды

### Сборка и тестирование
| Команда | Действие |
|---------|----------|
| `make all` | Собрать и протестировать все задания |
| `make build` | Собрать все задания (без тестов) |
| `make test` | Запустить тесты для всех заданий |
| `make build-members/user1/task1` | Собрать конкретное задание |
| `make test-members/user1/task1` | Протестировать конкретное задание |

### Дополнительные инструменты
| Команда | Действие |
|---------|----------|
| `make clean` | Удалить все собранные файлы |
| `make format` | Автоформатировать код (clang-format) |
| `make analyze` | Проверить код статическим анализатором |
| `make docs` | Сгенерировать документацию (Doxygen) |
| `make help` | Показать все доступные команды |

# Настройка окружения

### Требования
1. **Компилятор**: GCC ≥11 или Clang ≥12 (поддержка C++20)
2. **Инструменты**:
   ```bash
   # Для Ubuntu/Debian
   sudo apt install build-essential clang-format clang-tidy doxygen
