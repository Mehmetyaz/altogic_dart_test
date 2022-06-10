import 'package:altogic_dart/altogic_dart.dart';
import 'package:altogic_dart_test/authorization/sign_up.dart';
import 'package:altogic_dart_test/client/create_client.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

Future<APIResponse<Map<String, dynamic>>> ping() async {
  return client.endpoint.get('/ping').asMap();
}

Future<APIResponse<Map<String, dynamic>>> pingApiKey() async {
  return client.endpoint.get('/ping_api_key').asMap();
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

    test('api_key_required_success', () async {
      expect(createClientWithApiKey, returnsNormally);
      var result = await pingApiKey();
      expect(result.errors, isNull);
      expect(result.data, successPing);
    });

    test('api_key_required_missing_api_key', () async {
      expect(createClientTest, returnsNormally);
      var result = await pingApiKey();
      expect(result.errors, isNotNull);
      expect(result.errors!.status, 401);
      expect(result.errors!.items.first.code, 'missing_API_key');
    });

    test('api_key_required_incorrect_api_key', () async {
      expect(createClientWithIncorrectApiKey, returnsNormally);
      var result = await pingApiKey();
      expect(result.errors, isNotNull);
      expect(result.errors!.status, 401);
      expect(result.errors!.items.first.code, 'invalid_API_key');
    });
  });
}
