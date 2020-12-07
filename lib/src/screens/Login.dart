import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safa/src/module/class.dart';
import '../module/MyProvider.dart';

import '../module/Widgets.dart';
import '../module/functions.dart';
import '../module/Blocs.dart';



var _edmobile = TextEditingController();
var _sms1 = FocusNode();
var _sms2 = FocusNode();
var _sms3 = FocusNode();
var _sms4 = FocusNode();
var _sms5 = FocusNode();
var _sms6 = FocusNode();

IntBloc flg = IntBloc();
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
              stream: flg.stream$,
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
                            OButton(caption: 'ثبت نام', icon: Icon(CupertinoIcons.pencil_ellipsis_rectangle), onPressed: ()=>flg.setValue(2)),
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
    return Container(
      decoration: BoxDecoration(
        color: prov.themeData.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(35)
      ),
      width: 500,
      height: 375,
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          SizedBox(height: 25),
          Text('لطفا اطلاعات ذیل را تکمیل نمایید', style: TextStyle(fontFamily: 'Nazanin', fontSize: 18, fontWeight: FontWeight.bold),),
          // Header(title: 'ثبت نام حسابداری رایگان صفا', color: accentcolor(context).withOpacity(0.15),),
          SizedBox(height: 35),
          Row(
            children: [
              Expanded(child: Edit(hint: 'عنوان شرکت/کسب و کار', autofocus: true)),
              SizedBox(width: 5),
              Expanded(child: Edit(hint: 'نوع فعالیت')),
            ]
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Expanded(child: Edit(hint: 'نام و نام خانوادگی')),
              SizedBox(width: 5),
              Expanded(child: Edit(hint: 'شماره همراه', controller: _edmobile,)),
            ]
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: Edit(hint: 'رمز عبور', password: true)),
              SizedBox(width: 5),
              Expanded(child: Edit(hint: 'تایید رمز عبور', password: true)),
            ]
          ),
          SizedBox(height: 20),
          Row(
            children: [
              OButton(caption: 'مرحله بعد', icon: Icon(CupertinoIcons.arrow_right), onPressed: (){
                // sendSms(context, _edmobile.text, 'خب یره بزنگ دیگه');
                flg.setValue(21);
              }),
              Spacer(),
              FlatButton(child: Text('قبلا ثبت نام کرده ام'), onPressed: ()=>flg.setValue(1))
            ],
          )
        ],
      ),
    );
  }
}

class PnRegister2 extends StatelessWidget {
  const PnRegister2({Key key, @required this.prov}) : super(key: key);

  final MyProvider prov;
  
  @override
  Widget build(BuildContext context) {
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
                Expanded(child: Edit(maxlength: 1, numbersonly: true, focus: _sms6)),
                SizedBox(width: 1),
                Expanded(child: Edit(maxlength: 1, numbersonly: true, focus: _sms5, onChange: (String val){if (val.isNotEmpty) focusChange(context, _sms6);},)),
                SizedBox(width: 1),
                Expanded(child: Edit(maxlength: 1, numbersonly: true, focus: _sms4, onChange: (String val){if (val.isNotEmpty) focusChange(context, _sms5);},)),
                SizedBox(width: 1),
                Expanded(child: Edit(maxlength: 1, numbersonly: true, focus: _sms3, onChange: (String val){if (val.isNotEmpty) focusChange(context, _sms4);},)),
                SizedBox(width: 1),
                Expanded(child: Edit(maxlength: 1, numbersonly: true, focus: _sms2, onChange: (String val){if (val.isNotEmpty) focusChange(context, _sms3);},)),
                SizedBox(width: 1),
                Expanded(child: Edit(autofocus: true, maxlength: 1, numbersonly: true, focus: _sms1, onChange: (String val){if (val.isNotEmpty) focusChange(context, _sms2);})),
              ],
            ),
            SizedBox(height: 15),
//             Row(
//               children: [
//                 OButton(caption: 'ثبت نام', icon: Icon(CupertinoIcons.pencil_ellipsis_rectangle), onPressed: (){}),
//                 Spacer(),
//                 FlatButton(child: Text('ویرایش اطلاعات'), onPressed: ()=>flg.setValue(2)),
//                 Icon(CupertinoIcons.arrow_left, size: 12,)
// ,              ],
//             )
          ],
        ),
      ),
   );
  }
}