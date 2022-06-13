import 'package:altogic_dart/altogic_dart.dart';
import 'package:altogic_dart_test/utils.dart';

const String testBucketName = 'test_bucket';

BucketManager testBucket() {
  return client.storage.bucket(testBucketName);
}

Future<APIError?> removeTestBucket() async {
  return testBucket().delete();
}

Future<APIResponse<Map<String, dynamic>>> createBucketTest(
    {bool isPublic = false, List<String> tags = const []}) async {
  return client.storage
      .createBucket(testBucketName, tags: tags, isPublic: isPublic);
}

Future<APIResponse<bool>> bucketExists() async {
  return testBucket().exists();
}

Future<APIResponse<Map<String, dynamic>>> getBucketInfo() async {
  return testBucket().getInfo();
}

Future<APIError?> empty() {
  return testBucket().empty();
}

Future<APIResponse> listFiles() {
  return testBucket().listFiles();
}
