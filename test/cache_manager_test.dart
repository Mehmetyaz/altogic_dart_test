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

    test('get_success', () async {
      var result = await addTestCache('hello');

      expect(result, successResponse);

      var cache = await getTestCache().asString();

      expect(cache, successResponse);

      expect(cache.data, 'hello');
    });

    test('get_not_exists', () async {
      var result = await addTestCache('hello');

      expect(result, successResponse);

      var cache = await client.cache.get('not_exists').asString();

      expect(cache.errors, isNull);
      expect(cache.data, isNull);
    });

    test('delete', () async {
      var result = await addTestCache('hello');

      expect(result, successResponse);

      var cache = await client.cache.delete(testCacheKey);
      expect(cache, successResponse);

      var value = await getTestCache().asDynamic();

      expect(value.data, isNull);
      expect(value.errors, isNull);
    });

    test('delete_not_exists_key', () async {
      var result = await addTestCache('hello');

      expect(result, successResponse);

      await client.cache.delete(testCacheKey);

      var cache = await client.cache.delete(testCacheKey);
      expect(cache, successResponse);

      var value = await getTestCache().asDynamic();

      expect(value.data, isNull);
      expect(value.errors, isNull);
    });

    group('increment/decrement', () {
      test('success', () async {
        var result = await addTestCache(10);

        expect(result, successResponse);

        var increment = await client.cache.increment(testCacheKey, 1);

        expect(increment, successResponse);

        var cache = await getTestCache().asInt();

        expect(cache, successResponse);

        expect(cache.data, 11);

        var decrement = await client.cache.decrement(testCacheKey, 5);

        expect(decrement, successResponse);

        cache = await getTestCache().asInt();

        expect(cache, successResponse);

        expect(cache.data, 6);
      });

      test('not_exists_inc', () async {
        await client.cache.delete('not_exists_inc');
        var increment = await client.cache.increment('not_exists_inc', 1);

        expect(increment, successResponse);

        var cache = await client.cache.get('not_exists_inc').asInt();

        expect(cache, successResponse);
        expect(cache.data, 1);
      });

      test('not_exists_dec', () async {
        await client.cache.delete('not_exists_dec');
        var increment = await client.cache.decrement('not_exists_dec', 1);

        expect(increment, successResponse);

        var cache = await client.cache.get('not_exists_dec').asInt();

        expect(cache, successResponse);
        expect(cache.data, -1);
      });
    });

    test('expire_success', () async {
      var setResult = await client.cache.set('expire', 'hello', ttl: 3);

      expect(setResult, successResponse);

      await Future.delayed(Duration(seconds: 5));

      var value = await client.cache.get('expire').asDynamic();

      expect(value.data, isNull);
      expect(value.errors, isNull);
    });

    test('stats', () async {
      await addTestCache(10);

      var stats = await client.cache.getStats();

      expect(stats, successResponse);
    });

    test(skip:true,'list_keys', () async {
      await addTestCache(10);

      var list = await client.cache.listKeys(null, null);

      var cached = await getTestCache().asInt();

      print(cached.data);

      print(list.data);

      print(list.next);
      print(list.errors);

      expect(list, successResponse);
      expect(list.data, isNotEmpty);
    });
  });
}
