import 'package:altogic_dart_test/authorization/sign_in.dart';
import 'package:altogic_dart_test/authorization/sign_up.dart';
import 'package:altogic_dart_test/authorization/local_storage.dart';
import 'package:altogic_dart_test/client/create_client.dart';
import 'package:altogic_dart_test/utils.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('sign_up_with_mail', () {
    createClientTest();
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
    createClientTest();
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

  test('clear_local_data', () async {
    var storage = FakeStorage();
    createClientWithFakeStorage(storage);

    await clearUser();
    await signUpWithEmailCorrect();
    await validateMail();
    var result = await signInWithEmail();

    expect(result.user, isNotNull);

    // expect saved success
    expect(storage.values['session'], isNotEmpty);
    expect(storage.values['user'], isNotEmpty);

    var session = await getSessionTest();
    var user = await getUserTest();
    expect(session, isNotNull);
    expect(user, isNotNull);
    //--

    await clearLocalDataTest();

    // expect clear success
    expect(storage.values['session'], isNull);
    expect(storage.values['user'], isNull);

    session = await getSessionTest();
    user = await getUserTest();
    expect(session, isNull);
    expect(user, isNull);
    //--
  });
}
