import 'dart:convert';
import 'dart:typed_data';

import 'package:altogic_dart/altogic_dart.dart';
import 'package:altogic_dart_test/bucket_manager/create_bucket.dart';
import 'package:altogic_dart_test/utils.dart';

const fileName = 'hello.txt';
var fileContentString = 'altogic' * 100; // 700b
var longFileContentString = 'altogic' * 10000; // ~70kb
var veryLongFileContentString = 'altogic' * 750000; // ~5mb

var fileContent = utf8.encode(longFileContentString) as Uint8List;

Future<APIResponse<Map<String, dynamic>>> uploadTestFile() {
  return client.storage.bucket(testBucketName).upload(fileName, fileContent);
}
