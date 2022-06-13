import 'package:altogic_dart/altogic_dart.dart';
import 'package:altogic_dart_test/authorization/sign_in.dart';
import 'package:altogic_dart_test/authorization/sign_up.dart';

late AltogicClient client;

const envUrl = "https://c1-na.altogic.com/e:62a30491f3a9efcc5eb71193";
const clientKey = "abb823877b764da9a2a21c7318cd9d23";
const apiKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbnZJZCI6IjYyYTMwNDkxZjNhOWVmY2M1ZWI3MTE5MyIsImtleUlkIjoiNjJhMzA0OTJmM2E5ZWZjYzVlYjcxMTk5IiwiaWF0IjoxNjU0ODUwNzA2LCJleHAiOjI1MTg4NTA3MDZ9.vUtaI_ZjsqOLKBIbsxCijWNXrJxkuZhFjTIlFv8TMLo';

Future<APIResponse<Map<String, dynamic>>> ping(
    [AltogicClient? clientInstance]) async {
  return (clientInstance ?? client).endpoint.get('/ping').asMap();
}

Future<APIResponse<Map<String, dynamic>>> pingApiKey(
    [AltogicClient? clientInstance]) async {
  return (clientInstance ?? client).endpoint.get('/ping_api_key').asMap();
}

Future<APIResponse<Map<String, dynamic>>> pingSession(
    [AltogicClient? clientInstance]) async {
  return (clientInstance ?? client).endpoint.get('/ping_session').asMap();
}

const successPing = {'hello': 'world!'};

const email = 'mehmedyaz@gmail.com';
const phone = '+905530635063';
const pwd = 'mehmetyaz';

Future<APIResponse> clearUser([AltogicClient? clientInstance]) {
  return (clientInstance ?? client)
      .endpoint
      .delete('/clear_user', body: {'email': email, 'phone': phone}).asMap();
}

Future<APIResponse> validateMail([AltogicClient? clientInstance]) {
  return (clientInstance ?? client)
      .endpoint
      .post('/validate_mail', body: {'email': email, 'phone': phone}).asMap();
}

Future<void> setUpEmailUser(
    [bool signIn = true, AltogicClient? clientInstance]) async {
  await clearUser(clientInstance);
  await signUpWithEmailCorrect(clientInstance);
  await validateMail(clientInstance);
  if (signIn) await signInWithEmailCorrect(clientInstance);
}

Future<void> setUpPhoneUser(
    [bool signIn = true, AltogicClient? clientInstance]) async {
  await clearUser(clientInstance);
  await signUpWithPhoneCorrect(clientInstance);
  await validateMail(clientInstance);
  if (signIn) await signInWithPhoneCorrect(clientInstance);
}

extension Data on APIResponseBase {
  dynamic getData() {
    if (this is APIResponse) {
      return (this as APIResponse).data;
    } else if (this is UserSessionResult) {
      return (this as UserSessionResult).user == null &&
              (this as UserSessionResult).session == null
          ? null
          : {
              'user': (this as UserSessionResult).user?.toJson(),
              'session': (this as UserSessionResult).session?.toJson()
            };
    } else if (this is UserResult) {
      return (this as UserResult).user?.toJson();
    } else if (this is SessionResult) {
      return (this as SessionResult)
          .sessions
          ?.map((e) => e.toJson())
          .join('\n,');
    } else if (this is KeyListResult) {
      return (this as KeyListResult).data == null &&
              (this as KeyListResult).next == null
          ? null
          : {
              'data': (this as KeyListResult).data,
              'next': (this as KeyListResult).next,
            };
    }
  }
}
