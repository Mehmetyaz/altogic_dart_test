import 'package:altogic_dart/altogic_dart.dart';
import 'package:altogic_dart_test/utils.dart';

const String testBucketName = 'test_bucket';

Future<APIError?> removeTestBucket() async {
  return client.storage.bucket(testBucketName).delete();
}

Future<APIResponse<Map<String, dynamic>>> createBucketTest() async {
  return client.storage.createBucket(testBucketName);
}

Future<APIResponse<bool>> bucketExists() async {
  return client.storage.bucket(testBucketName).exists();
}
