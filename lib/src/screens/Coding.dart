import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../module/MyProvider.dart';
import '../module/Widgets.dart';
import '../module/Blocs.dart';
import '../module/class.dart';
import '../module/functions.dart';

CodingBloc _bloc;

class FmCoding extends StatelessWidget {
  const FmCoding({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MyProvider _prov = Provider.of<MyProvider>(context);
    if (_bloc == null)
      _bloc = CodingBloc(context: context, api: 'Coding/Group', token: _prov.currentUser.token);
    var _menu = IntBloc()..setValue(1);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.all(8),
        child: StreamWidget(
          stream: _menu.stream$, 
          itemBuilder: (int i)=>Column(
            children: [
              Header(title: 'سرفصل حسابها'),
              Row(
                children: [
                  Expanded(child: Menu(title: 'گروه حساب', inCard: true, selected: i==1, selectedColor: accentcolor(context).withOpacity(0.15), onTap: ()=>_menu.setValue(1))),
                  Expanded(child: Menu(title: 'حساب کل', inCard: true, selected: i==2, selectedColor: accentcolor(context).withOpacity(0.15), onTap: ()=>_menu.setValue(2))),
                  Expanded(child: Menu(title: 'حساب معین', inCard: true, selected: i==3, selectedColor: accentcolor(context).withOpacity(0.15), onTap: ()=>_menu.setValue(3))),
                  Expanded(child: Menu(title: 'حساب تفصیلی', inCard: true, selected: i==4, selectedColor: accentcolor(context).withOpacity(0.15), onTap: ()=>_menu.setValue(4))),
                ],
              ),
              i == 1
                ? Expanded(child: PnGroup(prov: _prov,))
                : i == 2
                  ? Expanded(child: PnKol(prov: _prov,))
                  : i == 3
                    ? Expanded(child: PnMoin(prov: _prov,))
                    : Expanded(child: PnTafsili(prov: _prov))
            ],
          )
        ),
      ),
    );
  }
}


class PnGroup extends StatelessWidget {
  const PnGroup({Key key, @required this.prov}) : super(key: key);

  final MyProvider prov;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridRow(
            [
              Field('کد گروه', bold: true),
              Field('عنوان گروه', bold: true),
              Field(IButton(type: Btn.Reload, onPressed: ()=>_bloc.fetchData()))
            ],
            color: rowColor(context),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Container(
                width: screenWidth(context) * 0.25,
                child: Edit(hint: 'گروه حساب جدید', onChange: (val){})
              ),
              IButton(type: Btn.Save, onPressed: (){})
            ],
          ),
          SizedBox(height: 15),
          Expanded(
            child: StreamListWidget(
              stream: _bloc.rowsStream$,
              itembuilder: (Mainclass rw) => GridRow(
                [
                  Field('${rw.id}'),
                  Field('${rw.name}'),
                  Field(IButton(type: Btn.Edit, onPressed: (){})),
                  Field(IButton(type: Btn.Del, onPressed: (){})),
                ],
                color: rw.edit ? editRowColor() : _bloc.rowsValue$.rows.indexOf(rw).isOdd ? rowColor(context) : Colors.transparent,
              )
            ),
          )
        ],
      ),
    );
  }
}

class PnKol extends StatelessWidget {
  const PnKol({Key key, @required this.prov}) : super(key: key);

  final MyProvider prov;

  @override
  Widget build(BuildContext context) {
    if (_bloc.rowsValue$.rows.where((element)=>element.selected).length == 0)
      _bloc.loadKol(_bloc.rowsValue$.rows[0].id);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridRow(
                  [
                    Field('گروه حساب', bold: true, center: true),
                  ],
                  color: rowColor(context),
                ),
                Expanded(
                  child: StreamListWidget(
                    stream: _bloc.rowsStream$,
                    itembuilder: (Mainclass rw) => GridRow(
                      [
                        Field('${rw.name}'),
                      ],
                      color: rw.selected ? accentcolor(context).withOpacity(0.15) : _bloc.rowsValue$.rows.indexOf(rw).isOdd ? rowColor(context) : Colors.transparent,
                      onTap: ()=>_bloc.loadKol(rw.id),
                    )
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                GridRow(
                  [
                    Field('کد کل', bold: true,),
                    Field('عنوان کل', bold: true,),
                    Field(IButton(type: Btn.Reload, onPressed: ()=>_bloc.fetchData()))
                  ],
                  color: rowColor(context),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    SizedBox(width: 10),
                    Expanded(child: Edit(hint: 'کد کل', onChange: (val){})),
                    SizedBox(width: 10),
                    Expanded(flex: 2,child: Edit(hint: 'عنوان کل', onChange: (val){})),
                    SizedBox(width: 10),
                    Field(IButton(type: Btn.Save, onPressed: (){})),
                    SizedBox(width: 10),
                  ],
                ),
                SizedBox(height: 15),
                Expanded(
                  child: StreamListWidget(
                    stream: _bloc.kolrowsStream$, 
                    itembuilder: (Mainclass rw) => GridRow(
                      [
                        Field('${rw.id}'),
                        Field('${rw.name}'),
                        Field(IButton(type: Btn.Edit, onPressed: (){})),
                        Field(IButton(type: Btn.Del, onPressed: (){})),
                      ],
                      color: rw.edit ? editRowColor() : _bloc.kolrowsValue$.rows.indexOf(rw).isOdd ? rowColor(context) : Colors.transparent,
                    )
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class PnMoin extends StatelessWidget {
  const PnMoin({Key key, @required this.prov}) : super(key: key);

  final MyProvider prov;

  @override
  Widget build(BuildContext context) {
    if (_bloc.rowsValue$.rows.where((element)=>element.selected).length == 0)
      _bloc.loadKol(_bloc.rowsValue$.rows[0].id, loadmoin: true);
    else if (_bloc.kolrowsValue$.rows.where((element)=>element.selected).length == 0)
      _bloc.loadMoin(_bloc.kolrowsValue$.rows[0].id);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridRow(
                  [
                    Field('گروه حساب', bold: true, center: true),
                  ],
                  color: rowColor(context),
                ),
                Expanded(
                  child: StreamListWidget(
                    stream: _bloc.rowsStream$,
                    itembuilder: (Mainclass rw) => GridRow(
                      [
                        Field('${rw.name}'),
                      ],
                      color: rw.selected ? accentcolor(context).withOpacity(0.15) : _bloc.rowsValue$.rows.indexOf(rw).isOdd ? rowColor(context) : Colors.transparent,
                      onTap: ()=>_bloc.loadKol(rw.id, loadmoin: true),
                    )
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                GridRow(
                  [
                    Field('حساب کل', bold: true, center: true),
                  ],
                  color: rowColor(context),
                ),
                Expanded(
                  child: StreamListWidget(
                    stream: _bloc.kolrowsStream$, 
                    itembuilder: (Mainclass rw) => GridRow(
                      [
                        Field('${rw.id} - ${rw.name}'),
                      ],
                      color: rw.selected ? accentcolor(context).withOpacity(0.15) : _bloc.kolrowsValue$.rows.indexOf(rw).isOdd ? rowColor(context) : Colors.transparent,
                      onTap: ()=>_bloc.loadMoin(rw.id),
                    )
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                GridRow(
                  [
                    Field('کد معین', bold: true,),
                    Field('عنوان معین', bold: true,),
                    Field(IButton(type: Btn.Reload, onPressed: ()=>_bloc.fetchData()))
                  ],
                  color: rowColor(context),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    SizedBox(width: 10),
                    Expanded(child: Edit(hint: 'کد معین', onChange: (val){})),
                    SizedBox(width: 10),
                    Expanded(flex: 2,child: Edit(hint: 'عنوان معین', onChange: (val){})),
                    SizedBox(width: 10),
                    Field(IButton(type: Btn.Save, onPressed: (){})),
                    SizedBox(width: 10),
                  ],
                ),
                SizedBox(height: 15),
                Expanded(
                  child: StreamListWidget(
                    stream: _bloc.moinrowsStream$, 
                    itembuilder: (Mainclass rw) => GridRow(
                      [
                        Field('${rw.id}'),
                        Field('${rw.name}'),
                        Field(IButton(type: Btn.Edit, onPressed: (){})),
                        Field(IButton(type: Btn.Del, onPressed: (){})),
                      ],
                      color: rw.edit ? editRowColor() : _bloc.moinrowsValue$.rows.indexOf(rw).isOdd ? rowColor(context) : Colors.transparent,
                    )
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class PnTafsili extends StatelessWidget {
  const PnTafsili({Key key, @required this.prov}) : super(key: key);

  final MyProvider prov;

  @override
  Widget build(BuildContext context) {
    PublicBloc _tafsili = PublicBloc(context: context, api: 'Coding/Tafsili', token: prov.currentUser.token, body: {});
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridRow(
            [
              Field('کد تفصیلی', bold: true),
              Field('عنوان تفصیلی', bold: true),
              Field(IButton(type: Btn.Reload, onPressed: ()=>_tafsili.fetchData()))
            ],
            color: rowColor(context),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              SizedBox(width: 10),
              Expanded(child: Edit(hint: 'کد تفصیلی', onChange: (val){})),
              SizedBox(width: 10),
              Expanded(flex: 2,child: Edit(hint: 'عنوان تفصیلی', onChange: (val){})),
              SizedBox(width: 10),
              Field(IButton(type: Btn.Save, onPressed: (){})),
              SizedBox(width: 10),
            ],
          ),
          SizedBox(height: 15),
          Expanded(
            child: StreamListWidget(
              stream: _tafsili.rowsStream$,
              itembuilder: (Mainclass rw) => GridRow(
                [
                  Field('${rw.id}'),
                  Field('${rw.name}'),
                  ..._bloc.tafLevel.rowsValue$.rows.map((e) => 
                    Field(
                      e.active ? Tooltip(
                        message: e.name, 
                        child: Checkbox(
                          value: e.id==1 ? rw.lev1 : e.id==2 ? rw.lev2 : e.id==3 ? rw.lev3 : e.id==4 ? rw.lev4 : e.id==5 ? rw.lev5 : rw.lev6,
                          onChanged: (val){}
                        )
                      ) : Container()
                    )
                  ),
                  Field(IButton(type: Btn.Edit, onPressed: (){})),
                  Field(IButton(type: Btn.Del, onPressed: (){})),
                ],
                color: rw.edit ? editRowColor() : _tafsili.rowsValue$.rows.indexOf(rw).isOdd ? rowColor(context) : Colors.transparent,
              )
            ),
          )
        ],
      ),
    );
  }
}
