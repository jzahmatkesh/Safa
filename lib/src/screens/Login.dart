import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safa/src/module/class.dart';
import '../module/MyProvider.dart';

import '../module/Widgets.dart';
import '../module/functions.dart';
import '../module/Blocs.dart';

class Login extends StatelessWidget {
  const Login({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _data = {'mobile':'', 'pass': ''};
    MyProvider _prov = Provider.of<MyProvider>(context);
    IntBloc flg = IntBloc();
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Center(
          child: StreamBuilder<int>(
            stream: flg.stream$,
            initialData: 1,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              return snapshot.data==1 ? Container(
                width: screenWidth(context) * 0.5,
                height: screenHeight(context) * 0.75,
                padding: EdgeInsets.all(8),
                child: Container(
                  margin: EdgeInsets.only(top: screenHeight(context) * 0.2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(margin: EdgeInsets.symmetric(horizontal: screenWidth(context)*0.1),child: Edit(hint: 'شماره همراه', value: _data['mobile'], onChange: (val)=> _data['mobile']=val)),
                      SizedBox(height: 10),
                      Container(margin: EdgeInsets.symmetric(horizontal: screenWidth(context)*0.1),child: Edit(hint: 'رمز عبور', value: _data['pass'], onChange: (val)=> _data['pass']=val, password: true)),
                      SizedBox(height: 10),
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
                          OButton(caption: 'ثبت نام', icon: Icon(CupertinoIcons.wand_stars), onPressed: ()=>flg.setValue(2)),
                        ],
                      )
                    ],
                  ),
                ),
              ) : PnRegister();
            }
          ),
        ),
      )
    );
  }
}


class PnRegister extends StatelessWidget {
  const PnRegister({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth(context) * 0.45,
      height: screenHeight(context) * 0.75,
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Header(title: 'ثبت نام حسابداری رایگان صفا', color: accentcolor(context).withOpacity(0.15),),
          SizedBox(height: 25),
          Row(
            children: [
              Expanded(child: Edit(hint: 'عنوان شرکت/کسب و کار', autofocus: true)),
              SizedBox(width: 5),
              Expanded(child: Edit(hint: 'نوع فعالیت')),
            ]
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: Edit(hint: 'نام و نام خانوادگی')),
              SizedBox(width: 5),
              Expanded(child: Edit(hint: 'شماره همراه')),
            ]
          ),
          SizedBox(height: 10),
          Row(
            children: [
              IButton(hint: 'مرحله بعد', icon: Icon(CupertinoIcons.arrow_right),)
            ],
          )
        ],
      ),
    );
  }
}