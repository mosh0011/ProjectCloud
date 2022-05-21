import 'package:shared_preferences/shared_preferences.dart';

//الكلاس الخاص بحفظ بيانات المستخدم في التطبيق

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

  Future<int> saveId(int id) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setInt('id', id);
    return id;
  }

  Future<int> saveNumberEnrollCourses(int num) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setInt('num', num);
    return num;
  }

  Future<int> getID() async {
    _prefs = await SharedPreferences.getInstance();
    return (_prefs.getInt('id') ?? -1);
  }

  Future<int> getNumberEnrollCourses() async {
    _prefs = await SharedPreferences.getInstance();
    return (_prefs.getInt('num') ?? 0);
  }

  Future<bool> logout() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setBool('login', false);
    return await _prefs.clear();
  }

  Future<Map<String, dynamic>> saveUser(Map<String, dynamic> user) async {
    _prefs = await SharedPreferences.getInstance();

    await _prefs.setBool('one', user[false] ?? false);
    await _prefs.setBool('two', user[false] ?? false);
    await _prefs.setBool('three', user[false] ?? false);
    await _prefs.setBool('hore', user[false] ?? false);
    await _prefs.setBool('hife', user[false] ?? false);

    return user;
  }

  Future<Map<String, dynamic>> getUserData() async {
    Map<String, dynamic> user = {};
    _prefs = await SharedPreferences.getInstance();
    final one = _prefs.getBool('one');
    final two = _prefs.getBool('two');
    final three = _prefs.getBool('three');
    final hore = _prefs.getBool('hore');
    final hife = _prefs.getBool('hife');

    user = {
      'one': one,
      'two': two,
      'three': three,
      'hore': hore,
      'hife': hife,
    };

    return user;
  }
}
