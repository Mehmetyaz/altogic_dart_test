import 'package:altogic_dart/altogic_dart.dart';
import 'package:altogic_dart_test/authorization/sign_in.dart';
import 'package:altogic_dart_test/authorization/sign_up.dart';

late AltogicClient client;

const envUrl = "https://c1-na.altogic.com/e:62a30491f3a9efcc5eb71193";
const clientKey = "abb823877b764da9a2a21c7318cd9d23";
const apiKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbnZJZCI6IjYyYTMwNDkxZjNhOWVmY2M1ZWI3MTE5MyIsImtleUlkIjoiNjJhMzA0OTJmM2E5ZWZjYzVlYjcxMTk5IiwiaWF0IjoxNjU0ODUwNzA2LCJleHAiOjI1MTg4NTA3MDZ9.vUtaI_ZjsqOLKBIbsxCijWNXrJxkuZhFjTIlFv8TMLo';

Future<APIResponse<Map<String, dynamic>>> ping() async {
  return client.endpoint.get('/ping').asMap();
}

Future<APIResponse<Map<String, dynamic>>> pingApiKey() async {
  return client.endpoint.get('/ping_api_key').asMap();
}

Future<APIResponse<Map<String, dynamic>>> pingSession() async {
  return client.endpoint.get('/ping_session').asMap();
}

const successPing = {'hello': 'world!'};

const email = 'mehmedyaz@gmail.com';
const phone = '+905530635063';
const pwd = 'mehmetyaz';

Future<APIResponse> clearUser() {
  return client.endpoint
      .delete('/clear_user', body: {'email': email, 'phone': phone}).asMap();
}

Future<APIResponse> validateMail() {
  return client.endpoint
      .post('/validate_mail', body: {'email': email, 'phone': phone}).asMap();
}

Future<void> setUpEmailUser([bool signIn = true]) async {
  await clearUser();
  await signUpWithEmailCorrect();
  await validateMail();
  if (signIn) await signInWithEmailCorrect();
}


Future<void> setUpPhoneUser([bool signIn = true]) async {
  await clearUser();
  await signUpWithPhoneCorrect();
  await validateMail();
  if (signIn) await signInWithPhoneCorrect();
}
