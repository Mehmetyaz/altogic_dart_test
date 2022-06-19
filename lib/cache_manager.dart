import 'package:altogic_dart/altogic_dart.dart';
import 'package:altogic_dart_test/utils.dart';

Future<APIError?> addTestCache(Object value) {
  return client.cache.set('test_cache', value);
}

FutureApiResponse getTestCache() {
  return client.cache.get('test_cache');
}
