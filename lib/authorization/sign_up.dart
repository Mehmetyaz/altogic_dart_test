import 'package:altogic_dart/altogic_dart.dart';

import '../utils.dart';

Future<UserSessionResult> signUpWithEmailCorrect() {
  return client.auth.signUpWithEmail(mail, pwd);
}

Future<UserSessionResult> signUpWithEmailAllIncorrect() {
  return client.auth.signUpWithEmail(mail.replaceFirst("@", ''), 'pwd');
}

Future<UserSessionResult> signUpWithEmailIncorrectMail() {
  return client.auth.signUpWithEmail(mail.replaceFirst("@", ''), pwd);
}

Future<UserSessionResult> signUpWithEmailIncorrectPass() {
  return client.auth.signUpWithEmail(mail, 'pwd');
}
