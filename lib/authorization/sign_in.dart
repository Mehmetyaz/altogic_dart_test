import 'package:altogic_dart/altogic_dart.dart';

import '../utils.dart';

Future<UserSessionResult> signInWithEmailCorrect(
    [AltogicClient? clientInstance]) {
  return (clientInstance ?? client).auth.signInWithEmail(email, pwd);
}

Future<UserSessionResult> signInWithEmailWrongMail() {
  return client.auth.signInWithEmail(email.replaceFirst('y', 't'), pwd);
}

Future<UserSessionResult> signInWithEmailWrongPwd() {
  return client.auth.signInWithEmail(email, pwd.replaceFirst('y', 't'));
}

Future<UserSessionResult> signInWithPhoneCorrect(
    [AltogicClient? clientInstance]) {
  return (clientInstance ?? client).auth.signInWithPhone(phone, pwd);
}

Future<UserSessionResult> signInWithPhoneWrongPhone() {
  return client.auth.signInWithPhone(phone.replaceFirst('55', '0'), pwd);
}

Future<UserSessionResult> signInWithPhoneWrongPwd() {
  return client.auth.signInWithPhone(phone, pwd.replaceFirst('y', 't'));
}
