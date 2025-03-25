import 'package:appwrite/appwrite.dart';
import 'package:pixelplayapp/core/config/utils/appwrite_const.dart';


class AppwriteProvider {
  Client client = Client();
  Account? account;
  Databases? database;

  AppwriteProvider() {
    client
        .setEndpoint(AppwriteConst.endpoint)
        .setProject(AppwriteConst.projectId)
        .setSelfSigned(status: true);
    account = Account(client);
    database = Databases(client);
  }
}