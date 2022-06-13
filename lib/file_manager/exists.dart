import 'package:altogic_dart/altogic_dart.dart';
import 'package:altogic_dart_test/bucket_manager/bucket.dart';
import 'package:altogic_dart_test/bucket_manager/upload.dart';

Future<APIResponse<bool>> getTestFileExists() {
  return testBucket().file(fullFileName).exists();
}
