import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_example_common/batch_test_page.dart';
import 'package:sqflite_example_common/deprecated_test_page.dart';
import 'package:sqflite_example_common/exception_test_page.dart';
import 'package:sqflite_example_common/exp_test_page.dart';
import 'package:sqflite_example_common/manual_test_page.dart';
import 'package:sqflite_example_common/src/dev_utils.dart';

import 'io_test_page.dart';
import 'model/main_item.dart';
import 'open_test_page.dart';
import 'raw_test_page.dart';
import 'slow_test_page.dart';
import 'src/main_item_widget.dart';
import 'todo_test_page.dart';
import 'type_test_page.dart';
export 'utils.dart' show supportsCompatMode;

/// Example app main entry point, exported for external application
///
/// might move to a different shared package.
void mainExampleApp() {
  WidgetsFlutterBinding.ensureInitialized();
  // debugAutoStartRouteName = testOpenRoute;
  runApp(const SqfliteExampleApp());
}

/// Sqflite test app
class SqfliteExampleApp extends StatefulWidget {
  /// test app.
  const SqfliteExampleApp({super.key});
  // This widget is the root of your application.

  @override
  // ignore: library_private_types_in_public_api
  _SqfliteExampleAppState createState() => _SqfliteExampleAppState();
}

/// Simple test page.
const String testRawRoute = '/test/simple';

/// Open test page.
const String testOpenRoute = '/test/open';

/// Slow test page.
const String testSlowRoute = '/test/slow';

/// Type test page.
const String testTypeRoute = '/test/type';

/// Batch test page.
const String testBatchRoute = '/test/batch';

/// `todo` example test page.
const String testTodoRoute = '/test/todo';

/// Exception test page.
const String testExceptionRoute = '/test/exception';

/// Manual test page.
const String testManualRoute = '/test/manual';

/// Experiment test page.
const String testExpRoute = '/test/exp';

/// IO only test page.
const String testIoRoute = '/test/io';

/// Deprecated test page.
const String testDeprecatedRoute = '/test/deprecated';

/// Extra routes added by the application.
Map<String, WidgetBuilder>? extraRoutes;

class _SqfliteExampleAppState extends State<SqfliteExampleApp> {
  var routes = <String, WidgetBuilder>{
    '/test': (BuildContext context) => MyHomePage(),
    testRawRoute: (BuildContext context) => RawTestPage(),
    testOpenRoute: (BuildContext context) => OpenTestPage(),
    testSlowRoute: (BuildContext context) => SlowTestPage(),
    testTodoRoute: (BuildContext context) => TodoTestPage(),
    testTypeRoute: (BuildContext context) => TypeTestPage(),
    testManualRoute: (BuildContext context) => const ManualTestPage(),
    testBatchRoute: (BuildContext context) => BatchTestPage(),
    testExceptionRoute: (BuildContext context) => ExceptionTestPage(),
    testExpRoute: (BuildContext context) => ExpTestPage(),
    if (!kIsWeb) testIoRoute: (BuildContext context) => IoTestPage(),
    testDeprecatedRoute: (BuildContext context) => DeprecatedTestPage(),
  }..addAll(extraRoutes ?? {});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sqflite Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with 'flutter run'. You'll see
        // the application has a blue toolbar. Then, without quitting
        // the app, try changing the primarySwatch below to Colors.green
        // and then invoke 'hot reload' (press 'r' in the console where
        // you ran 'flutter run', or press Run > Hot Reload App in IntelliJ).
        // Notice that the counter didn't reset back to zero -- the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Sqflite Demo Home Page'),
      routes: routes,
    );
  }
}

/// App home menu page.
class MyHomePage extends StatefulWidget {
  /// App home menu page.
  MyHomePage({super.key, this.title}) {
    _items.add(
      MainItem('Raw tests', 'Raw SQLite operations', route: testRawRoute),
    );
    _items.add(
      MainItem(
        'Open tests',
        'Open onCreate/onUpgrade/onDowngrade',
        route: testOpenRoute,
      ),
    );
    _items.add(
      MainItem('Type tests', 'Test value types', route: testTypeRoute),
    );
    _items.add(
      MainItem('Batch tests', 'Test batch operations', route: testBatchRoute),
    );
    _items.add(
      MainItem('Slow tests', 'Lengthy operations', route: testSlowRoute),
    );
    _items.add(
      MainItem(
        'Todo database example',
        'Simple Todo-like database usage example',
        route: testTodoRoute,
      ),
    );
    _items.add(
      MainItem(
        'Exp tests',
        'Experimental and various tests',
        route: testExpRoute,
      ),
    );
    _items.add(
      MainItem(
        'Exception tests',
        'Tests that trigger exceptions',
        route: testExceptionRoute,
      ),
    );
    if (!kIsWeb) {
      _items.add(MainItem('IO tests', 'IO tests', route: testIoRoute));
    }
    _items.add(
      MainItem(
        'Manual tests',
        'Tests that requires manual execution',
        route: testManualRoute,
      ),
    );

    _items.add(
      MainItem(
        'Deprecated test',
        'Keeping some old tests for deprecated functionalities',
        route: testDeprecatedRoute,
      ),
    );
    if (extraRoutes != null) {
      for (var entry in extraRoutes!.entries) {
        _items.add(MainItem(entry.key, 'Extra test', route: entry.key));
      }
    }
    // Uncomment to view all logs
    //Sqflite.devSetDebugModeOn(true);
  }

  final List<MainItem> _items = [];

  /// Page title.
  final String? title;

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

String? _debugAutoStartRouteName;

/// (debug) set the route to start with.
String? get debugAutoStartRouteName => _debugAutoStartRouteName;

/// Deprecated to avoid calls
@Deprecated('Deb only')
set debugAutoStartRouteName(String? routeName) =>
    _debugAutoStartRouteName = routeName;

class _MyHomePageState extends State<MyHomePage> {
  int get _itemCount => widget._items.length;

  @override
  void initState() {
    super.initState();

    Future<void>.delayed(Duration.zero).then((_) async {
      if (mounted) {
        // Use it to auto start a test page
        if (debugAutoStartRouteName != null) {
          // only once

          // await Navigator.of(context).pushNamed(testExpRoute);
          // await Navigator.of(context).pushNamed(testRawRoute);
          final future = Navigator.of(
            context,
          ).pushNamed(debugAutoStartRouteName!);
          // ignore: deprecated_member_use_from_same_package
          debugAutoStartRouteName = null;
          await future;
          // await Navigator.of(context).pushNamed(testExceptionRoute);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Sqflite demo', textAlign: TextAlign.center),
        ),
      ),
      body: ListView.builder(itemBuilder: _itemBuilder, itemCount: _itemCount),
    );
  }

  //new Center(child: new Text('Running on: $_platformVersion\n')),

  Widget _itemBuilder(BuildContext context, int index) {
    return MainItemWidget(widget._items[index], (MainItem item) {
      Navigator.of(context).pushNamed(item.route!);
    });
  }
}
