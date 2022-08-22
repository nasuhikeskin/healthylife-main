class Besin {
  String isim;
  String kalori;

  Besin(String _isim, String _kalori) {
    this.isim = _isim;
    this.kalori = _kalori;
  }

  @override
  String toString() {
    return '{isim: $isim, kalori: $kalori}';
  }

  Map<String, dynamic> toMap() {
    return {'isim': isim, 'kalori': kalori};
  }

  Besin.fromMap(Map<String, dynamic> map)
      : isim = map['isim'],
        kalori = map['kalori'];
}
