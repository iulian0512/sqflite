# sqflite

[![pub package](https://img.shields.io/pub/v/sqflite.svg)](https://pub.dev/packages/sqflite)

SQLite plugin for [Flutter](https://flutter.io).
Supports iOS, Android and MacOS.

* Support transactions and batches
* Automatic version management during open
* Helpers for insert/query/update/delete queries
* DB operation executed in a background thread on iOS and Android
* Linux/Windows/DartVM support using [sqflite_common_ffi](https://pub.dev/packages/sqflite_common_ffi)

## Documentation

* [Documentation](https://github.com/tekartik/sqflite/blob/master/sqflite/README.md)
* [API reference](https://pub.dartlang.org/documentation/sqflite/latest/sqflite/sqflite-library.html)
* [How to](https://github.com/tekartik/sqflite/blob/master/sqflite/doc/how_to.md) guide




## SPATIALITE Setup for IOS
add the override in your project's pubspec.yaml
```
sqflite_darwin:
    git:
      url: https://github.com/iulian0512/sqflite
      path: sqflite_darwin
      ref: b433114c1f4481bd1aa72c56a1e29953b1533bb5
 
```
