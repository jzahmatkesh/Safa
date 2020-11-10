class TBSanad{
  int id;
  String date;
  int reg;
  int taraz;
  double mande;
  String mandekind;
  String edate;
  String user;
  String note;

  TBSanad({this.id, this.date, this.reg, this.taraz, this.mande, this.mandekind, this.note, this.edate, this.user});

  factory TBSanad.fromjson(Map<String, dynamic> data) => 
    TBSanad(
      id: data['id'],
      date: data['date'],
      reg: data['reg'],
      taraz: data['taraz'],
      mande: data['mande'],
      mandekind: data['mandekind'],
      note: data['note'],
      edate: data['edate'],
      user: data['user'],
    );
}