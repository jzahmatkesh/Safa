import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

import 'class.dart';
import 'functions.dart';

abstract class Bloc{
  final String api;
  final String token;
  Map<String, dynamic> body;

  Bloc({@required this.api, @required this.token, this.body}){
    this.fetchData();
  }

  BehaviorSubject<DataModel> _rows = BehaviorSubject<DataModel>.seeded(DataModel(status: Status.Loading));
  Stream<DataModel> get rowsStream$ => _rows.stream;
  DataModel get rowsValue$ => _rows.value;

  fetchData() async{
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

  Future<Mainclass> saveData({BuildContext context, Mainclass data}) async{
    try{
      if (data.token == null || data.token.isEmpty)
        data.token = this.token;
      Map<String, dynamic> _data = await putToServer(api: '$api', body: jsonEncode(data.toJson()));
      if (_data['msg'] == "Success")
        return Mainclass.fromJson(_data['body']);
      throw Exception(_data['msg']);
    }
    catch(e){
      analyzeError(context, '$e');
    }
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
}

class SanadBloc extends Bloc{
    SanadBloc({@required String api, @required String token}): super(api: api, token: token, body: {'filter': 0});

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
    ArtyklBloc({@required String api, @required String token, @required Map<String, dynamic> body}): super(api: api, token: token, body: body);
}