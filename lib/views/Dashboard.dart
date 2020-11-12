import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safa/views/AnalyzeRep.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/Controller.dart';
import '../module/Widgets.dart';
import '../module/class.dart';
import '../module/functions.dart';
import 'Asnad.dart';
import 'Coding.dart';
import 'TafLevel.dart';

UserState _user = Get.find();

class Dashboard extends StatelessWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CodingState());
    return Scaffold(
      appBar: AppBar(
        title: Text('حسابداری رایگان'),
        centerTitle: true,
        leading: ObxValue(
          (data) => Switch(
            value: data.value,
            onChanged:(val) async{
              data.value=val; 
              SharedPreferences prefs = await SharedPreferences.getInstance();
              if (val){
                Get.changeTheme(appThemeData[AppTheme.Dark]); 
                prefs.setString("theme", "dark");
              }
              else{
                Get.changeTheme(appThemeData[AppTheme.Light]);
                prefs.setString("theme", "light");
              }
            }
          ),
          Get.isDarkMode.obs
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Visibility(visible: screenWidth(context) > 800, child: Expanded(child: SideBar())),
              Expanded(
                flex: 5, 
                child:Obx(()=> _user.dashMenuItem.value == 1
                  ? Asnad()
                  : _user.dashMenuItem.value == 2
                    ? Analyze()
                    :_user.dashMenuItem.value == 11
                      ? FmSanad() //sanad: Mainclass(old: 0, id: 0, date: '', note: '', reg: false),
                      : _user.dashMenuItem.value == 3
                        ? PnAccGroup()
                        : _user.dashMenuItem.value == 4
                          ? TafLevel()
                          : Text('none')
              )),
            ],
          ),
        ),
      ),
      endDrawer: screenWidth(context) < 800 ? Drawer(
        child: SideBar()
      ) : null,
    );
  }
}

class SideBar extends StatelessWidget {
  const SideBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Obx(()=> Column(
          children: [
            CircleAvatar(
              radius: screenWidth(context) * 0.03,
              backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRovb86cKzgTC1IxdqkGSkp2iw7uao99t7Fbg&usqp=CAU'),
            ),
            SizedBox(height: 25),
            Text('${_user.user.value.company}', style: gridFieldStyle()),
            Text('${_user.user.value.family}', style: gridFieldStyle()),
            SizedBox(height: 35,),
            Menu(icon: Icon(CupertinoIcons.rectangle_stack), title: 'اسناد حسابداری', selected: _user.dashMenuItem.value == 1, onTap: ()=> _user.setDashMenuItem(1)),
            Menu(icon: Icon(CupertinoIcons.rectangle_3_offgrid), title: 'آنالیز حساب ها', selected: _user.dashMenuItem.value == 2, onTap: ()=> _user.setDashMenuItem(2)),
            // Spacer(),
            Menu(icon: Icon(CupertinoIcons.rectangle_grid_3x2), title: 'کدینگ حسابداری', selected: _user.dashMenuItem.value == 3, onTap: ()=> _user.setDashMenuItem(3)),
            Menu(icon: Icon(CupertinoIcons.rectangle_compress_vertical), title: 'سطوح تفصیلی', selected: _user.dashMenuItem.value == 4, onTap: ()=> _user.setDashMenuItem(4)),
            Spacer(),
            Menu(icon: Icon(CupertinoIcons.house_alt), title: 'خروج از سیستم', onTap: ()=>_user.signOut(), hoverColor: Colors.red.withOpacity(0.25),),
          ],
        )),
      ),
    );
  }
}


