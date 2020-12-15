import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../module/Blocs.dart';
import '../module/MyProvider.dart';
import '../module/Widgets.dart';

class FmLevel extends StatelessWidget {
  const FmLevel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MyProvider _prov = Provider.of<MyProvider>(context);
    PublicBloc _bloc = PublicBloc(context: context, api: 'Coding/AccLevel', token: _prov.currentUser.token, body: {});
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Header(
              title: 'سطوح حساب تفصیلی',
              leftBtn: IButton(type: Btn.Reload, onPressed: ()=>_bloc.fetchData(),),
            ),
            GridRow([
              Field('فعال', bold: true,),
              Field('عنوان سطح', bold: true),
              Field(''),
              Field(Text('اختصاص اتومات تفصیلی')),
            ], header: true,),
            Expanded(
              child: StreamListWidget(
                stream: _bloc.rowsStream$,
                itembuilder: (data)=>GridRow(
                  [
                    Field(Checkbox(value: data.active, onChanged: (val){data.active=val; _bloc.saveData(context: context, data: data, addtorows: true);})),
                    Field(SizedBox(width: 10)),
                    Field(Edit(value: data.name, onSubmitted: (val){data.name=val; _bloc.saveData(context: context, data: data, addtorows: true, msg: true);})),
                    Field(''),
                    Field(SizedBox(width: 35)),
                    Field(Checkbox(value: data.autoins, onChanged: (val){data.autoins=val; _bloc.saveData(context: context, data: data, addtorows: true);})),
                    Field(SizedBox(width: 35)),
                  ]
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}