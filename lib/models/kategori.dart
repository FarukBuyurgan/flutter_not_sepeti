class Kategori {
  int? kategoriID;
  String? kategoriBaslik;

  //kategori eklerken kullan...
  Kategori(this.kategoriBaslik);

  // veri tarabanında veri çekerken kullan...
  Kategori.withID(this.kategoriID, this.kategoriBaslik);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['kategoriID'] = kategoriID;
    map['kategoriBaslik'] = kategoriBaslik;

    return map;
  }

  Kategori.fromMap(Map<String, dynamic> map) {
    kategoriID = map['kategoriID'];
    kategoriBaslik = map['kategoriBaslik'];
  }

  @override
  String toString() =>
      'Kategori(kategoriID: $kategoriID, kategoriBaslik: $kategoriBaslik)';
}