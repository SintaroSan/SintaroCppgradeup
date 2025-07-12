# Пошаговый процесс работы с системой проверки заданий

## Полный workflow от создания кода до мержа PR

### 1. Подготовка окружения участником

```bash
# Клонируем репозиторий
git clone git@github.com:SEIka1/cppgradeup.git
cd cppgradeup/members/

# Создание папки для заданий
mkdir -p ivanov-ivan  # замените на свою фамилию-имя
cd ivanov-ivan

# Создание папки для задания
mkdir -p taske1/src # для задания e1

# Аналогично для /tests
mkdir -p taske1/tests

# Идём к заданию
cd taske1

# Создание ветки для задания
git checkout -b ivanov-ivan-taske1  # замените на свои данные

# Создаем основной файл с решением
touch members/username/taskN/src/main.cpp

# Создаем CMakeLists.txt что бы локально билдить решение
touch members/username/taskN/CMakeLists.txt

# Опционально: создаем тесты
touch members/username/taskN/tests/testN.cpp
```

когда всё вроде как написано и готово к пушу:

### Фиксация изменений
```bash
git add src/main.cpp # не нужно добавлять свой CMakeLists.txt или на чём вы там собираете
git commit -m "Решение задания e1"

# Отправляет на гитхаб (если ветка уже есть)
git push origin ivanov-ivan-taske1

# Если ветка новая, Git попросит установить upstream:
git push --set-upstream origin ivanov-ivan-taske1
```

### 5. Пример минимального `CMakeLists.txt`:
```cmake
cmake_minimum_required(VERSION 3.10)
project(taskN)

set(CMAKE_CXX_STANDARD 20)
add_executable(solution src/main.cpp)
```

CMakeLists.txt нужен вам для билдинга кода на своей машине, пушить его сюда не надо!

### Создание `Pull Request`

1) Перейти в репозиторий: `https://github.com/SEIka1/cppgradeup`
2) Нажмите `Pull requests` → `New pull request`
3) Выберите:

      `base`: `main`

      `compare`: `ivanov-ivan-taske1`

4) Нажмите `Create pull request` и добавьте описание:

      i. Какое задание выполнено

      ii. Особенности реализации

      iii. Какие тесты добавлены

### Ожидание проверки

1. CI автоматически проверит код.

2. Если есть ошибки, вы можете добавить новые коммиты в ветку и запушить их — PR обновится автоматически.

## Обновление main после мержа

После одобрения PR:

```bash
git checkout main      # переключиться на main

git pull origin main   # обновить main

# Можете так же удалить локальную ветку у себя, если я у вас принял задание -> его уже не придется редачить и зачем вам эта ветка тогда?
git branch -d ivanov-ivan-taske1  # удалить локальную ветку

# Если Git ругается (ветка не слита), используйте принудительное удаление:
git branch -D ivanov-ivan-taske1

# Что бы удалить эту ветку на гитхабе (ибо зачем она теперь вам?)
git push origin --delete ivanov-ivan-taske1

# Если так вышло, что вы удалили ветку у себя и здесь она тоже удалена, то её в крайнем случае можно восстановить:
git checkout -b ivanov-ivan-taske1 <хэш-коммита>  # создать заново из коммита

# Если всё круто - задание сдано, начинаем делать новое задание - создаем новую ветку для него и там так же работаем (всё как и раньше)
git checkout -b ivanov-ivan-taske2  # для задания e2
```


# Правила для участников

-Не удаляйте ветки на GitHub, пока PR не принят!

-После мержа:

      Удалите ветку на GitHub (чтобы не засорять репозиторий).

      Локальную ветку можно удалить или оставить (например, для истории).

-Пример безопасной работы:
```bash
# После мержа PR:
git checkout main                  # переключиться на main
git pull origin main              # обновиться
git push origin --delete ivanov-ivan-taske1  # удалить на GitHub
git branch -d ivanov-ivan-taske1  # (опционально) удалить локально
```

-Добавляйте тесты для всех случаев (начиная с задания E5)

-Комментируйте сложные места в коде

-Отвечайте на комментарии ревьювера в течение 24 часов

## Структура:
members/ivanov-ivan/taskN/src/main.cpp

members/ivanov-ivan/taskN/tests/testN.cpp

## Минимальная структура:

members/username/taskN/src/main.cpp

## Ветки Git:

1) Формат: surname-name-taskX где X = e1..e10, m1..m10, h1..h10
2) Пример: ivanov-ivan-taskm3

## Папки с заданиями:

1. Должны точно соответствовать имени из ветки

Пример: для ветки petrov-peter-taskh4 → папка taskh4

# Настройка окружения

### Требования
1. **Компилятор**: GCC ≥11 или Clang ≥12 (поддержка C++20)
2. **Инструменты**:
   ```bash
   # Для Ubuntu/Debian
   sudo apt install build-essential clang-format clang-tidy

Если нажать на кнопку, весь проект сбилдится:
[![Manual Build](https://img.shields.io/badge/Manual_Build-Run_Now-blue?style=for-the-badge)](https://github.com/ваш-юзер/ваш-репозиторий/actions/workflows/manual_build.yml)
не нужно этого просто так делать.
