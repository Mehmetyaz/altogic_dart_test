import 'package:altogic_dart/altogic_dart.dart';

import '../utils.dart';

Future<UserSessionResult> signUpWithEmail() {
  return client.auth.signUpWithEmail(mail, pwd);
}

Future<UserSessionResult> signInWithEmail() {
  return client.auth.signInWithEmail(mail, pwd);
}
