import 'package:altogic_dart_test/bucket_manager/create_bucket.dart';
import 'package:altogic_dart_test/client/create_client.dart';
import 'package:altogic_dart_test/utils.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('exists', () {
    test('success', () async {
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
  });
}
