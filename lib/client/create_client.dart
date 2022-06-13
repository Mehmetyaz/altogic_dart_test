import 'package:altogic_dart/altogic_dart.dart';
import 'package:altogic_dart_test/authorization/local_storage.dart';

import '../utils.dart';

void createClientTest() {
  client = createClient(envUrl, clientKey);
}

void createClientTestIncorrectClient() {
  client = createClient(envUrl.replaceFirst('https://', ''), clientKey);
}

void createClientTestIncorrectEnvUrl() {
  client = createClient(envUrl.replaceFirst('altogic', 'a'), clientKey);
}

void createClientTestIncorrectClientKey() {
  client = createClient(envUrl, clientKey.replaceFirst('823', ''));
}

void createClientWithApiKey() {
  client = createClient(envUrl, clientKey, ClientOptions(apiKey: apiKey));
}

void createClientWithIncorrectApiKey() {
  client = createClient(envUrl, clientKey,
      ClientOptions(apiKey: apiKey.replaceFirst('M2E5ZWZjYzVlYjcx', '')));
}

void createClientWithFakeStorage(FakeStorage storage) {
  client =
      createClient(envUrl, clientKey, ClientOptions(localStorage: storage));
}
