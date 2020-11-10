import 'package:flutter/material.dart';

String serverIP = 'http://www.safa.cloud/core.php';

bool isDark(BuildContext context) => Theme.of(context).brightness == Brightness.dark;
Color scaffoldcolor(BuildContext context) => Theme.of(context).scaffoldBackgroundColor;
Color backgroundColor(BuildContext context) => Theme.of(context).backgroundColor;
Color accentcolor(BuildContext context) => Theme.of(context).accentColor;
Color dividercolor(BuildContext context) => Theme.of(context).dividerColor;
double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;


class MenuItem extends StatelessWidget {
  const MenuItem({Key key, this.title, this.subtitle, this.leading, this.selected, this.onTap}) : super(key: key);

  final String title;
  final String subtitle;
  final GestureTapCallback onTap;
  final Widget leading;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: this.leading,
      title: Text(this.title ?? ""),
      subtitle: Text(this.subtitle ?? ""),
      onTap: this.onTap,
      selected: this.selected ?? false,
    );
  }
}


class MyDivider extends StatelessWidget {
  const MyDivider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      height: 2.0,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
    );
  }
}


class GridColumn extends StatelessWidget {
  const GridColumn({Key key, this.value, this.color, this.icon, this.title, this.width}) : super(key: key);

  final String value;
  final Color color;
  final Icon icon;
  final bool title;
  final double width;

  @override
  Widget build(BuildContext context) {
    return this.width == null ? Expanded(
      child: Container(
        color: this.title ?? false ? Colors.grey[300] : this.color,
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 3.0),
        child: this.icon != null ? Row(children: [
          this.icon,
          SizedBox(width: 2.0,),
          Text(this.value, style: TextStyle(fontSize: this.title ?? false ? 17 : 14, fontWeight: this.title ?? false ? FontWeight.bold : FontWeight.normal),)
        ],) : Text(this.value ?? '', textAlign: this.title ?? false ? TextAlign.center : TextAlign.right, style: TextStyle(fontSize: this.title ?? false ? 17 : 14, fontWeight: this.title ?? false ? FontWeight.bold : FontWeight.normal)),
      )
    ) : 
    Container(
      color: Colors.grey[300],
      height: 47,
      width: this.width,
      child: Text(''),
    );
  }
}