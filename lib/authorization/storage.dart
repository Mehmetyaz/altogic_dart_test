import 'package:altogic_dart/altogic_dart.dart';

class FakeStorage extends ClientStorage {
  final Map<String, String> _values = {};

  @override
  Future<String?> getItem(String key) {
    return Future.value(_values[key]);
  }

  @override
  Future<void> removeItem(String key) {
    return Future(() => _values.remove(key));
  }

  @override
  Future<void> setItem(String key, String value) {
    return Future(() => _values[key] = value);
  }
}
