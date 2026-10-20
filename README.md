# PracMob4

Навчальний проєкт на Dart із п'ятьма консольними програмами. У них є приклади роботи зі змінними та функціями, проста система університету, обробка колекцій і даних, а також асинхронна робота з файлами.

## Запуск

Потрібен Dart SDK версії 3.0 або новішої. Відкрий термінал у папці проєкту, встанови залежності й запусти потрібну програму:

```powershell
dart pub get
dart run bin/task1_variables.dart
dart run bin/task2_functions.dart
dart run bin/task3_classes.dart
dart run bin/task4_collections.dart
dart run bin/task5_async.dart
```

Кожну команду `dart run` можна запускати окремо. Програми беруть приклади з папки `data/`.

## Папки проєкту

- `bin/` — п'ять програм для демонстрації завдань.
- `lib/models/` — класи студентів, курсів, викладачів та університету.
- `lib/utils/` — калькулятор, аналіз тексту й обробка даних.
- `data/` — приклади CSV- та JSON-файлів.
- `test/` — тести моделей і допоміжних функцій.
- `docs/` — UML-діаграма та інструкція з перевірок.
- `evidence/screenshots/` — знімки екрана запуску програм.

## Перевірки

Основні команди:

```powershell
dart analyze
dart run test/models_test.dart
dart run test/utils_test.dart
```

Інструкція для запуску тестів із покриттям коду є у [`docs/quality.md`](docs/quality.md). Час виконання асинхронної програми змінюється від запуску до запуску.

## Знімки екрана запуску

- [Завдання 1 — змінні й типи](evidence/screenshots/task1_variables.png)
- [Завдання 2 — функції](evidence/screenshots/task2_functions.png)
- [Завдання 3 — університетська система](evidence/screenshots/task3_classes.png)
- [Завдання 4 — колекції та дані](evidence/screenshots/task4_collections.png)
- [Завдання 5 — асинхронні операції](evidence/screenshots/task5_async.png)

## Репозиторій

[PracMob-4 на GitHub](https://github.com/TralalelaTralala/PracMob-4)
