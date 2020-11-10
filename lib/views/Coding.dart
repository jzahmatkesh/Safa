import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/Controller.dart';
import '../module/Widgets.dart';
import '../module/class.dart';
import '../module/functions.dart';
import 'Moin.dart';
import 'kol.dart';

class PnAccGroup extends StatelessWidget {
  const PnAccGroup({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   final CodingState coding = Get.find()..fetchGroup();
    
    return Obx(()=> Column(
      children: [
        Row(
          children: [
            Expanded(child: Menu(icon: Icon(CupertinoIcons.layers), title: screenWidth(context) < 1000 ? 'گروه' : 'گروه حساب ها', inCard: true, selectedColor: accentcolor(context).withOpacity(0.10), selected: coding.menuitem.value==1, onTap: (){coding.menuitem.value=1; coding.fetchGroup();})),
            Expanded(child: Menu(icon: Icon(CupertinoIcons.layers_alt), title: screenWidth(context) < 1000 ? 'کل' : 'حساب های کل', inCard: true, selectedColor: accentcolor(context).withOpacity(0.10), selected: coding.menuitem.value==2, onTap: (){
              if(coding.group.value.status == Status.Loaded && coding.groupRow.length == 0)
                myAlert(title: 'هشدار', message: 'جهت مدیریت حسابهای کل تعریف گروه حساب اجباری می باشد');
              else{
                coding.setMenu(2); 
                coding.selectgroup(coding.group.value.rows[0].id);
              }
            })),
            Expanded(child: Menu(icon: Icon(CupertinoIcons.layers_alt_fill), title: screenWidth(context) < 1000 ? 'معین' : 'حساب های معین', inCard: true, selectedColor: accentcolor(context).withOpacity(0.10), selected: coding.menuitem.value==3, onTap: (){
              if(coding.group.value.status == Status.Loaded && coding.groupRow.length == 0){
                myAlert(title: 'هشدار', message: 'ابتدا می بایست گروه حساب ها را تعریف کنید');
                coding.setMenu(1); 
              }
              else if(coding.kol.value.status == Status.Loaded && coding.kolRow.length == 0){
                myAlert(title: 'هشدار', message: 'جهت مدیریت حسابهای معین تعریف حساب کل اجباری می باشد');
                coding.setMenu(2); 
              }
              else{
                coding.setMenu(3); 
                coding.selectkol(coding.kol.value.rows == null ? 0 : coding.kol.value.rows[0].id);
              }
            })),
            Expanded(child: Menu(icon: Icon(CupertinoIcons.person_2_square_stack), title: screenWidth(context) < 1000 ? '' : 'حساب های تفصیلی', inCard: true, selectedColor: accentcolor(context).withOpacity(0.10), selected: coding.menuitem.value==4, onTap: (){coding.menuitem.value=4; coding.fetchTafsili();})),
          ],
        ),
        Expanded(
          child: coding.menuitem.value==1
            ? PnGroup(coding: coding)
            : coding.menuitem.value==2
              ? PnKol(coding: coding)
              : coding.menuitem.value==3
                ? PnMoin(coding: coding)
                : PnTafsili(coding: coding)
          )
      ]
    ));
  }
}



class PnGroup extends StatelessWidget {
  const PnGroup({Key key,@required this.coding,}) : super(key: key);

  final CodingState coding;

  @override
  Widget build(BuildContext context) {
    var _edgrpname = TextEditingController();
    var _edfname = FocusNode();
    int grpid = 0;

    editGroup(Mainclass rw){
      _edgrpname.text = rw.name; 
      grpid=rw.id; 
      focusChange(context, _edfname, _edfname);
      coding.setgroupEditMode(rw.id);
    }

    return Column(
      children: [
        GridRow(
          [
            Field('کد گروه حساب', bold: true), 
            Field('عنوان گروه حساب', bold: true), 
            Field(IButton(type: Btn.Reload, onPressed: () => coding.fetchGroup()))
          ], header: true
        ),
        SizedBox(height: 10),
        Row(
          children: [
            SizedBox(
              width: screenWidth(context) * 0.2, 
              child: Edit(
                hint: 'گروه حساب جدید', 
                controller: _edgrpname, 
                focus: _edfname,
                onSubmitted: (val) async{
                  if (val.trim().isNotEmpty && await coding.saveGroup(grpid, val)){
                    _edgrpname.clear();
                    grpid = 0;
                  }
                }, 
                autofocus: true
              )
            ),
            IButton(
              type: Btn.Save, 
              size: 22,
              onPressed: () async {
                if (_edgrpname.text.trim().isNotEmpty && await coding.saveGroup(grpid, _edgrpname.text)){
                  _edgrpname.clear();
                  grpid = 0;
                }
              }
            ),
          ],
        ),
        SizedBox(height: 10),
        Expanded(
          child: GetX<CodingState>(
            builder: (_) => AnalyzeData(
              data: coding.group.value, 
              onLoaded: (rw)=>GridRow(
                [
                  Field('${rw.id}'),
                  Field('${rw.name}', flex: 2),
                  Field(IButton(type: Btn.Edit, onPressed: ()=>editGroup(rw))),
                  Field(IButton(type: Btn.Del, onPressed: ()=>coding.delGroup(context, rw.id, rw.name)))
                ],
                onDoubleTap: ()=>editGroup(rw),
                color: rw.edit ? editRowColor() : coding.groupRow.indexOf(rw).isEven ? appbarColor(context) : Colors.transparent,
              )
            )
          ),
        ),
      ],
    );
  }
}

class PnTafsili extends StatelessWidget {
  const PnTafsili({Key key,@required this.coding,}) : super(key: key);

  final CodingState coding;

  @override
  Widget build(BuildContext context) {
    var _edid = TextEditingController();
    var _edname = TextEditingController();
    var _edfid = FocusNode();
    var _edfname = FocusNode();
    var _old = 0;

    tafsiliSave() async{
      focusChange(context, _edfname, _edfid);
      if (_edid.text.isNotEmpty || _edname.text.isNotEmpty)
        if (_edid.text.isEmpty)
          myAlert(title: 'مقادیر اجباری', message: 'کد تفصیلی مشخص نشده است');
        else if (_edname.text.isEmpty)
          myAlert(title: 'مقادیر اجباری', message: 'عنوان تفصیلی مشخص نشده است');
        else
          if (await coding.saveTafsili(Mainclass(old: _old, id: int.parse(_edid.text), name: _edname.text))){
            _old = 0;
            _edid.clear();
            _edname.clear();
          }
    }

    editTafsili(Mainclass rw){
      _old = rw.id;
      _edid.text = '${rw.id}';
      _edname.text = '${rw.name}';
      coding.setTafsiliEditMode(rw.id);
      focusChange(context, _edfname, _edfid);    
    }

    return Column(
      children: [
        GridRow(
          [
            Field('کد تفصیلی', bold: true), 
            Field('عنوان تفصیلی', bold: true, flex: 2,), 
            Field('سطوح قابل استفاده', bold: true), 
            Field(IButton(type: Btn.Reload, onPressed: () => coding.fetchTafsili()))
          ], header: true
        ),
        SizedBox(height: 10),
        Row(
          children: [
            SizedBox(width: screenWidth(context) * 0.1, child: Edit(controller: _edid, autofocus: true, hint: 'کد تفصیلی', focus: _edfid, numbersonly: true,onSubmitted: (_)=>focusChange(context, _edfid, _edfname))),
            SizedBox(width: 10),
            SizedBox(width: screenWidth(context) * 0.15, child: Edit(controller: _edname, hint: 'عنوان تفصیلی', focus: _edfname, onSubmitted: (val)=>tafsiliSave())),
            SizedBox(width: 10),
            IButton(type: Btn.Save, size: 22, onPressed: ()=>tafsiliSave()),
            Spacer(),
            SizedBox(width: screenWidth(context) * 0.15, child: Edit(hint: '... جستجو', onChange: (val)=>coding.searchInTafsili(val))),
          ],
        ),
        SizedBox(height: 10),
        Expanded(
          child: GetX<CodingState>(
            builder: (_) => AnalyzeData(
              data: coding.tafsili.value, 
              onLoaded: (rw)=>rw.inSearch ? GridRow(
                [
                  Field('${rw.id}'),
                  Field('${rw.name}', flex: 2),
                  coding.taflevel.where((element) => element.id==1).toList()[0].active
                    ? Field(Tooltip(message: coding.taflevel.where((element) => element.id==1).toList()[0].name, child: Checkbox(value: rw.lev1, onChanged: (val)=>coding.setTaftoLevel(rw.id, 1))))
                    : Field(Container()),
                  coding.taflevel.where((element) => element.id==2).toList()[0].active
                    ? Field(Tooltip(message: coding.taflevel.where((element) => element.id==2).toList()[0].name, child: Checkbox(value: rw.lev2, onChanged: (val)=>coding.setTaftoLevel(rw.id, 2))))
                    : Field(Container()),
                  coding.taflevel.where((element) => element.id==3).toList()[0].active
                    ? Field(Tooltip(message: coding.taflevel.where((element) => element.id==3).toList()[0].name, child: Checkbox(value: rw.lev3, onChanged: (val)=>coding.setTaftoLevel(rw.id, 3))))
                    : Field(Container()),
                  coding.taflevel.where((element) => element.id==4).toList()[0].active
                    ? Field(Tooltip(message: coding.taflevel.where((element) => element.id==4).toList()[0].name, child: Checkbox(value: rw.lev4, onChanged: (val)=>coding.setTaftoLevel(rw.id, 4))))
                    : Field(Container()),
                  coding.taflevel.where((element) => element.id==5).toList()[0].active
                    ? Field(Tooltip(message: coding.taflevel.where((element) => element.id==5).toList()[0].name, child: Checkbox(value: rw.lev5, onChanged: (val)=>coding.setTaftoLevel(rw.id, 5))))
                    : Field(Container()),
                  coding.taflevel.where((element) => element.id==6).toList()[0].active
                    ? Field(Tooltip(message: coding.taflevel.where((element) => element.id==6).toList()[0].name, child: Checkbox(value: rw.lev6, onChanged: (val)=>coding.setTaftoLevel(rw.id, 6))))
                    : Field(Container()),
                  Field(IButton(type: Btn.Edit, onPressed: ()=>editTafsili(rw))),
                  Field(IButton(type: Btn.Del, onPressed: ()=>coding.delTafsili(context, rw.id, rw.name)))
                ],
                onDoubleTap: ()=>editTafsili(rw),
                color: rw.edit ? editRowColor() : coding.tafsiliRow.indexOf(rw).isEven ? appbarColor(context) : Colors.transparent,
              ) : Container()
            )
          ),
        ),
      ],
    );
  }
}
