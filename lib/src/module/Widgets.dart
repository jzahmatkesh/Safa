import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'class.dart';
import 'functions.dart';

enum Btn{
  Add,Save,Exit,Reload,Del,Other,Edit,Loading
}
enum Sort{
  Asc,Desc
}

class Header extends StatelessWidget {
  const Header({Key key, @required this.title, this.rightBtn, this.leftBtn, this.color}) : super(key: key);

  final String title;
  final Widget rightBtn;
  final IButton leftBtn;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? appbarColor(context),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            children: [
              rightBtn != null
                ? rightBtn
                : Container(width: 0),
              Expanded(child: Text('$title', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Nazanin', fontSize: 22, fontWeight: FontWeight.bold),)),
              leftBtn != null
                ? leftBtn
                : Container(width: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class IButton extends StatelessWidget {
  const IButton({Key key, this.type, this.hint = "", this.icon, this.onPressed, this.size=20}) : super(key: key);

  
  final Btn type;
  final String hint;
  final Icon icon;
  final VoidCallback onPressed;
  final double size;


  @override
  Widget build(BuildContext context) {
    String _hnt = hint.isNotEmpty
      ? this.hint
      : type == Btn.Add
        ? 'جدید'
        : type == Btn.Del
        ? 'حذف'
        : type == Btn.Exit
          ? 'بازگشت'
          : type == Btn.Reload
            ? 'باگذاری مجدد'
            : type == Btn.Save
              ? 'ذخیره'
              : type == Btn.Edit
                ? 'ویرایش'
                : '';

    Icon _icon = icon != null
      ? Icon(this.icon.icon, size: this.size)
      : type == Btn.Add
        ? Icon(CupertinoIcons.plus_app, size: this.size)
        : type == Btn.Del
        ? Icon(CupertinoIcons.trash, size: this.size, color: Colors.grey[600])
        : type == Btn.Exit
          ? Icon(CupertinoIcons.arrow_up_left_square, size: this.size)
          : type == Btn.Reload
            ? Icon(CupertinoIcons.arrow_2_circlepath, size: this.size)
            : type == Btn.Save
              ? Icon(CupertinoIcons.floppy_disk, size: this.size, color: Colors.green)
              : type == Btn.Edit
                ? Icon(CupertinoIcons.pencil_ellipsis_rectangle, size: this.size, color: Colors.grey[600])
                : Icon(CupertinoIcons.question_diamond, size: this.size);

    return _hnt.isEmpty
      ? IconButton(
          icon: _icon,
          onPressed: this.onPressed
        )
      : Tooltip(
        message: _hnt,
        child: IconButton(
          icon: _icon,
          onPressed: type==Btn.Exit && this.onPressed==null 
            ? ()=>Navigator.of(context).pop()
            : this.onPressed
        ),
      );
  }
}

class OButton extends StatelessWidget {
  const OButton({Key key, this.type, this.caption, this.icon, this.onPressed, this.color}) : super(key: key);

  
  final Btn type;
  final String caption;
  final Icon icon;
  final VoidCallback onPressed;
  final Color color;


  @override
  Widget build(BuildContext context) {
    String _hnt = caption.isNotEmpty
      ? this.caption
      : type == Btn.Add
        ? 'جدید'
        : type == Btn.Del
        ? 'حذف'
        : type == Btn.Exit
          ? 'بازگشت'
          : type == Btn.Reload
            ? 'باگذاری مجدد'
            : type == Btn.Save
              ? 'ذخیره'
              : '';

    Icon _icon = icon != null
      ? this.icon
      : type == Btn.Add
        ? Icon(CupertinoIcons.plus_app)
        : type == Btn.Del
        ? Icon(CupertinoIcons.trash)
        : type == Btn.Exit
          ? Icon(CupertinoIcons.arrow_up_left_square)
          : type == Btn.Reload
            ? Icon(CupertinoIcons.arrow_2_circlepath)
            : type == Btn.Save
              ? Icon(CupertinoIcons.floppy_disk)
              : Icon(CupertinoIcons.question_diamond);

    return Card(
      color: this.color,
      child: CupertinoButton(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            type == Btn.Loading ? CupertinoActivityIndicator() : _icon,
            SizedBox(width: 10),
            Text(_hnt, style: TextStyle(fontFamily: 'nazanin', fontSize: 18, fontWeight: FontWeight.bold),),
          ],
        ),
        onPressed: type==Btn.Exit && this.onPressed==null 
          ? ()=>Navigator.of(context).pop()
          : this.onPressed,
        color: this.color,
      ),
    );
  }
}

class Menu extends StatelessWidget {
  const Menu({Key key, @required this.title, this.icon, this.selected, this.selectedColor, this.onTap, this.inCard, this.hoverColor}) : super(key: key);

  final String title;
  final Icon icon;
  final bool selected;
  final Color selectedColor;
  final VoidCallback onTap;
  final bool inCard;
  final Color hoverColor;
  

  @override
  Widget build(BuildContext context) {
    return this.inCard ?? false
        ? Card(child: widget())
        : widget(); 
  }
  Widget widget(){
    return ListTile(
      title: Text(title),
      leading: this.icon,
      selected: this.selected ?? false,
      selectedTileColor: this.selectedColor ?? Colors.transparent,
      onTap: this.onTap,
      hoverColor: this.hoverColor,
    );
  }
}

class Field extends StatelessWidget {
  const Field(this.data,{Key key, this.bold = false, this.flex = 1, this.sort, this.center = false}) : super(key: key);

  final dynamic data;
  final bool bold;
  final int flex;
  final Sort sort;
  final bool center;
  // final bool editable;
  // final String json;

  @override
  Widget build(BuildContext context) {
    return data is String
      ? this.sort == null
        ? widget()
        : this.sort == Sort.Asc
          ? Row(children: [Icon(CupertinoIcons.sort_up, size: 20), SizedBox(width: 3,), widget()],)
          : Row(children: [Icon(CupertinoIcons.sort_down, size: 20), SizedBox(width: 3,), widget()],)
      : data as Widget;
  }

  Widget widget(){
    return Text('$data', textAlign: this.center ? TextAlign.center : TextAlign.start, style: this.bold ? TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Lalezar', fontSize: 14) : null,);
  }
}

InputDecoration textDecoration(String label) {
  return InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(7.0),
      gapPadding: 4,
    ),
    fillColor: Colors.white,
    labelStyle: TextStyle(color: Colors.grey[500], fontSize: 14.0),
    labelText: label,
    counterText: ''
    // prefixIcon: icon==null ? null : Icon(icon, color: Colors.grey[500], size: 15.0,),
  );
}

class DateTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {

    //this fixes backspace bug
    // if (oldValue.text.length >= newValue.text.length) {
    //   return newValue;
    // }
    if (_addSeperators(oldValue.text, '/').length >= _addSeperators(newValue.text, '/').length) {
      return newValue;
    }

    var dateText = _addSeperators(newValue.text, '/');
    if (dateText.length > 10)
      dateText = dateText.substring(0, 10);
    return newValue.copyWith(text: dateText, selection: updateCursorPosition(dateText));
  }

  String _addSeperators(String value, String seperator) {
    value = value.replaceAll('/', '');
    var newString = '';
    for (int i = 0; i < value.length; i++) {
      newString += value[i];
      if (i == 3) {
        newString += seperator;
      }
      if (i == 5) {
        newString += seperator;
      }
    }
    return newString;
  }

  TextSelection updateCursorPosition(String text) {
    return TextSelection.fromPosition(TextPosition(offset: text.length));
  }
}

class TimeTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {

    //this fixes backspace bug
    // if (oldValue.text.length >= newValue.text.length) {
    //   return newValue;
    // }
    if (_addSeperators(oldValue.text, ':').length >= _addSeperators(newValue.text, ':').length) {
      return newValue;
    }

    var dateText = _addSeperators(newValue.text, ':');
    if (dateText.length > 5)
      dateText = dateText.substring(0, 5);
    if (dateText.length > 2 && int.parse(dateText.split(":")[0]) > 24)
      dateText = "24:${dateText.split(':')[1]}";
    if (dateText.length >= 5 && int.parse(dateText.split(":")[1]) > 24)
      dateText = "${dateText.split(':')[0]}:24";
    return newValue.copyWith(text: dateText, selection: updateCursorPosition(dateText));
  }

  String _addSeperators(String value, String seperator) {
    value = value.replaceAll(':', '');
    var newString = '';
    for (int i = 0; i < value.length; i++) {
      newString += value[i];
      if (i == 1) {
        newString += seperator;
      }
    }
    return newString;
  }

  TextSelection updateCursorPosition(String text) {
    return TextSelection.fromPosition(TextPosition(offset: text.length));
  }
}

class MoneyTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length == 0) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.extentOffset;
      // List<String> chars = newValue.text.replaceAll(',', '').split('');
      // String newString = '';
      // int j = 0;
      // for (int i = chars.length-1; i >= 0; i--) {
      //   if (j % 3 == 0 && j > 0){ 
      //     newString = ','+newString;
      //   }
      //   newString = chars[i]+newString;
      //   j++;
      // }
      String newString = moneySeprator(double.parse(newValue.text));
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndexFromTheRight,
        ),
      );
    } else {
      return newValue;
    }
  }
}

class Edit extends StatelessWidget {
  const Edit({Key key, this.value, this.onChange, this.controller, this.onSubmitted, this.autofocus = false, this.hint, this.password = false, this.focus, this.date=false, this.money=false, this.numbersonly=false, this.timeonly=false, this.readonly = false, this.onEditingComplete, this.maxlength}) : super(key: key);

  final bool autofocus;
  final String value;
  final Function onChange;
  final Function onSubmitted;
  final String hint;
  final bool password;
  final TextEditingController controller;
  final FocusNode focus;
  final bool date;
  final bool numbersonly;
  final bool timeonly;
  final bool money;
  final bool readonly;
  final VoidCallback onEditingComplete;
  final int maxlength;

  @override
  Widget build(BuildContext context) {
    if (controller != null && controller.text.isEmpty)
      controller.text = this.value ?? '';
    return TextFormField(
      readOnly: this.readonly,
      autofocus: this.autofocus,
      controller: this.controller ?? TextEditingController(text: this.value ?? ''),
      onChanged: this.onChange,
      decoration: textDecoration(this.hint),
      obscureText: this.password,
      onFieldSubmitted: this.onSubmitted,
      onEditingComplete: this.onEditingComplete,
      focusNode: this.focus,
      maxLength: this.maxlength,
      inputFormatters: date 
        ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly,DateTextFormatter()] 
        : this.numbersonly 
          ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly] 
          : this.timeonly
            ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly,TimeTextFormatter()]
            : this.money 
              ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly, MoneyTextFormatter()]
              : <TextInputFormatter>[],
    );
  }
}

class GridRow extends StatelessWidget {
  const GridRow(this.fields, {Key key, this.color, this.header = false, this.onTap, this.onDoubleTap}) : super(key: key);

  final List<Field> fields;
  final Color color;
  final bool header;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;

  @override
  Widget build(BuildContext context) {
    bool icn = fields.where((e) => !(e.data is String)).length > 0;
    return this.onTap != null
      ? Card(
        child: ListTile(
          dense: true,
          title: widget(context, icn),
          onTap: this.onTap,
        ),
        color: this.color ?? (this.header ? appbarColor(context) : Colors.transparent),
      )
      : GestureDetector(
        onDoubleTap: this.onDoubleTap,
        child: Card(
          color: this.color ?? (this.header ? appbarColor(context) : Colors.transparent),
          child: widget(context, icn)
        ),
      );
  }

  Widget widget(BuildContext context, bool icn){
    return Container(
      padding: EdgeInsets.symmetric(vertical: header ? 12 : icn ? 0 : 12, horizontal: 8),
      child: Row(
        children: [
          ...fields.map((e){
            if (e.data is String)
              return Expanded(flex: e.flex, child: e);
            else if (e.data is Edit) // || e.data is F2Edit
              return Expanded(flex: e.flex, child: Container(margin: EdgeInsets.symmetric(vertical: 5, horizontal: 3), child: e.data));
            else 
              return e.data;
          })
        ],
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   bool icn = fields.where((e) => !(e.data is String)).length > 0;
  //   return this.onTap != null
  //     ? ListTile(
  //       title: widget(context, icn),
  //       onTap: this.onTap,
  //     )
  //     : GestureDetector(
  //       onDoubleTap: this.onDoubleTap,
  //       child: widget(context, icn),
  //     );
  // }

  // Widget widget(BuildContext context, bool icn){
  //   return Card(
  //     color: this.color ?? (this.header ? appbarColor(context) : Colors.transparent),
  //     child: Padding(
  //       padding: EdgeInsets.symmetric(vertical: header ? 12 : icn ? 0 : 12, horizontal: 8),
  //       child: Row(
  //         children: [
  //           ...fields.map((e){
  //             if (e.data is String)
  //               return Expanded(flex: e.flex, child: e);
  //             else if (e.data is Edit || e.data is F2Edit)
  //               return Expanded(flex: e.flex, child: Container(margin: EdgeInsets.symmetric(vertical: 5, horizontal: 3), child: e.data));
  //             else 
  //               return e.data;
  //           })
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

class FilterItem extends StatelessWidget {
  const FilterItem({Key key, @required this.title, @required this.selected, this.onSelected, this.color}) : super(key: key);

  final Color color;
  final String title;
  final bool selected;
  final Function onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: FilterChip(
        backgroundColor: this.color,
        selectedColor: this.color,
        elevation: this.selected ? 5 : 2,
        shape: BeveledRectangleBorder(side: BorderSide(color: Colors.black12, width: 0.2), borderRadius: BorderRadius.circular(5.0)),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        label: Text('${this.title}'),
        selected: this.selected,
        onSelected: this.onSelected
      )
    );
  }
}

class StreamListWidget extends StatelessWidget {
  const StreamListWidget({Key key, @required this.stream, @required this.itembuilder}) : super(key: key);

  final Function(Mainclass) itembuilder;
  final Stream stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DataModel>(
      stream: this.stream,
      builder: (context, snap){
        if (snap.hasData)
          if (snap.data.status == Status.Error)
            return Center(child: Text('${snap.data.msg}'));
          else if (snap.data.status == Status.Loaded)             
            return ListView.builder(
              itemCount: snap.data.rows.length,
              itemBuilder: (context, idx){
                return itembuilder(snap.data.rows[idx]);
            },
            );
        return Center(child: CupertinoActivityIndicator());
      },
    );
  }
}

class StreamWidget extends StatelessWidget {
  const StreamWidget({Key key, @required this.stream, @required this.itemBuilder}) : super(key: key);

  final Stream<dynamic> stream;
  final Function itemBuilder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
      stream: this.stream,
      builder: (context, snap){
        if (snap.connectionState == ConnectionState.active)
          return this.itemBuilder(snap.data);
        return Center(child: CupertinoActivityIndicator());
      },
    );
  }
}