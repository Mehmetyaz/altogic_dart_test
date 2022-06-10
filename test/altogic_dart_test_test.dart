import 'package:altogic_dart/altogic_dart.dart';
import 'package:altogic_dart_test/authorization/sign_up.dart';
import 'package:altogic_dart_test/client/create_client.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

Future<APIResponse<Map<String, dynamic>>> ping() async {
  return client.endpoint.get('/ping').asMap();
}

const successPing = {'hello': 'world!'};

void main() {
  group('createClient', () {
    test('correct', () async {
      expect(createClientTest, returnsNormally);
      expect(client.auth, isA<AuthManager>());
      var result = await ping();
      expect(result.errors, isNull);
      expect(result.data, successPing);
    });

    test('incorrect-client', () {
      expect(createClientTestIncorrectClient, throwsA(isA<ClientError>()));
    });

    test('incorrect-server-env-url', () async {
      expect(createClientTestIncorrectEnvUrl, returnsNormally);
      expect(ping, throwsException);
    });

    test('incorrect-server-client-key', () async {
      expect(createClientTestIncorrectClientKey, returnsNormally);
      var result = await signUpWithEmail();
      expect(result.errors, isNotNull);
      expect(result.errors!.status, 401);
      expect(result.errors!.items.first.code, 'invalid_client_key');
    });
  });
}
