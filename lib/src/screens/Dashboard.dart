import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../module/MyProvider.dart';
import '../module/Widgets.dart';
import '../module/class.dart';
import '../module/functions.dart';
import 'Asnad.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MyProvider _prov = Provider.of<MyProvider>(context);
    
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
                child: StreamBuilder<int>(
                  stream: _prov.menuitemStream$,
                  builder: (context, snap){
                    if  (snap.hasData){
                      if (snap.data == 1) return Asnad();
                      // if (snap.data == 2) return Analyze();
                      // if (snap.data == 3) return FmSanad(); //sanad: Mainclass(old: 0, id: 0, date: '', note: '', reg: false),;
                      // if (snap.data == 4) return PnAccGroup();
                      // if (snap.data == 5) return TafLevel();
                    }
                    return Text('none');
                  },
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
                Menu(icon: Icon(CupertinoIcons.rectangle_stack), title: 'اسناد حسابداری', selected: snap.data == 1, onTap: ()=> prov.setDashMenuItem(1)),
                Menu(icon: Icon(CupertinoIcons.rectangle_3_offgrid), title: 'آنالیز حساب ها', selected: snap.data == 2, onTap: ()=> prov.setDashMenuItem(2)),
                // Spacer(),
                Menu(icon: Icon(CupertinoIcons.rectangle_grid_3x2), title: 'کدینگ حسابداری', selected: snap.data == 3, onTap: ()=> prov.setDashMenuItem(3)),
                Menu(icon: Icon(CupertinoIcons.rectangle_compress_vertical), title: 'سطوح تفصیلی', selected: snap.data == 4, onTap: ()=> prov.setDashMenuItem(4)),
                Spacer(),
                Menu(icon: Icon(CupertinoIcons.house_alt), title: 'خروج از سیستم', onTap: ()=>prov.signOut(), hoverColor: Colors.red.withOpacity(0.25),),
              ],
            );
          }
        )
      ),
    );
  }
}


