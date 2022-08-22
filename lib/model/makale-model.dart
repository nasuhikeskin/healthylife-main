class Makale {
  String baslik;
  String icerik;

  Makale(String gelenBaslik, String gelenIcerik) {
    this.baslik = gelenBaslik;
    this.icerik = gelenIcerik;
  }

  Map<String, dynamic> toMap() {
    return {'baslik': baslik, 'icerik': icerik};
  }

  Makale.fromMap(Map<String, dynamic> map)
      : baslik = map['baslik'],
        icerik = map['icerik'];
}
