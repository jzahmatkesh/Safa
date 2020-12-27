import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../module/Blocs.dart';
import '../module/MyProvider.dart';
import '../module/Widgets.dart';
import '../module/class.dart';
import '../module/functions.dart';


AnbarBloc _bloc;

TextEditingController _anbar = TextEditingController();
int _editanbarid = 0;
int _editprdid = 0;

TextEditingController _prdid = TextEditingController();
TextEditingController _prdname = TextEditingController();
TextEditingController _mojodi = TextEditingController();
TextEditingController _bprice = TextEditingController();
TextEditingController _sprice = TextEditingController();
FocusNode _fprdid = FocusNode();
FocusNode _fprdname = FocusNode();
FocusNode _fmojodi = FocusNode();
FocusNode _fbprice = FocusNode();
FocusNode _fsprice = FocusNode();

class FmProduct extends StatelessWidget {
  const FmProduct({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MyProvider _prov = Provider.of<MyProvider>(context);
    if (_bloc == null)
      _bloc = AnbarBloc(context: context, api: 'Anbar', token: _prov.currentUser.token);
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Header(title: 'مدیریت انبار / کالا'),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1, 
                  child: Column(
                    children: [
                      GridRow([Field('عنوان انبار', bold: true)], header: true),
                      Edit(hint: 'عنوان انبار', controller: _anbar,  onSubmitted: (val){_bloc.saveData(context: context, addtorows: true, data: Mainclass(id: _editanbarid, old: _editanbarid, name: val, active: false), msg: true); _anbar.clear();}),
                      Expanded(
                        child: StreamListWidget(
                          stream: _bloc.rowsStream$,
                          itembuilder: (rec)=>GridRow(
                            [
                              Field('${rec.name}'),
                              Field(IButton(type: Btn.Del, onPressed: ()=>_bloc.delData(context: context, body: {"id": rec.id}, msg: 'انبار ${rec.name}', removefromrow: true)))
                            ], 
                            onTap: ()=>_bloc.loadProduct(rec.id), 
                            onDoubleTap: (){
                              _bloc.editMode(rec.id);
                              _anbar.text = rec.name;
                              _editanbarid = rec.id;
                            },
                            color: rec.edit ? editRowColor() : rec.active ? accentcolor(context).withOpacity(0.15) : _bloc.rowsValue$.rows.indexOf(rec).isOdd ? rowColor(context) : Colors.transparent),
                        )
                      )
                    ]
                  )
                ),
                Expanded(
                  flex: 3, 
                  child: Column(
                    children: [
                      GridRow(
                        [
                          Field(SizedBox(width: 50)),
                          Field('کد کالا', bold: true,),
                          Field('عنوان کالا', bold: true,),
                          Field('موجودی اولیه', bold: true,),
                          Field('قیمت خرید', bold: true,),
                          Field('قیمت فروش', bold: true,),
                        ],
                        header: true,
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          SizedBox(width: 15),
                          Expanded(child: Edit(hint: '', controller: _prdid, focus: _fprdid, onSubmitted: (val)=>productFieldSubmit(context, _fprdname))),
                          SizedBox(width: 3),
                          Expanded(child: Edit(hint: '', controller: _prdname, focus: _fprdname, onSubmitted: (val)=>productFieldSubmit(context, _fmojodi))),
                          SizedBox(width: 3),
                          Expanded(child: Edit(hint: '', controller: _mojodi, focus: _fmojodi, onSubmitted: (val)=>productFieldSubmit(context, _fbprice))),
                          SizedBox(width: 3),
                          Expanded(child: Edit(hint: '', controller: _bprice, focus: _fbprice, onSubmitted: (val)=>productFieldSubmit(context, _fsprice))),
                          SizedBox(width: 3),
                          Expanded(child: Edit(hint: '', controller: _sprice, focus: _fsprice, onSubmitted: (val)=>productFieldSubmit(context, null))),
                          IButton(type: Btn.Save, onPressed: (){})
                        ],
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: StreamListWidget(
                          stream: _bloc.prdBloc.rowsStream$,
                          itembuilder: (rec)=>GridRow(
                            [
                              Field(CircleAvatar(backgroundImage: AssetImage('images/noimage.png'),)),
                              Field('${rec.id}'),
                              Field('${rec.name}'),
                              Field('${moneySeprator(rec.mojodi)}'),
                              Field('${moneySeprator(rec.buyprice)}'),
                              Field('${moneySeprator(rec.sellprice)}'),
                            ]
                          ),
                        ),
                      )
                    ]
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void productFieldSubmit(BuildContext context, FocusNode focus){
  // if (focus == _fprdname){
  //   _bloc.
  // }
  if (focus != null)
    focusChange(context, focus);
  else{
    _mojodi.text = _mojodi.text.isEmpty ? '0' : _mojodi.text;
    _bprice.text = _bprice.text.isEmpty ? '0' : _bprice.text;
    _sprice.text = _sprice.text.isEmpty ? '0' : _sprice.text;
    _bloc.prdBloc.saveData(context: context, addtorows: true, msg: true, 
      data: Mainclass(
        anbarid: _bloc.rowsValue$.rows.where((element)=>element.active).toList()[0].id,
        old: _editprdid, 
        id: int.parse(_prdid.text), 
        name: _prdname.text, 
        mojodi: double.tryParse(_mojodi.text.replaceAll(",", "") ?? 0), 
        buyprice: double.tryParse(_bprice.text.replaceAll(",", "") ?? 0), 
        sellprice: double.tryParse(_sprice.text.replaceAll(",", "") ?? 0)
      )
    );
  }
}