# Локальні результати перевірки

Дата запуску: 2026-10-20. Dart SDK: 3.13.3.

- `dart format bin lib test`: успішно, форматування без подальших змін.
- `dart analyze`: `No issues found!`.
- `dart run test/models_test.dart`: 6 тестів пройшли.
- `dart run test/utils_test.dart`: 5 тестів пройшли.
- Усі п'ять `dart run bin/taskN_*.dart`: завершилися з кодом 0.
- `task4_collections.dart`: створив `data/analysis_report.json` для 5 рядків CSV.
- `task5_async.dart`: створив `data/async_report.json`; на останньому запуску послідовне читання зайняло 4041 мкс, паралельне — 2560 мкс. JSON-результати обох способів збіглися. Це один вимір на локальних маленьких файлах, а не стабільний benchmark.

Локальні окремі набори тестів пройшли успішно. Пакетний runner та збір coverage тут не завершилися: запуск дочірнього Dart-процесу завершувався кодом `0xC0000008` у цьому обмеженому середовищі. Тому тут не вказано вигаданий відсоток покриття. Workflow `.github/workflows/dart.yml` запускає пакетний coverage збір у стандартному GitHub Linux runner та зберігає LCOV як артефакт.
