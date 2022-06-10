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

    test('incorrect_all', () async {
      await clearUser();
      var signUpResult = await signUpWithEmailAllIncorrect();

      expect(signUpResult.errors, isNotNull);
      expect(signUpResult.errors!.items.length, 2);
      expect(signUpResult.user, isNull);
      expect(signUpResult.session, isNull);
    });

    test('incorrect_mail', () async {
      await clearUser();
      var signUpResult = await signUpWithEmailIncorrectMail();

      expect(signUpResult.errors, isNotNull);
      expect(signUpResult.errors!.items.length, 1);
      expect(signUpResult.user, isNull);
      expect(signUpResult.session, isNull);
    });

    test('incorrect_pwd', () async {
      await clearUser();
      var signUpResult = await signUpWithEmailIncorrectPass();

      expect(signUpResult.errors, isNotNull);
      expect(signUpResult.errors!.items.length, 1);
      expect(signUpResult.user, isNull);
      expect(signUpResult.session, isNull);
    });
  });



  group('sign_up_with_phone', () {
    test('correct', () async {
      await clearUser();
      var signUpResult = await signUpWithPhoneCorrect();

      expect(signUpResult.errors, isNull);
      expect(signUpResult.user, isNotNull);
      // Verification not required. So session returns not null.
      expect(signUpResult.session, isNotNull);
    });

    test('incorrect_all', () async {
      await clearUser();
      var signUpResult = await signUpWithPhoneAllIncorrect();

      expect(signUpResult.errors, isNotNull);
      expect(signUpResult.errors!.items.length, 2);
      expect(signUpResult.user, isNull);
      expect(signUpResult.session, isNull);
    });

    test('incorrect_phone', () async {
      await clearUser();
      var signUpResult = await signUpWithPhoneIncorrectMail();

      expect(signUpResult.errors, isNotNull);
      expect(signUpResult.errors!.items.length, 1);
      expect(signUpResult.user, isNull);
      expect(signUpResult.session, isNull);
    });

    test('incorrect_pwd', () async {
      await clearUser();
      var signUpResult = await signUpWithPhoneIncorrectPass();

      expect(signUpResult.errors, isNotNull);
      expect(signUpResult.errors!.items.length, 1);
      expect(signUpResult.user, isNull);
      expect(signUpResult.session, isNull);
    });
  });
  
  
  
  
  
  
  
  
}
