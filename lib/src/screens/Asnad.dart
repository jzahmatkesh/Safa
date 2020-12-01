import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../module/Blocs.dart';
import '../module/MyProvider.dart';
import '../module/Widgets.dart';
import '../module/class.dart';
import '../module/functions.dart';


TextEditingController _sanadid = TextEditingController();
TextEditingController _date = TextEditingController();
TextEditingController _note = TextEditingController();
TextEditingController _kol = TextEditingController();
TextEditingController _moin = TextEditingController();
TextEditingController _taf1 = TextEditingController();
TextEditingController _taf2 = TextEditingController();
TextEditingController _taf3 = TextEditingController();
TextEditingController _taf4 = TextEditingController();
TextEditingController _taf5 = TextEditingController();
TextEditingController _taf6 = TextEditingController();
TextEditingController _bed = TextEditingController();
TextEditingController _bes = TextEditingController();
TextEditingController _artnote = TextEditingController();

FocusNode _fid = FocusNode();
FocusNode _fdate = FocusNode();
FocusNode _fnote = FocusNode();
FocusNode _fkol = FocusNode();
FocusNode _fmoin = FocusNode();
FocusNode _ftaf1 = FocusNode();
FocusNode _ftaf2 = FocusNode();
FocusNode _ftaf3 = FocusNode();
FocusNode _ftaf4 = FocusNode();
FocusNode _ftaf5 = FocusNode();
FocusNode _ftaf6 = FocusNode();
FocusNode _fbed = FocusNode();
FocusNode _fbes = FocusNode();
FocusNode _fartnote = FocusNode();

class Asnad extends StatelessWidget {
  const Asnad({Key key, @required this.asnad}) : super(key: key);

  final SanadBloc asnad;

  @override
  Widget build(BuildContext context) {
    MyProvider _prov = Provider.of<MyProvider>(context);
    // if (asnad == null)
    //   asnad = SanadBloc(context: context, api: 'Asnad', token: _prov.currentUser.token);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: StreamWidget(
        stream: asnad.sanadStream$, 
        itemBuilder: (Mainclass rec){
          if (rec==null)
           return PnAsnad(prov: _prov, asnad: this.asnad);
          else{
            _sanadid.text = rec.id.toString();
            _date.text = rec.date;
            _note.text = rec.note;
           return PnSanad(prov: _prov, sanad: rec, asnad: this.asnad);
          }
        }
      )
    );
  }
}

class PnAsnad extends StatelessWidget {
  const PnAsnad({Key key, @required this.prov, @required this.asnad}) : super(key: key);

  final SanadBloc asnad;
  final MyProvider prov;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(
          title: 'اسناد حسابداری',
          rightBtn: Row(
            children: [
              IButton(type: Btn.Add, onPressed: ()=>asnad.newSanad()),
              SizedBox(width: 3),
              IButton(icon: Icon(CupertinoIcons.eyeglasses), hint: 'فیلتر اسناد', onPressed: (){}),
            ],
          ),
          leftBtn: IButton(type: Btn.Reload, onPressed: ()=>asnad.fetchData()),
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
          child: StreamListWidget(stream: asnad.rowsStream$, itembuilder: (rw) =>GridRow(
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
                      ? IButton(icon: Icon(CupertinoIcons.trash), hint: 'حذف سند', onPressed: ()=>asnad.delData(context: context, msg: 'سند شماره ${rw.id}', body: {'id': rw.id}))
                      : Container(width: 40,)
              ),
              Field(IButton(icon: Icon(CupertinoIcons.doc_on_doc), hint: 'کپی سند', onPressed: ()=>asnad.copySanad(context, rw.id))),
              Field(IButton(icon: Icon(CupertinoIcons.viewfinder), hint: 'مشاهده سند', onPressed: ()=>asnad.showSanad(rw))),
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
          stream: asnad.filterStream$,
          builder: (context, snap){
            if (snap.hasData)
              return Row(
                children: [
                  FilterItem(title: 'بدون آرتیکل', selected: snap.data == 1, color: Colors.yellow.withOpacity(0.15), onSelected: (val)=> asnad.changeFilter(1)),
                  FilterItem(title: 'عدم تراز', selected: snap.data == 2, color: Colors.red.withOpacity(0.15), onSelected: (val)=> asnad.changeFilter(2)),
                  FilterItem(title: 'قابل ثبت', selected: snap.data == 3, color: Colors.lightBlue.withOpacity(0.25), onSelected: (val)=> asnad.changeFilter(3)),
                  FilterItem(title: 'ثبت شده', selected: snap.data == 4, color: Colors.green.withOpacity(0.15), onSelected: (val)=> asnad.changeFilter(4)),
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
  const PnSanad({Key key, @required this.prov, @required this.sanad, @required this.asnad}) : super(key: key);

  final Mainclass sanad;
  final MyProvider prov;
  final SanadBloc asnad;


  @override
  Widget build(BuildContext context) {
    ArtyklBloc _artykl = ArtyklBloc(context: context, api: 'Asnad/Artykl', token: prov.currentUser.token, body: {'id': sanad.id});

    _changeTafFocus(int i){
      if ((_artykl.tafLevel.rowsValue$.rows ?? []).where((element) => element.active && element.id==i).length > 0){
        if (i==1) focusChange(context, _ftaf1);
        else if (i==2) focusChange(context, _ftaf2);
        else if (i==3) focusChange(context, _ftaf3);
        else if (i==4) focusChange(context, _ftaf4);
        else if (i==5) focusChange(context, _ftaf5);
        else if (i==6) focusChange(context, _ftaf6);
      }
      else
        focusChange(context, _fartnote);
    }

    clearArtykl(){
      _kol.clear();_moin.clear();_taf1.clear();_taf2.clear();_taf3.clear();_taf4.clear();_taf5.clear();_taf6.clear();_bed.clear();_bes.clear();_artnote.clear();
    }

    editArtykl(Mainclass art){
      _artykl.editMode(art.id);
      _kol.text = art.kolid.toString();
      _moin.text = art.moinid.toString();
      _taf1.text = art.taf1.toString();
      _taf2.text = art.taf2.toString();
      _taf3.text = art.taf3.toString();
      _taf4.text = art.taf4.toString();
      _taf5.text = art.taf5.toString();
      _taf6.text = art.taf6.toString();
      _bed.text = moneySeprator(art.bed);
      _bes.text = moneySeprator(art.bes);
      _artnote.text = art.note;
    }

    saveArtykl() async{
      if (_kol.text.trim().isEmpty || _moin.text.trim().isEmpty)
        return;
      int _id = 0;
      _artykl.rowsValue$.rows.forEach((element) {
        if (element.edit)
          _id = element.id;
      });
      Mainclass _art = await _artykl.saveData(
        context: context, 
        msg: true,
        data: Mainclass(
          sanadid: int.parse(_sanadid.text),
          id: _id, 
          kolid: int.parse(_kol.text),
          moinid: int.parse(_moin.text),
          taf1: int.parse(_taf1.text.isEmpty ? '0' : _taf1.text),
          taf2: int.parse(_taf2.text.isEmpty ? '0' : _taf2.text),
          taf3: int.parse(_taf3.text.isEmpty ? '0' : _taf3.text),
          taf4: int.parse(_taf4.text.isEmpty ? '0' : _taf4.text),
          taf5: int.parse(_taf5.text.isEmpty ? '0' : _taf5.text),
          taf6: int.parse(_taf6.text.isEmpty ? '0' : _taf6.text),
          bed: double.parse(_bed.text.isEmpty ? '0' : _bed.text.replaceAll(",", "")),
          bes: double.parse(_bes.text.isEmpty ? '0' : _bes.text.replaceAll(",", "")),
          note: _artnote.text,
        )
      );
      if (_art.errorid > 0){
        if (_art.errorid == 1) focusChange(context, _fkol);
        if (_art.errorid == 2) focusChange(context, _fmoin);
        if (_art.errorid == 11) focusChange(context, _ftaf1);
        if (_art.errorid == 12) focusChange(context, _ftaf2);
        if (_art.errorid == 13) focusChange(context, _ftaf3);
        if (_art.errorid == 14) focusChange(context, _ftaf4);
        if (_art.errorid == 15) focusChange(context, _ftaf5);
        if (_art.errorid == 16) focusChange(context, _ftaf6);
        if (_art.errorid == 3) focusChange(context, _fbed);
      }
      else if (_art != null && _art.id > 0){
        _artykl.updateRow(_art);
        clearArtykl();
        focusChange(context, _fkol);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Header(
          rightBtn: sanad.reg ? null : IButton(type: Btn.Save, onPressed: (){}),
          title: 'سند حسابداری',
          leftBtn: IButton(type: Btn.Exit, onPressed: (){_artykl=null; asnad.showSanad(null);}),
          color: sanad.reg ? Colors.green.withOpacity(0.15) : null,
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Container(width: screenWidth(context) * 0.1, child: Edit(hint: 'شماره سند', controller: _sanadid, focus: _fid, onSubmitted: (val)=> focusChange(context, _fdate), readonly: sanad.reg)),
            SizedBox(width: 5),
            Container(width: screenWidth(context) * 0.1, child: Edit(hint: 'تاریخ سند', controller: _date, focus: _fdate, date: true, onSubmitted: (val)=> focusChange(context, _fnote), readonly: sanad.reg)),
            Spacer(),
            Tooltip(message: 'ثبت سند', child: Switch(value: sanad.reg, onChanged: (val)=>asnad.registerSanad(context, sanad.id)))
          ],
        ),
        SizedBox(height: 10),
        Container(width: screenWidth(context) * 0.3, child: Edit(hint: 'شرح سند', controller: _note, focus: _fnote, onSubmitted: (val)=> focusChange(context, _fkol), readonly: sanad.reg)),
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
        sanad.reg ? Container() : StreamBuilder<DataModel>(
          stream: _artykl.tafLevel.rowsStream$,
          builder: (context, snap){
            return snap.connectionState != ConnectionState.active || snap.data.rows == null ? Field(CupertinoActivityIndicator()) : GridRow([
              Field(Edit(hint: 'کد کل', controller: _kol, focus: _fkol, onSubmitted: (val)=>focusChange(context, _fmoin), autofocus: true, f2key: 'Kol')),
              Field(Edit(hint: 'کد معین', controller: _moin, focus: _fmoin, onSubmitted: (val)=>focusChange(context, _ftaf1), f2key: 'Moin', f2value: _kol)),
              ...snap.data.rows.where((element) => element.active).map(
                  (e) => e.id==1 
                    ? Field(Edit(hint: '${e.name}', controller: _taf1, focus: _ftaf1, onSubmitted: (val)=>_changeTafFocus(2), f2key: 'Tafsili', f2value: 1))
                    : e.id==2 
                      ? Field(Edit(hint: '${e.name}', controller: _taf2, focus: _ftaf2, onSubmitted: (val)=>_changeTafFocus(3), f2key: 'Tafsili', f2value: 2))
                      : e.id==3
                        ? Field(Edit(hint: '${e.name}', controller: _taf3, focus: _ftaf3, onSubmitted: (val)=>_changeTafFocus(4), f2key: 'Tafsili', f2value: 3))
                        : e.id==4
                          ? Field(Edit(hint: '${e.name}', controller: _taf4, focus: _ftaf4, onSubmitted: (val)=>_changeTafFocus(5), f2key: 'Tafsili', f2value: 4))
                          : e.id==5
                            ? Field(Edit(hint: '${e.name}', controller: _taf5, focus: _ftaf5, onSubmitted: (val)=>_changeTafFocus(6), f2key: 'Tafsili', f2value: 5))
                            : Field(Edit(hint: '${e.name}', controller: _taf6, focus: _ftaf6, onSubmitted: (val)=>focusChange(context, _fartnote), f2key: 'Tafsili', f2value: 6))
                 ),
              Field(Edit(hint: 'شرح آرتیکل', controller: _artnote, focus: _fartnote, onSubmitted: (val)=>focusChange(context, _fbed)), flex: 2),
              Field(Edit(hint: 'بدهکار', controller: _bed, focus: _fbed, onSubmitted: (val)=>focusChange(context, _fbes), money: true,)),
              Field(Edit(hint: 'بستانکار', controller: _bes, focus: _fbes, onSubmitted: (val)=>saveArtykl(), money: true,)),
              Field(SizedBox(width: 40)),
              Field(IButton(type: Btn.Save, onPressed: ()=>saveArtykl())),
            ]);
          }
        ),
        Expanded(
          child: StreamListWidget(stream: _artykl.rowsStream$, itembuilder: (rw)=> rw==null || _artykl.rowsValue$.rows==null ? Container() : GridRow(
            [
              Field('${rw.kolid}'),
              Field('${rw.moinid}'),
              ...(_artykl.tafLevel.rowsValue$.rows ?? []).where((element) => element.active).map((e) => Field('${e.id==1 ? rw.taf1 : e.id==2 ? rw.taf2 : e.id==3 ? rw.taf3 : e.id==4 ? rw.taf4 : e.id==5 ? rw.taf5 : rw.taf6}')),
              Field('${rw.note}', flex: 2,),
              Field('${moneySeprator(rw.bed)}'),
              Field('${moneySeprator(rw.bes)}'),
              Field(IButton(type: Btn.Edit, onPressed: ()=>editArtykl(rw))),
              Field(IButton(type: Btn.Del, onPressed: ()=>_artykl.delData(context: context, msg: 'آرتیکل', body: {'sanadid': sanad.id, 'id': rw.id})))
            ],
            color: rw.edit ? editRowColor() : _artykl.rowsValue$.rows.indexOf(rw).isOdd ? rowColor(context) : Colors.transparent,
          )),
        ),
        StreamWidget(stream: _artykl.rowsStream$, itemBuilder: (DataModel data)=> data.status==Status.Loaded ? GridRow(
          [
            Field('جمع'),
            Field(Spacer()),
            Field(data.rows.length == 0 ? '0' : moneySeprator(data.rows.reduce((value, element) => Mainclass(bed: value.bed+element.bed)).bed)),
            Field(data.rows.length == 0 ? '0' : moneySeprator(data.rows.reduce((value, element) => Mainclass(bes: value.bes+element.bes)).bes)),
          ], 
          header: true, color: accentcolor(context).withOpacity(0.05)
        ) : CupertinoActivityIndicator()),
        StreamWidget(stream: _artykl.rowsStream$, itemBuilder: (DataModel data){
          if (data.status==Status.Loaded){
            var _bed = data.rows.length == 0 ? 0 : data.rows.reduce((value, element) => Mainclass(bed: value.bed+element.bed)).bed;
            var _bes = data.rows.length == 0 ? 0 : data.rows.reduce((value, element) => Mainclass(bes: value.bes+element.bes)).bes;
            return GridRow(
              [
                Field('اختلاف'),
                Field(Spacer()),
                Field(moneySeprator(_bed > _bes ? _bed - _bes : 0)),
                Field(moneySeprator(_bed < _bes ? _bes - _bed : 0)),
              ], 
              header: true, color: sanad.reg ? Colors.green.withOpacity(0.15) : _bed!=_bes || _bed==0 ? editRowColor().withOpacity(0.15) : accentcolor(context).withOpacity(0.05)
            );
          }
          return CupertinoActivityIndicator();
        }),
      ],
    );
  }
}



