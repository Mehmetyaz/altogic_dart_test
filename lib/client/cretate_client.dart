import 'package:altogic_dart/altogic_dart.dart';

late AltogicClient client;

const envUrl = "https://c1-na.altogic.com/e:62a30491f3a9efcc5eb71193";
const clientKey = "abb823877b764da9a2a21c7318cd9d23";

void createClientTest() {
  client = createClient(envUrl, clientKey);
}

void createClientTestIncorrectClient() {
  client = createClient(envUrl.replaceFirst('https://', ''), clientKey);
}
