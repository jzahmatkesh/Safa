import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../module/Blocs.dart';
import '../module/MyProvider.dart';
import '../module/Widgets.dart';
import '../module/class.dart';
import '../module/functions.dart';


ProductBloc _bloc;

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
      _bloc = ProductBloc(context: context, api: 'Anbar', token: _prov.currentUser.token);
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
                              Field(IButton(type: Btn.Del, hint: 'حذف کالا', onPressed: ()=>_bloc.prdBloc.delData(context: context, body: {'anbarid': rec.anbarid,  'id': rec.id}, msg: 'کالای ${rec.name}', removefromrow: true))),
                            ],
                            onDoubleTap: ()=>editProduct(rec),
                            color: rec.edit ? editRowColor() : _bloc.prdBloc.rowsValue$.rows.indexOf(rec).isOdd ? rowColor(context) : Colors.transparent,
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

void productFieldSubmit(BuildContext context, FocusNode focus) async{
  int anbar = 0;
  if (_bloc.rowsValue$.rows.where((element)=>element.active).toList().length > 0)
    anbar = _bloc.rowsValue$.rows.where((element)=>element.active).toList()[0].id;
  if (focus == _fprdname){
    Mainclass _res = await _bloc.checkPrdID(anbar, int.tryParse(_prdid.text) ?? 0);
    if (_res != null){
      _editprdid = _res.id;
      _prdname.text = _res.name;
      _mojodi.text = _res.mojodi.toString();
      _bprice.text = _res.buyprice.toString();
      _sprice.text = _res.sellprice.toString();
      focusChange(context, _fmojodi);  
    }
    else
      focusChange(context, _fprdname);  
  }
  else if (focus != null)
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
    _prdid.clear();
    _prdname.clear();
    _mojodi.clear();
    _bprice.clear();
    _sprice.clear();
    focusChange(context, _fprdid);
  }
}

void editProduct(Mainclass rec){
  _editprdid    = rec.id;
  _prdid.text   = rec.id.toString();
  _prdname.text = rec.name;
  _mojodi.text  = rec.mojodi.toString();
  _bprice.text  = rec.buyprice.toString();
  _sprice.text  = rec.sellprice.toString();
  _bloc.prdBloc.editMode(rec.id);
}