import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

import '../views/Login.dart';
import 'class.dart';

final appThemeData = {
  AppTheme.Light : ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      primaryColor: Colors.blue,
      accentColor: Colors.blueAccent,
      scaffoldBackgroundColor: Colors.white,
      bottomAppBarColor: Colors.grey[100],
      textTheme: TextTheme(
        headline1: TextStyle(color: Colors.grey[600], fontFamily: 'Lalezar', fontSize: 14.0),
      ),
      fontFamily: 'nazanin',
  ),
  AppTheme.Dark : ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blueGrey,
      primaryColor: Color(0xFF294c60),
      accentColor: Colors.lightBlueAccent,
      scaffoldBackgroundColor: Colors.grey[800],
      bottomAppBarColor: Colors.grey[700],
      textTheme: TextTheme(
        headline1: TextStyle(color: Colors.white70, fontFamily: 'Lalezar', fontSize: 14.0)
      ),
      fontFamily: 'nazanin',
  ),
};


String serverIP(){
  return "127.0.0.1";
}

Future<Map<String, dynamic>> postToServer({String api, dynamic body, Map<String,String> header}) async{
  if (header == null)
    header = {'Content-Type': 'application/json'};
  var res = await http.post("http://${serverIP()}:8080/Finance/api/$api", headers: header, body: body);
  if(res.statusCode == 200)
    return {"msg": "Success", "body": json.decode(utf8.decode(res.bodyBytes))};
  else
    return {"msg": utf8.decode(res.bodyBytes)};
}

Future<Map<String, dynamic>> putToServer({String api, dynamic body, Map<String,String> header}) async{
  if (header == null)
    header = {'Content-Type': 'application/json'};
  var res = await http.put("http://${serverIP()}:8080/Finance/api/$api", headers: header, body: body);
  if(res.statusCode == 200)
    return {"msg": "Success", "body": json.decode(utf8.decode(res.bodyBytes))};
  else
    return {"msg": utf8.decode(res.bodyBytes)};
}

Future<Map<String, dynamic>> delToServer({String api, dynamic body, Map<String,String> header}) async{
  if (header == null)
    header = {'Content-Type': 'application/json'};

  http.Request rq = http.Request('DELETE', Uri.parse('http://${serverIP()}:8080/Finance/api/$api'))
    ..headers.addAll(header)
    ..body = body;

  http.StreamedResponse res = await http.Client().send(rq);
  if(res.statusCode == 200)
    return res.stream.toBytes().then((value) => {"msg": "Success", "body": json.decode(utf8.decode((value)))});
  else
    return res.stream.toBytes().then((value) => {"msg": utf8.decode((value))});
}

generateMd5(String data) {
  var content = new Utf8Encoder().convert(data);
  var md5 = crypto.md5;
  var digest = md5.convert(content);
  return hex.encode(digest.bytes);
}

double screenWidth(BuildContext context)=> MediaQuery.of(context).size.width;
double screenHeight(BuildContext context)=> MediaQuery.of(context).size.height;

void myAlert({@required String title, @required dynamic message, Color color = Colors.deepOrange, Icon icon, int second = 5}){
  Get.snackbar(
    title, 
    message,
    titleText: Directionality(textDirection: TextDirection.rtl, child: Text('$title', style: TextStyle(color: color == Colors.transparent ? Colors.black : Colors.white))),
    messageText: Directionality(textDirection: TextDirection.rtl, child: Text('$message', style: TextStyle(color: color == Colors.transparent ? Colors.black : Colors.white))),
    padding: EdgeInsets.all(12),
    margin: EdgeInsets.all(12),
    backgroundColor: color,
    snackPosition: SnackPosition.TOP
  );
}

String compileErrorMessage(String err){
  if (err.toLowerCase().contains("http status 404") || err.toLowerCase().contains("xmlhttprequest error"))
    return 'دسترسی به وب سرور امکان پذیر نمی باشد. لطفا از اتصال به اینترنت اطمینان حاصل نمایید';
  else if (err.toLowerCase().contains("http status 404") || err.toLowerCase().contains("xmlhttprequest error"))
    return 'خطای ۴۰۵ در سرور. لطفا پس از بروز رسانی مجددا سعی نمایید';
  else if (err.toLowerCase().contains("http status 500") || err.toLowerCase().contains("xmlhttprequest error"))
    return 'خطا در پردازش اطلاعات در وب سرور امکان پذیر نمی باشد. لطفا از اتصال به اینترنت اطمینان حاصل نمایید';
  return err.toLowerCase().replaceAll('exception:', '');
}

void analyzeError(String note, {bool msg = true}){
  if (note.indexOf("Token Not Valid") >= 0)
    Get.to(Login());
  else if (msg)
    myAlert(title: 'خطا', message: compileErrorMessage('$note'), color: Colors.red[800]);
}

void confirmMessage(BuildContext context, String title, String msg, {Function yesclick, Function noClick, AlertType type = AlertType.warning}){
  Alert(
    context: context,
    type: type,    
    title: title,
    desc: msg,
    buttons: [
      DialogButton(
        color: Colors.deepOrangeAccent,
        child: Text(
          "خیر",
          style: alertButtonStyle(),
        ),
        onPressed: () => noClick==null ? Navigator.pop(context) : noClick(),
        width: 55,
      ),
      DialogButton(
        child: Text(
          "بلی",
          style: alertButtonStyle(),
        ),
        onPressed: () => yesclick==null ? Navigator.pop(context) : yesclick(),
        width: 55,
      ),
    ],
  ).show();
}

void showWaiting(BuildContext context){
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context){
      return Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.blueGrey.withOpacity(0.1),
        child: Material(
          color: Colors.blueGrey.withOpacity(0.1),
          child: Center(
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CupertinoActivityIndicator(radius: 20.0,),
                    SizedBox(height: 10.0,),
                    Text('...لطفا کمی شکیبا باشید', style: gridFieldStyle(),)
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  );
}

void hideWaiting(BuildContext context){
  Navigator.pop(context);
}

String moneySeprator(double newValue){
    List<String> chars = newValue.toString().split('');
    String newString = '';
    int j = 0;
    for (int i = chars.length-1; i >= 0; i--) {
      if (j % 3 == 0 && j > 0){ 
        newString = ','+newString;
      }
      newString = chars[i]+newString;
      j++;
    }
    return newString;
}

TextStyle alertButtonStyle()=> TextStyle(fontSize: 15,fontFamily: 'lalezar',color: Colors.white);
Color scaffoldcolor(BuildContext context)=> Theme.of(context).scaffoldBackgroundColor;
Color appbarColor(BuildContext context)=> Theme.of(context).bottomAppBarColor;
Color backgroundColor(BuildContext context)=> Theme.of(context).backgroundColor;
Color accentcolor(BuildContext context)=> Theme.of(context).accentColor;
Color textColor(BuildContext context)=> Theme.of(context).buttonColor;
TextStyle gridFieldStyle()=> TextStyle(fontSize: 15,fontFamily: 'lalezar');

Color editRowColor() => Colors.deepOrange.withOpacity(0.15);

focusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
  if (currentFocus != null)
    currentFocus.unfocus();
  else
    FocusScope.of(context).unfocus();
  FocusScope.of(context).requestFocus(nextFocus);  
}

showFormAsDialog({@required Widget form, Function done, bool modal = false}){
  Get.defaultDialog(title: '', content: form, barrierDismissible: !modal, radius: 10).then((value){
    if (done != null)
      done(value);
  });
  // showDialog(
  //   context: context,
  //   barrierDismissible: !modal,
  //   builder: (context){
  //     return AlertDialog(
  //       content: form
  //     ); 
  //   }
  // ).then((data){
  //   if (done != null)
  //     done(data);
  // });
}





