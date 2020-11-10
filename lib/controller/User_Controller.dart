import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../module/Repository.dart';
import '../module/class.dart';
import '../module/functions.dart';


var _repo = Repository();

class UserState extends GetxController{
  var user = User().obs;

  @override
  void onInit() {
    super.onInit();
    verify();
  }

  void authenticate(String mobile, String pass) async{
    try{
      user.value = await _repo.authenticate(mobile, pass);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", user.value.token);
    }
    catch(e){
      analyzeError('$e');
    }
  }

  void verify() async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String theme = prefs.getString("theme") ?? "";
      if (theme.isNotEmpty)
        if (theme.contains("dark"))
          Get.changeTheme(appThemeData[AppTheme.Dark]); 
        else 
          Get.changeTheme(appThemeData[AppTheme.Light]);

      String token = prefs.getString("token") ?? "";
      if (token.isNotEmpty)
        user.value = await _repo.verify(token);
    }
    catch(e){
      analyzeError('$e');
    }
  }
}