import 'package:altogic_dart/altogic_dart.dart';

late AltogicClient client;

const envUrl = "https://c1-na.altogic.com/e:62a30491f3a9efcc5eb71193";
const clientKey = "abb823877b764da9a2a21c7318cd9d23";
const apiKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbnZJZCI6IjYyYTMwNDkxZjNhOWVmY2M1ZWI3MTE5MyIsImtleUlkIjoiNjJhMzA0OTJmM2E5ZWZjYzVlYjcxMTk5IiwiaWF0IjoxNjU0ODUwNzA2LCJleHAiOjI1MTg4NTA3MDZ9.vUtaI_ZjsqOLKBIbsxCijWNXrJxkuZhFjTIlFv8TMLo';

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
