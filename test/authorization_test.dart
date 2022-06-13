import 'package:altogic_dart/altogic_dart.dart';
import 'package:altogic_dart_test/authorization/sign_in.dart';
import 'package:altogic_dart_test/authorization/sign_out.dart';
import 'package:altogic_dart_test/authorization/sign_up.dart';
import 'package:altogic_dart_test/authorization/local_storage.dart';
import 'package:altogic_dart_test/client/create_client.dart';
import 'package:altogic_dart_test/utils.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'utils.dart';

void main() {
  group('sign_up_with_mail', () {
    createClientTest();
    test('correct', () async {
      await clearUser();
      var signUpResult = await signUpWithEmailCorrect();

      expect(signUpResult.errors, successResponse);
      expect(signUpResult.user, isNotNull);
      expect(signUpResult.session, isNull);
    });

    test('incorrect_all', () async {
      await clearUser();
      var signUpResult = await signUpWithEmailAllIncorrect();

      expect(signUpResult.errors, errorResponse);
      expect(signUpResult.errors!.items.length, 2);
      expect(signUpResult.user, isNull);
      expect(signUpResult.session, isNull);
    });

    test('incorrect_mail', () async {
      await clearUser();
      var signUpResult = await signUpWithEmailIncorrectMail();

      expect(signUpResult.errors, errorResponse);
      expect(signUpResult.errors!.items.length, 1);
      expect(signUpResult.user, isNull);
      expect(signUpResult.session, isNull);
    });

    test('incorrect_pwd', () async {
      await clearUser();
      var signUpResult = await signUpWithEmailIncorrectPass();

      expect(signUpResult.errors, errorResponse);
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

      expect(signUpResult.errors, successResponse);
      expect(signUpResult.user, isNotNull);
      // Verification not required. So session returns not null.
      expect(signUpResult.session, isNotNull);
    });

    test('incorrect_all', () async {
      await clearUser();
      var signUpResult = await signUpWithPhoneAllIncorrect();

      expect(signUpResult.errors, errorResponse);
      expect(signUpResult.errors!.items.length, 2);
      expect(signUpResult.user, isNull);
      expect(signUpResult.session, isNull);
    });

    test('incorrect_phone', () async {
      await clearUser();
      var signUpResult = await signUpWithPhoneIncorrectMail();

      expect(signUpResult.errors, errorResponse);
      expect(signUpResult.errors!.items.length, 1);
      expect(signUpResult.user, isNull);
      expect(signUpResult.session, isNull);
    });

    test('incorrect_pwd', () async {
      await clearUser();
      var signUpResult = await signUpWithPhoneIncorrectPass();

      expect(signUpResult.errors, errorResponse);
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
    var result = await signInWithEmailCorrect();

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

  test('invalidate_session', () async {
    var storage = FakeStorage();
    createClientWithFakeStorage(storage);

    await clearUser();
    await signUpWithEmailCorrect();
    await validateMail();
    var result = await signInWithEmailCorrect();

    expect(result.errors, successResponse);
    expect(result.user, isNotNull);

    // expect saved success
    expect(storage.values['session'], isNotEmpty);
    expect(storage.values['user'], isNotEmpty);

    var session = await getSessionTest();
    var user = await getUserTest();
    expect(session, isNotNull);
    expect(user, isNotNull);
    //--

    await invalidateSessionTest();

    // expect clear success
    expect(storage.values['session'], isNull);
    expect(storage.values['user'], isNull);

    session = await getSessionTest();
    user = await getUserTest();
    expect(session, isNull);
    expect(user, isNull);
    //--
  });

  group('set-get user-session', () {
    test('success', () async {
      // Flow : signIn - expect saved - clear - set user|session - expect saved
      var storage = FakeStorage();
      createClientWithFakeStorage(storage);
      await clearUser();
      await signUpWithEmailCorrect();
      await validateMail();
      await signInWithEmailCorrect();

      // expect saved success
      expect(storage.values['session'], isNotNull);
      expect(storage.values['user'], isNotNull);

      var session = await getSessionTest();
      var user = await getUserTest();
      expect(session, isNotNull);
      expect(user, isNotNull);
      //--

      await clearLocalDataTest();

      // set user-session
      await setSessionTest(session!);
      await setUserTest(user!);
      // --

      // expect get success
      session = await getSessionTest();
      user = await getUserTest();
      expect(session, isNotNull);
      expect(user, isNotNull);
      // --
    });

    test('not stored', () async {
      var storage = FakeStorage();
      createClientWithFakeStorage(storage);

      await setUpEmailUser();

      await clearLocalDataTest();
      // expect get success
      var session = await getSessionTest();
      var user = await getUserTest();
      expect(session, isNull);
      expect(user, isNull);
      // --
    });

    test('storage undefined', () async {
      createClientTest();
      await clearUser();
      await signUpWithEmailCorrect();
      await validateMail();
      var result = await signInWithEmailCorrect();

      expect(result.errors, successResponse);
      expect(result.user, isNotNull);
      expect(result.session, isNotNull);

      var session = result.session;
      var user = result.user;

      // expect unsaved
      var sessionGet = await getSessionTest();
      var userGet = await getUserTest();
      expect(sessionGet, isNull);
      expect(userGet, isNull);
      //--

      // set user-session
      await setSessionTest(session!);
      await setUserTest(user!);
      // --

      // expect unsaved
      sessionGet = await getSessionTest();
      userGet = await getUserTest();
      expect(sessionGet, isNull);
      expect(userGet, isNull);
      //--
    });
  });

  group('sign_in_with_email', () {
    test('correct', () async {
      createClientTest();
      await setUpEmailUser(false);

      var result = await signInWithEmailCorrect();
      expect(result.errors, successResponse);
      expect(result.user, isNotNull);
      expect(result.session, isNotNull);
    });

    test('already_signed', () async {
      createClientTest();
      await setUpEmailUser(false);

      var result = await signInWithEmailCorrect();
      expect(result.errors, successResponse);
      expect(result.user, isNotNull);
      expect(result.session, isNotNull);

      result = await signInWithEmailCorrect();
      expect(result.errors, successResponse);
      expect(result.user, isNotNull);
      expect(result.session, isNotNull);
    });

    test('incorrect_mail', () async {
      createClientTest();
      var result = await signInWithEmailWrongMail();
      expect(result.errors, errorResponse);
      expect(result.session, isNull);
      expect(result.user, isNull);
    });

    test('incorrect_pwd', () async {
      createClientTest();
      var result = await signInWithEmailWrongPwd();

      expect(result.errors, errorResponse);
      expect(result.session, isNull);
      expect(result.user, isNull);
    });
  });

  group('sign_in_with_phone', () {
    test('correct', () async {
      createClientTest();
      await setUpPhoneUser(false);

      var result = await signInWithPhoneCorrect();
      expect(result.errors, successResponse);
      expect(result.user, isNotNull);
      expect(result.session, isNotNull);
    });

    test('already_signed', () async {
      createClientTest();
      await setUpPhoneUser(false);

      var result = await signInWithPhoneCorrect();

      expect(result.errors, successResponse);
      expect(result.user, isNotNull);
      expect(result.session, isNotNull);

      result = await signInWithPhoneCorrect();

      expect(result.errors, successResponse);
      expect(result.user, isNotNull);
      expect(result.session, isNotNull);
    });

    test('incorrect_phone', () async {
      createClientTest();
      var result = await signInWithPhoneWrongPhone();

      expect(result.errors, errorResponse);
      expect(result.session, isNull);
      expect(result.user, isNull);
    });

    test('incorrect_pwd', () async {
      createClientTest();
      var result = await signInWithPhoneWrongPwd();

      expect(result.errors, errorResponse);
      expect(result.session, isNull);
      expect(result.user, isNull);
    });
  });

  group('sign_out', () {
    test('sign_out', () async {
      createClientTest();
      await setUpEmailUser();
      var ping = await pingSession();
      expect(ping, successResponse);
      var result = await signOutTest();
      expect(result, successResponse);

      ping = await pingSession();
      expect(ping, errorResponse);
      expect(ping.errors?.status, 401);
    });

    test('sign_out_already_signed_out', () async {
      createClientTest();
      var result = await signOutTest();
      expect(result, errorResponse);
      expect(result?.status, 401);

      var ping = await pingSession();
      expect(ping, errorResponse);
      expect(ping.errors?.status, 401);
    });
  });

  test('sign_out_all', () async {
    createClientTest();
    var client1 = client;
    var client2 = createClient(envUrl, clientKey);

    await setUpEmailUser(true, client1);
    await signInWithEmailCorrect(client2);

    var ping1Ftr = pingSession(client1);
    var ping2Ftr = pingSession(client2);

    var pings = await Future.wait([ping1Ftr, ping2Ftr]);

    expect(pings.where((element) => element.errors != null), isEmpty);

    await client1.auth.signOutAll();

    ping1Ftr = pingSession(client1);
    ping2Ftr = pingSession(client2);

    pings = await Future.wait([ping1Ftr, ping2Ftr]);

    expect(pings.where((element) => element.errors != null).length, 2);
  });

  test('sign_out_all_except_current', () async {
    createClientTest();
    var client1 = client;
    var client2 = createClient(envUrl, clientKey);

    await setUpEmailUser(true, client1);
    await signInWithEmailCorrect(client2);

    var ping1Ftr = pingSession(client1);
    var ping2Ftr = pingSession(client2);

    var pings = await Future.wait([ping1Ftr, ping2Ftr]);

    expect(pings.where((element) => element.errors != null), isEmpty);

    await client1.auth.signOutAllExceptCurrent();

    ping1Ftr = pingSession(client1);
    ping2Ftr = pingSession(client2);

    pings = await Future.wait([ping1Ftr, ping2Ftr]);

    expect(pings.where((element) => element.errors != null).length, 1);
    expect(pings[0], successResponse);
    expect(pings[1], errorResponse);
  });
}
