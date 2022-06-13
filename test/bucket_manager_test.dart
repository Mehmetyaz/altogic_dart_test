import 'package:altogic_dart_test/bucket_manager/create_bucket.dart';
import 'package:altogic_dart_test/client/create_client.dart';
import 'package:altogic_dart_test/utils.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test(skip: true, 'exists', () async {
    createClientTest();

    await setUpEmailUser();

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

  test('get_info', () async {
    createClientTest();

    await setUpEmailUser();

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
}
