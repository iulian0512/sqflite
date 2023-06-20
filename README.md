# sqflite

[![pub package](https://img.shields.io/pub/v/sqflite.svg)](https://pub.dev/packages/sqflite)
[![Build Status](https://travis-ci.org/tekartik/sqflite.svg?branch=master)](https://travis-ci.org/tekartik/sqflite)
[![codecov](https://codecov.io/gh/tekartik/sqflite/branch/master/graph/badge.svg)](https://codecov.io/gh/tekartik/sqflite)

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




## Setup for IOS
* Include the override for FMBD in your runner podfile, example
```

target 'Runner' do
  use_frameworks!
  use_modular_headers!
  pod 'FMDB' , :git => 'https://github.com/iulian0512/fmdb.git'. # here it is 

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
end

```
