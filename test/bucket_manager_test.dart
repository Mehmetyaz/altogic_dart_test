import 'package:altogic_dart_test/bucket_manager/bucket.dart';
import 'package:altogic_dart_test/bucket_manager/upload.dart';
import 'package:altogic_dart_test/client/create_client.dart';
import 'package:altogic_dart_test/file_manager/exists.dart';
import 'package:altogic_dart_test/utils.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'matcher.dart';

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
        uploadTestFile(suffix: '1'),
        uploadTestFile(suffix: '2'),
        uploadTestFile(suffix: '3'),
        uploadTestFile(suffix: '4'),
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
        uploadTestFile(suffix: '1'),
        uploadTestFile(suffix: '2'),
        uploadTestFile(suffix: '3'),
        uploadTestFile(suffix: '4'),
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

    test('medium_file', () async {
      await removeTestBucket();
      await createBucketTest();
      var result = await uploadMidTestFile();
      expect(result, successResponse);
    });

    test('long_file - on progress check', () async {
      await removeTestBucket();
      await createBucketTest();
      var i = 0;
      var result = await uploadLongTestFile(
          onUploadProgress: (total, uploaded, percentComplete) {
        i++;
      });
      expect(result, successResponse);
      expect(i > 10, true);
    });

    test('wrong_bucket', () async {
      await removeTestBucket();
      await createBucketTest();
      var result = await uploadTestFile(wrong: true);
      expect(result, errorResponse);
    });
  });

  group('delete_files', () {
    test('success', () async {
      await removeTestBucket();
      await createBucketTest(isPublic: true);

      var uploads = await Future.wait([
        uploadTestFile(suffix: '1'),
        uploadTestFile(suffix: '2'),
        uploadTestFile(suffix: '3'),
        uploadTestFile(suffix: '4'),
      ]);

      expect(uploads.where((element) => element.errors != null), isEmpty);

      var names = List.generate(
          4, (index) => fileName + ((index + 1).toString()) + fileExt);

      var deleteResult = await deleteFiles(names.toList());

      expect(deleteResult, successResponse);

      var result = await listFiles();

      expect(result, successResponse);
      expect(result.data, isA<List>());

      var data = result.data as List;

      expect(data, isEmpty);
    });

    test('some exists some not', () async {
      await removeTestBucket();
      await createBucketTest(isPublic: true);

      var uploads = await Future.wait([
        uploadTestFile(suffix: '1'),
        uploadTestFile(suffix: '2'),
        uploadTestFile(suffix: '3'),
        uploadTestFile(suffix: '4'),
      ]);

      expect(uploads.where((element) => element.errors != null), isEmpty);

      var names = [
        ...List.generate(
            2, (index) => fileName + ((index + 1).toString()) + fileExt),
        ...List.generate(
            2, (index) => fileName + ((index + 30).toString()) + fileExt)
      ];

      var deleteResult = await deleteFiles(names.toList());

      expect(deleteResult, successResponse);

      var result = await listFiles();

      expect(result, successResponse);
      expect(result.data, isA<List>());

      var data = result.data as List;

      expect(data.length, 2);
    });

    test('all not exists', () async {
      await removeTestBucket();
      await createBucketTest(isPublic: true);

      var uploads = await Future.wait([
        uploadTestFile(suffix: '1'),
        uploadTestFile(suffix: '2'),
        uploadTestFile(suffix: '3'),
        uploadTestFile(suffix: '4'),
      ]);

      expect(uploads.where((element) => element.errors != null), isEmpty);

      var names = List.generate(
          4, (index) => fileName + ((index + 30).toString()) + fileExt);

      var deleteResult = await deleteFiles(names.toList());

      expect(deleteResult, successResponse);

      var result = await listFiles();

      expect(result, successResponse);
      expect(result.data, isA<List>());

      var data = result.data as List;

      expect(data.length, 4);
    });

    test('bucket not exists', () async {
      await removeTestBucket();
      await createBucketTest(isPublic: true);

      await uploadTestFile();

      await removeTestBucket();

      var deleteResult = await deleteFiles([fullFileName]);

      expect(deleteResult, errorResponse);
    });
  });

  group('tags', () {
    test('success', () async {
      await removeTestBucket();
      await createBucketTest();

      var addRes = await testBucket().addTags(['tag1', 'tag2']);

      expect(addRes, successResponse);

      var bucketInfo = await testBucket().getInfo();

      expect(bucketInfo, successResponse);

      expect(
          bucketInfo.data!['tags'], allOf(contains('tag1'), contains('tag2')));

      var removeRes = await testBucket().removeTags(['tag1', 'tag2']);

      expect(removeRes, successResponse);

      bucketInfo = await testBucket().getInfo();

      expect(bucketInfo, successResponse);

      expect(bucketInfo.data!['tags'], isEmpty);
    });

    test('not exists', () async {
      var addRes = await client.storage.bucket('nameOrId').addTags(['tag']);
      var removeRes =
          await client.storage.bucket('nameOrId').removeTags(['tag']);

      expect(addRes, errorResponse);
      expect(removeRes, errorResponse);
    });

    group('update_info', () {
      test('name', () async {
        await client.storage
            .bucket('newName')
            .updateInfo(newName: testBucketName, isPublic: true);

        var bucket = testBucket();
        var res = await bucket.updateInfo(newName: 'newName', isPublic: true);

        expect(res, successResponse);

        var exists = await client.storage.bucket('newName').exists();

        expect(exists, successResponse);

        expect(exists.data, true);

        await client.storage
            .bucket('newName')
            .updateInfo(newName: testBucketName, isPublic: true);
      });

      test('public', () async {
        await removeTestBucket();
        // default public is false.
        await createBucketTest();
        var bucket = testBucket();
        var res =
            await bucket.updateInfo(newName: testBucketName, isPublic: true);

        expect(res, successResponse);

        var info = await bucket.getInfo();

        expect(info, successResponse);

        expect(info.data!['isPublic'], true);
      });

      test('tags', () async {
        await removeTestBucket();
        await createBucketTest();
        var bucket = testBucket();
        var res = await bucket.updateInfo(
            newName: testBucketName, isPublic: false, tags: ['tag1', 'tag2']);

        expect(res, successResponse);

        var info = await bucket.getInfo();

        expect(info, successResponse);

        expect(info.data!['isPublic'], false);
        expect(info.data!['tags'], isA<List>());
        expect(info.data!['tags'], allOf(contains('tag1'), contains('tag2')));
      });

      test('not exists', () async {
        await removeTestBucket();
        var bucket = testBucket();
        var res = await bucket.updateInfo(
            newName: testBucketName, isPublic: false, tags: ['tag1', 'tag2']);

        expect(res, errorResponse);

        var exists = await bucket.exists();

        expect(exists, successResponse);

        expect(exists.data, false);
      });
    });
  });
}
