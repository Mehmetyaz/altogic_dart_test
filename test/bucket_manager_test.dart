import 'package:altogic_dart_test/bucket_manager/bucket.dart';
import 'package:altogic_dart_test/bucket_manager/upload.dart';
import 'package:altogic_dart_test/client/create_client.dart';
import 'package:altogic_dart_test/file_manager/exists.dart';
import 'package:altogic_dart_test/utils.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'utils.dart';

void main() {
  setUp(() async {
    createClientTest();
    await setUpEmailUser();
  });

  test('exists', () async {
    await removeTestBucket();
    var exists = await bucketExists();

    expect(exists, successResponse);
    expect(exists.data, false);

    var createResult = await createBucketTest();

    expect(createResult, successResponse);

    exists = await bucketExists();

    expect(exists, successResponse);
    expect(exists.data, true);
  });

  test('get_info', () async {
    await removeTestBucket();
    var bucketInfo = await getBucketInfo();

    expect(bucketInfo, errorResponse);

    var createResult =
        await createBucketTest(isPublic: true, tags: ['test_tag1']);

    expect(createResult, successResponse);

    bucketInfo = await getBucketInfo();

    expect(bucketInfo, successResponse);

    var data = bucketInfo.data!;

    expect(data['name'], testBucketName);
    expect(data['isPublic'], true);
    expect(data['tags'], contains('test_tag1'));
  });

  test('empty', () async {
    await removeTestBucket();
    var createResult =
        await createBucketTest(isPublic: true, tags: ['test_tag1']);

    expect(createResult, successResponse);

    var uploaded = await uploadTestFile();

    expect(uploaded, successResponse);

    var fileExists = await getTestFileExists();

    expect(fileExists, successResponse);
    expect(fileExists.data, true);

    var emptyResult = await empty();

    expect(emptyResult, isNull);

    fileExists = await getTestFileExists();

    expect(fileExists, successResponse);
    expect(fileExists.data, false);
  });

  test('empty_not_exists', () async {
    await removeTestBucket();
    var emptyResult = await empty();
    expect(emptyResult, isNotNull);
  });

  test('rename', () async {
    await removeTestBucket();

    var result =
        await client.storage.bucket(testBucketName).rename('new_test_bucket');

    expect(result, errorResponse);

    await createBucketTest();

    result =
        await client.storage.bucket(testBucketName).rename('new_test_bucket');

    expect(result, successResponse);
    var bucketExists = await client.storage.bucket('new_test_bucket').exists();

    expect(bucketExists, successResponse);
    expect(bucketExists.data, true);

    await client.storage.bucket('new_test_bucket').delete();
  });

  test('delete', () async {
    await removeTestBucket();
    await createBucketTest();

    var existsRes = await bucketExists();

    expect(existsRes, successResponse);

    var result = await removeTestBucket();

    expect(result, isNull);

    result = await removeTestBucket();

    expect(result, isNotNull);
  });

  group('make_public', () {
    test('exists', () async {
      await removeTestBucket();
      await createBucketTest(isPublic: false);

      var existsRes = await bucketExists();

      expect(existsRes, successResponse);

      var result = await testBucket().makePublic();

      expect(result, successResponse);

      var info = await getBucketInfo();

      expect(info, successResponse);
      expect(info.data!['isPublic'], true);
    });

    test('not_exists', () async {
      await removeTestBucket();

      var existsRes = await bucketExists();

      expect(existsRes, successResponse);
      expect(existsRes.data, false);

      var result = await testBucket().makePublic();

      expect(result, errorResponse);
    });

    test('already_public', () async {
      await removeTestBucket();
      await createBucketTest(isPublic: true);

      var result = await testBucket().makePublic();

      expect(result, successResponse);
    });
  });

  group('make_private', () {
    test('exists', () async {
      await removeTestBucket();
      await createBucketTest(isPublic: true);

      var existsRes = await bucketExists();

      expect(existsRes, successResponse);

      var result = await testBucket().makePrivate();

      expect(result, successResponse);

      var info = await getBucketInfo();

      expect(info, successResponse);
      expect(info.data!['isPublic'], false);
    });

    test('not_exists', () async {
      await removeTestBucket();

      var existsRes = await bucketExists();

      expect(existsRes, successResponse);
      expect(existsRes.data, false);

      var result = await testBucket().makePrivate();

      expect(result, errorResponse);
    });

    test('already_private', () async {
      await removeTestBucket();
      await createBucketTest(isPublic: false);

      var result = await testBucket().makePrivate();

      expect(result, successResponse);
    });
  });

  group('list_files', () {
    test('success', () async {
      await removeTestBucket();
      await createBucketTest(isPublic: true);

      var uploads = await Future.wait([
        uploadTestFile('1'),
        uploadTestFile('2'),
        uploadTestFile('3'),
        uploadTestFile('4'),
      ]);

      expect(uploads.where((element) => element.errors != null), isEmpty);

      var result = await listFiles();

      expect(result, successResponse);
      expect(result.data, isA<List>());

      var data = result.data as List;

      expect(data.length, 4);
      expect(
          data.map((e) => e['fileName']),
          allOf(contains('hello1.txt'), contains('hello2.txt'),
              contains('hello3.txt'), contains('hello4.txt')));
    });

    test('empty', () async {
      await removeTestBucket();
      await createBucketTest(isPublic: true);

      var uploads = await Future.wait([
        uploadTestFile('1'),
        uploadTestFile('2'),
        uploadTestFile('3'),
        uploadTestFile('4'),
      ]);

      expect(uploads.where((element) => element.errors != null), isEmpty);

      await empty();

      var result = await listFiles();

      expect(result, successResponse);
      expect(result.data, isA<List>());

      var data = result.data as List;

      expect(data, isEmpty);
    });

    test('not_exists', () async {
      await removeTestBucket();

      var existsRes = await bucketExists();

      expect(existsRes, successResponse);
      expect(existsRes.data, false);

      var result = await testBucket().listFiles();

      expect(result, errorResponse);
    });
  });

  group('upload', () {
    test('short_file', () async {
      await removeTestBucket();
      await createBucketTest();
      var result = await uploadTestFile();
      expect(result, successResponse);
    });
  });
}
