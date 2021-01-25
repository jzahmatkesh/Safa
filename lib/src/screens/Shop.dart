import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../module/Blocs.dart';
import '../module/MyProvider.dart';
import '../module/Widgets.dart';
import '../module/class.dart';
import '../module/functions.dart';

ShopBloc _shop;
MyProvider _prov;

class ShoppingMng extends StatelessWidget {
  const ShoppingMng({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_prov == null)
      _prov = Provider.of<MyProvider>(context);
    if (_shop == null)
      _shop = ShopBloc(context: context, api: 'OnlineShop', token: _prov.currentUser.token);
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
            height: 150,
            child: Row(
              children: [
                MButton(icon: Icon(CupertinoIcons.viewfinder), caption: 'مشاهده فروشگاه', color: Colors.deepOrange, onPressed: (){}),
                SizedBox(width: 10),
                MButton(icon: Icon(CupertinoIcons.settings), caption: 'تنظیمات', color: Colors.purple, onPressed: ()=>showFormAsDialog(context: context, form: PnSetting())),
                SizedBox(width: 10),
                MButton(icon: Icon(CupertinoIcons.person_3),caption: 'مشتریان', color: Colors.blue, onPressed: (){}),
                SizedBox(width: 10),
                MButton(icon: Icon(CupertinoIcons.shopping_cart), caption: 'سفارشات', color: Colors.lime, onPressed: (){}),
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
          SizedBox(height: 10),
          GridRow(
            [
              Field('فعال', bold: true, width: 75),
              Field('تصویر', bold: true, width: 95,),
              Field('عنوان انبار-کالا', bold: true, flex: 2),
              Field('قیمت خرید', bold: true),
              Field('قیمت فروش', bold: true),
              Field('عنوان سایت', bold: true),
              Field('قیمت سایت', bold: true),
              Field('قیمت با تخفیف', bold: true),
              Field('', width: 40),
            ],
            header: true,
          ),
          Expanded(
            child: StreamBuilder<DataModel>(
              stream: _shop.prdBloc.rowsStream$,
              builder: (context, snap) {
                if (snap.hasData)
                  if (snap.data.status == Status.Loaded)
                    return ListView.builder(
                      itemCount: snap.data.rows.length,
                      itemBuilder: (context, idx){
                        Mainclass e  = snap.data.rows[idx];
                        return Container(
                          color: idx.isOdd  ? rowColor(context) : Colors.transparent,
                          child: Row(
                            children: [
                              Tooltip(message: 'فروش در سایت',  child: Switch(value: true, onChanged: (val){})),
                              SizedBox(width: 10),
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
                              SizedBox(width: 5),
                              Expanded(
                                flex: 2, 
                                child: Text('${e.anbarname} - ${e.name}')
                              ),
                              SizedBox(width: 5),
                              Expanded(child: Text('${moneySeprator(e.buyprice)} ریال')),
                              SizedBox(width: 5),
                              Expanded(child: Text('${moneySeprator(e.sellprice)} ریال')),
                              SizedBox(width: 5),
                              Expanded(child: Text('${e.name}')),
                              SizedBox(width: 5),
                              Expanded(child: Text('${moneySeprator(e.sellprice)} ریال')),
                              SizedBox(width: 5),
                              Expanded(child: Text('${moneySeprator(e.sellprice)} ریال')),
                              IButton(type: Btn.Edit, onPressed: (){})
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

class PnSetting extends StatelessWidget {
  const PnSetting({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _edtitle = TextEditingController(text: '${_prov.companyInfo.shoptitle}');
    TextEditingController _edtel = TextEditingController(text: '${_prov.companyInfo.shoptel}');
    TextEditingController _edaddress = TextEditingController(text: '${_prov.companyInfo.shopaddress}');

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: screenWidth(context) * 0.5,
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                MButton(icon: Icon(CupertinoIcons.floppy_disk), color: Colors.green, minWidth: 65, onPressed: (){}),
                SizedBox(width: 15),
                Expanded(child: Edit(hint: 'عنوان فروشگاه', controller: _edtitle,)),
                SizedBox(width: 5),
                Expanded(child: Edit(hint: 'تلفن تماس', controller: _edtel,)),
              ],
            ),
            SizedBox(height: 35),
            Text(':فروش از انبارهای انتخاب شده در ذیل', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),),
            SizedBox(height: 10),
            StreamBuilder<DataModel>(
              stream: _shop.rowsStream$,
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  if (snapshot.data.status==Status.Loaded)
                    return Wrap(
                      children: snapshot.data.rows.map((e)=>Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(width: 15),
                          Switch(value: e.showinshop, onChanged: (val){}),
                          Text('${e.name}')
                        ]
                      )).toList()
                    );
                  else if (snapshot.data.status == Status.Error)
                    return Center(child: Text('${snapshot.data.msg}'));
                return Center(child: CupertinoActivityIndicator());
              }
            ),
            SizedBox(height: 35),
            Text(':سایر تنظیمات فروشگاه اینترنتی', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),),
            SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 15),
                Switch(value: _prov.companyInfo.showshopprice, onChanged: (val){}),
                Text('نمایش نرخ کالا در فروشگاه')
              ]
            ),
            SizedBox(height: 35),
            Edit(hint: 'آدرس فروشگاه', controller: _edaddress),
          ],
        ),
      ),
    );
  }
}





