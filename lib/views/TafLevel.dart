import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/Controller.dart';
import '../module/Widgets.dart';
import '../module/functions.dart';

class TafLevel extends StatelessWidget {
  const TafLevel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AccLevelState _controller = Get.put(AccLevelState())..fetchData();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Header(
              title: 'سطوح حساب تفصیلی', 
              leftBtn: IButton(type: Btn.Reload, onPressed: (){})
            ),
            GridRow([Field('فعال/غیرفعال', bold: true,), Field('عنوان سطح تفصیلی', bold: true,), Field('اختصاص اتومات تفصیلی', bold: true,)], header: true,),
            Expanded(
              child: GetX<AccLevelState>(
                builder: (_) => AnalyzeData(
                  data: _controller.levels.value, 
                  onLoaded: (rw)=> GridRow([
                    Field(Switch(value: rw.active, onChanged: (val)=>_controller.saveDta(rw.id, rw.name, val ? 1 : 0, rw.autoins ? 1 : 0))),
                    Field(SizedBox(width: 15)),
                    rw.active
                      ? Field(
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25), 
                          width: screenWidth(context) * 0.45, 
                          child: Edit(
                            hint: 'عنوان سطح تفصیلی', 
                            value: rw.name, 
                            onSubmitted: (val)=>_controller.saveDta(rw.id, val, rw.active ? 1 : 0, rw.autoins ? 1 : 0)
                          )
                        )
                      )
                      : Field(Container(margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),width: screenWidth(context) * 0.45, child:Text('${rw.name}'))),
                    Field(Tooltip(message: 'اختصاص اتومات تفصیلی جدید به این سطح', child: Switch(value: rw.autoins, onChanged: (val)=>_controller.saveDta(rw.id, rw.name, rw.active ? 1 : 0, val ? 1 : 0)))),
                    Field(Spacer()),
                    // Field(IButton(hint: 'اختصاص تفصیلی', icon: Icon(CupertinoIcons.text_badge_checkmark), onPressed: ()=>showFormAsDialog(form: TafsiliList(controller: _controller))))
                  ])
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
