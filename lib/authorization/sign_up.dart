import 'package:altogic_dart/altogic_dart.dart';

import '../utils.dart';

Future<UserSessionResult> signUpWithEmailCorrect() {
  return client.auth.signUpWithEmail(email, pwd);
}

Future<UserSessionResult> signUpWithEmailAllIncorrect() {
  return client.auth.signUpWithEmail(email.replaceFirst("@", ''), 'pwd');
}

Future<UserSessionResult> signUpWithEmailIncorrectMail() {
  return client.auth.signUpWithEmail(email.replaceFirst("@", ''), pwd);
}

Future<UserSessionResult> signUpWithEmailIncorrectPass() {
  return client.auth.signUpWithEmail(email, 'pwd');
}

Future<UserSessionResult> signUpWithPhoneCorrect() {
  return client.auth.signUpWithPhone(phone, pwd);
}

Future<UserSessionResult> signUpWithPhoneAllIncorrect() {
  return client.auth.signUpWithPhone(phone.replaceFirst("553", ''), 'pwd');
}

Future<UserSessionResult> signUpWithPhoneIncorrectMail() {
  return client.auth.signUpWithPhone(phone.replaceFirst("553", ''), pwd);
}

Future<UserSessionResult> signUpWithPhoneIncorrectPass() {
  return client.auth.signUpWithPhone(phone, 'pwd');
}
