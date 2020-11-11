import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safa/module/F2Edit.dart';

import '../controller/Controller.dart';
import '../module/Widgets.dart';
import '../module/class.dart';
import '../module/functions.dart';

class Sanad extends StatelessWidget{
  const Sanad({Key key, @required this.sanad}) : super(key: key);

  final Mainclass sanad;

  @override
  Widget build(BuildContext context) {
    UserState _user = Get.find();
    
    var _edid = TextEditingController();
    var _eddate = TextEditingController();
    var _ednote = TextEditingController();
    var _edkol = TextEditingController();
    var _edmoin = TextEditingController();
    var _edtaf1 = TextEditingController();
    var _edtaf2 = TextEditingController();
    var _edtaf3 = TextEditingController();
    var _edtaf4 = TextEditingController();
    var _edtaf5 = TextEditingController();
    var _edtaf6 = TextEditingController();
    var _edartnote = TextEditingController();
    var _edbed = TextEditingController();
    var _edbes = TextEditingController();

    var _fid = FocusNode();
    var _fdate = FocusNode();
    var _fnote = FocusNode();
    var _fkol = FocusNode();
    var _fmoin = FocusNode();
    var _ftaf1 = FocusNode();
    var _ftaf2 = FocusNode();
    var _ftaf3 = FocusNode();
    var _ftaf4 = FocusNode();
    var _ftaf5 = FocusNode();
    var _ftaf6 = FocusNode();
    var _fartnote = FocusNode();
    var _fbed = FocusNode();
    var _fbes = FocusNode();

    void focusChange(FocusNode next){
      FocusScope.of(context).requestFocus(next);
    }
    FocusNode findFocus(int i){ 
      if (i== 1) return _ftaf1;
      if (i== 2) return _ftaf2;
      if (i== 3) return _ftaf3;
      if (i== 4) return _ftaf4;
      if (i== 5) return _ftaf5;
      if (i== 6) return _ftaf6;
      return null;
    }
    void changeTafFocus(int from){
      bool find = false;
      _user.taflevel.forEach((e) { 
        if (e.id > from && e.active && !find){
          find = true;
          focusChange(findFocus(e.id));
        }
      });
      if (!find)
        focusChange(_fartnote);
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Header(title: 'سند حسابداری'),
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 5),
                Container(width: screenWidth(context)*0.1, child: Edit(hint: 'شماره سند', controller: _edid, focus: _fid, numbersonly: true, autofocus: true, readonly: _user.sanad.value.reg, onSubmitted: (val)=>focusChange(_fdate))),
                SizedBox(width: 5),
                Container(width: screenWidth(context)*0.2, child: Edit(hint: 'تاریخ سند', controller: _eddate, focus: _fdate, date: true, readonly: _user.sanad.value.reg, onSubmitted: (val)=>focusChange(_fnote))),
              ],
            ),          
            SizedBox(height: 10),
            Row(
              children: [
                Container(width: screenWidth(context)*0.5, child: Edit(hint: 'شرح سند', controller: _ednote, focus: _fnote, readonly: _user.sanad.value.reg, onSubmitted: (val)=>focusChange(_fkol))),
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
            GridRow(
              [
              Field(F2Edit(hint: 'کد کل', controller: _edkol, focus: _fkol, f2key: 'Kol', onSubmitted: (val)=>focusChange(_fmoin))),
              Field(F2Edit(hint: 'کد معین', controller: _edmoin, focus: _fmoin, f2key: 'Moin', f2controller: _edkol, onSubmitted: (val){
                var i = 0;
                _user.taflevel.forEach((e) { if (e.active && i==0) i = e.id;});
                focusChange(findFocus(i));              
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
                        ? _ftaf1 
                        : e.id==2 
                          ? _ftaf2 
                          : e.id==3 
                            ? _ftaf3 
                            : e.id==4 
                              ? _ftaf4 
                              : e.id==5 
                                ? _ftaf5 
                                : e.id==6 
                                  ? _ftaf6 
                                  : null, 
                      f2key: 'Tafsili${e.id}',
                      onSubmitted: (val)=>changeTafFocus(e.id)
                    )
                  );
                return Field(Container(width: 0));
              }),
              Field(Edit(hint: 'شرح آرتیکل', controller: _edartnote, focus: _fartnote, onSubmitted: (val)=>focusChange(_fbed)), flex: 2,),
              Field(Edit(hint: 'بدهکار', money: true, controller: _edbed, focus: _fbed, onSubmitted: (val)=> focusChange(_fbes))),
              Field(Edit(hint: 'بستانکار', money: true, controller: _edbes, focus: _fbes, onSubmitted: (val)=> focusChange(_fkol))),
              Field(SizedBox(width: 40)),
              Field(IButton(type: Btn.Save, onPressed: (){}))
            ],
          ),
         ],
        ),
      ),
    );  
  }
}