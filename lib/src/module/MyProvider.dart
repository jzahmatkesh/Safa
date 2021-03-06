import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Repository.dart';
import 'class.dart';
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

  BehaviorSubject<Mainclass> _company = BehaviorSubject<Mainclass>.seeded(null);
  Stream<Mainclass> get companyStream$ => _company.stream;
  Mainclass get companyInfo => _company.value;

  BehaviorSubject<int> _menuItem = BehaviorSubject<int>.seeded(1);
  Stream<int> get menuitemStream$ => _menuItem.stream;

  BehaviorSubject<int> _loginIdx = BehaviorSubject<int>.seeded(1);
  Stream<int> get loginIdxStream$ => _loginIdx.stream;
  int get loginIdx$ => _loginIdx.stream.value;

  BehaviorSubject<int> _inProgress = BehaviorSubject<int>.seeded(1);
  Stream<int> get inProgressStream$ => _inProgress.stream;
  int get inProgress$ => _inProgress.stream.value;

  String _token = "";
  String _smsToken = "";

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

  setLoginIdx(int i)=>_loginIdx.add(i);

  setCompany(int i){
    cmpid = i;
    // notifyListeners();
  }

  void authenticate(BuildContext context, String mobile, String pass) async{
    _user.add(User(id: 0));
    try{
      _user.add(await _repo.authenticate(mobile, pass));
      _company.add(await  _repo.loadCompanyInfo(currentUser.token));
      if (currentUser.moincount == 0)
        setDashMenuItem(3);
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
      if (token.isNotEmpty){
        _user.value = await _repo.verify(token);
        _company.add(await  _repo.loadCompanyInfo(currentUser.token));
        if (currentUser.moincount == 0)
          setDashMenuItem(3);
      }
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
  
  void register(BuildContext context, String cmpname, String job, String family, String mobile, String pass1, String pass2, {String smstoken}) async{
    try{
      try{
        _inProgress.add(2);
        if (pass1.trim() != pass2.trim())
          myAlert(context: context, title: 'خطا', message: 'تکرار کلمه عبور صحیح نمی باشد');
        else if (pass1.trim().length < 6)
          myAlert(context: context, title: 'خطا', message: 'کلمه عبور می بایست حداقل ۶ کاراکتر باشد');
        else if (pass1.trim().contains("123456") || pass1.trim().contains("234567") || pass1.trim().contains("345678") || pass1.trim().contains("password") || pass1.trim().contains("abcdef"))
          myAlert(context: context, title: 'خطا', message: 'لطفا از کلمه عبور پیچیده تری استفاده نمایید');
        else if (smstoken == null){
          var rng = new Random();
          var code = rng.nextInt(900000) + 100000;
          _smsToken = code.toString();
          if (await sendSms(context, mobile, 'رمز تایید $_smsToken'))
            _loginIdx.add(21);
        }
        else if (smstoken != _smsToken)
            myAlert(context: context, title: 'خطا', message: 'رمز پیامکی صحیح نمی باشد');
        else{
          bool _res = await _repo.register(
            {
              "cmpname": "$cmpname",
              "jobtitle": "$job",
              "family": "$family",
              "mobile": "$mobile",
              "pass": "${generateMd5(pass1)}"
            }
          );
          if (_res)
            authenticate(context, mobile, pass1);
        }
      }
      finally{
        _inProgress.add(1);
      }
    }
    catch(e){
      analyzeError(context, '$e');
    }
  }

  void reSendSms(BuildContext context, String mobile) async{
    await sendSms(context, mobile, 'رمز تایید $_smsToken');
  }
}