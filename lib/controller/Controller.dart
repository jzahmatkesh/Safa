import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../module/Repository.dart';
import '../module/class.dart';
import '../module/functions.dart';


var _repo = Repository();

class UserState extends GetxController{
  var user = User().obs;
  User get userInfo => user.value;

  var dashMenuItem = 1.obs;
  var sanad = Mainclass().obs;
  var taflevel = List<Mainclass>().obs;
  var artykl = DataModel(status: Status.Loading).obs;

  void setDashMenuItem(int i) async{
    dashMenuItem.value = i;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("menu", i);
  }

  void showSanad(Mainclass snd) async{
    taflevel.value = await _repo.loadData('Coding/AccLevel');
    dashMenuItem.value = 11;
    sanad.value = snd;
    artykl.value = DataModel(status: Status.Loaded, rows: await _repo.loadData('Asnad/Artykl', body: {'id': snd.id}));
  }

  @override
  void onInit() {
    super.onInit();
    verify();
  }

  void authenticate(String mobile, String pass) async{
    try{
      user.value = await _repo.authenticate(mobile, pass);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", user.value.token);
    }
    catch(e){
      analyzeError('$e');
    }
  }

  void verify() async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String theme = prefs.getString("theme") ?? "";
      if (theme.isNotEmpty)
        if (theme.contains("dark"))
          Get.changeTheme(appThemeData[AppTheme.Dark]); 
        else 
          Get.changeTheme(appThemeData[AppTheme.Light]);

      if (prefs.getInt('menu') != null && prefs.getInt('menu') > 0)
        dashMenuItem.value = prefs.getInt('menu');

      String token = prefs.getString("token") ?? "";
print("token: $token");
      if (token.isNotEmpty)
        user.value = await _repo.verify(token);
    }
    catch(e){
      analyzeError('$e', msg: false);
    }
  }

  void signOut() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    user.value = User();
  }

  Future<int> saveSanad(int id, String date, String note) async{
    try{
      var _res = await _repo.saveData('Asnad/Sanad', {'old': sanad.value.id, 'id': id, 'date': date, 'note': note});
      myAlert(title: 'موفقیت آمیز', message: 'ذخیره سند موفقیت آمیز بود', color: Colors.green);
      sanad.value = Mainclass(old: id, id: id, date: date, note: note);
      return _res.id;
    }
    catch(e){
      analyzeError('$e');
      return 0;
    }
  }
  
  Future<bool> saveArtykl(Mainclass art) async{
    try{
      art.token = userInfo.token;
      var _res = await _repo.saveData('Asnad/Artykl', art.toJson());
      myAlert(title: 'موفقیت آمیز', message: 'ذخیره سند موفقیت آمیز بود', color: Colors.green);
      bool nvld = true;
      artykl.value.rows.forEach((element) {
        if (element.id == art.id){
          nvld = false;
          element.kolid =_res.kolid;
          element.kolname =_res.kolname;
          element.moinid =_res.moinid;
          element.moinname =_res.moinname;
          element.taf1 =_res.taf1;
          element.taf1name =_res.taf1name;
          element.taf2 =_res.taf2;
          element.taf2name =_res.taf2name;
          element.taf3 =_res.taf3;
          element.taf3name =_res.taf3name;
          element.taf4 =_res.taf4;
          element.taf4name =_res.taf4name;
          element.taf5 =_res.taf5;
          element.taf5name =_res.taf5name;
          element.taf6 =_res.taf6;
          element.taf6name =_res.taf6name;
          element.note =_res.note;
          element.bed =_res.bed;
          element.bes =_res.bes;
          element.edit = false;
        }
      });
      if (nvld)
        artykl.value.rows.insert(0, _res);
      artykl.value = DataModel(status: Status.Loaded, rows: artykl.value.rows);
      return true;
    }
    catch(e){
      analyzeError('$e');
      return false;
    }
  }

  setArtyklEdit(int id){
    artykl.value.rows.forEach((element) {
      element.edit = element.id == id;
    });
    artykl.value = DataModel(status: Status.Loaded, rows: artykl.value.rows);
  }

  delArtykl(BuildContext context, int id){
    confirmMessage(context, 'تایید حذف', 'آیا اطمینان به حذف آرتیکل دارید؟', yesclick: () async{
      try{
        await _repo.delData('Asnad/Artykl', {'sanadid': sanad.value.id, 'id': id});
        artykl.value.rows.removeWhere((element) => element.id==id);
        artykl.value = DataModel(status: Status.Loaded, rows: artykl.value.rows);
        Navigator.pop(context);
      }
      catch(e){
        analyzeError('$e');
        Navigator.pop(context);
      }
    });
  }

  double mandeBed(){
    if (artykl.value.status == Status.Loaded){
      return artykl.value.rows.reduce((value, element) => Mainclass(bed: value.bed+element.bed)).bed;
    }
    return 0;
  }
  double mandeBes(){
    if (artykl.value.status == Status.Loaded){
      return artykl.value.rows.reduce((value, element) => Mainclass(bes: value.bes+element.bes)).bes;
    }
    return 0;
  }
}

class CodingState extends GetxController{
  var taflevel = List<Mainclass>().obs;
  var group = DataModel(status: Status.Loading).obs;
  var kol = DataModel(status: Status.Loading).obs;
  var moin = DataModel(status: Status.Loading).obs;
  var tafsili = DataModel(status: Status.Loading).obs;

  var f2List = DataModel(status: Status.Loading).obs;

  List<Mainclass> get groupRow => group.value.rows;
  List<Mainclass> get kolRow => kol.value.rows;
  List<Mainclass> get moinRow => moin.value.rows;
  List<Mainclass> get tafsiliRow => tafsili.value.rows;
  List<Mainclass> get f2Row => f2List.value.rows;
  var menuitem = 1.obs;


  void setMenu(int i)=> menuitem.value = i;

  void fetchGroup({bool loadkol = false}) async{
    setMenu(1);
    taflevel.value = await _repo.loadData('Coding/AccLevel');
    group.value = DataModel(status: Status.Loading);
    try{
      group.value = DataModel(status: Status.Loaded, rows: await _repo.loadData('Coding/Group'));
      groupRow[0].selected = true;
      group.value = DataModel(status: Status.Loaded, rows: group.value.rows);
      if (loadkol)
        fetchKol(groupRow[0].id, loadmoin: true);
    }
    catch(e){
      analyzeError('$e');
      group.value = DataModel(status: Status.Error, msg: 'خطا در دریافت اطلاعات از سرور');
    }
  }

  void selectgroup(int id){
    group.value.rows.forEach((element) {
      element.selected = element.id == id;
      if (element.selected)
        fetchKol(element.id);
    });
    group.value = DataModel(status: Status.Loaded, rows: group.value.rows);

  }

  void setgroupEditMode(int id){
    groupRow.forEach((element) {
      element.edit = element.id == id;
    });
    group.value = DataModel(status: Status.Loaded, rows: groupRow);
  }

  Future<bool> saveGroup(int id, String name) async{
    try{
      Mainclass res = await _repo.saveData('Coding/Group', {'id': id, 'name': name});
      groupRow.forEach((element) {
        if (element.id == id){
          element.id = res.id;
          element.name = name;
          element.edit = false;
        }
      });
      if (id == 0)
        groupRow.insert(0, Mainclass(id: res.id, name: name));
      group.value = DataModel(status: Status.Loaded, rows: groupRow);
      return true;
    }
    catch(e){
      analyzeError('$e');
      return false;
    }
  }

  void delGroup(BuildContext context, int id, String name){
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف $name می باشید؟', yesclick: () async{
      try{
        await _repo.delData('Coding/Group', {'id': id, 'name': name});
        groupRow.removeWhere((element) => element.id == id);
        group.value = DataModel(status: Status.Loaded, rows: groupRow);
        Navigator.of(context).pop();
        myAlert(title: 'حذف موفقیت آمیز', message: 'حذف $name با موفقیت انجام گردید', color: Colors.green);
      }
      catch(e){
        Navigator.of(context).pop();
        analyzeError('$e');
      }
    });
  }

  void fetchKol(int grp, {bool loadmoin = false}) async{
    kol.value = DataModel(status: Status.Loading);
    if (grp == 0)
      fetchGroup(loadkol: true);
    else
      try{
        kol.value = DataModel(status: Status.Loaded, rows: await _repo.loadData('Coding/Kol', body: {'grpid': grp}));
        if (loadmoin && kol.value.rows.length > 0){
          kol.value.rows[0].selected = true;
          fetchMoin(kol.value.rows[0].id);
        }
      }
      catch(e){
        analyzeError('$e');
        kol.value = DataModel(status: Status.Error, msg: 'خطا در دریافت اطلاعات از سرور');
      }
  }

  void selectkol(int id){
    if (id == 0)
      fetchKol(0, loadmoin: true);
    else{
      kol.value.rows.forEach((element) {
        element.selected = element.id == id;
        if (element.selected)
          fetchMoin(element.id);
      });
      kol.value = DataModel(status: Status.Loaded, rows: kol.value.rows);
    }
  }

  void setkolEditMode(int id){
    kolRow.forEach((element) {
      element.edit = element.id == id;
    });
    kol.value = DataModel(status: Status.Loaded, rows: kolRow);
  }

  void searchInKol(String val){
    kolRow.forEach((element) {
      element.inSearch = element.name.contains(val) || element.id.toString().contains(val);
    });
    kol.value = DataModel(status: Status.Loaded, rows: kolRow);
  }

  Future<bool> saveKol(Mainclass kl) async{
    try{
      final UserState _user = Get.find();
      kl.token = _user.userInfo.token;
      await _repo.saveData('Coding/Kol', kl.toJson());
      kolRow.forEach((element) {
        if (element.id == kl.old){
          element.old = kl.id;
          element.id = kl.id;
          element.name = kl.name;
          element.edit = false;
        }
      });
      if (kl.old == 0)
        kolRow.insert(0, Mainclass(old: kl.id, id: kl.id, name: kl.name));
      kol.value = DataModel(status: Status.Loaded, rows: kolRow);
      return true;
    }
    catch(e){
      analyzeError('$e');
      return false;
    }
  }

  void delKol(BuildContext context, int id, String name){
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف $name می باشید؟', yesclick: () async{
      try{
        await _repo.delData('Coding/Kol', {'id': id, 'name': name});
        kolRow.removeWhere((element) => element.id == id);
        kol.value = DataModel(status: Status.Loaded, rows: kolRow);
        Navigator.of(context).pop();
        myAlert(title: 'حذف موفقیت آمیز', message: 'حذف $name با موفقیت انجام گردید', color: Colors.green);
      }
      catch(e){
        Navigator.of(context).pop();
        analyzeError('$e');
      }
    });
  }

  void fetchMoin(int kol) async{
    moin.value = DataModel(status: Status.Loading);
    try{
      moin.value = DataModel(status: Status.Loaded, rows: await _repo.loadData('Coding/Moin', body: {'kolid': kol}));
    }
    catch(e){
      analyzeError('$e');
      moin.value = DataModel(status: Status.Error, msg: 'خطا در دریافت اطلاعات از سرور');
    }
  }

  void setmoinEditMode(int id){
    moinRow.forEach((element) {
      element.edit = element.id == id;
    });
    moin.value = DataModel(status: Status.Loaded, rows: moinRow);
  }

  void searchInMoin(String val){
    moinRow.forEach((element) {
      element.inSearch = element.name.contains(val) || element.id.toString().contains(val);
    });
    moin.value = DataModel(status: Status.Loaded, rows: moinRow);
  }

  Future<bool> saveMoin(Mainclass mn) async{
    try{
      final UserState _user = Get.find();
      mn.token = _user.userInfo.token;
      await _repo.saveData('Coding/Moin', mn.toJson());
      moinRow.forEach((element) {
        if (element.id == mn.old){
          element.old = mn.id;
          element.id = mn.id;
          element.name = mn.name;
          element.edit = false;
        }
      });
      if (mn.old == 0)
        moinRow.insert(0, Mainclass(kolid: mn.kolid, old: mn.id, id: mn.id, name: mn.name));
      moin.value = DataModel(status: Status.Loaded, rows: moinRow);
      return true;
    }
    catch(e){
      analyzeError('$e');
      return false;
    }
  }

  void delMoin(BuildContext context, int kolid, int id, String name){
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف $name می باشید؟', yesclick: () async{
      try{
        await _repo.delData('Coding/Moin', {'kolid': kolid, 'id': id, 'name': name});
        moinRow.removeWhere((element) => element.id == id);
        moin.value = DataModel(status: Status.Loaded, rows: moinRow);
        Navigator.of(context).pop();
        myAlert(title: 'حذف موفقیت آمیز', message: 'حذف $name با موفقیت انجام گردید', color: Colors.green);
      }
      catch(e){
        Navigator.of(context).pop();
        analyzeError('$e');
      }
    });
  }

  void fetchTafsili() async{
    tafsili.value = DataModel(status: Status.Loading);
    try{
      tafsili.value = DataModel(status: Status.Loaded, rows: await _repo.loadData('Coding/Tafsili'));
    }
    catch(e){
      analyzeError('$e');
      tafsili.value = DataModel(status: Status.Error, msg: 'خطا در دریافت اطلاعات از سرور');
    }
  }

  void delTafsili(BuildContext context, int id, String name){
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف $name می باشید؟', yesclick: () async{
      try{
        await _repo.delData('Coding/Tafsili', {'id': id, 'name': name});
        tafsiliRow.removeWhere((element) => element.id == id);
        tafsili.value = DataModel(status: Status.Loaded, rows: tafsiliRow);
        Navigator.of(context).pop();
        myAlert(title: 'حذف موفقیت آمیز', message: 'حذف $name با موفقیت انجام گردید', color: Colors.green);
      }
      catch(e){
        Navigator.of(context).pop();
        analyzeError('$e');
      }
    });
  }

  Future<bool> saveTafsili(Mainclass obj) async{
    try{
      final UserState _user = Get.find();
      obj.token = _user.userInfo.token;
      var _nw = await _repo.saveData('Coding/Tafsili', obj.toJson());
      tafsiliRow.forEach((element) {
        if (element.id == obj.old){
          element.old = obj.id;
          element.id = obj.id;
          element.name = obj.name;
          element.edit = false;
        }
      });
      if (obj.old == 0)
        tafsiliRow.insert(0, Mainclass(old: obj.id, id: obj.id, name: obj.name, lev1: _nw.lev1, lev2: _nw.lev2, lev3: _nw.lev3, lev4: _nw.lev4, lev5: _nw.lev5, lev6: _nw.lev6));
      tafsili.value = DataModel(status: Status.Loaded, rows: tafsiliRow);
      return true;
    }
    catch(e){
      analyzeError('$e');
      return false;
    }
  }

  void setTafsiliEditMode(int id){
    tafsiliRow.forEach((element) {
      element.edit = element.id == id;
    });
    tafsili.value = DataModel(status: Status.Loaded, rows: tafsiliRow);
  }

  void searchInTafsili(String val){
    tafsiliRow.forEach((element) {
      element.inSearch = element.name.contains(val) || element.id.toString().contains(val);
    });
    tafsili.value = DataModel(status: Status.Loaded, rows: tafsiliRow);
  }

  void setTaftoLevel(int id, int lev) async{
    try{
      final UserState _user = Get.find();
      bool _res = await _repo.setTafToLev({'token': _user.userInfo.token, 'id': id, 'lev': lev});
      tafsiliRow.forEach((element) {
        if (element.id == id){
          if (lev == 1)
            element.lev1 = _res;
          if (lev == 2)
            element.lev2 = _res;
          if (lev == 3)
            element.lev3 = _res;
          if (lev == 4)
            element.lev4 = _res;
          if (lev == 5)
            element.lev5 = _res;
          if (lev == 6)
            element.lev6 = _res;
        }
      });
      tafsili.value = DataModel(status: Status.Loaded, rows: tafsiliRow);
    }
    catch(e){
      analyzeError('$e');
    }
  }

  void fetchF2(String f2key, String val, int kol) async{
    f2List.value = DataModel(status: Status.Loading);
    try{
      if (val.isEmpty)
        f2List.value = DataModel(status: Status.Loading);
      else
        if (f2key.contains('Kol'))
          f2List.value = DataModel(status: Status.Loaded, rows: await _repo.loadData('Coding/Kol', body: {'grpid': -1, 'name': val}));
        else if (f2key.contains('Moin'))
          f2List.value = DataModel(status: Status.Loaded, rows: await _repo.loadData('Coding/Moin', body: {'kolid': kol, 'name': val}));
        else if (f2key.contains('Tafsili'))
          f2List.value = DataModel(status: Status.Loaded, rows: await _repo.loadData('Coding/Tafsili', body: {'name': val, 'lev': f2key.replaceAll('Tafsili', '').length>0 ? int.parse(f2key.replaceAll('Tafsili', '')) : 0}));
    }
    catch(e){
      analyzeError('$e');
      f2List.value = DataModel(status: Status.Error, msg: 'خطا در دریافت اطلاعات از سرور');
    }
  }
  void clearF2(){
    f2List.value = DataModel(status: Status.Loading, rows: []);
  }
}

class AccLevelState extends GetxController{
  var levels = DataModel(status: Status.Loading).obs;
  List<Mainclass> get levelsRow => levels.value.rows;
   
  @override
  void onInit() {
    super.onInit();
    fetchData();
  }
 

  fetchData() async{
    try{
      levels.value = DataModel(status: Status.Loading);
      levels.value = DataModel(status: Status.Loaded, rows: await _repo.loadData('Coding/AccLevel'));
    }
    catch(e){
      analyzeError('$e');
      levels.value = DataModel(status: Status.Error, msg: '$e');
    }
  }

  saveDta(int id, String name, int act, int autoins) async{
    try{
      Mainclass _data = await _repo.saveData('Coding/AccLevel', {'id': id, 'name': name, 'active': act, 'autoins': autoins});
      levelsRow.forEach((element) {
        if (element.id == _data.id){
          element.name = _data.name;
          element.active = _data.active;
          element.autoins = _data.autoins;
        } 
        // else if (element.id > _data.id && !_data.active)
        //   element.active = false;
        // else if (element.id < _data.id && _data.active)
        //   element.active = true;
      });
      levels.value = DataModel(status: Status.Loaded, rows: levelsRow);
      myAlert(title: 'ذخیره', message: 'ذخیره اطلاعات با موفقیت انجام گرددید', color: Colors.green);
    }
    catch(e){
      analyzeError('$e');
    }
  }
}

class SanadState extends GetxController{
  final UserState _user = Get.find();
  var listSanad = DataModel(status: Status.Loading).obs;

  List<Mainclass> get listSanadRow => listSanad.value.rows;



  @override
  void onInit() async{
    super.onInit();
  }


  void fetchSanads() async{
    try{
      listSanad.value = DataModel(status: Status.Loading);
      listSanad.value = DataModel(status: Status.Loaded, rows: await _repo.loadData('Asnad'));
    }
    catch(e){
      analyzeError('$e');
      listSanad.value = DataModel(status: Status.Error, msg: '$e');
    }
  }

  void regSanad(int id) async{
    try{
      var _rec = await _repo.saveData('Asnad/Reg', {'token': _user.userInfo.token, 'id': id});
      listSanadRow.forEach((element) {
        if (element.id == id)
          element.reg = _rec.reg;
      });
      listSanad.value = DataModel(status: Status.Loaded, rows: listSanadRow);
    }
    catch(e){
      analyzeError('$e');
    }
  }

  void delSanad(BuildContext context, int id){
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف سند شماره $id می باشید؟', yesclick: () async{
      try{
        await _repo.delData('Asnad', {'token': _user.userInfo.token, 'id': id});
        listSanadRow.removeWhere((element) => element.id==id);
        listSanad.value = DataModel(status: Status.Loaded, rows: listSanadRow);
      }
      catch(e){
        analyzeError('$e');
      }
    });
  }
}



