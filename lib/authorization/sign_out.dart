import 'package:altogic_dart/altogic_dart.dart';
import 'package:altogic_dart_test/utils.dart';

Future<APIError?> signOutTest() {
  return client.auth.signOut();
}

Future<APIError?> signOutAllTest() {
  return client.auth.signOutAll();
}

Future<APIError?> signOutAllExceptCurrentTest() {
  return client.auth.signOutAllExceptCurrent();
}
