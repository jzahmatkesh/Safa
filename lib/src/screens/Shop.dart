import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../module/Blocs.dart';
import '../module/MyProvider.dart';
import '../module/Widgets.dart';
import '../module/class.dart';
import '../module/functions.dart';

ProductBloc _bloc;

class ShoppingMng extends StatelessWidget {
  const ShoppingMng({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MyProvider _prov = Provider.of<MyProvider>(context);
    if (_bloc == null)
      _bloc = ProductBloc(context: context, api: 'Anbar', token: _prov.currentUser.token);
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
            height: 150,
            child: Row(
              children: [
                MaterialButton(
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.viewfinder),
                      SizedBox(width: 5),
                      Text('مشاهده فروشگاه'),
                    ],
                  ),
                  color: isDark(context) ? Colors.blue.shade700 : Colors.blue.shade200,
                  height: 65,
                  minWidth: 150,
                  elevation: 3,
                  onPressed: (){},
                ),
                SizedBox(width: 10),
                MaterialButton(
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.settings),
                      SizedBox(width: 5),
                      Text('تنظیمات'),
                    ],
                  ),
                  color: isDark(context) ? Colors.green.shade700 : Colors.green.shade200,
                  height: 65,
                  minWidth: 125,
                  elevation: 3,
                  onPressed: (){},
                ),
                SizedBox(width: 10),
                MaterialButton(
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.person_3),
                      SizedBox(width: 5),
                      Text('مشتریان'),
                    ],
                  ),
                  color: isDark(context) ? Colors.deepOrange.shade700 : Colors.deepOrange.shade200,
                  height: 65,
                  minWidth: 125,
                  elevation: 3,
                  onPressed: (){},
                ),
                SizedBox(width: 10),
                MaterialButton(
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.shopping_cart),
                      SizedBox(width: 5),
                      Text('سفارشات'),
                    ],
                  ),
                  color: isDark(context) ? Colors.purple.shade700 : Colors.purple.shade200,
                  height: 65,
                  minWidth: 125,
                  elevation: 3,
                  onPressed: (){},
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            child: Row(
              children: [
                Container(
                  width: 200,
                  child: Edit(hint: 'جستجو ...', onChange: (val){}),
                )
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<DataModel>(
              stream: _bloc.prdBloc.rowsStream$,
              builder: (context, snap) {
                if (snap.hasData)
                  if (snap.data.status == Status.Loaded)
                    return ListView.builder(
                      itemCount: snap.data.rows.length,
                      itemBuilder: (context, idx){
                        Mainclass e  = snap.data.rows[idx];
                        return  Card(
                          child: Row(
                            children: [
                              Tooltip(message: 'فعال جهت فروش',  child: Switch(value: true, onChanged: (val){})),
                              SizedBox(width: 15),
                              Container(
                                margin: EdgeInsets.all(10),
                                height: 75,
                                width: 75,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade200),
                                  image: DecorationImage(
                                    image: NetworkImage('http://${serverIP()}:8080/Finance/LoadFile.jsp?token=${_prov.currentUser.token}&type=Product&id=${e.id}&rdf=${Random().nextInt(100)}'),
                                    fit: BoxFit.scaleDown
                                  ),
                                  borderRadius: BorderRadius.circular(12)
                                ),
                              ),
                              // CircleAvatar(
                              //   radius: 25,
                              //   backgroundImage: NetworkImage('http://${serverIP()}:8080/Finance/LoadFile.jsp?token=${_prov.currentUser.token}&type=Product&id=${e.id}&rdf=${Random().nextInt(100)}'),
                              // ),
                              SizedBox(width: 25),
                              Container(width: 200, child: Text('${e.name}')),
                              SizedBox(width: 25),
                              Text('${moneySeprator(e.sellprice)}  ریال'),
                              Spacer(),
                              Container(
                                width: 100,
                                child: Edit(hint: 'قیمت با تخفیف', value: '${moneySeprator(e.sellprice)}',)
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        );
                      }
                    );
                  else if (snap.data.status == Status.Error)
                    return Center(child: Text('${snap.data.msg}'));
                return Center(child: CupertinoActivityIndicator());
              }
            ),
          )
        ],
      )
    );
  }
}