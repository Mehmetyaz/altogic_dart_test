


import 'package:altogic_dart_test/authorization/local_storage.dart';
import 'package:altogic_dart_test/authorization/sign_in.dart';
import 'package:altogic_dart_test/client/create_client.dart';
import 'package:altogic_dart_test/utils.dart';

void main() async {



  var storage = FakeStorage();

  createClientWithFakeStorage(storage);

  await setUpMailUser(false);

  var result = await signInWithEmailCorrect();


  print(result.errors);
  print(result.session);
  print(result.user);


  print(storage.values);


}