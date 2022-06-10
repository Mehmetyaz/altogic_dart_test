import 'package:altogic_dart/altogic_dart.dart';
import 'package:altogic_dart_test/utils.dart';

Future<Session?> getSessionTest() {
  return client.auth.getSession();
}

Future<User?> getUserTest() {
  return client.auth.getUser();
}

void setUserTest(User user) {
  return client.auth.setUser(user);
}

void setSessionTest(Session session) {
  return client.auth.setSession(session);
}

Future<void> clearLocalDataTest() async {
  return client.auth.clearLocalData();
}

Future<void> invalidateSessionTest() async {
  return client.auth.invalidateSession();
}



class FakeStorage extends ClientStorage {
  final Map<String, String> values = {};

  @override
  Future<String?> getItem(String key) {
    return Future.value(values[key]);
  }

  @override
  Future<void> removeItem(String key) {
    return Future(() => values.remove(key));
  }

  @override
  Future<void> setItem(String key, String value) {
    return Future(() => values[key] = value);
  }
}
