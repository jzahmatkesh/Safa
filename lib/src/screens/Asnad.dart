import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../module/class.dart';

import '../module/Blocs.dart';
import '../module/MyProvider.dart';
import '../module/Widgets.dart';
import '../module/functions.dart';

SanadBloc _asnad;
ArtyklBloc _artykl;

class Asnad extends StatelessWidget {
  const Asnad({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MyProvider _prov = Provider.of<MyProvider>(context);
    if (_asnad == null)
      _asnad = SanadBloc(api: 'Asnad', token: _prov.currentUser.token);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: StreamWidget(
        stream: _asnad.sanadStream$, 
        itemBuilder: (Mainclass rec)=> rec==null
          ? PnAsnad(prov: _prov)
          : PnSanad(prov: _prov, sanad: rec)
      )
    );
  }
}

class PnAsnad extends StatelessWidget {
  const PnAsnad({Key key, @required this.prov,}) : super(key: key);

  final MyProvider prov;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(
          title: 'اسناد حسابداری',
          rightBtn: Row(
            children: [
              IButton(type: Btn.Add, onPressed: ()=>prov.setDashMenuItem(11)),
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
          child: StreamListWidget(stream: _asnad.rowsStream$, itembuilder: (rw) =>GridRow(
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
              Field(IButton(icon: Icon(CupertinoIcons.viewfinder), hint: 'مشاهده سند', onPressed: ()=>_asnad.showSanad(rw)))
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
    );
  }
}

class PnSanad extends StatelessWidget {
  const PnSanad({Key key, @required this.prov, @required this.sanad}) : super(key: key);

  final Mainclass sanad;
  final MyProvider prov;

  @override
  Widget build(BuildContext context) {
    if (_artykl == null)
      _artykl = ArtyklBloc(api: 'Asnad/Artykl', token: prov.currentUser.token, body: {'id': sanad.id});
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Header(
          rightBtn: IButton(type: Btn.Save, onPressed: (){}),
          title: 'سند حسابداری',
          leftBtn: IButton(type: Btn.Exit, onPressed: (){_artykl=null; _asnad.showSanad(null);}),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Container(width: screenWidth(context) * 0.1, child: Edit(hint: 'شماره سند', value: '${this.sanad.id}')),
            SizedBox(width: 5),
            Container(width: screenWidth(context) * 0.1, child: Edit(hint: 'تاریخ سند', value: '${this.sanad.date}', date: true)),
          ],
        ),
        SizedBox(height: 10),
        Container(width: screenWidth(context) * 0.3, child: Edit(hint: 'شرح سند', value: '${this.sanad.note}')),
        SizedBox(height: 10),
        StreamBuilder<DataModel>(
          stream: _artykl.tafLevel.rowsStream$,
          builder: (context, snap){
            return snap.connectionState != ConnectionState.active || snap.data.rows == null ? Field(CupertinoActivityIndicator()) : GridRow([
              Field('کد کل', bold: true,),
              Field('کد معین', bold: true,),
              ...snap.data.rows.where((element) => element.active).map((e) => Field(e.name, bold: true)),
              Field('شرح آرتیکل', bold: true, flex: 2),
              Field('بدهکار', bold: true,),
              Field('بستانکار', bold: true,),
            ], header: true);
          }
        ),
        StreamBuilder<DataModel>(
          stream: _artykl.tafLevel.rowsStream$,
          builder: (context, snap){
            return snap.connectionState != ConnectionState.active || snap.data.rows == null ? Field(CupertinoActivityIndicator()) : GridRow([
              Field(Edit(hint: 'کد کل')),
              Field(Edit(hint: 'کد معین')),
              ...snap.data.rows.where((element) => element.active).map((e) => Field(Edit(hint: '${e.name}'))),
              Field(Edit(hint: 'شرح آرتیکل'), flex: 2),
              Field(Edit(hint: 'بدهکار')),
              Field(Edit(hint: 'بستانکار')),
              Field(SizedBox(width: 40)),
              Field(IButton(type: Btn.Save, onPressed: (){})),
            ]);
          }
        ),
        Expanded(
          child: StreamListWidget(stream: _artykl.rowsStream$, itembuilder: (rw)=> rw==null || _artykl.rowsValue$.rows==null ? Container() : GridRow(
            [
              Field('${rw.kolid}'),
              Field('${rw.moinid}'),
              ..._artykl.tafLevel.rowsValue$.rows.where((element) => element.active).map((e) => Field('${e.id==1 ? rw.taf1 : e.id==2 ? rw.taf2 : e.id==3 ? rw.taf3 : e.id==4 ? rw.taf4 : e.id==5 ? rw.taf5 : rw.taf6}')),
              Field('${rw.note}', flex: 2,),
              Field('${moneySeprator(rw.bed)}'),
              Field('${moneySeprator(rw.bes)}'),
              Field(IButton(type: Btn.Edit, onPressed: (){})),
              Field(IButton(type: Btn.Del, onPressed: (){}))
            ],
            color: _artykl.rowsValue$.rows.indexOf(rw).isOdd ? rowColor(context) : Colors.transparent,
          )),
        ),
      ],
    );
  }
}



