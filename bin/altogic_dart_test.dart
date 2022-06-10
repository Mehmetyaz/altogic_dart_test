


import 'package:altogic_dart_test/client/create_client.dart';
import 'package:altogic_dart_test/utils.dart';

void main() async {


  createClientTest();

  var res = await client.endpoint.post('/clear_user', body: {'email': email}).asMap();


  print(res.errors);
  print(res.data);



}