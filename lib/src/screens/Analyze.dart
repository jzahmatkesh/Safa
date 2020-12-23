import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../module/Blocs.dart';
import '../module/MyProvider.dart';
import '../module/Widgets.dart';
import '../module/class.dart';
import '../module/functions.dart';


AnalyzeBloc _bloc;
class FmAnalyze extends StatelessWidget {
  const FmAnalyze({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MyProvider _prov = Provider.of<MyProvider>(context);
    if (_bloc == null)
      _bloc = AnalyzeBloc(context: context, api: 'Analyze/Kol', token: _prov.currentUser.token, body: {});
    return Padding(
      padding: EdgeInsets.all(8),
      child: StreamWidget(
        stream: _bloc.analyzeStream$,
        itemBuilder: (data)=> Column(
          children: [
            Header(title: 'آنالیز حساب', rightBtn: IButton(icon: Icon(CupertinoIcons.rectangle_on_rectangle), hint: 'انتخاب سطح شروع', onPressed: ()=>showFormAsDialog(context: context, form: StartLev()))),
            _bloc.lev > 0 
              ? _bloc.tafid == 0
                ? Expanded(child: PnStartTaf()) 
                : Container(height: 55, child: PnStartTaf(header: false))
              : Container(),
            (_bloc.lev > 0 && _bloc.tafid>0) || (_bloc.lev == 0)
              ? _bloc.kolid == 0 ? Expanded(child: PnKol()) : Container(height: 55, child: PnKol(header: false))
              : Container(),
            _bloc.kolid > 0
              ? _bloc.moinid == 0 ? Expanded(child: PnMoin()) : Container(height: 55, child: PnMoin(header: false))
              : Container(),
            _bloc.moinid > 0
              ? _bloc.taf1 == 0 ? Expanded(child: PnTaf1()) : Container(height: 55, child: PnTaf1(header: false))
              : Container(),
            _bloc.taf1 > 0
              ? _bloc.taf2 == 0 ? Expanded(child: PnTaf2()) : Container(height: 55, child: PnTaf2(header: false))
              : Container(),
            _bloc.taf2 > 0
              ? _bloc.taf3 == 0 ? Expanded(child: PnTaf3()) : Container(height: 55, child: PnTaf3(header: false))
              : Container(),
            _bloc.taf3 > 0
              ? _bloc.taf4 == 0 ? Expanded(child: PnTaf4()) : Container(height: 55, child: PnTaf4(header: false))
              : Container(),
            _bloc.taf4 > 0
              ? _bloc.taf5 == 0 ? Expanded(child: PnTaf5()) : Container(height: 55, child: PnTaf5(header: false))
              : Container(),
            _bloc.taf5 > 0
              ? _bloc.taf6 == 0 ? Expanded(child: PnTaf6()) : Container(height: 55, child: PnTaf6(header: false))
              : Container(),
          ],
        ),
      )
    );
  }
}

class PnKol extends StatelessWidget {
  const PnKol({Key key, this.header = true}) : super(key: key);

  final bool header;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IButton(icon: Icon(CupertinoIcons.printer), hint: 'پرینت', onPressed: ()=>showFormAsDialog(context: context, form: PdfViewer())),
        this.header ? GridRow([
          Field('کد کل', bold: true,),
          Field('عنوان کل', flex: 2, bold: true,),
          Field('گردش بدهکار', bold: true,),
          Field('گردش بستانکار', bold: true,),
          Field('مانده بدهکار', bold: true,),
          Field('مانده بستانکار', bold: true,),
        ], header: true) :  Container(),
        Expanded(
          child: StreamListWidget(
            stream: _bloc.rowsStream$,
            itembuilder: (rw)=> rw.active ? Stack(
              children: [
                GridRow(
                  [
                    Field('${rw.id}'),
                    Field('${rw.name}', flex: 2),
                    Field('${moneySeprator(rw.bed)}', color: Colors.red.withOpacity(0.2)),
                    Field('${moneySeprator(rw.bes)}', color: Colors.green.withOpacity(0.2)),
                    Field('${moneySeprator(rw.mandebed)}', color: Colors.blue.withOpacity(0.2)),
                    Field('${moneySeprator(rw.mandebes)}', color: Colors.purple.withOpacity(0.2)),
                  ],
                  color: !this.header ? accentcolor(context).withOpacity(0.1) : _bloc.rowsValue$.rows.indexOf(rw).isOdd ? rowColor(context) : null,
                  onTap: ()=>this.header ? _bloc.loadMoin(rw.id) : _bloc.loadMoin(0)
                ),
                this.header ? Container() : Align(alignment: Alignment.centerLeft, child: Chip(backgroundColor: Colors.green.withOpacity(0.25), label: Text('کل', style: gridFieldStyle()), padding: EdgeInsets.zero,)),
              ],
            ) : Container(),
          ),
        ),
      ],
    );
  }
}

class PnMoin extends StatelessWidget {
  const PnMoin({Key key, this.header = true}) : super(key: key);

  final bool header;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        this.header ? GridRow([
          Field('کد معین', bold: true,),
          Field('عنوان معین', flex: 2, bold: true,),
          Field('گردش بدهکار', bold: true,),
          Field('گردش بستانکار', bold: true,),
          Field('مانده بدهکار', bold: true,),
          Field('مانده بستانکار', bold: true,),
        ], header: true) :  Container(),
        Expanded(
          child: StreamListWidget(
            stream: _bloc.moinStream$,
            itembuilder: (rw)=> rw.active ? Stack(
              children: [
                GridRow(
                  [
                    Field('${rw.id}'),
                    Field('${rw.name}', flex: 2),
                    Field('${moneySeprator(rw.bed)}', color: Colors.red.withOpacity(0.2)),
                    Field('${moneySeprator(rw.bes)}', color: Colors.green.withOpacity(0.2)),
                    Field('${moneySeprator(rw.mandebed)}', color: Colors.blue.withOpacity(0.2)),
                    Field('${moneySeprator(rw.mandebes)}', color: Colors.purple.withOpacity(0.2)),
                  ],
                  color: !this.header ? accentcolor(context).withOpacity(0.1) : _bloc.moinrows$.rows.indexOf(rw).isOdd ? rowColor(context) : null,
                  onTap: ()=>this.header ? _bloc.loadTafsili(rw.id) : _bloc.backtoMoin(),
                ),
                this.header ? Container() : Align(alignment: Alignment.centerLeft, child: Chip(backgroundColor: Colors.green.withOpacity(0.25), label: Text('معین', style: gridFieldStyle()), padding: EdgeInsets.zero,)),
              ],
            ) : Container(),
          ),
        ),
      ],
    );
  }
}

class PnTaf1 extends StatelessWidget {
  const PnTaf1({Key key, this.header = true}) : super(key: key);

  final bool header;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        this.header ? GridRow([
          Field('کد تفصیلی', bold: true,),
          Field('${_bloc.taflevel$[0].name}', flex: 2, bold: true,),
          Field('گردش بدهکار', bold: true,),
          Field('گردش بستانکار', bold: true,),
          Field('مانده بدهکار', bold: true,),
          Field('مانده بستانکار', bold: true,),
        ], header: true) :  Container(),
        Expanded(
          child: StreamListWidget(
            stream: _bloc.taf1Stream$,
            itembuilder: (rw)=> rw.active ? Stack(
              children: [
                GridRow(
                  [
                    Field('${rw.id}'),
                    Field('${rw.name}', flex: 2),
                    Field('${moneySeprator(rw.bed)}', color: Colors.red.withOpacity(0.2)),
                    Field('${moneySeprator(rw.bes)}', color: Colors.green.withOpacity(0.2)),
                    Field('${moneySeprator(rw.mandebed)}', color: Colors.blue.withOpacity(0.2)),
                    Field('${moneySeprator(rw.mandebes)}', color: Colors.purple.withOpacity(0.2)),
                  ],
                  onTap: ()=>this.header  ? _bloc.loadTafsili(rw.id) : _bloc.backtoTaf1(),
                  color: !this.header ? accentcolor(context).withOpacity(0.1) : _bloc.taf1rows$.rows.indexOf(rw).isOdd ? rowColor(context) : null,
                ),
                this.header ? Container() : Align(alignment: Alignment.centerLeft, child: Chip(backgroundColor: Colors.green.withOpacity(0.25), label: Text('${_bloc.taflevel$[0].name}', style: gridFieldStyle()), padding: EdgeInsets.zero,)),
              ],
            ) : Container(),
          ),
        ),
      ],
    );
  }
}

class PnTaf2 extends StatelessWidget {
  const PnTaf2({Key key, this.header = true}) : super(key: key);

  final bool header;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        this.header ? GridRow([
          Field('کد تفصیلی', bold: true,),
          Field('${_bloc.taflevel$[1].name}', flex: 2, bold: true,),
          Field('گردش بدهکار', bold: true,),
          Field('گردش بستانکار', bold: true,),
          Field('مانده بدهکار', bold: true,),
          Field('مانده بستانکار', bold: true,),
        ], header: true) :  Container(),
        Expanded(
          child: StreamListWidget(
            stream: _bloc.taf2Stream$,
            itembuilder: (rw)=> rw.active ? Stack(
              children: [
                GridRow(
                  [
                    Field('${rw.id}'),
                    Field('${rw.name}', flex: 2),
                    Field('${moneySeprator(rw.bed)}', color: Colors.red.withOpacity(0.2)),
                    Field('${moneySeprator(rw.bes)}', color: Colors.green.withOpacity(0.2)),
                    Field('${moneySeprator(rw.mandebed)}', color: Colors.blue.withOpacity(0.2)),
                    Field('${moneySeprator(rw.mandebes)}', color: Colors.purple.withOpacity(0.2)),
                  ],
                  onTap: ()=>this.header ? _bloc.loadTafsili(rw.id) : _bloc.backtoTaf2(),
                  color: !this.header ? accentcolor(context).withOpacity(0.1) : _bloc.taf2rows$.rows.indexOf(rw).isOdd ? rowColor(context) : null,
                ),
                this.header ? Container() : Align(alignment: Alignment.centerLeft, child: Chip(backgroundColor: Colors.green.withOpacity(0.25), label: Text('${_bloc.taflevel$[1].name}', style: gridFieldStyle()), padding: EdgeInsets.zero,)),
              ],
            ) : Container(),
          ),
        ),
      ],
    );
  }
}

class PnTaf3 extends StatelessWidget {
  const PnTaf3({Key key, this.header = true}) : super(key: key);

  final bool header;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        this.header ? GridRow([
          Field('کد تفصیلی', bold: true,),
          Field('${_bloc.taflevel$[2].name}', flex: 2, bold: true,),
          Field('گردش بدهکار', bold: true,),
          Field('گردش بستانکار', bold: true,),
          Field('مانده بدهکار', bold: true,),
          Field('مانده بستانکار', bold: true,),
        ], header: true) :  Container(),
        Expanded(
          child: StreamListWidget(
            stream: _bloc.taf3Stream$,
            itembuilder: (rw)=> rw.active ? Stack(
              children: [
                GridRow(
                  [
                    Field('${rw.id}'),
                    Field('${rw.name}', flex: 2),
                    Field('${moneySeprator(rw.bed)}', color: Colors.red.withOpacity(0.2)),
                    Field('${moneySeprator(rw.bes)}', color: Colors.green.withOpacity(0.2)),
                    Field('${moneySeprator(rw.mandebed)}', color: Colors.blue.withOpacity(0.2)),
                    Field('${moneySeprator(rw.mandebes)}', color: Colors.purple.withOpacity(0.2)),
                  ],
                  onTap: ()=>this.header ? _bloc.loadTafsili(rw.id) : _bloc.backtoTaf3(),
                  color: !this.header ? accentcolor(context).withOpacity(0.1) : _bloc.taf3rows$.rows.indexOf(rw).isOdd ? rowColor(context) : null,
                ),
                this.header ? Container() : Align(alignment: Alignment.centerLeft, child: Chip(backgroundColor: Colors.green.withOpacity(0.25), label: Text('${_bloc.taflevel$[2].name}', style: gridFieldStyle()), padding: EdgeInsets.zero,)),
              ],
            ) : Container(),
          ),
        ),
      ],
    );
  }
}

class PnTaf4 extends StatelessWidget {
  const PnTaf4({Key key, this.header = true}) : super(key: key);

  final bool header;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        this.header ? GridRow([
          Field('کد تفصیلی', bold: true,),
          Field('${_bloc.taflevel$[3].name}', flex: 2, bold: true,),
          Field('گردش بدهکار', bold: true,),
          Field('گردش بستانکار', bold: true,),
          Field('مانده بدهکار', bold: true,),
          Field('مانده بستانکار', bold: true,),
        ], header: true) :  Container(),
        Expanded(
          child: StreamListWidget(
            stream: _bloc.taf4Stream$,
            itembuilder: (rw)=> rw.active ? Stack(
              children: [
                GridRow(
                  [
                    Field('${rw.id}'),
                    Field('${rw.name}', flex: 2),
                    Field('${moneySeprator(rw.bed)}', color: Colors.red.withOpacity(0.2)),
                    Field('${moneySeprator(rw.bes)}', color: Colors.green.withOpacity(0.2)),
                    Field('${moneySeprator(rw.mandebed)}', color: Colors.blue.withOpacity(0.2)),
                    Field('${moneySeprator(rw.mandebes)}', color: Colors.purple.withOpacity(0.2)),
                  ],
                  onTap: ()=>this.header ? _bloc.loadTafsili(rw.id) : _bloc.backtoTaf4(),
                  color: !this.header ? accentcolor(context).withOpacity(0.1) : _bloc.taf4rows$.rows.indexOf(rw).isOdd ? rowColor(context) : null,
                ),
                this.header ? Container() : Align(alignment: Alignment.centerLeft, child: Chip(backgroundColor: Colors.green.withOpacity(0.25), label: Text('${_bloc.taflevel$[3].name}', style: gridFieldStyle()), padding: EdgeInsets.zero,)),
              ],
            ) : Container(),
          ),
        ),
      ],
    );
  }
}

class PnTaf5 extends StatelessWidget {
  const PnTaf5({Key key, this.header = true}) : super(key: key);

  final bool header;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        this.header ? GridRow([
          Field('کد تفصیلی', bold: true,),
          Field('${_bloc.taflevel$[4].name}', flex: 2, bold: true,),
          Field('گردش بدهکار', bold: true,),
          Field('گردش بستانکار', bold: true,),
          Field('مانده بدهکار', bold: true,),
          Field('مانده بستانکار', bold: true,),
        ], header: true) :  Container(),
        Expanded(
          child: StreamListWidget(
            stream: _bloc.taf5Stream$,
            itembuilder: (rw)=> rw.active ? Stack(
              children: [
                GridRow(
                  [
                    Field('${rw.id}'),
                    Field('${rw.name}', flex: 2),
                    Field('${moneySeprator(rw.bed)}', color: Colors.red.withOpacity(0.2)),
                    Field('${moneySeprator(rw.bes)}', color: Colors.green.withOpacity(0.2)),
                    Field('${moneySeprator(rw.mandebed)}', color: Colors.blue.withOpacity(0.2)),
                    Field('${moneySeprator(rw.mandebes)}', color: Colors.purple.withOpacity(0.2)),
                  ],
                  onTap: ()=>this.header ? _bloc.loadTafsili(rw.id) : _bloc.backtoTaf5(),
                  color: !this.header ? accentcolor(context).withOpacity(0.1) : _bloc.taf5rows$.rows.indexOf(rw).isOdd ? rowColor(context) : null,
                ),
                this.header ? Container() : Align(alignment: Alignment.centerLeft, child: Chip(backgroundColor: Colors.green.withOpacity(0.25), label: Text('${_bloc.taflevel$[4].name}', style: gridFieldStyle()), padding: EdgeInsets.zero,)),
              ],
            ) : Container(),
          ),
        ),
      ],
    );
  }
}

class PnTaf6 extends StatelessWidget {
  const PnTaf6({Key key, this.header = true}) : super(key: key);

  final bool header;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        this.header ? GridRow([
          Field('کد تفصیلی', bold: true,),
          Field('${_bloc.taflevel$[5].name}', flex: 2, bold: true,),
          Field('گردش بدهکار', bold: true,),
          Field('گردش بستانکار', bold: true,),
          Field('مانده بدهکار', bold: true,),
          Field('مانده بستانکار', bold: true,),
        ], header: true) :  Container(),
        Expanded(
          child: StreamListWidget(
            stream: _bloc.taf6Stream$,
            itembuilder: (rw)=> rw.active ? GridRow(
              [
                Field('${rw.id}'),
                Field('${rw.name}', flex: 2),
                Field('${moneySeprator(rw.bed)}', color: Colors.red.withOpacity(0.2)),
                Field('${moneySeprator(rw.bes)}', color: Colors.green.withOpacity(0.2)),
                Field('${moneySeprator(rw.mandebed)}', color: Colors.blue.withOpacity(0.2)),
                Field('${moneySeprator(rw.mandebes)}', color: Colors.purple.withOpacity(0.2)),
              ],
              onTap: ()=>_bloc.loadTafsili(rw.id),
              color: !this.header ? accentcolor(context).withOpacity(0.1) : _bloc.taf6rows$.rows.indexOf(rw).isOdd ? rowColor(context) : null,
            ) : Container(),
          ),
        ),
      ],
    );
  }
}

class PnStartTaf extends StatelessWidget {
  const PnStartTaf({Key key, this.header = true}) : super(key: key);

  final bool header;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        this.header ? GridRow([
          Field('کد تفصیلی', bold: true,),
          Field('${_bloc.taflevel$[_bloc.lev].name}', flex: 2, bold: true,),
          Field('گردش بدهکار', bold: true,),
          Field('گردش بستانکار', bold: true,),
          Field('مانده بدهکار', bold: true,),
          Field('مانده بستانکار', bold: true,),
        ], header: true) :  Container(),
        Expanded(
          child: StreamListWidget(
            stream: _bloc.startTafStream$,
            itembuilder: (rw)=> rw.active ? Stack(
              children: [
                GridRow(
                  [
                    Field('${rw.id}'),
                    Field('${rw.name}', flex: 2),
                    Field('${moneySeprator(rw.bed)}', color: Colors.red.withOpacity(0.2)),
                    Field('${moneySeprator(rw.bes)}', color: Colors.green.withOpacity(0.2)),
                    Field('${moneySeprator(rw.mandebed)}', color: Colors.blue.withOpacity(0.2)),
                    Field('${moneySeprator(rw.mandebes)}', color: Colors.purple.withOpacity(0.2)),
                  ],
                  color: !this.header ? accentcolor(context).withOpacity(0.1) : _bloc.taf1rows$.rows.indexOf(rw).isOdd ? rowColor(context) : null,
                  onTap: ()=>this.header  ? _bloc.loadTafsili(rw.id) : _bloc.backtoTaf1(),
                ),
                this.header ? Container() : Align(alignment: Alignment.centerLeft, child: Chip(backgroundColor: Colors.green.withOpacity(0.25), label: Text('${_bloc.taflevel$[0].name}', style: gridFieldStyle()), padding: EdgeInsets.zero,)),
              ],
            ) : Container(),
          ),
        ),
      ],
    );
  }
}

class StartLev extends StatelessWidget {
  const StartLev({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: 350,
        // padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Header(title: 'سطح مورد نظر را انتخاب نمایید'),
            Card(child: ListTile(title: Text('حساب کل'), onTap: ()=>_bloc.setStartLev(0))),
            ..._bloc.taflevel$.map((e) => Card(child: ListTile(title: Text(e.name), onTap: ()=>_bloc.setStartLev(e.id))))
          ],
        )
      ),
    );
  }
}

class PdfViewer extends StatelessWidget {
  const PdfViewer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth(context)*0.85,
      child: PdfPreview(
        build: (format) => _generatePdf(format, 'آنالیز حساب - گردش حساب کل', _bloc.rowsValue$.rows),
      ),
    );
  }
}

Future<Uint8List> _generatePdf(PdfPageFormat format, String title, List<Mainclass> data) async {
  final pdf = pw.Document();
  final font = await rootBundle.load("fonts/NAZANIN.ttf");
  final ttf = pw.Font.ttf(font);

  pdf.addPage(
    pw.Page(
      theme: pw.ThemeData.withFont(
          base: ttf,
      ),
      // pageFormat: format,
      build: (context) {
        return pw.Table.fromTextArray(
          cellStyle: pw.TextStyle(font: ttf),
          headerStyle: pw.TextStyle(font: ttf),
          cellAlignment: pw.Alignment.centerRight,
          context: context, 
          data: [
            [
              'مانده بستانکار',
              'مانده بدهکار',
              'بستانکار',
               'بدهکار',
              'عنوان کل',
              'کد کل',
            ],
            ...data.map((e) => ['${moneySeprator(e.mandebes)}', '${moneySeprator(e.mandebed)}', '${moneySeprator(e.bes)}', '${moneySeprator(e.bed)}', '${e.name}', '${e.id}'])
          ]
        );
        // return pw.Container(
        //     child: pw.Column(
        //       children: [
        //         pw.Text('$title', style: pw.TextStyle(font: ttf)),
        //         ...data.map((e) => pw.Container(
        //           margin: pw.EdgeInsets.all(12),
        //           child: pw.Row(
        //             children: [
        //               pw.Expanded(child: pw.Text('${moneySeprator(e.mandebes)}', style: pw.TextStyle(font: ttf))),
        //               pw.SizedBox(width: 5),
        //               pw.Expanded(child: pw.Text('${moneySeprator(e.mandebed)}', style: pw.TextStyle(font: ttf))),
        //               pw.SizedBox(width: 5),
        //               pw.Expanded(child: pw.Text('${moneySeprator(e.bes)}', style: pw.TextStyle(font: ttf))),
        //               pw.SizedBox(width: 5),
        //               pw.Expanded(child: pw.Text('${moneySeprator(e.bed)}', style: pw.TextStyle(font: ttf))),
        //               pw.SizedBox(width: 5),
        //               pw.Expanded(child: pw.Text('${e.name}', textDirection: pw.TextDirection.rtl), flex: 2),
        //               pw.SizedBox(width: 5),
        //               pw.Expanded(child: pw.Text('${e.id}', style: pw.TextStyle(font: ttf))),
        //             ]
        //           )
        //         ))
        //       ]
        //     )
        //   // )
        // );
      },
    ),
  );

  return pdf.save();
}
