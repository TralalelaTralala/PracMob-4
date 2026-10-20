# Перевірки якості

Запускайте команди з кореня репозиторію:

```powershell
dart format --set-exit-if-changed bin lib test
dart analyze
dart run test/models_test.dart
dart run test/utils_test.dart
dart test --coverage=coverage
dart run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --packages=.dart_tool/package_config.json --report-on=lib
```

Дві окремі команди `dart run test/...` запускають набори тестів моделей і утиліт без test-runner worker processes. У CI команда `dart test --coverage=coverage` збирає coverage JSON, а наступна команда створює LCOV-звіт у `coverage/lcov.info`. Каталог `coverage/` не додається до Git; CI зберігає його окремо як артефакт. `coverage` вже входить до графа залежностей пакета `test`.

Для порівняння часу запустіть `dart run bin/task5_async.dart` кілька разів. У `data/async_report.json` записуються виміри саме поточного запуску. На малих локальних файлах паралельне читання може не бути швидшим через накладні витрати планувальника.

## Що покривають тести

- обчислення GPA, пройдених курсів і серіалізацію `Student`;
- правила зарахування, передумови, CRUD і статистику університету;
- операції калькулятора та помилки ділення на нуль;
- аналіз тексту з українськими символами;
- обробку колекцій і коректних/некоректних CSV-даних.

Локальний запуск тестів без coverage записаний у `evidence/`. Тестовий runner із дочірніми процесами та збір coverage можуть залежати від обмежень середовища; у звичайному середовищі їх запускає workflow `.github/workflows/dart.yml`.
