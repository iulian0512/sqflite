---
name: sqflite-common-ffi-web-test-suite
description: >-
  Use when running or reproducing the sqflite web (sqflite_common_ffi_web)
  browser tests with sqflite_common_ffi_web_test: setupSqfliteWebBinaries /
  SqfliteWebSetupOptions and the tool/setup_web_tests.dart step that downloads
  sqflite_sw_v1.js and sqlite3.wasm, dart test -p chrome (dart2js or
  dart2wasm), @TestOn('browser') suites built on createDatabaseFactoryFfiWeb,
  SqfliteFfiWebOptions (sharedWorkerUri, forceAsBasicWorker, indexedDbName,
  sqlite3WasmUri), databaseFactoryFfiWebNoWebWorker,
  ffiWebNoWebWorkerTestContext, getWebOptions, running the shared
  sqflite_common_test suite in a browser, and the web demo page.
---

# sqflite web browser tests (sqflite_common_ffi_web_test)

`sqflite_common_ffi_web_test` is the harness that runs the shared
`sqflite_common_test` suite in a real browser against
`sqflite_common_ffi_web`, in its three worker flavours, plus a demo page and
the setup tooling. It is the reference to copy when adding sqflite web tests to
an app.

## Guidelines

* The package has no public library: everything lives under `lib/src/`
  (`src/common.dart`, `src/import.dart`, `src/ui.dart`) and it is
  `publish_to: none`. Prefer copying the pattern below into your own package.
  If you really depend on it (inside the sqflite repo):
  ```yaml
  dev_dependencies:
    sqflite_common_ffi_web_test:
      git:
        url: https://github.com/tekartik/sqflite
        path: packages_web/sqflite_common_ffi_web_test
  ```
* Setup is mandatory before any browser test: the worker js file and the
  sqlite3 wasm file must sit next to the tests. Run
  `dart run tool/setup_web_tests.dart` (or `tool/setup_web_tests_force.dart`
  to re-download), which calls `setupSqfliteWebBinaries` from
  `package:sqflite_common_ffi_web/setup.dart` with
  `SqfliteWebSetupOptions(verbose: true, dir: 'test', force: force)`. For the
  demo page use `dir: 'web'` (the default) or the
  `dart run sqflite_common_ffi_web:setup` command.
* The generated worker file name is `sqflite_sw.js` unless the `sqflite:`
  section of `pubspec.yaml` overrides it — this package pins
  `sqflite_sw_v1.js`, which is why every test passes
  `sharedWorkerUri: Uri.parse('sqflite_sw_v1.js')`. Client and setup must
  agree on that name, or opening a database hangs/fails in the browser.
* Running: `dart test -p chrome` (`tool/run_web_tests.dart`), or
  `dart test -p chrome --compiler dart2wasm`
  (`tool/run_web_wasm_tests.dart`), or one file, e.g.
  `dart test -p chrome test/sqflite_ffi_web_basic_web_worker_test.dart`
  (`tool/setup_and_run_basic_worker_tests.dart` does setup + that run).
  `dart_test.yaml` sets `concurrency: 1`: the flavours share one IndexedDB
  origin, parallel test files corrupt each other.
* Test file shape: `@TestOn('browser')` before `library;`, an `async` `main()`
  that gives the flavour its own databases path
  (`setDatabasesPath('${await factory.getDatabasesPath()}_web')`), then
  `all.run(context)` from `package:sqflite_common_test/all_test.dart`. Wrap it
  in `try`/`catch` and declare a skipped test telling the reader to run the
  setup first — a missing wasm/worker file throws while `main()` is still
  declaring tests.
* The three flavours under test:
  * shared worker (default): `createDatabaseFactoryFfiWeb(options:
    SqfliteFfiWebOptions(sharedWorkerUri: ...))`.
  * basic worker (Android mobile web has no `SharedWorker`): same plus
    `forceAsBasicWorker: true`, which is `@visibleForTesting` and needs an
    `// ignore: invalid_use_of_visible_for_testing_member` outside a `test/`
    directory.
  * no worker (SQLite in the main isolate): `databaseFactoryFfiWebNoWebWorker`,
    already wrapped as `ffiWebNoWebWorkerTestContext` in `lib/src/common.dart`.
* Assert the flavour with `await factory.getWebOptions()`
  (`options.sharedWorkerUri`, `options.forceAsBasicWorker`): it also proves the
  worker actually answered. The extension (`DatabaseFactoryFfiWebExtension`) is
  not exported by the public `sqflite_ffi_web.dart`; import
  `package:sqflite_common_ffi_web_test/src/import.dart`, which re-exports it.
* The context is the plain `SqfliteLocalTestContext` from
  `package:sqflite_common_test/sqflite_test.dart`; on the web `isWeb` is true
  and `supportsMultipleInstances` is automatically false, so do not override
  those. See the `sqflite-common-test-suite` skill for the other flags, and
  `sqflite-common-ffi-web-setup` / `sqflite-common-ffi-web-options` for the
  factory itself.
* Two apps on the same origin (this package's `web/` page and
  `example/web1/`) must not share files nor storage: pass distinct
  `sqfliteWebWorkerFilename` / `sqlite3WasmFilename` at setup and matching
  `sharedWorkerUri` / `sqlite3WasmUri` / `indexedDbName` in the client.
* `lib/src/ui.dart` (`write(String)`, `addButton(text, action)`) is the tiny
  page output helper used by the demo; the html page must contain an
  `#output` and an `#input` element.
* VM-side tests in the same package check the setup itself
  (`test/setup_test.dart`, `test/dart_project_setup_test.dart`,
  `test/flutter_project_setup_test.dart`): they create a scratch project under
  `.dart_tool/`, run `dart pub add sqflite_common_ffi_web` and
  `dart run sqflite_common_ffi_web:setup`. They are slow
  (`Timeout(Duration(minutes: 5))`) and need network access.
* Anti-patterns: running `dart test -p chrome` without the setup step;
  raising `concurrency`; testing on the VM with `databaseFactoryFfiWeb`
  (browser only); reusing one databases path for two flavours.

## Examples

### Browser suite, shared worker flavour

```dart
@TestOn('browser')
library;

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite_common_ffi_web_test/src/import.dart';
import 'package:sqflite_common_test/all_test.dart' as all;
import 'package:sqflite_common_test/sqflite_test.dart';
import 'package:test/test.dart';

final _factory = createDatabaseFactoryFfiWeb(
  options: SqfliteFfiWebOptions(sharedWorkerUri: Uri.parse('sqflite_sw_v1.js')),
);

Future<void> main() async {
  sqfliteFfiInit();
  try {
    var dbsPath = await _factory.getDatabasesPath();
    await _factory.setDatabasesPath('${dbsPath}_web');

    test('options', () async {
      var options = await _factory.getWebOptions();
      expect(options.sharedWorkerUri, Uri.parse('sqflite_sw_v1.js'));
    });
    all.run(SqfliteLocalTestContext(databaseFactory: _factory));
  } catch (e) {
    test('Please run setup_web_tests first', () {}, skip: true);
  }
}
```

### Basic worker and no worker flavours

```dart
@TestOn('browser')
library;

// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite_common_ffi_web_test/src/import.dart';
import 'package:sqflite_common_test/all_test.dart' as all;
import 'package:sqflite_common_test/sqflite_test.dart';
import 'package:test/test.dart';

final _basicWorkerFactory = createDatabaseFactoryFfiWeb(
  options: SqfliteFfiWebOptions(
    forceAsBasicWorker: true,
    sharedWorkerUri: Uri.parse('sqflite_sw_v1.js'),
  ),
);

Future<void> main() async {
  var dbsPath = await _basicWorkerFactory.getDatabasesPath();
  await _basicWorkerFactory.setDatabasesPath('${dbsPath}_basic_worker');

  test('basic worker options', () async {
    expect(
      (await _basicWorkerFactory.getWebOptions()).forceAsBasicWorker,
      isTrue,
    );
  });
  all.run(SqfliteLocalTestContext(databaseFactory: _basicWorkerFactory));

  group('no_web_worker', () {
    all.run(
      SqfliteLocalTestContext(databaseFactory: databaseFactoryFfiWebNoWebWorker),
    );
  });
}
```

### Setup script for a test directory

```dart
import 'package:sqflite_common_ffi_web/setup.dart';

Future<void> main() async {
  await setupWebTests(force: true);
}

/// Downloads sqflite_sw*.js and sqlite3.wasm next to the tests.
Future<void> setupWebTests({bool? force}) async {
  await setupSqfliteWebBinaries(
    options: SqfliteWebSetupOptions(verbose: true, dir: 'test', force: force),
  );
}
```

### Setup with dedicated file names and storage (second app, same origin)

```dart
import 'package:path/path.dart';
import 'package:sqflite_common_ffi_web/setup.dart';

Future<void> main() async {
  await setupSqfliteWebBinaries(
    options: SqfliteWebSetupOptions(
      dir: join('example', 'web1'),
      verbose: true,
      force: true,
      sqfliteWebWorkerFilename: 'sqflite_sw_example_web1.js',
      sqlite3WasmFilename: 'sqlite3_example_web1.wasm',
    ),
  );
}
```

### Demo page reading the sqlite version

```dart
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite_common_ffi_web_test/src/ui.dart';

Future<void> main() async {
  var factory = createDatabaseFactoryFfiWeb(
    options: SqfliteFfiWebOptions(
      sharedWorkerUri: Uri.parse('sqflite_sw_example_web1.js'),
      sqlite3WasmUri: Uri.parse('sqlite3_example_web1.wasm'),
      indexedDbName: 'sqflite_databases_example_web1',
    ),
  );
  var db = await factory.openDatabase(inMemoryDatabasePath);
  var version = (await db.rawQuery('select sqlite_version()')).first.values.first;
  write('SQLite version: $version');
  await db.close();
}
```

### Commands

```bash
# once, and after any sqflite_common_ffi_web upgrade
dart run tool/setup_web_tests.dart
# all browser tests (dart2js), then the wasm variant
dart test -p chrome
dart test -p chrome --compiler dart2wasm
# one flavour
dart test -p chrome test/sqflite_ffi_web_no_web_worker_test.dart
# demo page on http://localhost:8080
dart run tool/build_and_serve.dart
```
