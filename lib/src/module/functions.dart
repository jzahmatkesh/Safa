import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:file_picker/file_picker.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/Login.dart';
import 'class.dart';


// google persian fonts   Cairo, Amiri, changa, Almarai, el messiri, markazi, lalezar, mada, lateef, scheherazade, harmattan, rakkas, mirza
final appThemeData = {
  AppTheme.Light : ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      primaryColor: Colors.lightBlue[900],
      accentColor: Colors.blueAccent,
      scaffoldBackgroundColor: Colors.white,
      bottomAppBarColor: Colors.grey[100],
      textTheme: TextTheme(
        headline1: GoogleFonts.mirza(color: Colors.grey[600], fontSize: 14.0),
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
        headline1: GoogleFonts.mirza(color: Colors.grey[600], fontSize: 14.0),
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
      return json.decode(utf8.decode(res.bodyBytes));
}

Future<List<Mainclass>> fetchListFromServer({String api, dynamic body, Map<String,String> header}) async{
    if (header == null)
      header = {'Content-Type': 'application/json'};
    var res = await http.post("http://${serverIP()}:8080/Finance/api/$api", headers: header, body: body);
    if(res.statusCode == 200){
      return (json.decode(utf8.decode(res.bodyBytes)) as List).map((e) => Mainclass.fromJson(json.decode(e))).toList();
    }
    throw Exception(json.decode(utf8.decode(res.bodyBytes)));
}

Future<Map<String, dynamic>> putToServer({String api, dynamic body, Map<String,String> header}) async{
  if (header == null)
    header = {'Content-Type': 'application/json'};
  var res = await http.put("http://${serverIP()}:8080/Finance/api/$api", headers: header, body: body);
  if(res.statusCode == 200)
    return {"msg": "Success", "body": json.decode(utf8.decode(res.bodyBytes))};
  else
    return json.decode(utf8.decode(res.bodyBytes));
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
    return res.stream.toBytes().then((value) => json.decode(utf8.decode((value))));
}

generateMd5(String data) {
  var content = new Utf8Encoder().convert(data);
  var md5 = crypto.md5;
  var digest = md5.convert(content);
  return hex.encode(digest.bytes);
}

double screenWidth(BuildContext context)=> MediaQuery.of(context).size.width;
double screenHeight(BuildContext context)=> MediaQuery.of(context).size.height;

void myAlert({@required BuildContext context,@required String title, @required dynamic message, Msg msgType = Msg.Error, Icon icon, int second = 5}){
  Color color;
  if (msgType == Msg.Error) color = Colors.red;
  if (msgType == Msg.Info) color = Colors.blue;
  if (msgType == Msg.Success) color = Colors.green;
  if (msgType == Msg.Warning) color = Colors.deepOrange;
  showFlash(
    context: context,
    duration: Duration(seconds: second),
    builder: (_, controller) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Flash(
          backgroundColor: color ?? Colors.red,
          controller: controller,
          position: FlashPosition.bottom,
          style: FlashStyle.grounded,
          child: FlashBar(
            icon: Icon(
              icon ?? Icons.face,
              size: 36.0,
              color: Colors.white,
            ),
            title: Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            message: message is String
              ? Text(message.replaceAll("Exception:", ""), style: TextStyle(color: Colors.white),)
              : message is Widget
                ? message
                : Text('$message'),
          ),
        ),
      );
    }
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

void analyzeError(BuildContext context, String note, {bool msg = true}){
  if (note.indexOf("Token Not Valid") >= 0)
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Login()),
      (route) => false
    );
  else if (msg){
    myAlert(context: context, title: 'خطا', message: '${compileErrorMessage('$note')}');
  }
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
bool isDark(BuildContext context)=> Theme.of(context).brightness == Brightness.dark;
Color scaffoldcolor(BuildContext context)=> Theme.of(context).scaffoldBackgroundColor;
Color bottomAppbarColor(BuildContext context)=> Theme.of(context).bottomAppBarColor;
Color appbarColor(BuildContext context)=> Theme.of(context).bottomAppBarColor;
Color backgroundColor(BuildContext context)=> Theme.of(context).backgroundColor;
Color accentcolor(BuildContext context)=> Theme.of(context).accentColor;
Color textColor(BuildContext context)=> Theme.of(context).buttonColor;
Color headlineColor(BuildContext context)=> Theme.of(context).textTheme.headline1.color;
TextStyle gridFieldStyle()=> TextStyle(fontSize: 15,fontFamily: 'lalezar');

Color editRowColor() => Colors.deepOrange.withOpacity(0.15);
Color rowColor(BuildContext context) => appbarColor(context).withOpacity(0.65);

focusChange(BuildContext context, FocusNode nextFocus) {
  // if (currentFocus != null)
  //   currentFocus.unfocus();
  // else
  //   FocusScope.of(context).unfocus();
  FocusScope.of(context).requestFocus(nextFocus);  
}

showFormAsDialog({@required BuildContext context, @required Widget form, Function done, bool modal = false}){
  showDialog(
    context: context,
    barrierDismissible: !modal,
    builder: (context){
      return AlertDialog(
        content: form
      ); 
    }
  ).then((data){
    if (done != null)
      done(data);
  });
}

Future<bool> sendSms(BuildContext context, String number, String msg) async{
  try{
    var res = await postToServer(api: "User/SMS", body: jsonEncode({"family": msg, "mobile": number}));
    if (res['msg'] == "Success" && res['body']['result'] == "success")
      return true;
    else if (res['msg'] == "Success" && res['body']['result'] == "error"){
      if (res['body']['messageids'] == 5) myAlert(context: context, title: 'خطا', message: "امکان گرفتن پیام وجود ندارد");
      if (res['body']['messageids'] == 7) myAlert(context: context, title: 'خطا', message: "امکان دسترسی به خط مورد نظر وجود ندارد");
      if (res['body']['messageids'] == 8) myAlert(context: context, title: 'خطا', message: "شماره همراه وارد شده صحیح نمی باشد");
      if (res['body']['messageids'] == 10) myAlert(context: context, title: 'خطا', message: "خطایی در سیستم رخ داده است . دوباره سعی کنید");
      if (res['body']['messageids'] == 11) myAlert(context: context, title: 'خطا', message: "نامعتبر می باشد . IP");
      if (res['body']['messageids'] == 20) myAlert(context: context, title: 'خطا', message: "شماره مخاطب جهت دریافت پیامک فیلتر شده می باشد");
      if (res['body']['messageids'] == 21) myAlert(context: context, title: 'خطا', message: "ارتباط با سرویس دهنده قطع می باشد");
    }
    return false;
    // print('sms send: $msg');
    // return await Future.delayed(Duration(seconds: 5)).then((value) => true);



    // var res = await http.post("http://parsasms.com/tools/urlservice/send/?username=rayan-paya&password=Arman&from=3000500222&to=$number&message=$msg", headers: {'Content-Type': 'application/json'});
    // if (res.statusCode == 200)
    //   return true;
    // return false;

    // var res = await http.post("https://RestfulSms.com/api/Token", headers: {'Content-Type': 'application/json'}, body: jsonEncode({"UserApiKey":"b60b459c21eb9446a001459c", "SecretKey":"P@ssw0rds**!@"}));
    // if (res.statusCode == 201){
    //   var _tokenkey = json.decode(utf8.decode(res.bodyBytes))['TokenKey'];
      // var res2 = await http.post("https://RestfulSms.com/api/MessageSend", 
      // headers: <String, String>{
      //   "content-type":  "application/json", 
      //   "x-sms-ir-secure-token": "Bearer: $_tokenkey",
      // }, 
      //   body: jsonEncode({
      //     "Messages":["$msg"],
      //     "MobileNumbers": ["$number"],
      //     "LineNumber": "30002577625785",
      //     "SendDateTime": "",
      //     "CanContinueInCaseOfError": "false",
      //   })
      // );  

    // }
  }
  catch(e){
    print('$e');
    analyzeError(context, '$e');
    return false;
  }
}

Future<bool> sendFile(BuildContext context, String token, Uint8List file, String filename, String type, int id, {int cmpid=0, int id1=0, int id2=0, int id3=0, int id4=0, int id5 = 0}) async {
  try{
    var url = Uri.parse("http://${serverIP()}:8080/Finance/GetFile.jsp?token=$token&type=$type&id=$id&cmpid=$cmpid&id1=$id1&id2=$id2&id3=$id3&id4=$id4&id5=$id5");
    var request = new http.MultipartRequest("POST", url);
    List<int> _selectedFile = file;

    request.files.add(http.MultipartFile.fromBytes('file', _selectedFile, filename: "$filename"));

    http.StreamedResponse _res = await request.send();
    if (_res.statusCode == 200){
      myAlert(context: context, title: 'موفقیت آمیز', message: 'ارسال فایل به سرور با موفقیت انجام گردید', msgType: Msg.Success);
      return true;
    }
    else if (_res.statusCode == 501)
      myAlert(context: context, title: 'خطا', message: 'حجم فایل بیشتر از ۱۰ مگابایت نمی تواند باشد');
    else if (_res.statusCode == 502)
      myAlert(context: context, title: 'خطا', message: 'مجاز به آپلود فایل نمی باشید');
    else
      myAlert(context: context, title: 'خطا', message: 'خطا در پردازش فایل ارسالی. لطفا پس از بروز رسانی مجددا سعی نمایید');
    return false;
  }
  catch(e){
    return false;
  }
}

void prcUploadImg({BuildContext context, String token, int id, String tag, VoidCallback ondone, int cmpid=0, int id1=0, int id2=0, int id3=0, int id4=0, int id5 = 0}) async{
  FilePickerResult result = await FilePicker.platform.pickFiles();
  if(result != null) {
    try{
      showWaiting(context);
      PlatformFile file = result.files.first;
      bool str = await sendFile(context, token, file.bytes, file.name.split('/').last, "$tag", id, cmpid: cmpid, id1: id1, id2: id2, id3: id3, id4: id4, id5: id5);
      if (str && ondone != null)
        ondone();
    }
    finally{
      hideWaiting(context);
    }
  }
}


launchUrl(String url) async{
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }                      
}