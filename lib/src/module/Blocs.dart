import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

import 'class.dart';
import 'functions.dart';

class IntBloc{
  IntBloc();

  BehaviorSubject<int> _value = BehaviorSubject<int>();
  Stream<int> get stream$ => _value.stream;
  int get value => _value.value;

  setValue(int i)=>_value.add(i);
}
abstract class Bloc{
  final BuildContext context;
  final String api;
  final String token;
  Map<String, dynamic> body;

  Bloc({@required this.context, @required this.api, @required this.token, this.body}){
    this.fetchData();
  }

  BehaviorSubject<DataModel> _rows = BehaviorSubject<DataModel>.seeded(DataModel(status: Status.Loading));
  Stream<DataModel> get rowsStream$ => _rows.stream;
  DataModel get rowsValue$ => _rows.value;

  reload(){
    _rows.add(rowsValue$);
  }

  fetchData({bool waiting = false}) async{
    try{
      Future.delayed(Duration.zero, () => showWaiting(context));
      try{
        _rows.add(DataModel(status: Status.Loading));
        if (this.body == null)
          this.body = {'token': token};
        else
          this.body.putIfAbsent('token', () => token);
        Map<String, dynamic> _data = await postToServer(api: '$api', body: jsonEncode(body));
        if (_data['msg'] == "Success"){
          _rows.add(DataModel(status: Status.Loaded, rows: _data['body'].map<Mainclass>((data) => Mainclass.fromJson(json.decode(data))).toList()));
        }
        else
          throw Exception(_data['msg']);
      }
      catch(e){
        _rows.add(DataModel(status: Status.Error, msg: '$e'));
      }
    }
    finally{
      hideWaiting(context);
    }
  }

  Future<Mainclass> saveData({BuildContext context, Mainclass data, bool msg = false, String secapi, bool addtorows = false}) async{
    Map<String, dynamic> _data;
    try{
      showWaiting(context);
      try{
        if (data.token == null || data.token.isEmpty)
          data.token = this.token;
        _data = await putToServer(api: '${secapi ?? api}', body: jsonEncode(data.toJson()));
        if (_data['msg'] == "Success"){
          if (msg)
            myAlert(context: context, msgType: Msg.Success, title: 'ذخیره', message: 'ذخیره اطلاعات با موفقیت انجام گردید');
          if (addtorows){
            bool nval = true;
            rowsValue$.rows.forEach((element) {
              if (element.id == data.old){
                element.old  = data.id;
                element.name = data.name;
                element.edit = false;
                nval = false;
              }
            });
            data.old = data.id;
            if (nval)
              rowsValue$.rows.insert(0, data);
            _rows.add(rowsValue$);
          }
          return Mainclass.fromJson(_data['body']);
        }
        throw Exception(_data['msg']);
      }
      catch(e){
        analyzeError(context, '$e');
      }
    }
    finally{
      hideWaiting(context);
    }
    if (_data.containsKey('errorid'))
      return Mainclass(errorid: _data['errorid']);
    else
      return null;
  }

  void delData({BuildContext context, String msg, Map<String, dynamic> body}){
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف $msg می باشید؟', yesclick: () async{
      try{
        body.putIfAbsent('token', () => this.token);
        Map<String, dynamic> _data = await delToServer(api: '${this.api}', body: jsonEncode(body));
        if (_data['msg'] == "Success"){
          Navigator.of(context).pop();
          this.fetchData();
        }
        else{
          Navigator.of(context).pop();
          throw Exception(_data['msg']);
        }
      }
      catch(e){
        Navigator.of(context).pop();
        analyzeError(context, '$e');
      }
    });
  }

  updateRow(Mainclass art){
    if (rowsValue$.rows.where((element) => element.id==art.id).length > 0)
      rowsValue$.rows.forEach((element){ 
        if (element.id==art.id){
          element.edit = false;
          element.name = art.name;
          element.kolid = art.kolid;
          element.kolname = art.kolname;
          element.moinid = art.moinid;
          element.moinname = art.moinname;
          element.taf1 = art.taf1;
          element.taf1name = art.taf1name;
          element.taf2 = art.taf2;
          element.taf2name = art.taf2name;
          element.taf3 = art.taf3;
          element.taf3name = art.taf3name;
          element.taf4 = art.taf4;
          element.taf4name = art.taf4name;
          element.taf5 = art.taf5;
          element.taf5name = art.taf5name;
          element.taf6 = art.taf6;
          element.taf6name = art.taf6name;
          element.bed = art.bed;
          element.bes = art.bes;
          element.note = art.note;
        }
      });
    else
      rowsValue$.rows.insert(0, art);
    _rows.add(DataModel(status: Status.Loaded, rows: rowsValue$.rows));
  }

  editMode(int id){
    rowsValue$.rows.forEach((element) {element.edit = element.id == id;});
    _rows.add(DataModel(status: Status.Loaded, rows: rowsValue$.rows));
  }

  findByName(String val){
    rowsValue$.rows.forEach((element) {
      element.inSearch = element.name.contains(val);
      element.selected = false;
    });
    _rows.add(rowsValue$);
  }

  selectRowbyClick(Mainclass rw){
    if (rowsValue$.rows != null){
      rowsValue$.rows.forEach((value) {
        value.selected = value == rw;
      });
      reload();
    }
  }
  selectRow(int i){
    if (rowsValue$.rows != null){
      int idx = -1;
      rowsValue$.rows.forEach((value) {
        if (value.inSearch){
          idx++;
          value.selected = idx == i;
        }
        else
          value.selected = false;
      });
      reload();
    }
  }
  selectNextRow(){
    if (rowsValue$.rows != null){
      int i=-1, idx = -1;
      rowsValue$.rows.forEach((element) {
        if (element.inSearch){
          idx++;
          if (element.selected)
            i = idx;
        }
      });
      selectRow(i+1);
    }
    reload();
  }
  selectPriorRow(){
    if (rowsValue$.rows != null){
      int i=-1, idx = -1;
      rowsValue$.rows.forEach((element) {
        if (element.inSearch){
          idx++;
          if (element.selected)
            i = idx;
        }
      });
      selectRow(i-1);
    }
    reload();
  }
}

class PublicBloc extends Bloc{
  PublicBloc({@required BuildContext context,@required String api, @required String token, @required Map<String, dynamic> body}): super(context: context, api: api, token: token, body: body);
}
class SanadBloc extends Bloc{
  SanadBloc({@required BuildContext context, @required String api, @required String token}): super(context: context, api: api, token: token, body: {'filter': 0});

  BehaviorSubject<int> _filter = BehaviorSubject<int>.seeded(0);
  Stream<int> get filterStream$ => _filter.stream;
  int get filterValue => _filter.value;

  BehaviorSubject<Mainclass> _sanad = BehaviorSubject<Mainclass>.seeded(null);
  Stream<Mainclass> get sanadStream$ => _sanad.stream;
  Mainclass get sanadValue => _sanad.value;

  changeFilter(int i){
    if (filterValue == i)
      i = 0;
    this.body['filter'] = i;
    _filter.add(i);
    this.fetchData();
  }

  showSanad(Mainclass rec)=>_sanad.add(rec);
  copySanad(BuildContext context, int id){
    confirmMessage(context, 'کپی سند', 'آیا مایل به کپی سند شماره $id به سند جدید می باشید؟', yesclick: () async{
      Navigator.pop(context);
      try{
        Map<String, dynamic> _data = await postToServer(api: 'Asnad/Copy', body: jsonEncode({'id': id, 'token': this.token}));
        if (_data['msg'] == "Success"){
          fetchData();
          showSanad(Mainclass.fromJson(_data['body']));
        }
        else
          throw Exception(_data['msg']);
      }
      catch(e){
        analyzeError(context, '$e');
      }
    });
  }

  newSanad() async{
    try{
      var _data = await postToServer(api: 'Asnad/NewSanad', body: jsonEncode({'token': this.token}));
      if (_data['msg'] == "Success"){
        showSanad(Mainclass.fromJson(_data['body']));
        _rows.value.rows.insert(0, Mainclass.fromJson(_data['body']));
        _rows.add(_rows.value);
      }
      else
        throw Exception(_data['msg']);
    }
    catch(e){
      analyzeError(context, '$e');
    }
  }

  registerSanad(BuildContext context, int id) async{
    try{
      Mainclass _res = await saveData(context: context, data: Mainclass(id: id), secapi: 'Asnad/Reg');
      if (_res != null){
        if (sanadValue != null){
          sanadValue.reg = _res.reg;
          _sanad.add(_res);
        }
        rowsValue$.rows.forEach((element) {
          if (element.id == id)
            element.reg = _res.reg;
        });
        _rows.add(_rows.value);
      }
    }
    catch(e){
      analyzeError(context, '$e');
    }
  }
}

class ArtyklBloc extends Bloc{
  PublicBloc tafLevel;
  
  ArtyklBloc({@required BuildContext context,@required String api, @required String token, @required Map<String, dynamic> body}): super(context: context, api: api, token: token, body: body){
      tafLevel = PublicBloc(context: context, api: 'Coding/AccLevel', token: token, body: {});
  }

}

class CodingBloc extends Bloc{
  int _groupid = 0;
  int _kolid = 0;

  PublicBloc tafLevel;
  CodingBloc({@required BuildContext context, @required String api, @required String token, @required Map<String, dynamic> body}): super(context: context, api: api, token: token, body: body){
      tafLevel = PublicBloc(context: context, api: 'Coding/AccLevel', token: token, body: {});
  }

  BehaviorSubject<DataModel> _kolrows = BehaviorSubject<DataModel>.seeded(DataModel(status: Status.Loading));
  Stream<DataModel> get kolrowsStream$ => _kolrows.stream;
  DataModel get kolrowsValue$ => _kolrows.value;

  BehaviorSubject<DataModel> _moinrows = BehaviorSubject<DataModel>.seeded(DataModel(status: Status.Loading));
  Stream<DataModel> get moinrowsStream$ => _moinrows.stream;
  DataModel get moinrowsValue$ => _moinrows.value;

  void loadKol(int grp, {bool loadmoin = false}) async{
    try{
      _groupid = grp;
      rowsValue$.rows.forEach((element) {
        element.selected = element.id == grp;
      });
      _rows.add(rowsValue$);
      Future.delayed(Duration.zero, () => showWaiting(context));
      try{
        _kolrows.add(DataModel(status: Status.Loading));
        Map<String, dynamic> _data = await postToServer(api: 'Coding/Kol', body: jsonEncode({'token': token,'grpid': grp}));
        if (_data['msg'] == "Success"){
          _kolrows.add(DataModel(status: Status.Loaded, rows: _data['body'].map<Mainclass>((data) => Mainclass.fromJson(json.decode(data))).toList()));
          if (loadmoin)
            loadMoin(kolrowsValue$.rows[0].id);
        }
        else
          throw Exception(_data['msg']);
      }
      catch(e){
        _kolrows.add(DataModel(status: Status.Error, msg: '$e'));
      }
    }
    finally{
      hideWaiting(context);
    }
  }

  Future<Mainclass> saveKol(BuildContext context, Mainclass data) async{
    data.grpid = _groupid;
    if( await saveData(context: context, secapi: 'Coding/Kol', data: data) != null){
      bool _nv = true;
      kolrowsValue$.rows.forEach((element) {
        if (element.id == data.old){
          element.id = data.id;
          element.name = data.name;
          element.edit = false;
          _nv = false;
        }
      });
      data.old = data.id;
      if (_nv)
        kolrowsValue$.rows.insert(0, data);
      _kolrows.add(kolrowsValue$);
      return data;
    }
    else
      return null;
  }

  void loadMoin(int kol) async{
    try{
      _kolid = kol;
      kolrowsValue$.rows.forEach((element) {
        element.selected = element.id == kol;
      });
      _kolrows.add(kolrowsValue$);
      Future.delayed(Duration.zero, () => showWaiting(context));
      try{
        _moinrows.add(DataModel(status: Status.Loading));
        Map<String, dynamic> _data = await postToServer(api: 'Coding/Moin', body: jsonEncode({'token': token,'kolid': kol}));
        if (_data['msg'] == "Success"){
          _moinrows.add(DataModel(status: Status.Loaded, rows: _data['body'].map<Mainclass>((data) => Mainclass.fromJson(json.decode(data))).toList()));
        }
        else
          throw Exception(_data['msg']);
      }
      catch(e){
        _kolrows.add(DataModel(status: Status.Error, msg: '$e'));
      }
    }
    finally{
      hideWaiting(context);
    }
  }

  Future<Mainclass> saveMoin(BuildContext context, Mainclass data) async{
    data.kolid = _kolid;
print('old; ${data.old}');
    if( await saveData(context: context, secapi: 'Coding/Moin', data: data) != null){
      bool _nv = true;
      moinrowsValue$.rows.forEach((element) {
        if (element.id == data.old){
          element.id = data.id;
          element.name = data.name;
          element.edit = false;
          _nv = false;
        }
      });
      data.old = data.id;
      if (_nv)
        moinrowsValue$.rows.insert(0, data);
      _moinrows.add(moinrowsValue$);
      return data;
    }
    else
      return null;
  }

  void editKol(int id){
    kolrowsValue$.rows.forEach((element) {
      element.edit = element.id == id;
    });
    _kolrows.add(kolrowsValue$);
  }

  void editMoin(int id){
    moinrowsValue$.rows.forEach((element) {
      element.edit = element.id == id;
    });
    _moinrows.add(moinrowsValue$);
  }
}