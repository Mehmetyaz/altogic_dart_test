import 'package:altogic_dart_test/cache_manager.dart';
import 'package:altogic_dart_test/client/create_client.dart';
import 'package:altogic_dart_test/utils.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'matcher.dart';

void main() {
  createClientTest();
  setUp(() async {
    await setUpEmailUser();
  });
  group('cache', () {
    test('set', () async {
      var result = await addTestCache(10);

      expect(result, successResponse);

      var cache = await getTestCache().asInt();

      expect(cache, successResponse);

      expect(cache.data, 10);
    });


    test('set_overwrite', () async {
      var result = await addTestCache(20);

      expect(result, successResponse);

      var cache = await getTestCache().asInt();

      expect(cache, successResponse);

      expect(cache.data, 20);
    });

    test('set_overwrite_with_different_type', () async {
      var result = await addTestCache('hello');

      expect(result, successResponse);

      var cache = await getTestCache().asString();

      expect(cache, successResponse);

      expect(cache.data, 'hello');
    });
  });
}
