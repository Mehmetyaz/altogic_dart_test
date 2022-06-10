import 'package:altogic_dart/altogic_dart.dart';
import 'package:altogic_dart_test/client/create_client.dart';

const mail = 'mehmedyaz@gmail.com';
const pwd = 'mehmetyaz';

Future<UserSessionResult> signUpWithEmail() {
  return client.auth.signUpWithEmail(mail, pwd);
}
