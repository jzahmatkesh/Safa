import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safa/module/functions.dart';
import '../controller/Controller.dart';
import '../module/Widgets.dart';

class Login extends StatelessWidget {
  const Login({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserState _user = Get.find();
    var _data = {'mobile':'', 'pass': ''};
    return Scaffold(
      body: Center(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            width: screenWidth(context) * 0.3 < 300 ? 300 : screenWidth(context) * 0.3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Edit(hint: 'شماره همراه', value: _data['mobile'], onChange: (val)=> _data['mobile']=val),
                SizedBox(height: 10),
                Edit(hint: 'رمز عبور', value: _data['pass'], onChange: (val)=> _data['pass']=val, password: true),
                SizedBox(height: 10),
                OButton(caption: 'ورود به سیستم', icon: Icon(CupertinoIcons.checkmark_shield_fill), onPressed: ()=>_user.authenticate(_data['mobile'], _data['pass']))
              ],
            ),
          ),
        )
      ),
    );
  }
}