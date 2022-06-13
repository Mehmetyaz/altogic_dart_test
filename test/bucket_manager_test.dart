import 'package:altogic_dart_test/bucket_manager/create_bucket.dart';
import 'package:altogic_dart_test/bucket_manager/upload.dart';
import 'package:altogic_dart_test/client/create_client.dart';
import 'package:altogic_dart_test/file_manager/exists.dart';
import 'package:altogic_dart_test/utils.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  setUp(() async {
    createClientTest();
    await setUpEmailUser();
  });

  test(skip: true, 'exists', () async {
    await removeTestBucket();
    var exists = await bucketExists();

    expect(exists.errors, isNull);
    expect(exists.data, false);

    var createResult = await createBucketTest();

    expect(createResult.errors, isNull);
    expect(createResult.data, isNotNull);

    exists = await bucketExists();

    expect(exists.errors, isNull);
    expect(exists.data, true);
  });

  test(skip: true, 'get_info', () async {
    await removeTestBucket();
    var bucketInfo = await getBucketInfo();

    expect(bucketInfo.errors, isNotNull);
    expect(bucketInfo.data, isNull);

    var createResult =
        await createBucketTest(isPublic: true, tags: ['test_tag1']);

    expect(createResult.errors, isNull);
    expect(createResult.data, isNotNull);

    bucketInfo = await getBucketInfo();

    expect(bucketInfo.errors, isNull);
    expect(bucketInfo.data, isNotNull);

    var data = bucketInfo.data!;

    expect(data['name'], testBucketName);
    expect(data['isPublic'], true);
    expect(data['tags'], contains('test_tag1'));
  });

  test('empty', () async {
    await removeTestBucket();
    var createResult =
        await createBucketTest(isPublic: true, tags: ['test_tag1']);

    expect(createResult.errors, isNull);
    expect(createResult.data, isNotNull);

    var uploaded = await uploadTestFile();

    expect(uploaded.errors, isNull);
    expect(uploaded.data, isNotNull);

    var fileExists = await getTestFileExists();

    expect(fileExists.errors, isNull);
    expect(fileExists.data, true);

    var emptyResult = await empty();

    expect(emptyResult, isNull);

    fileExists = await getTestFileExists();

    expect(fileExists.errors, isNull);
    expect(fileExists.data, false);
  });
}
