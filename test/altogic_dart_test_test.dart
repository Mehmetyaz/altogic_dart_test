import 'package:altogic_dart/altogic_dart.dart';
import 'package:altogic_dart_test/client/cretate_client.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('createClient', () {
    test('correct', () {
      expect(createClientTest, returnsNormally);
      expect(client.auth, isA<AuthManager>());
    });
  });
}
