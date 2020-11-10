import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/Controller.dart';
import '../module/F2Edit.dart';
import '../module/Widgets.dart';
import '../module/class.dart';
import '../module/functions.dart';

UserState _user = Get.find();

class Asnad extends StatelessWidget {
  const Asnad({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _sanadState = Get.put(SanadState())..fetchSanads();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          Header(
            title: 'اسناد حسابداری',
            rightBtn: IButton(icon: Icon(CupertinoIcons.eyeglasses), hint: 'فیلتر اسناد', onPressed: (){}),
            leftBtn: IButton(type: Btn.Reload, onPressed: ()=>_sanadState.fetchSanads()),
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
            child: GetX<SanadState>(
              builder: (_) => AnalyzeData(
                data: _sanadState.listSanad.value, 
                onLoaded: (rw)=>GridRow(
                  [
                    Field('${rw.id}'),
                    Field('${rw.date}'),
                    Field('${rw.note}', flex: 2,),
                    Field('${moneySeprator(rw.bed)}'),
                    Field('${moneySeprator(rw.bes)}'),
                    Field(
                      rw.bed>0 && rw.bes == rw.bed && !rw.reg 
                        ? IButton(icon: Icon(CupertinoIcons.hand_thumbsdown), hint: 'ثبت سند', onPressed: ()=>_sanadState.regSanad(rw.id))
                        : rw.reg
                          ? IButton(icon: Icon(CupertinoIcons.hand_thumbsup), hint: 'خروج از ثبت', onPressed: ()=>_sanadState.regSanad(rw.id))
                          : rw.bed==0 && rw.bes==0
                            ? IButton(icon: Icon(CupertinoIcons.trash), hint: 'حذف سند', onPressed: ()=>_sanadState.delSanad(context, rw.id))
                            : Container(width: 40,)
                    ),
                    Field(IButton(icon: Icon(CupertinoIcons.viewfinder), hint: 'مشاهده سند', onPressed: ()=>_user.showSanad(rw)))
                  ],
                  color: rw.bed==0 && rw.bes == 0 
                    ? Colors.yellow.withOpacity(0.15)
                    : rw.bed != rw.bes
                      ? Colors.red.withOpacity(0.15)
                      : rw.reg 
                        ? Colors.green.withOpacity(0.5)
                        : rw.bed>0 && rw.bes == rw.bed && !rw.reg
                          ? Colors.green.withOpacity(0.15)
                          :  null,
                ),
              )
            )
          ),
          Row(
            children: [
              Card(color: Colors.yellow.withOpacity(0.15), child: Container(margin: EdgeInsets.symmetric(vertical: 8, horizontal: 25), child: Text('بدون آرتیکل'))),
              Card(color: Colors.red.withOpacity(0.15), child: Container(margin: EdgeInsets.symmetric(vertical: 8, horizontal: 25), child: Text('عدم تراز'))),
              Card(color: Colors.green.withOpacity(0.15), child: Container(margin: EdgeInsets.symmetric(vertical: 8, horizontal: 25), child: Text('ثبت نشده'))),
              Card(color: Colors.green.withOpacity(0.5), child: Container(margin: EdgeInsets.symmetric(vertical: 8, horizontal: 25), child: Text('ثبت شده'))),
            ]
          ),
        ],
      ),
    );
  }
}

class FmSanad extends StatelessWidget {
  const FmSanad({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _edid = TextEditingController(text: _user.sanad.value.id.toString());
    var _eddate = TextEditingController(text: _user.sanad.value.date);
    var _ednote = TextEditingController(text: _user.sanad.value.note);
    var _edfid = FocusNode();
    var _edfdate = FocusNode();
    var _edfnote = FocusNode();

    var _edkol = TextEditingController(text: '');
    var _edmoin = TextEditingController(text: '');
    var _edtaf1 = TextEditingController(text: '');
    var _edtaf2 = TextEditingController(text: '');
    var _edtaf3 = TextEditingController(text: '');
    var _edtaf4 = TextEditingController(text: '');
    var _edtaf5 = TextEditingController(text: '');
    var _edtaf6 = TextEditingController(text: '');
    var _edartnote = TextEditingController(text: '');
    var _edbed = TextEditingController(text: '');
    var _edbes = TextEditingController(text: '');
    var _edfkol = FocusNode();
    var _edfmoin = FocusNode();
    var _edftaf1 = FocusNode();
    var _edftaf2 = FocusNode();
    var _edftaf3 = FocusNode();
    var _edftaf4 = FocusNode();
    var _edftaf5 = FocusNode();
    var _edftaf6 = FocusNode();
    var _edfartnote = FocusNode();
    var _edfbed = FocusNode();
    var _edfbes = FocusNode();
    var artid = 0;

    FocusNode findFocus(int i){ 
      if (i== 1) return _edftaf1;
      if (i== 2) return _edftaf2;
      if (i== 3) return _edftaf3;
      if (i== 4) return _edftaf4;
      if (i== 5) return _edftaf5;
      if (i== 6) return _edftaf6;
      return null;
    }
    
    void changeTafFocus(int from){
      bool find = false;
      _user.taflevel.forEach((e) { 
        if (e.id > from && e.active && !find){
          find = true;
          focusChange(context, findFocus(from), findFocus(e.id));
        }
      });
      if (!find)
        focusChange(context, findFocus(from), _edfartnote);
    }
    void saveSanad() async {
      var id = await _user.saveSanad(int.parse(_edid.text), _eddate.text, _ednote.text);
      if (id > 0)
        _edid.text = id.toString();
      else{
        _edid.text = _user.sanad.value.old.toString();
        _eddate.text = _user.sanad.value.date;
        _ednote.text = _user.sanad.value.note;
      }
    }
    void saveArtykl() async{
        if (await _user.saveArtykl(
          Mainclass(
            sanadid: _user.sanad.value.id, 
            id: artid, 
            kolid: _edkol.text.isEmpty ? 0 : int.parse(_edkol.text), 
            moinid: _edmoin.text.isEmpty ? 0 : int.parse(_edmoin.text), 
            taf1: _edtaf1.text.isEmpty ? 0 : int.parse(_edtaf1.text), 
            taf2: _edtaf2.text.isEmpty ? 0 : int.parse(_edtaf2.text), 
            taf3: _edtaf3.text.isEmpty ? 0 : int.parse(_edtaf3.text), 
            taf4: _edtaf4.text.isEmpty ? 0 : int.parse(_edtaf4.text), 
            taf5: _edtaf5.text.isEmpty ? 0 : int.parse(_edtaf5.text), 
            taf6: _edtaf6.text.isEmpty ? 0 : int.parse(_edtaf6.text), 
            bed: _edbed.text.isEmpty ? 0 : double.parse(_edbed.text.isEmpty ? '0' : _edbed.text.replaceAll(',', '')), 
            bes: _edbes.text.isEmpty ? 0 : double.parse(_edbes.text.isEmpty ? '0' : _edbes.text.replaceAll(',', '')), 
            note: _edartnote.text
          )
        )){
            artid = 0; 
            _edkol.clear();
            _edmoin.clear();
            _edtaf1.clear();
            _edtaf2.clear();
            _edtaf3.clear();
            _edtaf4.clear();
            _edtaf5.clear();
            _edtaf6.clear();
            _edbed.clear();
            _edbes.clear();
            _edartnote.clear();
        } 
    }
    void editArtykl(Mainclass rw){
      _user.setArtyklEdit(rw.id);
      artid = rw.id;
      _edkol.text = rw.kolid.toString();
      _edmoin.text = rw.moinid.toString();
      _edtaf1.text = rw.taf1.toString();
      _edtaf2.text = rw.taf2.toString();
      _edtaf3.text = rw.taf3.toString();
      _edtaf4.text = rw.taf4.toString();
      _edtaf5.text = rw.taf5.toString();
      _edtaf6.text = rw.taf6.toString();
      _edartnote.text = rw.note;
      _edbed.text = rw.bed.toString();
      _edbes.text = rw.bes.toString();
    }
    
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          Header(
            title: 'سند حسابداری',
            rightBtn: _user.sanad.value.reg ? null : IButton(type: Btn.Save, onPressed: ()=>saveSanad()),
            leftBtn: IButton(type: Btn.Exit, onPressed: ()=>_user.setDashMenuItem(1),),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              SizedBox(width: 5),
              Container(width: screenWidth(context)*0.1, child: Edit(hint: 'شماره سند', controller: _edid, focus: _edfid, numbersonly: true, autofocus: true, readonly: _user.sanad.value.reg, onSubmitted: (val){_edid.text=val; focusChange(context, _edfid, _edfdate);})),
              SizedBox(width: 5),
              Container(width: screenWidth(context)*0.2, child: Edit(hint: 'تاریخ سند', controller: _eddate, focus: _edfdate, date: true, readonly: _user.sanad.value.reg, onSubmitted: (val){_eddate.text=val; focusChange(context, _edfdate, _edfnote);})),
              Spacer(),
              IButton(icon: Icon(CupertinoIcons.plus_rectangle_on_rectangle), hint: 'کپی در سند جدید', onPressed: (){}),
              SizedBox(width: 15),
              IButton(icon: Icon(CupertinoIcons.arrow_right_to_line), hint: 'اولین سند', onPressed: (){}),
              IButton(icon: Icon(CupertinoIcons.arrow_right), hint: 'سند قبلی', onPressed: (){}),
              IButton(icon: Icon(CupertinoIcons.arrow_left_to_line), hint: 'سند بعدی', onPressed: (){}),
              IButton(icon: Icon(CupertinoIcons.arrow_left_to_line), hint: 'آخرین سند', onPressed: (){}),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Container(width: screenWidth(context)*0.5, child: Edit(hint: 'شرح سند', controller: _ednote, focus: _edfnote, readonly: _user.sanad.value.reg, onSubmitted: (val){_ednote.text=val; focusChange(context, _edfnote, _edfid); saveSanad();})),
              Spacer(),
              Container(width: screenWidth(context)*0.1, child: Edit(hint: '... برو به سند', value: '', onSubmitted: (val)=>print(val))),
            ]
          ),
          SizedBox(height: 10),
          GridRow(
            [
              Field('کد کل', bold: true,),
              Field('کد معین', bold: true,),
              ... _user.taflevel.map((e){ 
                if (e.active)
                  return Field('${e.name}', bold: true);
                return Field(Container(width: 0));
              }),
              Field('شرح آرتیکل', bold: true, flex: 2,),
              Field('بدهکار', bold: true,),
              Field('بستانکار', bold: true,),
              Field(SizedBox(width: 50))
            ],
            header: true,
          ),
          Obx(()=>_user.sanad.value.reg ? Container() : GridRow(
            [
              Field(F2Edit(hint: 'کد کل', controller: _edkol, focus: _edfkol, f2key: 'Kol', onSubmitted: (val)=>focusChange(context, _edfkol, _edfmoin))),
              Field(F2Edit(hint: 'کد معین', controller: _edmoin, focus: _edfmoin, f2key: 'Moin', f2controller: _edkol, onSubmitted: (val){
              // Field(Edit(hint: 'کد معین', numbersonly: true, controller: _edmoin, focus: _edfmoin, onSubmitted: (val){
                var i = 0;
                _user.taflevel.forEach((e) { if (e.active && i==0) i = e.id;});
                focusChange(context, _edfmoin, findFocus(i));              
              })),
              ... _user.taflevel.map((e){ 
                if (e.active)
                  return Field(
                    F2Edit(
                      hint: '${e.name}', 
                      controller: e.id==1 
                        ? _edtaf1 
                        : e.id==2 
                          ? _edtaf2 
                          : e.id==3 
                            ? _edtaf3 
                            : e.id==4 
                              ? _edtaf4 
                              : e.id==5 
                                ? _edtaf5 
                                : e.id==6 
                                  ? _edtaf6 
                                  : null, 
                      focus: e.id==1 
                        ? _edftaf1 
                        : e.id==2 
                          ? _edftaf2 
                          : e.id==3 
                            ? _edftaf3 
                            : e.id==4 
                              ? _edftaf4 
                              : e.id==5 
                                ? _edftaf5 
                                : e.id==6 
                                  ? _edftaf6 
                                  : null, 
                      f2key: 'Tafsili${e.id}',
                      onSubmitted: (val)=>changeTafFocus(e.id)
                    )
                  );
                return Field(Container(width: 0));
              }),
              Field(Edit(hint: 'شرح آرتیکل', controller: _edartnote, focus: _edfartnote, onSubmitted: (val)=>focusChange(context, _edfartnote, _edfbed)), flex: 2,),
              Field(Edit(hint: 'بدهکار', money: true, controller: _edbed, focus: _edfbed, onSubmitted: (val){if (val.isNotEmpty) _edbes.clear(); focusChange(context, _edfbed, _edfbes);})),
              Field(Edit(hint: 'بستانکار', money: true, controller: _edbes, focus: _edfbes, onSubmitted: (val){if (val.isNotEmpty) _edbed.clear(); saveArtykl(); focusChange(context, _edfbes, _edfkol);})),
              Field(SizedBox(width: 40)),
              Field(IButton(type: Btn.Save, onPressed: (){saveArtykl(); focusChange(context, _edfbes, _edfkol);}))
            ],
          )),
          Expanded(
            child: GetX<UserState>(
              builder: (_) => AnalyzeData(
                data: _user.artykl.value, 
                onLoaded: (rw)=>GridRow(
                  [
                    Field('${rw.kolid}'),
                    Field('${rw.moinid}'),
                    ... _user.taflevel.map((e){ 
                      if (e.active)
                        return Field('${e.id==1 ? rw.taf1 : e.id==2 ? rw.taf2 : e.id==3 ? rw.taf3 : e.id==4 ? rw.taf4 : e.id==5 ? rw.taf5 : e.id==6 ? rw.taf6 : 0}');
                      return Field(Container(width: 0));
                    }),
                    Field('${rw.note}', flex: 2,),
                    Field('${moneySeprator(rw.bed)}'),
                    Field('${moneySeprator(rw.bes)}'),
                    _user.sanad.value.reg ? Field(SizedBox(width: 40, height: 40,)) : Field(IButton(type: Btn.Edit, onPressed: ()=>editArtykl(rw))),
                    _user.sanad.value.reg ? Field(SizedBox(width: 40, height: 40,)) : Field(IButton(type: Btn.Del, onPressed: ()=>_user.delArtykl(context, rw.id)))
                  ],
                  color: rw.edit ? editRowColor() : null,
                )
              )
            )
          ),
          Obx(()=>GridRow(
            [
              Field('جمع', flex: 2),
              ... _user.taflevel.map((e){ 
                if (e.active)
                  return Field('');
                return Field(Container(width: 0));
              }),
              Field('', flex: 2),
              Field('${moneySeprator(_user.mandeBed())}'),
              Field('${moneySeprator(_user.mandeBes())}'),
              Field(SizedBox(width: 80))
            ],
            header: true,
          )),
          Obx(()=>GridRow(
            [
              Field('اختلاف', flex: 2),
              ... _user.taflevel.map((e){ 
                if (e.active)
                  return Field('');
                return Field(Container(width: 0));
              }),
              Field('', flex: 2),
              Field('${_user.mandeBed() > _user.mandeBes() ? moneySeprator(_user.mandeBed()-_user.mandeBes()) : 0}'),
              Field('${_user.mandeBes() > _user.mandeBed() ? moneySeprator(_user.mandeBes()-_user.mandeBed()) : 0}'),
              Field(SizedBox(width: 80))
            ],
            header: true,
          ))
        ],
      )
    );
  }
}


