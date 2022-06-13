import 'package:altogic_dart/altogic_dart.dart';
import 'package:altogic_dart_test/utils.dart';

const String testBucketName = 'test_bucket';

Future<APIError?> removeTestBucket() async {
  return client.storage.bucket(testBucketName).delete();
}

Future<APIResponse<Map<String, dynamic>>> createBucketTest(
    {bool isPublic = false, List<String> tags = const []}) async {
  return client.storage
      .createBucket(testBucketName, tags: tags, isPublic: isPublic);
}

Future<APIResponse<bool>> bucketExists() async {
  return client.storage.bucket(testBucketName).exists();
}

Future<APIResponse<Map<String, dynamic>>> getBucketInfo() async {
  return client.storage.bucket(testBucketName).getInfo();
}
