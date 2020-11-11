import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safa/module/functions.dart';
import '../controller/Controller.dart';
import '../module/Widgets.dart';

var _sec = 1.obs;
var _defcoding = false.obs;

class Login extends StatelessWidget {
  const Login({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserState _user = Get.find();
    var _data = {'mobile':'', 'pass': ''};
    var _fname = FocusNode();
    var _fsemat = FocusNode();
    var _fmobile = FocusNode();
    var _femail = FocusNode();
    var _fpas1 = FocusNode();
    var _fpas2 = FocusNode();
    var _fcmp = FocusNode();
    var _fjob = FocusNode();
    var _fceo = FocusNode();
    var _fceomobile = FocusNode();
    var _ftel = FocusNode();
    var _faddress = FocusNode();
    var _fsms1 = FocusNode();
    var _fsms2 = FocusNode();
    var _fsms3 = FocusNode();
    var _fsms4 = FocusNode();
    var _fsms5 = FocusNode();
    var _fsms6 = FocusNode();

    var _edname = TextEditingController();
    var _edsemat = TextEditingController();
    var _edmobile = TextEditingController();
    var _edemail = TextEditingController();
    var _edpas1 = TextEditingController();
    var _edpas2 = TextEditingController();
    var _edcmp = TextEditingController();
    var _edjob = TextEditingController();
    var _edceo = TextEditingController();
    var _edceomobile = TextEditingController();
    var _edtel = TextEditingController();
    var _edaddress = TextEditingController();
    var _edsms1 = TextEditingController();
    var _edsms2 = TextEditingController();
    var _edsms3 = TextEditingController();
    var _edsms4 = TextEditingController();
    var _edsms5 = TextEditingController();
    var _edsms6 = TextEditingController();

    final _pagecontroller = PageController(
    initialPage: 0,
    );
    void nextPage(){
      _pagecontroller.animateToPage(_pagecontroller.page.toInt() + 1,
        duration: Duration(milliseconds: 400),
        curve: Curves.linear
      );
    }

    void previousPage(){
      _pagecontroller.animateToPage(_pagecontroller.page.toInt() -1,
        duration: Duration(milliseconds: 400),
        curve: Curves.linear
      );
    }

    void register(){
      String error = "";
      if (_edname.text.isEmpty)
        error = 'نام خانوادگی مشخص نشده است';
      else if (_edmobile.text.isEmpty)
        error = 'شماره همراه مشخص نشده است';
      else if (_edpas1.text != _edpas2.text)
        error = 'تکرار رمز عبور صحیح نمی باشد';
      else if (_edpas1.text.length < 6)
        error = 'رمز عبور می بایست حداقل شش کاراکتر باشد';

      if (error.isNotEmpty){
        myAlert(title: 'هشدار', message: error);
        if (_pagecontroller.page > 1)
          previousPage();
      }
      else if (_pagecontroller.page < 2){
        _user.sendRegisterSms(_edmobile.text);
        nextPage();        
      }
      else{
        String sms = _edsms1.text.trim()+_edsms2.text.trim()+_edsms3.text.trim()+_edsms4.text.trim()+_edsms5.text.trim()+_edsms6.text.trim();
        if (_edcmp.text.isEmpty)
          error = 'عنوان شرکت مشخص نشده است';
        else if (_edjob.text.isEmpty)
          error = 'نوع فعالیت مشخص نشده است';
        else if (sms.isEmpty)
          error = 'رمز پیامک شده جهت تایید شماره همراه مشخص نشده است';
        else if (sms.length != 6)
          error = 'رمز پیامک شده جهت تایید شماره همراه صحیح نمی باشد';

        if (error.isNotEmpty){
          myAlert(title: 'هشدار', message: error);
        }
        else
          print("ready yo registert");
      }
    }
    
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Center(
          child: Container(
            width: screenWidth(context) * 0.5,
            height: screenHeight(context) * 0.75,
            padding: EdgeInsets.all(8),
            child: PageView(
              controller: _pagecontroller,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(margin: EdgeInsets.symmetric(horizontal: screenWidth(context)*0.1),child: Edit(hint: 'شماره همراه', value: _data['mobile'], onChange: (val)=> _data['mobile']=val)),
                    SizedBox(height: 10),
                    Container(margin: EdgeInsets.symmetric(horizontal: screenWidth(context)*0.1),child: Edit(hint: 'رمز عبور', value: _data['pass'], onChange: (val)=> _data['pass']=val, password: true)),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OButton(caption: 'ورود به سیستم', icon: Icon(CupertinoIcons.checkmark_shield_fill), onPressed: ()=>_user.authenticate(_data['mobile'], _data['pass'])),
                        OButton(caption: 'ثبت نام', icon: Icon(CupertinoIcons.wand_stars), onPressed: ()=>nextPage()),
                      ],
                    )
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Header(title: 'ثبت نام حسابداری رایگان صفا'),
                    SizedBox(height: 25,),
                    Row(
                      children:[
                        Expanded(child: Edit(hint: 'نام و نام خانوادگی', focus: _fname, controller: _edname, onEditingComplete: ()=>focusChange(context, _fname, _fsemat))),
                        SizedBox(width: 5),
                        Expanded(child: Edit(hint: 'سمت', focus: _fsemat, controller: _edsemat, onEditingComplete: ()=>focusChange(context, _fsemat, _fmobile))),
                      ]
                    ),
                    SizedBox(height: 5),
                    Row(
                      children:[
                        Expanded(child: Edit(hint: 'شماره همراه', focus: _fmobile, controller: _edmobile, onEditingComplete: ()=>focusChange(context, _fmobile, _femail))),
                        SizedBox(width: 5),
                        Expanded(child: Edit(hint: 'پست الکترونیک', focus: _femail, controller: _edemail, onEditingComplete: ()=>focusChange(context, _femail, _fpas1))),
                      ]
                    ),
                    SizedBox(height: 15),
                    Row(
                      children:[
                        Expanded(child: Edit(hint: 'رمز عبور', focus: _fpas1, controller: _edpas1, onEditingComplete: ()=>focusChange(context, _fpas1, _fpas2), password: true,)),
                        SizedBox(width: 5),
                        Expanded(child: Edit(hint: 'تکرار رمز عبور', focus: _fpas2, controller: _edpas2, password: true, onEditingComplete: (){nextPage(); focusChange(context, _fpas2, _fcmp);})),
                      ]
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        OButton(caption: 'ادامه', icon: Icon(CupertinoIcons.arrow_right_square_fill), onPressed: ()=>register()),
                        Spacer(),
                        TextButton(child: Text('قبلا ثبت نام کرده ام'), onPressed: ()=>previousPage())
                      ],
                    )
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Header(title: 'ثبت نام حسابداری رایگان صفا'),
                    SizedBox(height: 25,),
                    Row(
                      children:[
                        Expanded(child: Edit(hint: 'عنوان شرکت', focus: _fcmp, controller: _edcmp, onSubmitted: (val)=>focusChange(context, _fcmp, _fjob))),
                        SizedBox(width: 5),
                        Expanded(child: Edit(hint: 'نوع فعالیت', focus: _fjob, controller: _edjob, onSubmitted: (val)=>focusChange(context, _fjob, _fceo))),
                      ]
                    ),
                    SizedBox(height: 5),
                    Row(
                      children:[
                        Expanded(child: Edit(hint: 'مدیرعامل', focus: _fceo, controller: _edceo, onSubmitted: (val)=>focusChange(context, _fceo, _fceomobile))),
                        SizedBox(width: 5),
                        Expanded(child: Edit(hint: 'شماره همراه', focus: _fceomobile, controller: _edceomobile, onSubmitted: (val)=>focusChange(context, _fceomobile, _ftel))),
                      ]
                    ),
                    SizedBox(height: 5),
                    Row(
                      children:[
                        Expanded(child: Edit(hint: 'تلفن', focus: _ftel, controller: _edtel, onSubmitted: (val)=>focusChange(context, _ftel, _faddress))),
                        SizedBox(width: 5),
                        Expanded(flex: 2, child: Edit(hint: 'آدرس', focus: _faddress, controller: _edaddress, onSubmitted: (val)=>focusChange(context, _faddress, _fsms1))),
                      ]
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Obx(()=>Checkbox(value: _defcoding.value, onChanged: (val)=>_defcoding.value=val)),
                        Expanded(child: Text('کدینگ پیش فرض درج شود'))
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children:[
                        Expanded(flex: 2, child: Text('رمز پیامک شده'),),
                        SizedBox(width: 5),
                        Expanded(child: Edit(maxlength: 1, focus: _fsms6, controller: _edsms6, onChange: (val)=>focusChange(context, _fsms6, _fcmp))),
                        SizedBox(width: 5),
                        Expanded(child: Edit(maxlength: 1, focus: _fsms5, controller: _edsms5, onChange: (val)=>focusChange(context, _fsms5, _fsms6))),
                        SizedBox(width: 5),
                        Expanded(child: Edit(maxlength: 1, focus: _fsms4, controller: _edsms4, onChange: (val)=>focusChange(context, _fsms4, _fsms5))),
                        SizedBox(width: 5),
                        Expanded(child: Edit(maxlength: 1, focus: _fsms3, controller: _edsms3, onChange: (val)=>focusChange(context, _fsms3, _fsms4))),
                        SizedBox(width: 5),
                        Expanded(child: Edit(maxlength: 1, focus: _fsms2, controller: _edsms2, onChange: (val)=>focusChange(context, _fsms2, _fsms3))),
                        SizedBox(width: 5),
                        Expanded(child: Edit(maxlength: 1, focus: _fsms1, controller: _edsms1, onChange: (val)=>focusChange(context, _fsms1, _fsms2))),
                        Expanded(flex: 2, child: Container(),)
                      ]
                    ),
                    SizedBox(height: 25),
                    Row(
                      children: [
                        OButton(caption: 'ثبت نام', icon: Icon(CupertinoIcons.floppy_disk), onPressed: ()=>register()),
                        Spacer(),
                        OButton(caption: 'بازگشت', icon: Icon(CupertinoIcons.arrow_left_square_fill), onPressed: ()=>previousPage()),
                      ],
                    )
                  ],
                )
              ]
            ),
          ),
        ),
      )
    );
  }
}
