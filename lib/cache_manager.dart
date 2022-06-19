import 'package:altogic_dart/altogic_dart.dart';
import 'package:altogic_dart_test/utils.dart';

const String testCacheKey = 'test_cache';


Future<APIError?> addTestCache(Object value) {
  return client.cache.set(testCacheKey, value);
}

FutureApiResponse getTestCache() {
  return client.cache.get(testCacheKey);
}
