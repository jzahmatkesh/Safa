import 'package:flutter/material.dart';

enum AppTheme {
 Light, Dark
}
enum Status{
  Loading, Loaded, Error
}
enum Msg{
  Warning, Error, Success, Info
}

class User{
    int id;
    String company;
    String family;
    String mobile;
    bool admin;
    
    int sanadcount;
    int kolcount;
    int moincount;
    int tafsilicount;

    String semat;
    AppTheme theme;
    String token;
 
    User({this.id,this.family,this.mobile,this.admin,this.semat, this.token, this.theme = AppTheme.Light});
 
    User.fromJson(Map<String, dynamic> json):
        id = json['id'],
        company = json['company'],
        family = json['family'],
        mobile = json['mobile'],
        admin = json['admin'] == 1,
        semat = json['semat'],
        token = json['token'],
        sanadcount = json['sanadcount'],
        kolcount = json['kolcount'],
        moincount = json['moincount'],
        tafsilicount = json['tafsilicount'],
        theme = AppTheme.Light;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['family'] = this.family;
        data['mobile'] = this.mobile;
        data['admin'] = this.admin ? 1 : 0;
        data['semat'] = this.semat;
        data['token'] = this.token;
        return data;
    }
}

class Mainclass{
    int cmpid;
    String cmpname;
    int dorehid;
    String dorehname;
    int userid;
    String userfamily;
    int sanadid;
    int levid;
    int tafid;
    int grpid;
    int kolid;
    int moinid;
    int old;
    int id;
    String name;
    String date;
    String note;
    int taf1;
    int taf2;
    int taf3;
    int taf4;
    int taf5;
    int taf6;
    String kolname;
    String moinname;
    String taf1name;
    String taf2name;
    String taf3name;
    String taf4name;
    String taf5name;
    String taf6name;
    double bed;
    double bes;
    double mandebed;
    double mandebes;
    bool edit;
    String token;
    bool selected;
    bool inSearch;
    bool lev1;
    bool lev2;
    bool lev3;
    bool lev4;
    bool lev5;
    bool lev6;
    bool active;
    bool autoins;
    bool reg;
    int errorid;

    Mainclass({this.cmpid,this.cmpname,this.dorehid,this.dorehname,this.userid,this.userfamily,this.sanadid,this.levid,this.tafid,this.grpid,this.kolid,this.moinid,this.old,this.id=0,this.name,this.date,this.note,this.taf1,this.taf2,this.taf3,this.taf4,this.taf5,this.taf6,this.kolname,this.moinname,this.taf1name,this.taf2name,this.taf3name,this.taf4name,this.taf5name,this.taf6name,this.bed,this.bes,this.mandebed,this.mandebes,this.edit=false, this.token, this.selected=false, this.inSearch = true, this.lev1=false,this.lev2=false,this.lev3=false,this.lev4=false,this.lev5=false,this.lev6=false, this.active = true, this.autoins = false, this.reg=false, this.errorid = 0});
 
    Mainclass.fromJson(Map<String, dynamic> json):
        cmpid = json['cmpid'],
        cmpname = json['cmpname'],
        dorehid = json['dorehid'],
        dorehname = json['dorehname'],
        userid = json['userid'],
        userfamily = json['userfamily'],
        sanadid = json['sanadid'],
        levid = json['levid'],
        tafid = json['tafid'],
        grpid = json['grpid'],
        kolid = json['kolid'],
        moinid = json['moinid'],
        old = json['id'],
        id = json['id'],
        name = json['name'],
        date = json['date'],
        note = json['note'],
        taf1 = json['taf1'],
        taf2 = json['taf2'],
        taf3 = json['taf3'],
        taf4 = json['taf4'],
        taf5 = json['taf5'],
        taf6 = json['taf6'],
        lev1 = json['lev1'] == 2 ? null : json['lev1'] == 1,
        lev2 = json['lev2'] == 2 ? null : json['lev2'] == 1,
        lev3 = json['lev3'] == 2 ? null : json['lev3'] == 1,
        lev4 = json['lev4'] == 2 ? null : json['lev4'] == 1,
        lev5 = json['lev5'] == 2 ? null : json['lev5'] == 1,
        lev6 = json['lev6'] == 2 ? null : json['lev6'] == 1,
        kolname = json['kolname'],
        moinname = json['moinname'],
        taf1name = json['taf1name'],
        taf2name = json['taf2name'],
        taf3name = json['taf3name'],
        taf4name = json['taf4name'],
        taf5name = json['taf5name'],
        taf6name = json['taf6name'],
        bed = json['bed'],
        bes = json['bes'],
        mandebed = json['mandebed'],
        mandebes = json['mandebes'],
        edit = json['edit'] == 1,
        active = json['active'] == 1,
        autoins = json['autoins'] == 1,
        reg = json['reg'] == 1,
        selected = false,
        inSearch = true,
        errorid = json['errorid'] ?? 0;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        if (this.cmpid != null)
          data['cmpid'] = this.cmpid;
        if (this.cmpname != null)
          data['cmpname'] = this.cmpname;
        if (this.dorehid != null)
          data['dorehid'] = this.dorehid;
        if (this.dorehname != null)
          data['dorehname'] = this.dorehname;
        if (this.userid != null)
          data['userid'] = this.userid;
        if (this.userfamily != null)
          data['userfamily'] = this.userfamily;
        if (this.sanadid != null)
          data['sanadid'] = this.sanadid;
        if (this.levid != null)
          data['levid'] = this.levid;
        if (this.grpid != null)
          data['grpid'] = this.grpid;
        if (this.kolid != null)
          data['kolid'] = this.kolid;
        if (this.moinid != null)
          data['moinid'] = this.moinid;
        if (this.tafid != null)
          data['tafid'] = this.tafid;
        if (this.id != null)
          data['id'] = this.id;
        if (this.old != null)
          data['old'] = this.old;
        if (this.name != null)
          data['name'] = this.name;
        if (this.date != null)
          data['date'] = this.date;
        if (this.note != null)
          data['note'] = this.note;
        if (this.taf1 != null)
          data['taf1'] = this.taf1;
        if (this.taf2 != null)
          data['taf2'] = this.taf2;
        if (this.taf3 != null)
          data['taf3'] = this.taf3;
        if (this.taf4 != null)
          data['taf4'] = this.taf4;
        if (this.taf5 != null)
          data['taf5'] = this.taf5;
        if (this.taf6 != null)
          data['taf6'] = this.taf6;
        if (this.kolname != null)
          data['kolname'] = this.kolname;
        if (this.moinname != null)
          data['moinname'] = this.moinname;
        if (this.taf1name != null)
          data['taf1name'] = this.taf1name;
        if (this.taf2name != null)
          data['taf2name'] = this.taf2name;
        if (this.taf3name != null)
          data['taf3name'] = this.taf3name;
        if (this.taf4name != null)
          data['taf4name'] = this.taf4name;
        if (this.taf5name != null)
          data['taf5name'] = this.taf5name;
        if (this.taf6name != null)
          data['taf6name'] = this.taf6name;
        if (this.bed != null)
          data['bed'] = this.bed;
        if (this.bes != null)
          data['bes'] = this.bes;
        data['active'] = this.active ? 1 : 0;
        data['autoins'] = this.autoins ? 1 : 0;
        data['reg'] = this.reg ? 1 : 0;
        data['token'] = this.token;
        return data;
    }
}

class DataModel{
  Status status;
  List<Mainclass> rows;
  String msg;

  DataModel({@required this.status, this.rows, this.msg});
}

class ExcelRow{
  bool check;
  List<dynamic> cells;

  ExcelRow({@required this.check, @required this.cells});
}