import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../module/Blocs.dart';
import '../module/MyProvider.dart';
import '../module/Widgets.dart';
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
            _bloc.kolid == 0 ? Expanded(child: PnKol()) : Container(height: 55, child: PnKol(header: false)),
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
                this.header ? Container() : Positioned(top: 0, left: 0, child: Chip(label: Text('کل', style: gridFieldStyle()), padding: EdgeInsets.zero,)),
                GridRow(
                  [
                    Field('${rw.id}'),
                    Field('${rw.name}', flex: 2),
                    Field('${moneySeprator(rw.bed)}'),
                    Field('${moneySeprator(rw.bes)}'),
                    Field('${moneySeprator(rw.mandebed)}'),
                    Field('${moneySeprator(rw.mandebes)}'),
                  ],
                  onTap: ()=> _bloc.loadMoin(this.header ? rw.id  : 0),
                  color: !this.header ? accentcolor(context).withOpacity(0.1) : _bloc.rowsValue$.rows.indexOf(rw).isEven ? rowColor(context) : null,
                ),
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
                this.header ? Container() : Positioned(top: 0, left: 0, child: Chip(label: Text('معین', style: gridFieldStyle()), padding: EdgeInsets.zero,)),
                GridRow(
                  [
                    Field('${rw.id}'),
                    Field('${rw.name}', flex: 2),
                    Field('${moneySeprator(rw.bed)}'),
                    Field('${moneySeprator(rw.bes)}'),
                    Field('${moneySeprator(rw.mandebed)}'),
                    Field('${moneySeprator(rw.mandebes)}'),
                  ],
                  onTap: ()=>this.header ? _bloc.loadTafsili(rw.id) : _bloc.backtoMoin(),
                  color: !this.header ? accentcolor(context).withOpacity(0.1) : _bloc.moinrows$.rows.indexOf(rw).isEven ? rowColor(context) : null,
                ),
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
          Field('عنوان تفصیلی', flex: 2, bold: true,),
          Field('گردش بدهکار', bold: true,),
          Field('گردش بستانکار', bold: true,),
          Field('مانده بدهکار', bold: true,),
          Field('مانده بستانکار', bold: true,),
        ], header: true) :  Container(),
        Expanded(
          child: StreamListWidget(
            stream: _bloc.taf1Stream$,
            itembuilder: (rw)=> rw.active ? GridRow(
              [
                this.header ? Field(SizedBox(width: 1))  :  Field(Chip(label: Text('${_bloc.taflevel$[0].name}'), padding: EdgeInsets.zero,)),
                Field(SizedBox(width: 5)),
                Field('${rw.id}'),
                Field('${rw.name}', flex: 2),
                Field('${moneySeprator(rw.bed)}'),
                Field('${moneySeprator(rw.bes)}'),
                Field('${moneySeprator(rw.mandebed)}'),
                Field('${moneySeprator(rw.mandebes)}'),
              ],
              onTap: ()=>this.header  ? _bloc.loadTafsili(rw.id) : _bloc.backtoTaf1(),
              color: !this.header ? accentcolor(context).withOpacity(0.1) : _bloc.moinrows$.rows.indexOf(rw).isEven ? rowColor(context) : null,
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
          Field('عنوان تفصیلی', flex: 2, bold: true,),
          Field('گردش بدهکار', bold: true,),
          Field('گردش بستانکار', bold: true,),
          Field('مانده بدهکار', bold: true,),
          Field('مانده بستانکار', bold: true,),
        ], header: true) :  Container(),
        Expanded(
          child: StreamListWidget(
            stream: _bloc.taf2Stream$,
            itembuilder: (rw)=> rw.active ? GridRow(
              [
                this.header ? Field(SizedBox(width: 1))  :  Field('${_bloc.taflevel$[1].name}', bold: true),
                Field('${rw.id}'),
                Field('${rw.name}', flex: 2),
                Field('${moneySeprator(rw.bed)}'),
                Field('${moneySeprator(rw.bes)}'),
                Field('${moneySeprator(rw.mandebed)}'),
                Field('${moneySeprator(rw.mandebes)}'),
              ],
              onTap: ()=>this.header ? _bloc.loadTafsili(rw.id) : _bloc.backtoTaf2(),
              color: !this.header ? accentcolor(context).withOpacity(0.1) : _bloc.moinrows$.rows.indexOf(rw).isEven ? rowColor(context) : null,
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
          Field('عنوان تفصیلی', flex: 2, bold: true,),
          Field('گردش بدهکار', bold: true,),
          Field('گردش بستانکار', bold: true,),
          Field('مانده بدهکار', bold: true,),
          Field('مانده بستانکار', bold: true,),
        ], header: true) :  Container(),
        Expanded(
          child: StreamListWidget(
            stream: _bloc.taf3Stream$,
            itembuilder: (rw)=> rw.active ? GridRow(
              [
                this.header ? Field(SizedBox(width: 1))  :  Field('${_bloc.taflevel$[2].name}', bold: true),
                Field('${rw.id}'),
                Field('${rw.name}', flex: 2),
                Field('${moneySeprator(rw.bed)}'),
                Field('${moneySeprator(rw.bes)}'),
                Field('${moneySeprator(rw.mandebed)}'),
                Field('${moneySeprator(rw.mandebes)}'),
              ],
              onTap: ()=>this.header ? _bloc.loadTafsili(rw.id) : _bloc.backtoTaf3(),
              color: !this.header ? accentcolor(context).withOpacity(0.1) : _bloc.moinrows$.rows.indexOf(rw).isEven ? rowColor(context) : null,
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
          Field('عنوان تفصیلی', flex: 2, bold: true,),
          Field('گردش بدهکار', bold: true,),
          Field('گردش بستانکار', bold: true,),
          Field('مانده بدهکار', bold: true,),
          Field('مانده بستانکار', bold: true,),
        ], header: true) :  Container(),
        Expanded(
          child: StreamListWidget(
            stream: _bloc.taf4Stream$,
            itembuilder: (rw)=> rw.active ? GridRow(
              [
                this.header ? Field(SizedBox(width: 1))  :  Field('${_bloc.taflevel$[3].name}', bold: true),
                Field('${rw.id}'),
                Field('${rw.name}', flex: 2),
                Field('${moneySeprator(rw.bed)}'),
                Field('${moneySeprator(rw.bes)}'),
                Field('${moneySeprator(rw.mandebed)}'),
                Field('${moneySeprator(rw.mandebes)}'),
              ],
              onTap: ()=>this.header ? _bloc.loadTafsili(rw.id) : _bloc.backtoTaf4(),
              color: !this.header ? accentcolor(context).withOpacity(0.1) : _bloc.moinrows$.rows.indexOf(rw).isEven ? rowColor(context) : null,
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
          Field('عنوان تفصیلی', flex: 2, bold: true,),
          Field('گردش بدهکار', bold: true,),
          Field('گردش بستانکار', bold: true,),
          Field('مانده بدهکار', bold: true,),
          Field('مانده بستانکار', bold: true,),
        ], header: true) :  Container(),
        Expanded(
          child: StreamListWidget(
            stream: _bloc.taf5Stream$,
            itembuilder: (rw)=> rw.active ? GridRow(
              [
                this.header ? Field(SizedBox(width: 1))  :  Field('${_bloc.taflevel$[4].name}', bold: true),
                Field('${rw.id}'),
                Field('${rw.name}', flex: 2),
                Field('${moneySeprator(rw.bed)}'),
                Field('${moneySeprator(rw.bes)}'),
                Field('${moneySeprator(rw.mandebed)}'),
                Field('${moneySeprator(rw.mandebes)}'),
              ],
              onTap: ()=>this.header ? _bloc.loadTafsili(rw.id) : _bloc.backtoTaf5(),
              color: !this.header ? accentcolor(context).withOpacity(0.1) : _bloc.moinrows$.rows.indexOf(rw).isEven ? rowColor(context) : null,
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
          Field('عنوان تفصیلی', flex: 2, bold: true,),
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
                this.header ? Field(SizedBox(width: 1))  :  Field('${_bloc.taflevel$[5].name}', bold: true),
                Field('${rw.id}'),
                Field('${rw.name}', flex: 2),
                Field('${moneySeprator(rw.bed)}'),
                Field('${moneySeprator(rw.bes)}'),
                Field('${moneySeprator(rw.mandebed)}'),
                Field('${moneySeprator(rw.mandebes)}'),
              ],
              onTap: ()=>_bloc.loadTafsili(rw.id),
              color: !this.header ? accentcolor(context).withOpacity(0.1) : _bloc.moinrows$.rows.indexOf(rw).isEven ? rowColor(context) : null,
            ) : Container(),
          ),
        ),
      ],
    );
  }
}
