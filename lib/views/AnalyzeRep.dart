import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safa/controller/Controller.dart';
import 'package:safa/module/Widgets.dart';
import 'package:safa/module/functions.dart';

class Analyze extends StatelessWidget{
  const Analyze({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AnalyzeState _analyzeState = Get.put(AnalyzeState())..fetchKol();
    UserState _user = Get.find();
    var _levStart = 0.obs;
    if (_user.taflevel.length == 0)
      _user.loadTafLevels();

    String idTitle(){
      if (_levStart.value == 0)
        return 'کد کل';
      else if (_levStart.value == -1)
        return 'کد معین';
      else 
        return "کد "+_user.taflevel.where((elemet) => elemet.id==_levStart.value).toList()[0].name;
    }
    String nameTitle(){
      if (_levStart.value == 0)
        return 'عنوان کل';
      else if (_levStart.value == -1)
        return 'عنوان معین';
      else 
        return "عنوان "+_user.taflevel.where((elemet) => elemet.id==_levStart.value).toList()[0].name;
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Header(
              title: 'گزارش آنالیز حساب',
              leftBtn: IButton(type: Btn.Reload, onPressed: (){_user.loadTafLevels(); _levStart.value=0; _analyzeState.fetchKol();})
            ),
            Obx(()=>Row(
              children: [
                Expanded(child: Menu(title: 'حساب کل', inCard: true, selected: _levStart.value==0, onTap: (){_levStart.value = 0; _analyzeState.fetchKol();}, selectedColor: accentcolor(context).withOpacity(0.10),)),
                ..._user.taflevel.map((element) => element.active ? Expanded(child: Menu(title: '${element.name}', inCard: true, selected: _levStart.value==element.id, onTap: (){_levStart.value = element.id; _analyzeState.fetchTafsili(element.id);}, selectedColor: accentcolor(context).withOpacity(0.10),)) : Container()),
              ],
            )),
            Obx(()=> _analyzeState.rec1.value != null
              ? GridRow(
                  [
                    Field('${_analyzeState.rec1.value.id}'),
                    Field('${_analyzeState.rec1.value.name}', flex: 2,),
                    Field('${moneySeprator(_analyzeState.rec1.value.bed)}'),
                    Field('${moneySeprator(_analyzeState.rec1.value.bes)}'),
                    Field('${moneySeprator(_analyzeState.rec1.value.mandebed)}'),
                    Field('${moneySeprator(_analyzeState.rec1.value.mandebes)}'),
                  ], 
                  color: accentcolor(context).withOpacity(0.35),
                )
              : Container()             
            ),
            Obx(()=>GridRow(
              [
                Field(idTitle(), bold: true,),
                Field(nameTitle(), bold: true, flex: 2,),
                Field('جمع بدهکار', bold: true,),
                Field('جمع بستانکار', bold: true,),
                Field('مانده بدهکار', bold: true,),
                Field('مانده بستانکار', bold: true,),
              ],
              header: true,
            )),
            Expanded(
              child: Obx(()=>AnalyzeData(
                data: _analyzeState.kol.value, 
                onLoaded: (rw)=>GridRow(
                  [
                    Field('${rw.id}'),
                    Field('${rw.name}', flex: 2,),
                    Field('${moneySeprator(rw.bed)}'),
                    Field('${moneySeprator(rw.bes)}'),
                    Field('${moneySeprator(rw.mandebed)}'),
                    Field('${moneySeprator(rw.mandebes)}'),
                  ],
                  color: _analyzeState.kolRow.indexOf(rw).isOdd ? appbarColor(context) : Colors.transparent,
                  onTap: (){_analyzeState.chooseKol(rw, _levStart.value); _levStart.value=-1;},
                )
              ))
            )
          ],
        ),
      ),
    );
  }
}