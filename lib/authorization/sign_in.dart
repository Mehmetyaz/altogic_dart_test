import 'package:altogic_dart/altogic_dart.dart';

import '../utils.dart';

Future<UserSessionResult> signInWithEmailCorrect() {
  return client.auth.signInWithEmail(email, pwd);
}

Future<UserSessionResult> signInWithEmailWrongMail() {
  return client.auth.signInWithEmail(email.replaceFirst('y', 't'), pwd);
}

Future<UserSessionResult> signInWithEmailWrongPwd() {
  return client.auth.signInWithEmail(email, pwd.replaceFirst('y', 't'));
}
