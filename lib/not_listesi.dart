import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_not_sepeti/models/notlar.dart';
import 'package:flutter_not_sepeti/models/kategori.dart';
import 'package:flutter_not_sepeti/not_detay.dart';
import 'package:flutter_not_sepeti/utils/database_helper.dart';
import 'package:flutter_not_sepeti/kategori_islemleri.dart';

class NotListesi extends StatefulWidget {
  const NotListesi({super.key});

  @override
  State<NotListesi> createState() => _NotListesiState();
}

class _NotListesiState extends State<NotListesi> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  var _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Kategori> tumKategoriler = <Kategori>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(224, 224, 224, 1),
      key: _scaffoldKey,
      appBar: AppBar(
        toolbarHeight: 70.0,
        backgroundColor: const Color(0xff8f250C),
        shadowColor: Colors.black,
        elevation: 20,
        title: const Text(
          "Not Sepeti",
          style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        actions: <Widget>[
          PopupMenuButton(
            shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.white)),
            color: const Color(0xff8f250C),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(
                      Icons.import_contacts,
                      color: Colors.white,
                    ),
                    title: const Text(
                      "Kategoriler",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _kategorilerSayfasinaGit(context);
                    },
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            backgroundColor: const Color(0xff8f250C),
            onPressed: () {
              kategoriEkleDialog(context);
            },
            heroTag: "KategoriEkle",
            tooltip: "Kategori Ekle",
            mini: true,
            child: const Icon(
              Icons.import_contacts,
              color: Colors.white,
            ),
          ),
          FloatingActionButton(
            backgroundColor: const Color(0xff8f250C),
            tooltip: "Not Ekle",
            heroTag: "NotEkle",
            onPressed: () => tumKategoriler.isEmpty
                ? _detaySayfasinaGit(context)
                : ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Kategori Boş!!! Önce Kategori Ekleyiniz."),
                      duration: Duration(seconds: 5),
                    ),
                  ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Notlar(),
    );
  }

  void kategoriEkleDialog(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    String? yeniKategoriAdi;

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text(
              "Kategori Ekle",
              style: TextStyle(
                  fontWeight: FontWeight.w700, color: Color(0xff8f250C)),
            ),
            children: <Widget>[
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onSaved: (yeniDeger) {
                      yeniKategoriAdi = yeniDeger!;
                    },
                    decoration: const InputDecoration(
                      labelText: "Kategori Adı",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff8f250C), width: 2.0)),
                    ),
                    // ignore: missing_return
                    validator: (girilenKategoriAdi) {
                      if (girilenKategoriAdi!.isEmpty) {
                        return "En az 1 karakter giriniz";
                      }
                    },
                  ),
                ),
              ),
              ButtonBar(
                children: <Widget>[
                  ElevatedButton(
                    style: TextButton.styleFrom(
                        backgroundColor: const Color(0xffCA5310)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Vazgeç",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  ElevatedButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        databaseHelper
                            .kategoriEkle(Kategori(yeniKategoriAdi!))
                            .then((kategoriID) {
                          if (kategoriID > 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.black,
                                content: Text("Kategori Eklendi"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        });
                      }
                    },
                    //color: Color(0xff501E4B),
                    child: const Text(
                      "Kaydet",
                      style: TextStyle(
                          color: Color(0xff8f250C),
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  _detaySayfasinaGit(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => NotDetay(
                  baslik: "Yeni Not",
                  duzenlenecekNot: null,
                ))).then((value) {
      setState(() {});
    });
  }

  void _kategorilerSayfasinaGit(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Kategoriler()));
  }
}

class Notlar extends StatefulWidget {
  @override
  _NotlarState createState() => _NotlarState();
}

class _NotlarState extends State<Notlar> {
  late List<Not> tumNotlar;
  late DatabaseHelper databaseHelper;

  @override
  void initState() {
    super.initState();
    tumNotlar = <Not>[];
    databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyleBaslik = Theme.of(context).textTheme.bodyText2!.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          fontFamily: 'Montserrat',
        );

    return FutureBuilder(
      future: databaseHelper.notListesiniGetir(),
      builder: (context, AsyncSnapshot<List<Not>> snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          tumNotlar = snapShot.data!;
          sleep(const Duration(milliseconds: 500));
          return ListView.builder(
              itemCount: tumNotlar.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  iconColor: const Color(0xff8f250C),
                  collapsedIconColor: Colors.black,
                  leading:
                      _oncelikIconuAta(tumNotlar[index].notOncelik!.toInt()),
                  title: Text(
                    tumNotlar[index].notBaslik.toString(),
                    style: textStyleBaslik,
                  ),
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Kategori",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  tumNotlar[index].kategoriBaslik.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Color(0xff8f250C)),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Oluşturulma Tarihi",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  databaseHelper.dateFormat(DateTime.parse(
                                      tumNotlar[index].notTarih.toString())),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Color(0xff8f250C)),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(top: 40),
                                child: const Center(
                                  child: Text(
                                    "İçerik",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 15),
                                child: Text(
                                  tumNotlar[index].notIcerik.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          ButtonBar(
                            alignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ElevatedButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: const Color(0xffCA5310)),
                                  onPressed: () =>
                                      _notSil(tumNotlar[index].notID!.toInt()),
                                  child: const Text(
                                    "SİL",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  )),
                              ElevatedButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.grey.shade300),
                                  onPressed: () {
                                    _detaySayfasinaGit(
                                        context, tumNotlar[index]);
                                  },
                                  child: const Text(
                                    "GÜNCELLE",
                                    style: TextStyle(
                                        color: Color(0xffCA5310),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              });
        } else {
          return const Center(
              child: Text(
            "Yükleniyor...",
            style: TextStyle(
                color: Color(
                  0xff8f250C,
                ),
                fontSize: 16),
          ));
        }
      },
    );
  }

  _detaySayfasinaGit(BuildContext context, Not not) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => NotDetay(
                  baslik: "Notu Düzenle",
                  duzenlenecekNot: not,
                ))).then((value) {
      setState(() {});
    });
  }

  _oncelikIconuAta(int notOncelik) {
    switch (notOncelik) {
      case 0:
        return const CircleAvatar(
            radius: 26,
            backgroundColor: Color(0xffFBBA72),
            child: Text(
              "DÜŞÜK",
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xffCA5310),
                  fontWeight: FontWeight.bold),
            ));

      case 1:
        return const CircleAvatar(
            radius: 26,
            backgroundColor: Color(0xffFBBA72),
            child: Text(
              "ORTA",
              style: TextStyle(
                  color: Color(0xffBB4D00), fontWeight: FontWeight.bold),
            ));
      case 2:
        return const CircleAvatar(
            radius: 26,
            backgroundColor: Color(0xffFBBA72),
            child: Text(
              "ACİL",
              style: TextStyle(
                  color: Color(0xff691E06), fontWeight: FontWeight.bold),
            ));
    }
  }

  _notSil(int notID) {
    databaseHelper.notSil(notID).then((silinenID) {
      if (silinenID != 0) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.black, content: Text("Not Silindi")));

        setState(() {});
      }
    });
  }
}
