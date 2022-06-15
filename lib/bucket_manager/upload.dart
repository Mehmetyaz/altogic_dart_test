import 'dart:convert';
import 'dart:typed_data';

import 'package:altogic_dart/altogic_dart.dart';
import 'package:altogic_dart_test/bucket_manager/bucket.dart';
import 'package:altogic_dart_test/utils.dart';

const fileName = 'hello';
const fileExt = '.txt';

const fullFileName = fileName + fileExt;

var fileContentString = 'altogic' * 100; // 700b
var midFileContentString = 'altogic' * 10000; // ~70kb
var veryLongFileContentString = 'altogic' * 750000; // ~5mb

var fileContent = utf8.encode(midFileContentString) as Uint8List;

Future<APIResponse<Map<String, dynamic>>> uploadTestFile(
    {String? suffix, bool wrong = false}) {
  return client.storage
      .bucket(testBucketName.replaceFirst('test', wrong ? '' : 'test'))
      .upload(fileName + (suffix ?? '') + fileExt, fileContent,
          FileUploadOptions(createBucket: false));
}

Future<APIResponse<Map<String, dynamic>>> uploadMidTestFile([String? suffix]) {
  return client.storage.bucket(testBucketName).upload(
      '${fileName}_mid_${suffix ?? ''}$fileExt',
      utf8.encode(midFileContentString) as Uint8List);
}

Future<APIResponse<Map<String, dynamic>>> uploadLongTestFile(
    {OnUploadProgress? onUploadProgress, String? suffix}) {
  return client.storage.bucket(testBucketName).upload(
      '${fileName}_long_${suffix ?? ''}$fileExt',
      utf8.encode(veryLongFileContentString) as Uint8List,
      FileUploadOptions(onProgress: onUploadProgress));
}
