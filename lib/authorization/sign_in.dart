import 'package:altogic_dart/altogic_dart.dart';

import '../utils.dart';

Future<UserSessionResult> signInWithEmail() {
  return client.auth.signInWithEmail(email, pwd);
}
