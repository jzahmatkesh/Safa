import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safa/module/Widgets.dart';

import '../controller/Controller.dart';
import '../module/class.dart';
import '../module/functions.dart';

class PnKol extends StatelessWidget {
  const PnKol({Key key, @required this.coding,}) : super(key: key);

  final CodingState coding;

  @override
  Widget build(BuildContext context) {
    var _edid = TextEditingController();
    var _edname = TextEditingController();
    var _edfid = FocusNode();
    var _edfname = FocusNode();
    var _old = 0;

    kolSave() async{
      focusChange(context, _edfname, _edfid);
      if (_edid.text.isNotEmpty || _edname.text.isNotEmpty)
        if (_edid.text.isEmpty)
          myAlert(title: 'مقادیر اجباری', message: 'کد کل مشخص نشده است');
        else if (_edname.text.isEmpty)
          myAlert(title: 'مقادیر اجباری', message: 'عنوان کل مشخص نشده است');
        else
          if (await coding.saveKol(Mainclass(grpid: coding.groupRow.where((element) => element.selected).toList()[0].id, old: _old, id: int.parse(_edid.text), name: _edname.text))){
            _old = 0;
            _edid.clear();
            _edname.clear();
          }
    }

    editKol(Mainclass rw){
      _old = rw.id;
      _edid.text = '${rw.id}';
      _edname.text = '${rw.name}';
      coding.setkolEditMode(rw.id);
      focusChange(context, _edfname, _edfid);    
    }

    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              GridRow([Field('عنوان گروه حساب', bold: true), ], header: true),
              Expanded(
                child: GetX<CodingState>(
                  builder: (_) => AnalyzeData(
                    data: coding.group.value, 
                    onLoaded: (rw)=>GridRow(
                      [Field('${rw.name}', flex: 2)],
                      color: rw.selected ? accentcolor(context).withOpacity(0.25) : coding.group.value.rows.indexOf(rw).isEven ? appbarColor(context) : Colors.transparent,
                      onTap: ()=>coding.selectgroup(rw.id),
                    )
                  )
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Column(
            children: [
              GridRow(
                [
                  Field('کد کل', bold: true), 
                  Field('عنوان کل', bold: true), 
                ], header: true
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: screenWidth(context) * 0.1, child: Edit(controller: _edid, autofocus: true, hint: 'کد کل', focus: _edfid, numbersonly: true,onSubmitted: (_)=>focusChange(context, _edfid, _edfname))),
                  SizedBox(width: 10),
                  SizedBox(width: screenWidth(context) * 0.2, child: Edit(controller: _edname, hint: 'عنوان کل', focus: _edfname, onSubmitted: (val)=>kolSave())),
                  SizedBox(width: 10),
                  IButton(type: Btn.Save, size: 22, onPressed: ()=>kolSave()),
                  Spacer(),
                  SizedBox(width: screenWidth(context) * 0.2, child: Edit(hint: '... جستجو', onChange: (val)=>coding.searchInKol(val))),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: GetX<CodingState>(
                  builder: (_) => AnalyzeData(
                    data: coding.kol.value, 
                    onLoaded: (rw)=> rw.inSearch ? GridRow(
                      [
                        Field('${rw.id}'),
                        Field('${rw.name}', flex: 2),
                        Field(IButton(type: Btn.Edit, onPressed: ()=>editKol(rw))),
                        Field(IButton(type: Btn.Del, onPressed: ()=>coding.delKol(context, rw.id, rw.name)))
                      ],
                      color: rw.edit ? editRowColor() : coding.kolRow.indexOf(rw).isEven ? appbarColor(context) : Colors.transparent,
                      onDoubleTap: ()=>editKol(rw),
                    ) : Container()
                  )
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
