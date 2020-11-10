import 'dart:convert';

import 'package:get/get.dart';
import 'package:safa/controller/Controller.dart';

import 'class.dart';
import 'functions.dart';

class Repository{
  
  Future<User> authenticate(String mobile, String pass) async{
    Map<String, dynamic> _data = await postToServer(api: 'User/Authenticate', body: jsonEncode({"mobile": mobile, "pass": generateMd5(pass)}));
    if (_data['msg'] == "Success")
      return User.fromJson(_data['body']);
    throw Exception(_data['msg']);
  }

  Future<User> verify(String token) async{
    Map<String, dynamic> _data = await postToServer(api: 'User/Verify', body: jsonEncode({"token": token}));
    if (_data['msg'] == "Success")
      return User.fromJson(_data['body']);
    throw Exception(_data['msg']);
  }

  Future<List<Mainclass>> loadData(String api, {Map<String, dynamic> body}) async{
    final UserState _user = Get.find();
    if (body == null)
      body = {'token': _user.user.value.token};
    else
      body.putIfAbsent('token', () => _user.user.value.token);
    Map<String, dynamic> _data = await postToServer(api: '$api', body: jsonEncode(body));
    if (_data['msg'] == "Success")
      return _data['body'].map<Mainclass>((data) => Mainclass.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }

  Future<Mainclass> saveData(String api, Map<String, dynamic> body) async{
    final UserState _user = Get.find();
    body.putIfAbsent('token', () => _user.user.value.token);
    Map<String, dynamic> _data = await putToServer(api: '$api', body: jsonEncode(body));
    if (_data['msg'] == "Success")
      return Mainclass.fromJson(_data['body']);
    throw Exception(_data['msg']);
  }

  Future<bool> delData(String api, Map<String, dynamic> body) async{
    final UserState _user = Get.find();
    body.putIfAbsent('token', () => _user.user.value.token);
    Map<String, dynamic> _data = await delToServer(api: '$api', body: jsonEncode(body));
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }

  Future<bool> setTafToLev(Map<String, dynamic> body) async{
    final UserState _user = Get.find();
    body.putIfAbsent('token', () => _user.user.value.token);
    Map<String, dynamic> _data = await putToServer(api: 'Coding/TaftoLevel', body: jsonEncode(body));
    if (_data['msg'] == "Success")
      return _data['body']['lev'] == 1;
    throw Exception(_data['msg']);
  }
}