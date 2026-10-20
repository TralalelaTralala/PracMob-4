# PracMob4

Навчальний консольний проєкт на Dart: базові типи й функції, університетська OOP-система, колекції та CSV-аналіз, асинхронна робота з JSON-файлами.

## Вимоги

- Dart SDK 3.0.0 або новіший
- Git (необов'язково для запуску програм)

Перевірити Dart у PowerShell:

```powershell
dart --version
```

Якщо команда `dart` не розпізнається, додайте каталог `...\dart-sdk\bin` до змінної середовища `Path`, відкрийте новий термінал і повторіть команду. У Flutter SDK Dart зазвичай лежить у `flutter\bin\cache\dart-sdk\bin`.

## Встановлення та запуск

У корені `PracMob4`:

```powershell
dart pub get
dart run bin/task1_variables.dart
dart run bin/task2_functions.dart
dart run bin/task3_classes.dart
dart run bin/task4_collections.dart
dart run bin/task5_async.dart
```

Програми читають приклади з `data/` відносно кореня проєкту. Запускайте команди саме з кореня, як показано вище.

## Структура

```text
PracMob4/
├── bin/                         # П'ять незалежних консольних демонстрацій
├── data/                        # CSV і три JSON-файли для асинхронного завдання
├── docs/                         # UML-діаграма та короткі звіти
├── lib/models/                   # Student, Course, Person, Professor, University
├── lib/utils/                    # Калькулятор, обробка тексту, даних і CSV
├── test/                         # Тести моделей та утиліт
├── analysis_options.yaml
└── pubspec.yaml
```

## Завдання

1. `task1_variables.dart`: числа, рядки, логіка, колекції, null safety та required-параметр.
2. `task2_functions.dart`: функції з різними параметрами, функції вищого порядку, замикання, рекурсія; калькулятор і текстовий аналізатор.
3. `task3_classes.dart`: успадкування, поліморфізм, студенти/курси/викладачі, передумови, CRUD, оцінки й статистика.
4. `task4_collections.dart`: List/Set/Map, перетворення та групування; аналіз студентів із `data/students.csv`.
5. `task5_async.dart`: паралельне читання трьох JSON-файлів, потік студентів, обробка, запис звіту й порівняння послідовного та паралельного читання.

## Перевірка якості

```powershell
dart format --set-exit-if-changed bin lib test
dart analyze
dart run test/models_test.dart
dart run test/utils_test.dart
dart test --coverage=coverage
```

Команди для лічильника покриття наведені у `docs/quality.md`. Результат бенчмарку залежить від комп'ютера, тому зберігається як фактичний вивід запуску, а не як очікувана константа.

## Докази запуску

У `evidence/` збережені текстові результати програм і перевірок. `task1_variables.png`–`task5_async.png` — справжні знімки вікна PowerShell під час запуску п'яти програм. `quality_checks.png` поки що оформлений зі збережених логів; справжній знімок перевірок можна додати окремо.

- [Task 1 — Variables & Types](evidence/screenshots/task1_variables.png)
- [Task 2 — Functions](evidence/screenshots/task2_functions.png)
- [Task 3 — OOP University System](evidence/screenshots/task3_classes.png)
- [Task 4 — Collections & Data](evidence/screenshots/task4_collections.png)
- [Task 5 — Async Processing](evidence/screenshots/task5_async.png)
- [Analyzer and test results (rendered from logs)](evidence/screenshots/quality_checks.png)

## Публікація на GitHub

Публічний репозиторій: [TralalelaTralala/PracMob-4](https://github.com/TralalelaTralala/PracMob-4).

Щоб відправити наступні зміни з кореня проєкту:

```powershell
git push -u origin main
```

Не додавайте токени, паролі чи приватні ключі до Git.
