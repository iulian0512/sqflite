import 'package:sqflite_common_ffi_web/setup.dart';

Future<void> main() async {
  await setupSqfliteWebBinaries(
    options: SqfliteWebSetupOptions(force: true, verbose: true),
  );
}
