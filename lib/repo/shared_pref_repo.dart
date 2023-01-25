import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsRepo {
  static late Future<SharedPreferences> _future;
  static const String userName = "userName";

  SharedPrefsRepo() {
    _future = SharedPreferences.getInstance();
  }

  Stream<String?> getUserName() {
    return _future.then((sp) => sp.getString(userName)).asStream();
  }

  Stream<bool> setUserName(String name) {
    return _future.then((sp) => sp.setString(userName, name)).asStream();
  }
}
