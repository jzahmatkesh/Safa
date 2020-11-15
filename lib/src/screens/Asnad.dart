import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../module/Blocs.dart';
import '../module/MyProvider.dart';
import '../module/Widgets.dart';
import '../module/functions.dart';

SanadBloc _asnad;

class Asnad extends StatelessWidget {
  const Asnad({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MyProvider _prov = Provider.of<MyProvider>(context);
    if (_asnad == null)
      _asnad = SanadBloc(api: 'Asnad', token: _prov.currentUser.token);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          Header(
            title: 'اسناد حسابداری',
            rightBtn: Row(
              children: [
                IButton(type: Btn.Add, onPressed: ()=>_prov.setDashMenuItem(11)),
                SizedBox(width: 3),
                IButton(icon: Icon(CupertinoIcons.eyeglasses), hint: 'فیلتر اسناد', onPressed: (){}),
              ],
            ),
            leftBtn: IButton(type: Btn.Reload, onPressed: ()=>_asnad.fetchData()),
          ),
          GridRow(
            [
              Field('شماره سند', bold: true),
              Field('تاریخ سند', bold: true),
              Field('شرح سند', bold: true, flex: 2,),
              Field('جمع بدهکار', bold: true),
              Field('جمع بستانکار', bold: true),
              Field(SizedBox(width: 80,))
            ],
            header: true,
          ),
          Expanded(
            child: StreamWidget(stream: _asnad.rowsStream$, itembuilder: (rw) =>GridRow(
              [
                Field('${rw.id}'),
                Field('${rw.date}'),
                Field('${rw.note}', flex: 2,),
                Field('${moneySeprator(rw.bed)}'),
                Field('${moneySeprator(rw.bes)}'),
                Field(
                  rw.bed>0 && rw.bes == rw.bed && !rw.reg 
                    ? IButton(icon: Icon(CupertinoIcons.hand_thumbsdown), hint: 'ثبت سند', onPressed: (){})
                    : rw.reg
                      ? IButton(icon: Icon(CupertinoIcons.hand_thumbsup), hint: 'خروج از ثبت', onPressed: (){})
                      : rw.bed==0 && rw.bes==0
                        ? IButton(icon: Icon(CupertinoIcons.trash), hint: 'حذف سند', onPressed: ()=>_asnad.delData(context: context, msg: 'سند شماره ${rw.id}', body: {'id': rw.id}))
                        : Container(width: 40,)
                ),
                Field(IButton(icon: Icon(CupertinoIcons.viewfinder), hint: 'مشاهده سند', onPressed: ()=>print('show sanad')))
              ],
              color: rw.bed==0 && rw.bes == 0 
                ? Colors.yellow.withOpacity(0.15)
                : rw.bed != rw.bes
                  ? Colors.red.withOpacity(0.15)
                  : rw.reg 
                    ? Colors.green.withOpacity(0.15)
                    : rw.bed>0 && rw.bes == rw.bed && !rw.reg
                      ? Colors.lightBlue.withOpacity(0.25)
                      :  null,
              onDoubleTap: (){},
            ))
          ),
          StreamBuilder<int>(
            stream: _asnad.filterStream$,
            builder: (context, snap){
              if (snap.hasData)
                return Row(
                  children: [
                    FilterItem(title: 'بدون آرتیکل', selected: snap.data == 1, color: Colors.yellow.withOpacity(0.15), onSelected: (val)=> _asnad.changeFilter(1)),
                    FilterItem(title: 'عدم تراز', selected: snap.data == 2, color: Colors.red.withOpacity(0.15), onSelected: (val)=> _asnad.changeFilter(2)),
                    FilterItem(title: 'قابل ثبت', selected: snap.data == 3, color: Colors.lightBlue.withOpacity(0.25), onSelected: (val)=> _asnad.changeFilter(3)),
                    FilterItem(title: 'ثبت شده', selected: snap.data == 4, color: Colors.green.withOpacity(0.15), onSelected: (val)=> _asnad.changeFilter(4)),
                  ],
                );
              return Container();
            },
          )
        ],
      ),
    );
  }
}