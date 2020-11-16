import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:safa/src/module/Repository.dart';
import 'package:safa/src/module/class.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'functions.dart';

String enumName(AppTheme anyEnum) {
 return anyEnum.toString().split('.')[1];
}

class MyProvider with ChangeNotifier {
  Repository _repo = Repository();

  BehaviorSubject<ThemeData> _themeData = BehaviorSubject<ThemeData>.seeded(ThemeData.light());
  Stream<ThemeData> get themeDataStream$ => _themeData.stream;
  final _kThemePreference = "theme_preference";

  BehaviorSubject<User> _user = BehaviorSubject<User>.seeded(null);
  Stream<User> get userStream$ => _user.stream;
  User get currentUser => _user.value;

  BehaviorSubject<int> _menuItem = BehaviorSubject<int>.seeded(1);
  Stream<int> get menuitemStream$ => _menuItem.stream;
  
  String _token = "";

  int menuitem = 0;
  int cmpid = 0;

  MyProvider() {
   // We load theme at the start
    _loadTheme();
    verify();
  }
 
  ThemeData get themeData {
    if (_themeData.value == null) {
      _themeData.add(appThemeData[AppTheme.Light]);
    }
    return _themeData.value;
  }

 /// Sets theme and notifies listeners about change. 
  setTheme(AppTheme theme) async {
    _themeData.add(appThemeData[theme]);
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt(_kThemePreference, AppTheme.values.indexOf(theme));
    });
    notifyListeners();
  }

  void _loadTheme() {
   SharedPreferences.getInstance().then((prefs) {
     int preferredTheme = prefs.getInt(_kThemePreference) ?? 0;
     _themeData.add(appThemeData[AppTheme.values[preferredTheme]]);
     menuitem = prefs.getInt("MenuItem") ?? 0;
     // Once theme is loaded - notify listeners to update UI
     notifyListeners();
   });
 }

  setToken(String str){
    _token = str;
  }

  String get token{
    return _token ?? "";
  }

  setCompany(int i){
    cmpid = i;
    // notifyListeners();
  }

  void authenticate(BuildContext context, String mobile, String pass) async{
    _user.add(User(id: 0));
    try{
      _user.add(await _repo.authenticate(mobile, pass));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", _user.value.token);
    }
    catch(e){
      _user.add(null);
      analyzeError(context, '$e');
    }
  }

  void verify() async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String theme = prefs.getString("theme") ?? "";
      if (theme.isNotEmpty)
        if (theme.contains("dark"))
          setTheme(AppTheme.Dark); 
        else 
          setTheme(AppTheme.Light); 

      if (prefs.getInt('menu') != null && prefs.getInt('menu') > 0)
        _menuItem.add(prefs.getInt('menu'));

      String token = prefs.getString("token") ?? "";
      if (token.isNotEmpty)
        _user.value = await _repo.verify(token);
    }
    catch(e){
    }
  }

  void signOut() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    _user.add(null);
  }  

  void setDashMenuItem(int i) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('menu', i);
    _menuItem.add(i);
  }
}