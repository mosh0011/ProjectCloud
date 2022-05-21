import 'package:shared_preferences/shared_preferences.dart';

//The class for saving user data in the application

class SharedPrefUser {
  late SharedPreferences _prefs;
  String? image;
  Future<bool> login() async {
    _prefs = await SharedPreferences.getInstance();

    return await _prefs.setBool('login', true);
  }

  Future<bool> isLogin() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool('login') ?? false;
  }

  Future<bool> logout() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setBool('login', false);
    return await _prefs.clear();
  }

  Future<int> saveId(int id) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setInt('id', id);
    return id;
  }

  Future<int> getID() async {
    _prefs = await SharedPreferences.getInstance();
    return (_prefs.getInt('id') ?? -1);
  }
}
