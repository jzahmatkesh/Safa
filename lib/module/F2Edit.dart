import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/Controller.dart';
import 'Widgets.dart';
import 'class.dart';

class F2Edit extends StatefulWidget {
  
  const F2Edit({Key key, this.value, this.onChange, this.controller, this.onSubmitted, this.autofocus = false, this.hint, this.password = false, this.focus, this.date=false, this.money=false, this.numbersonly=false, this.timeonly=false, this.readonly = false, this.f2key, this.f2controller}) : super(key: key);

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
  final String f2key;
  final TextEditingController f2controller;

  @override
  _F2EditState createState() => _F2EditState();
}

class _F2EditState extends State<F2Edit> {

  OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final CodingState _controller = Get.find();
  
  @override
  void initState() {
    if (widget.focus != null)
      widget.focus.addListener(() {
        if (widget.focus.hasFocus) {
          _controller.clearF2();
          this._overlayEntry = this._createOverlayEntry();
          Overlay.of(context).insert(this._overlayEntry);

        } else {
          if (this._overlayEntry != null){
            this._overlayEntry.remove();
            this._overlayEntry = null;
          }
        }
      });
    super.initState();
  }

  @override
  void dispose() { 
    if (!this._overlayEntry.isNull)
      this._overlayEntry.remove();
    super.dispose();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width + 75,
        // height: 300,
        child: CompositedTransformFollower(
          link: this._layerLink,
          showWhenUnlinked: false,
          offset: Offset(-75, size.height + 5.0),
          child: Material(
            elevation: 4.0,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Obx(()=> _controller.f2Row == null || _controller.f2List.value.status!=Status.Loaded 
                ? Container() 
                : widget.f2key.contains('Moin') && widget.f2controller.text.isEmpty
                  ? Center(child: Text('کد کل مشخص نشده است')) 
                  : _controller.f2Row != null && _controller.f2Row.length==0
                    ? Container() 
                    : _controller.f2List.value.msg == widget.f2key
                      ? Container(
                        height: 300,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: _controller.f2Row.length,
                          itemBuilder: (BuildContext context, int idx) {
                            return _controller.f2Row[idx].inSearch ? ListTile(
                              title: Text('${_controller.f2Row[idx].id}  ${_controller.f2Row[idx].name}', style: TextStyle(fontSize: 12),),
                              onTap: (){widget.controller.text = _controller.f2Row[idx].id.toString(); this._overlayEntry.remove(); this._overlayEntry = null;},
                            ) : Container(height: 0);
                          },
                        ),
                      )
                      : Container()
              )
            ),
          ),
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: this._layerLink,
      child: GestureDetector(
        onDoubleTap: ()=>_controller.fetchF2(widget.f2key, ' ', widget.f2controller!=null && widget.f2controller.text.isNotEmpty && widget.f2controller.text.isNumericOnly ? int.parse(widget.f2controller.text) : 0),
        child: TextFormField(
          focusNode: widget.focus,
          readOnly: widget.readonly,
          autofocus: widget.autofocus,
          controller: widget.controller ?? TextEditingController(text: widget.value ?? ''),
          onChanged: (val)=> _controller.fetchF2(widget.f2key, val.trim(), widget.f2controller!=null && widget.f2controller.text.isNotEmpty && widget.f2controller.text.isNumericOnly ? int.parse(widget.f2controller.text) : 0),
          decoration: textDecoration(widget.hint),
          obscureText: widget.password,
          // onFieldSubmitted: widget.onSubmitted,
          onFieldSubmitted:(val){
            if (!val.isNumericOnly && widget.controller != null && _controller.f2Row != null)
              for(Mainclass element in _controller.f2Row){
                if (element.name.contains(val.trim())){
                  widget.controller.text = element.id.toString();    
                  break;
                }
              }
            if (widget.onSubmitted != null)
              widget.onSubmitted(val);
          },

          // focusNode: widget.focus,
          // inputFormatters: widget.date 
          //   ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly,DateTextFormatter()] 
          //   : widget.numbersonly 
          //     ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly] 
          //     : widget.timeonly
          //       ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly,TimeTextFormatter()]
          //       : widget.money 
          //         ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly, MoneyTextFormatter()]
          //         : <TextInputFormatter>[],
        ),
      )
    );
  }
}
