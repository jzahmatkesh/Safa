import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../module/Blocs.dart';
import '../module/MyProvider.dart';
import '../module/Widgets.dart';
import '../module/class.dart';
import '../module/functions.dart';

CodingBloc _bloc;
PublicBloc _tafsili;
IntBloc _menu = IntBloc()..setValue(1);
int _id = 0;
TextEditingController _edid = TextEditingController();
TextEditingController _edname = TextEditingController();
FocusNode _fgrpname = FocusNode();
FocusNode _fkolid = FocusNode();
FocusNode _fkolname = FocusNode();
FocusNode _fmoinid = FocusNode();
FocusNode _fmoinname = FocusNode();
FocusNode _ftafid = FocusNode();
FocusNode _ftafname = FocusNode();

class FmCoding extends StatelessWidget { 
  const FmCoding({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MyProvider _prov = Provider.of<MyProvider>(context);
    if (_bloc == null || _bloc.token != _prov.currentUser.token)
      _bloc = CodingBloc(context: context, api: 'Coding/Group', token: _prov.currentUser.token, body: {});
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.all(8),
        child: StreamWidget(
          stream: _menu.stream$, 
          itemBuilder: (int i)=>Column(
            children: [
              GridError(
                msg: Row(
                  children: [
                    _prov.currentUser.kolcount == 0 ? Button(caption: 'درج سرفصل های استاندارد', icon: Icon(CupertinoIcons.gear), onTap: (){}) : Container(),
                    SizedBox(width: 5),
                    Button(caption: 'دریافت از فایل اکسل', icon: Icon(FontAwesomeIcons.fileExcel), onTap: ()=>importfromexcel(context, _prov.currentUser.token))
                  ]
                ),
                color: accentcolor(context).withOpacity(0.35),
              ),
              Header(title: 'سرفصل حسابها'),
              Row(
                children: [
                  Expanded(child: Menu(title: 'گروه حساب', inCard: true, selected: i==1, selectedColor: accentcolor(context).withOpacity(0.15), onTap: (){_id=0; _menu.setValue(1);})),
                  Expanded(child: Menu(title: 'حساب کل', inCard: true, selected: i==2, selectedColor: accentcolor(context).withOpacity(0.15), onTap: (){_id=0; _menu.setValue(2);})),
                  Expanded(child: Menu(title: 'حساب معین', inCard: true, selected: i==3, selectedColor: accentcolor(context).withOpacity(0.15), onTap: (){_id=0; _menu.setValue(3);})),
                  Expanded(child: Menu(title: 'حساب تفصیلی', inCard: true, selected: i==4, selectedColor: accentcolor(context).withOpacity(0.15), onTap: (){_id=0; _menu.setValue(4);})),
                ],
              ),
              i == 1
                ? Expanded(child: PnGroup(prov: _prov,))
                : i == 2
                  ? Expanded(child: PnKol(prov: _prov, menu: _menu,))
                  : i == 3
                    ? Expanded(child: PnMoin(prov: _prov, menu: _menu,))
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
                child: Edit(hint: 'گروه حساب جدید', controller: _edname, focus: _fgrpname, onSubmitted: (val) async{
                  Mainclass _rw = await _bloc.saveData(context: context, data: Mainclass(id: _id, name: val), msg: true);
                  if (_rw != null){
                    _id = 0;
                    _edname.clear();
                    _bloc.updateRow(_rw);                  
                  }
                })
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
                  Field(
                    IButton(
                      type: Btn.Edit, 
                      onPressed: (){
                        _id = rw.id;
                        _edname.text = rw.name;
                        _bloc.editMode(rw.id);
                        focusChange(context, _fgrpname);
                      }
                    )
                  ),
                  Field(IButton(type: Btn.Del, onPressed: ()=>_bloc.delGroup(context, rw.id, rw.name))),
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
  const PnKol({Key key, @required this.prov, @required this.menu}) : super(key: key);

  final MyProvider prov;
  final IntBloc menu;

  @override
  Widget build(BuildContext context) {
    if (_bloc.rowsValue$.rows.length == 0)
      Future.delayed(Duration(milliseconds: 1)).then((value){
        myAlert(context: context, title: 'هشدار', message: 'گروه حساب تعریف نشده است', msgType: Msg.Warning);
        menu.setValue(1);
      });
    else if (_bloc.rowsValue$.rows.where((element)=>element.selected).length == 0)
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
                    Expanded(child: Edit(hint: 'کد کل', controller: _edid, focus: _fkolid, onChange: (val){}, onSubmitted: (val)=>focusChange(context, _fkolname))),
                    SizedBox(width: 10),
                    Expanded(flex: 2,child: Edit(hint: 'عنوان کل', controller: _edname, focus: _fkolname, onChange: (val){}, onSubmitted: (val)=>saveKol(context))),
                    SizedBox(width: 10),
                    Field(IButton(type: Btn.Save, onPressed: ()=>saveKol(context))),
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
                        Field(IButton(type: Btn.Edit, onPressed: ()=>editkol(context, rw))),
                        Field(IButton(type: Btn.Del, onPressed: ()=>_bloc.delKol(context, rw.id, rw.name))),
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
  const PnMoin({Key key, @required this.prov, @required this.menu}) : super(key: key);

  final MyProvider prov;
  final IntBloc menu;

  @override
  Widget build(BuildContext context) {


    if (_bloc.rowsValue$.rows.length == 0)
      Future.delayed(Duration(milliseconds: 1)).then((value){
        myAlert(context: context, title: 'هشدار', message: 'گروه حساب تعریف نشده است', msgType: Msg.Warning);
        menu.setValue(1);
      });
    else if (_bloc.rowsValue$.rows.where((element)=>element.selected).length == 0)
      _bloc.loadKol(_bloc.rowsValue$.rows[0].id, loadmoin: true);
    else if (_bloc.kolrowsValue$.rows.where((element)=>element.selected).length == 0 && _bloc.kolrowsValue$.rows.length > 0)
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
                    Expanded(child: Edit(hint: 'کد معین', focus: _fmoinid, controller: _edid, onSubmitted: (val)=>focusChange(context, _fmoinname))),
                    SizedBox(width: 10),
                    Expanded(flex: 2,child: Edit(hint: 'عنوان معین', focus: _fmoinname, controller: _edname, onSubmitted: (val)=>saveMoin(context))),
                    SizedBox(width: 10),
                    Field(IButton(type: Btn.Save, onPressed: ()=>saveMoin(context))),
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
                        Field(IButton(type: Btn.Edit, onPressed: ()=>editmoin(context, rw))),
                        Field(IButton(type: Btn.Del, onPressed: ()=>_bloc.delMoin(context, rw.kolid, rw.id, rw.name))),
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
    if (_tafsili == null)
      _tafsili = PublicBloc(context: context, api: 'Coding/Tafsili', token: prov.currentUser.token, body: {});
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
              Expanded(child: Edit(hint: 'کد تفصیلی', focus: _ftafid, controller: _edid, onSubmitted: (val)=>focusChange(context, _ftafname))),
              SizedBox(width: 10),
              Expanded(flex: 2,child: Edit(hint: 'عنوان تفصیلی', focus: _ftafname, controller: _edname, onSubmitted: (val)=>saveTafsili(context))),
              SizedBox(width: 10),
              Field(IButton(type: Btn.Save, onPressed: ()=>saveTafsili(context))),
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
                  Field(IButton(type: Btn.Edit, onPressed: ()=>edittafsili(context, rw))),
                  Field(IButton(type: Btn.Del, onPressed: ()=>_tafsili.delData(context: context, body: {"id": rw.id}, msg: "تفصیلی ${rw.name}"))),
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


void saveKol(BuildContext context) async{
  if (_edid.text.isEmpty)
    myAlert(context: context, title: 'مقادیر اجباری', message: 'کد حساب کل مشخص نشده است');
  else if (_edname.text.isEmpty)
    myAlert(context: context, title: 'مقادیر اجباری', message: 'عنوان حساب کل مشخص نشده است');
  else{
    if (await _bloc.saveKol(context, Mainclass(old: _id, id: int.parse(_edid.text), name: _edname.text)) != null){
      _edid.clear();
      _edname.clear();
      focusChange(context, _fkolid);
    }
  }
}

void saveMoin(BuildContext context) async{
  if (_edid.text.isEmpty)
    myAlert(context: context, title: 'مقادیر اجباری', message: 'کد حساب معین مشخص نشده است');
  else if (_edname.text.isEmpty)
    myAlert(context: context, title: 'مقادیر اجباری', message: 'عنوان حساب معین مشخص نشده است');
  else{
    if (await _bloc.saveMoin(context, Mainclass(old: _id, id: int.parse(_edid.text), name: _edname.text)) != null){
      _edid.clear();
      _edname.clear();
      focusChange(context, _fmoinid);
    }
  }
}

void saveTafsili(BuildContext context) async{
  if (_edid.text.isEmpty)
    myAlert(context: context, title: 'مقادیر اجباری', message: 'کد تفصیلی مشخص نشده است');
  else if (_edname.text.isEmpty)
    myAlert(context: context, title: 'مقادیر اجباری', message: 'عنوان تفصیلی مشخص نشده است');
  else{
    if (await _tafsili.saveData(context: context, data: Mainclass(old: _id, id: int.parse(_edid.text), name: _edname.text), addtorows: true) != null){
      _edid.clear();
      _edname.clear();
      focusChange(context, _ftafid);
    }
  }
}

void editkol(BuildContext context, Mainclass rw){
  _edid.text = rw.id.toString();
  _edname.text = rw.name;
  _id = rw.id;
  _bloc.editKol(rw.id);
  focusChange(context, _fkolname);
}

void editmoin(BuildContext context, Mainclass rw){
  _edid.text = rw.id.toString();
  _edname.text = rw.name;
  _id = rw.id;
  _bloc.editMoin(rw.id);
  focusChange(context, _fmoinname);
}

void edittafsili(BuildContext context, Mainclass rw){
  _edid.text = rw.id.toString();
  _edname.text = rw.name;
  _id = rw.id;
  _tafsili.editMode(rw.id);
  focusChange(context, _ftafname);
}

void importfromexcel(BuildContext context, String token) async{
  FilePickerResult result = await FilePicker.platform.pickFiles();
  if(result != null) {
    var bytes = result.files.first.bytes;//file.readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    showFormAsDialog(context: context, form: FmImportExcel(excel: excel, token: token));
  }
}

class FmImportExcel extends StatelessWidget {
  const FmImportExcel({Key key, @required this.excel, @required this.token}) : super(key: key);

  final Excel excel;
  final String token;

  @override
  Widget build(BuildContext context) {
    var table  = excel.tables.keys.first;
    bool grpid = false, grpname = false, kolid = false, kolname = false, moinid = false, moinname = false;
    excel.tables[table].rows[0].forEach((element) {
      grpid = grpid || element=="کد گروه";
      grpname = grpname || element=="عنوان گروه";
      kolid = kolid || element=="کد کل";
      kolname = kolname || element=="عنوان کل";
      moinid = moinid || element=="کد معین";
      moinname = moinname || element=="عنوان معین";
    });
    ExcelBloc _excelBloc = ExcelBloc(rows: excel.tables[table].rows);
    
    void importFromExcel() async{
      bool res, messaged = false;
      try{
        showWaiting(context);
        if (_excelBloc.value.where((element) => (element.check ?? false) && !element.imported).length == 0)
          myAlert(context: context, title: 'هشدار', message: 'رکوردی انتخاب نشده است');
        else{
          _excelBloc.value.asMap().forEach((idx, element) async{
            if (idx > 0 && (element.check ?? false) && !element.imported){
              if ((res ?? true))
                if (!(element.cells[0] is int))
                  _excelBloc.checkRow(idx, null, error: '${element.cells[0]} عددی نیست و قابل درج در کد گروه نمی باشد'); 
                else if (!(element.cells[2] is int))
                  _excelBloc.checkRow(idx, null, error: '${element.cells[2]} عددی نیست و قابل درج در کد کل نمی باشد');
                else if (!(element.cells[4] is int))
                  _excelBloc.checkRow(idx, null, error: '${element.cells[4]} عددی نیست و قابل درج در کد معین نمی باشد');
                else{
                  res = await _excelBloc.exportToDB(
                    context: context, 
                    api: 'Coding/ImportExcel', 
                    data: {
                      'token': this.token,
                      'grpid': element.cells[0],
                      'grpname': element.cells[1],
                      'kolid': element.cells[2],
                      'kolname': element.cells[3],
                      'moinid': element.cells[4],
                      'moinname': element.cells[5],
                    }
                  );
                  if (res)
                    _excelBloc.imported(idx);
                  if (_excelBloc.value.where((element) => !element.imported).length == 1 && !messaged){
                    messaged = true;
                    Navigator.of(context).pop();
                    myAlert(context: context, title: 'موفقیت آمیز', message: '${_excelBloc.value.where((element) => element.imported).length} رکورد با موفقیت در بانک  اطلاعاتی درج گردید', msgType: Msg.Success);
                  }
                }
            }
          });
          _bloc.fetchData();
          _id=0; 
          _menu.setValue(1);
        }
      }
      finally{
        hideWaiting(context);
      }
    }
    
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: screenWidth(context) * 0.75,
        height: screenHeight(context) * 0.75,
        child: Column(
          children: [
            Header(title: 'دریافت اطلاعات سرفصل حساب از اکسل', leftBtn: IButton(type: Btn.Exit), rightBtn: grpid && grpname && kolid && kolname && moinid && moinname ? IButton(hint: 'درج ردیف های انتخابی در بانک اطلاعات', icon: Icon(CupertinoIcons.layers_alt), onPressed: ()=>importFromExcel()) : null,),
            SizedBox(height: 15),
            !grpid || !grpname || !kolid || !kolname || !moinid || !moinname ? Container(width: screenWidth(context) * 0.65 > 600 ? 600 : screenWidth(context) * 0.50, child: Image(image: AssetImage('images/excel-coding.png'),)) : Container(),
            SizedBox(height: 15),
            Expanded(
              child: StreamBuilder<List<ExcelRow>>(
                stream: _excelBloc.stream$, 
                builder: (context, snap)=> snap.connectionState==ConnectionState.active ? ListView.builder(
                  itemCount: snap.data.length,
                  itemBuilder: (context, idx)=>snap.data[idx].imported ? Container() : GridRow([
                    Field(grpid && grpname && kolid && kolname && moinid && moinname 
                      ? snap.data[idx].error != null 
                        ? Padding(padding: const EdgeInsets.all(4.0),child: Tooltip(message: '${snap.data[idx].error}', child: Icon(CupertinoIcons.xmark_square, color: Colors.red))) 
                        : Checkbox(value: snap.data[idx].check, onChanged: (val)=>_excelBloc.checkRow(idx, val)) 
                      : Container(height: 38,)
                    ),
                    Field(SizedBox(width: 10)),
                    ... snap.data[idx].cells.map((e) => 
                      idx == 0
                        ? snap.data[idx].cells.indexOf(e)==0 && !grpid 
                          ? Field(Expanded(child: Row(children: [Tooltip(message: 'عنوان فیلد صحیح نمی باشد به فایل اکسل نمونه توجه فرمایید', child: Icon(CupertinoIcons.hand_thumbsdown, color: Colors.red, size: 14)), SizedBox(width: 5), Expanded(child: Text('$e'))])))
                          : snap.data[idx].cells.indexOf(e)==1 && !grpname
                            ? Field(Expanded(child: Row(children: [Tooltip(message: 'عنوان فیلد صحیح نمی باشد به فایل اکسل نمونه توجه فرمایید', child: Icon(CupertinoIcons.hand_thumbsdown, color: Colors.red, size: 14)), SizedBox(width: 5), Expanded(child: Text('$e'))])))
                            : snap.data[idx].cells.indexOf(e)==2 && !kolid 
                              ? Field(Expanded(child: Row(children: [Tooltip(message: 'عنوان فیلد صحیح نمی باشد به فایل اکسل نمونه توجه فرمایید', child: Icon(CupertinoIcons.hand_thumbsdown, color: Colors.red, size: 14)), SizedBox(width: 5), Expanded(child: Text('$e'))])))
                              : snap.data[idx].cells.indexOf(e)==3 && !kolname 
                                ? Field(Expanded(child: Row(children: [Tooltip(message: 'عنوان فیلد صحیح نمی باشد به فایل اکسل نمونه توجه فرمایید', child: Icon(CupertinoIcons.hand_thumbsdown, color: Colors.red, size: 14)), SizedBox(width: 5), Expanded(child: Text('$e'))])))
                                : snap.data[idx].cells.indexOf(e)==4 && !moinid 
                                  ? Field(Expanded(child: Row(children: [Tooltip(message: 'عنوان فیلد صحیح نمی باشد به فایل اکسل نمونه توجه فرمایید', child: Icon(CupertinoIcons.hand_thumbsdown, color: Colors.red, size: 14)), SizedBox(width: 5), Expanded(child: Text('$e'))])))
                                  : snap.data[idx].cells.indexOf(e)==5 && !moinname 
                                    ? Field(Expanded(child: Row(children: [Tooltip(message: 'عنوان فیلد صحیح نمی باشد به فایل اکسل نمونه توجه فرمایید', child: Icon(CupertinoIcons.hand_thumbsdown, color: Colors.red, size: 14)), SizedBox(width: 5), Expanded(child: Text('$e'))])))
                                    : snap.data[idx].cells.indexOf(e)==6 && !moinname 
                                      ? Field(Expanded(child: Row(children: [Tooltip(message: 'عنوان فیلد صحیح نمی باشد به فایل اکسل نمونه توجه فرمایید', child: Icon(CupertinoIcons.hand_thumbsdown, color: Colors.red, size: 14)), SizedBox(width: 5), Expanded(child: Text('$e'))])))
                                      : Field('$e')
                        : Field('$e')
                    )
                  ], header: idx==0, color: snap.data[idx].error != null ? Colors.red.withOpacity(0.15) : null)
                ) : Center(child: CupertinoActivityIndicator(),)
              ),
            )
          ],
        ),
      ),
    );
  }
}