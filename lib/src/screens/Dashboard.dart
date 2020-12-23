import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../module/Blocs.dart';
import '../module/MyProvider.dart';
import '../module/Widgets.dart';
import '../module/class.dart';
import '../module/functions.dart';
import 'Analyze.dart';
import 'Asnad.dart';
import 'Coding.dart';
import 'Level.dart';


SanadBloc _asnad;

class Dashboard extends StatelessWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MyProvider _prov = Provider.of<MyProvider>(context);

    if (_asnad == null)
      _asnad = SanadBloc(context: context, api: 'Asnad', token: _prov.currentUser.token);

    return Scaffold(
      appBar: AppBar(
        title: Text('حسابداری رایگان'),
        centerTitle: true,
        leading: StreamBuilder<ThemeData>(
          stream: _prov.themeDataStream$,
          builder: (context, snap){
            if (snap.hasData)
              return Switch(
                value: snap.data.brightness == Brightness.dark,
                onChanged:(val)=>_prov.setTheme(val ? AppTheme.Dark : AppTheme.Light)
              );  
            return Container();
          },
        ) 
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Visibility(visible: screenWidth(context) > 800, child: Expanded(child: SideBar(prov: _prov))),
              Expanded(
                flex: 5, 
                child: Column(
                  children: [
                    Expanded(
                      child: StreamBuilder<int>(
                        stream: _prov.menuitemStream$,
                        builder: (context, snap){
                          if  (snap.hasData){
                            if (snap.data == 1) return Asnad(asnad: _asnad);
                            if (snap.data == 2) return FmAnalyze();
                            if (snap.data == 3) return FmCoding();
                            if (snap.data == 4) return FmLevel();
                          }
                          return Text('none');
                        },
                      ),
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
      endDrawer: screenWidth(context) < 800 ? Drawer(
        child: SideBar(prov: _prov)
      ) : null,
    );
  }
}

class SideBar extends StatelessWidget {
  const SideBar({Key key, @required this.prov}) : super(key: key);

  final MyProvider prov;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: StreamBuilder<int>(
          stream: prov.menuitemStream$,
          builder: (context, snap){
            return Column(
              children: [
                CircleAvatar(
                  radius: screenWidth(context) * 0.03,
                  backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRovb86cKzgTC1IxdqkGSkp2iw7uao99t7Fbg&usqp=CAU'),
                ),
                SizedBox(height: 25),
                Text('${prov.currentUser.company}', style: gridFieldStyle()),
                Text('${prov.currentUser.family}', style: gridFieldStyle()),
                SizedBox(height: 35,),
                Menu(icon: Icon(CupertinoIcons.rectangle_grid_3x2), title: 'سرفصل حسابها', selected: snap.data == 3, onTap: ()=> prov.setDashMenuItem(3)),
                Menu(icon: Icon(CupertinoIcons.rectangle_compress_vertical), title: 'سطوح تفصیلی', selected: snap.data == 4, onTap: ()=> prov.setDashMenuItem(4)),
                Menu(icon: Icon(CupertinoIcons.rectangle_stack), title: 'اسناد حسابداری', selected: snap.data == 1, onTap: ()=> prov.setDashMenuItem(1)),
                Menu(icon: Icon(CupertinoIcons.rectangle_3_offgrid), title: 'آنالیز حساب ها', selected: snap.data == 2, onTap: ()=> prov.setDashMenuItem(2)),
                Spacer(),
                Menu(icon: Icon(CupertinoIcons.money_dollar_circle), title: 'کمک مالی', onTap: ()=>showFormAsDialog(context: context, form: PnDonate())),
                Spacer(),
                Menu(icon: Icon(CupertinoIcons.house_alt), title: 'خروج از سیستم', onTap: (){_asnad=null; prov.signOut();}, hoverColor: Colors.red.withOpacity(0.25),),
              ],
            );
          }
        )
      ),
    );
  }
}

class PnDonate extends StatelessWidget {
  const PnDonate({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: screenWidth(context) * 0.75,
        height: screenHeight(context) * 0.75,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('images/donate.png'))
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('اهدای کمک مالی', style: TextStyle(fontFamily: 'Lalezar', fontSize: 30, fontWeight: FontWeight.bold, color: Colors.grey),),
                  SizedBox(height: 10),
                  Text('اهدای کمک مالی کاملا اختیاری می باشد. چنانچه از مجموع امکانات و خدمات ما در حسابداری صفا راضی هستید می توانید با اهدای کمک مالی ما را در ادامه این راه همیاری نمایید. ', style: TextStyle(fontFamily: 'parastoo', fontSize: 14, color: Colors.grey),),
                  Text('تشکر و سپاس از طرف مجموعه حسابداری رایگان صفا', style: TextStyle(fontFamily: 'parastoo', fontSize: 14, color: Colors.grey),),
                ],
              ),
            ),
            SizedBox(width: 100),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Card(
                    color: Colors.red.withOpacity(0.5),
                    child: ListTile(
                      title: Text('بیست هزار تومان'),
                      leading: Icon(CupertinoIcons.money_dollar_circle),
                      onTap: ()=>launchUrl("https://zarinp.al/349377"),
                      hoverColor: Colors.redAccent,
                    ),
                  ),
                  Card(
                    color: Colors.green.withOpacity(0.5),
                    child: ListTile(
                      title: Text('پنجاه هزار تومان'),
                      leading: Icon(CupertinoIcons.money_dollar_circle),
                      onTap: ()=>launchUrl("https://zarinp.al/349378"),
                      hoverColor: Colors.greenAccent,
                    ),
                  ),
                  Card(
                    color: Colors.blue.withOpacity(0.5),
                    child: ListTile(
                      title: Text('یکصد هزار تومان'),
                      leading: Icon(CupertinoIcons.money_dollar_circle),
                      onTap: ()=>launchUrl("https://zarinp.al/349379"),
                      hoverColor: Colors.blueAccent,
                    ),
                  )                    
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}