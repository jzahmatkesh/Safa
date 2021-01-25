import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safa/src/module/class.dart';
import '../module/MyProvider.dart';

import '../module/Widgets.dart';
import '../module/functions.dart';


var _sms1 = FocusNode();
var _sms2 = FocusNode();
var _sms3 = FocusNode();
var _sms4 = FocusNode();
var _sms5 = FocusNode();
var _sms6 = FocusNode();
var _edsms1 = TextEditingController();
var _edsms2 = TextEditingController();
var _edsms3 = TextEditingController();
var _edsms4 = TextEditingController();
var _edsms5 = TextEditingController();
var _edsms6 = TextEditingController();
var _cmp = FocusNode();
var _job = FocusNode();
var _family = FocusNode();
var _mobile = FocusNode();
var _pass1 = FocusNode();
var _pass2 = FocusNode();
var _edcmp = TextEditingController();
var _edjob = TextEditingController();
var _edfamily = TextEditingController();
var _edmobile = TextEditingController();
var _edpass1 = TextEditingController();
var _edpass2 = TextEditingController();

class Login extends StatelessWidget {
  const Login({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _data = {'mobile':'', 'pass': ''};
    MyProvider _prov = Provider.of<MyProvider>(context);
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/background.png'),
              fit: BoxFit.cover
            )
          ),
          child: Center(
            child: StreamBuilder<int>(
              stream: _prov.loginIdxStream$,
              initialData: 1,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                return snapshot.data==1 ? Container(
                  decoration: BoxDecoration(
                    color: _prov.themeData.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(35)
                  ),
                  width: 350,
                  height: 300,
                  padding: EdgeInsets.all(8),
                  child: Container(
                    margin: EdgeInsets.only(top: 45),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(margin: EdgeInsets.symmetric(horizontal: 25),child: Edit(hint: 'شماره همراه', value: _data['mobile'], onChange: (val)=> _data['mobile']=val)),
                        SizedBox(height: 10),
                        Container(margin: EdgeInsets.symmetric(horizontal: 25),child: Edit(hint: 'رمز عبور', value: _data['pass'], onChange: (val)=> _data['pass']=val, password: true)),
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StreamBuilder<User>(
                              stream: _prov.userStream$,
                              builder: (context, snap){
                                if (!snap.hasData && snap.data == null)
                                  return OButton(caption: 'ورود به سیستم', icon: Icon(CupertinoIcons.checkmark_shield_fill), onPressed: ()=>_prov.authenticate(context, _data['mobile'], _data['pass']));
                                return OButton(type: Btn.Loading, caption: 'بررسی ...');
                              },
                            ),
                            SizedBox(width: 10),
                            OButton(caption: 'ثبت نام', icon: Icon(CupertinoIcons.pencil_ellipsis_rectangle), onPressed: ()=>_prov.setLoginIdx(2)),
                          ],
                        ),
                        // SizedBox(height: 15),
                        // FlatButton(child: Text('رمز عبورم را فراموش کرده ام'), onPressed: (){})
                      ],
                    ),
                  ),
                ) : snapshot.data == 2
                  ? PnRegister(prov: _prov)
                  : snapshot.data == 21
                    ? PnRegister2(prov: _prov)
                    : Text('Nothiing');
              }
            ),
          ),
        ),
      )
    );
  }
}

class PnRegister extends StatelessWidget {
  const PnRegister({Key key, @required this.prov}) : super(key: key);

  final MyProvider prov;

  @override
  Widget build(BuildContext context) {
    MyProvider _prov = Provider.of<MyProvider>(context);
    final _formKey = new GlobalKey<FormState>();
    return Container(
      decoration: BoxDecoration(
        color: prov.themeData.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(35)
      ),
      width: 500,
      height: 425,
      padding: EdgeInsets.all(8),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 25),
            Text('لطفا اطلاعات ذیل را تکمیل نمایید', style: TextStyle(fontFamily: 'Nazanin', fontSize: 18, fontWeight: FontWeight.bold),),
            // Header(title: 'ثبت نام حسابداری رایگان صفا', color: accentcolor(context).withOpacity(0.15),),
            SizedBox(height: 35),
            Row(
              children: [
                Expanded(child: Edit(hint: 'عنوان شرکت/کسب و کار', notempty: true, focus: _cmp, controller: _edcmp, autofocus: true, onSubmitted: (val)=>focusChange(context, _job),)),
                SizedBox(width: 5),
                Expanded(child: Edit(hint: 'نوع فعالیت', notempty: true, focus: _job, controller: _edjob, onSubmitted: (val)=>focusChange(context, _family),)),
              ]
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Expanded(child: Edit(hint: 'نام و نام خانوادگی', notempty: true, focus: _family, controller: _edfamily, onSubmitted: (val)=>focusChange(context, _mobile),)),
                SizedBox(width: 5),
                Expanded(child: Edit(hint: 'شماره همراه', notempty: true, focus: _mobile, controller: _edmobile, onSubmitted: (val)=>focusChange(context, _pass1),)),
              ]
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(child: Edit(hint: 'رمز عبور', password: true, notempty: true, focus: _pass1, controller: _edpass1, onSubmitted: (val)=>focusChange(context, _pass2),)),
                SizedBox(width: 5),
                Expanded(child: Edit(hint: 'تایید رمز عبور', password: true, notempty: true, focus: _pass2, controller: _edpass2, onSubmitted: (val){if (_formKey.currentState.validate()) _prov.register(context, _edcmp.text, _edjob.text, _edfamily.text, _edmobile.text, _edpass1.text, _edpass2.text);})),
              ]
            ),
            SizedBox(height: 20),
            Row(
              children: [
                StreamWidget(
                  stream: _prov.inProgressStream$, 
                  itemBuilder: (int idx)=>idx == 2 
                    ? OButton(caption: 'مرحله بعد', type: Btn.Loading)
                    : OButton(caption: 'مرحله بعد', icon: Icon(CupertinoIcons.arrow_right), onPressed: (){if (_formKey.currentState.validate())  _prov.register(context, _edcmp.text, _edjob.text, _edfamily.text, _edmobile.text, _edpass1.text, _edpass2.text);}),
                ),
                Spacer(),
                FlatButton(child: Text('قبلا ثبت نام کرده ام'), onPressed: ()=>_prov.setLoginIdx(1))
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PnRegister2 extends StatelessWidget {
  const PnRegister2({Key key, @required this.prov}) : super(key: key);

  final MyProvider prov;
  
  @override
  Widget build(BuildContext context) {
    MyProvider _prov = Provider.of<MyProvider>(context);
    return Container(
       decoration: BoxDecoration(
        color: prov.themeData.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(35)
      ),
      width: 500,
      height: 375,
      padding: EdgeInsets.symmetric(horizontal: 125),
      // margin: EdgeInsets.symmetric(horizontal: 35),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('کد شش رقمی پیامک شده را وارد نمایید', style: TextStyle(fontWeight: FontWeight.bold, color: headlineColor(context)),),
            SizedBox(height: 35),
            Row(
              children: [
                Expanded(child: Edit(maxlength: 1, numbersonly: true, focus: _sms6, controller: _edsms6, onChange: (val){{if (val.isNotEmpty) _prov.register(context, _edcmp.text, _edjob.text, _edfamily.text, _edmobile.text, _edpass1.text, _edpass2.text, smstoken: "${_edsms1.text}${_edsms2.text}${_edsms3.text}${_edsms4.text}${_edsms5.text}${_edsms6.text}");}},)),
                SizedBox(width: 1),
                Expanded(child: Edit(maxlength: 1, numbersonly: true, focus: _sms5, controller: _edsms5, onChange: (String val){if (val.isNotEmpty) focusChange(context, _sms6);},)),
                SizedBox(width: 1),
                Expanded(child: Edit(maxlength: 1, numbersonly: true, focus: _sms4, controller: _edsms4, onChange: (String val){if (val.isNotEmpty) focusChange(context, _sms5);},)),
                SizedBox(width: 1),
                Expanded(child: Edit(maxlength: 1, numbersonly: true, focus: _sms3, controller: _edsms3, onChange: (String val){if (val.isNotEmpty) focusChange(context, _sms4);},)),
                SizedBox(width: 1),
                Expanded(child: Edit(maxlength: 1, numbersonly: true, focus: _sms2, controller: _edsms2, onChange: (String val){if (val.isNotEmpty) focusChange(context, _sms3);},)),
                SizedBox(width: 1),
                Expanded(child: Edit(autofocus: true, maxlength: 1, numbersonly: true, focus: _sms1, controller: _edsms1, onChange: (String val){if (val.isNotEmpty) focusChange(context, _sms2);})),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                FlatButton(child: Text('ارسال مجدد پیامک'), onPressed: ()=>_prov.reSendSms(context, _edmobile.text)),
                Spacer(),
                FlatButton(child: Text('ویرایش اطلاعات'), onPressed: ()=>_prov.setLoginIdx(2)),
                Icon(CupertinoIcons.arrow_left, size: 12,)
,              ],
            )
          ],
        ),
      ),
   );
  }
}