import 'package:altogic_dart_test/authorization/sign_up.dart';
import 'package:altogic_dart_test/client/create_client.dart';
import 'package:altogic_dart_test/utils.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  setUp(() async {
    createClientTest();
  });

  group('sign_up_with_mail', () {
    test('correct', () async {
      await clearUser();
      var signUpResult = await signUpWithEmailCorrect();

      expect(signUpResult.errors, isNull);
      expect(signUpResult.user, isNotNull);
      expect(signUpResult.session, isNull);
    });
  });
}
