import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

import 'class.dart';
import 'functions.dart';

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

  fetchData() async{
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

  Future<Mainclass> saveData({BuildContext context, Mainclass data, bool msg = false}) async{
    Map<String, dynamic> _data;
    try{
      showWaiting(context);
      try{
        if (data.token == null || data.token.isEmpty)
          data.token = this.token;
        _data = await putToServer(api: '$api', body: jsonEncode(data.toJson()));
        if (_data['msg'] == "Success"){
          if (msg)
            myAlert(context: context, msgType: Msg.Success, title: 'ذخیره', message: 'ذخیره اطلاعات با موفقیت انجام گردید');
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
        if (_data['msg'] == "Success")
          this.fetchData();
        else
          throw Exception(_data['msg']);
      }
      catch(e){
        analyzeError(context, '$e');
      }
      Navigator.of(context).pop();
    });
  }

  updateRow(Mainclass art){
    if (rowsValue$.rows.where((element) => element.id==art.id).length > 0)
      rowsValue$.rows.forEach((element){ 
        if (element.id==art.id){
          element.edit = false;
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
}

class ArtyklBloc extends Bloc{
  PublicBloc tafLevel;
  
  ArtyklBloc({@required BuildContext context,@required String api, @required String token, @required Map<String, dynamic> body}): super(context: context, api: api, token: token, body: body){
      tafLevel = PublicBloc(context: context, api: 'Coding/AccLevel', token: token, body: {});
  }

}