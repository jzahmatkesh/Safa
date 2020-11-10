import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safa/controller/Controller.dart';
import 'package:safa/module/class.dart';
import 'package:safa/module/functions.dart';
import 'package:safa/views/Dashboard.dart';
import 'package:safa/views/Login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'حسابداری رایگان',
      debugShowCheckedModeBanner: false,
      theme: appThemeData[AppTheme.Light],
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserState userController = Get.put(UserState());
    return Scaffold(
      body: GetX<UserState>(builder: (_)=> userController.user.value.id == null ? Login() : Dashboard())
    );
  }
}