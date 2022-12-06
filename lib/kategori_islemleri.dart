// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_not_sepeti/utils/database_helper.dart';

import 'package:flutter_not_sepeti/models/kategori.dart';

class Kategoriler extends StatefulWidget {
  @override
  _KategorilerState createState() => _KategorilerState();
}

class _KategorilerState extends State<Kategoriler> {
  List<Kategori>? tumKategoriler;
  late DatabaseHelper databaseHelper;

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyleBaslik = Theme.of(context).textTheme.bodyText2!.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        fontFamily: 'Montserrat',
        color: const Color(0xff8f250C));

    if (tumKategoriler == null) {
      tumKategoriler = <Kategori>[];
      kategoriListesiniGuncelle();
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 20,
        backgroundColor: const Color(0xff8f250C),
        title: const Text("Kategoriler"),
      ),
      body: ListView.builder(
          itemCount: tumKategoriler!.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () => _kategoriGuncelle(tumKategoriler![index], context),
              title: Text(
                tumKategoriler![index].kategoriBaslik.toString(),
                style: textStyleBaslik,
              ),
              trailing: InkWell(
                child: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onTap: () =>
                    _kategoriSil(tumKategoriler![index].kategoriID!.toInt()),
              ),
              leading: const Icon(
                Icons.import_contacts,
                color: Color(0xff8f250C),
              ),
            );
          }),
    );
  }

  void kategoriListesiniGuncelle<Kategori>() {
    databaseHelper.kategoriListesiniGetir().then((kategorileriIcerenList) {
      setState(() {
        tumKategoriler = kategorileriIcerenList;
      });
    });
  }

  _kategoriSil(int kategoriID) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text("Kategori Sil ",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff8f250C),
                  fontWeight: FontWeight.w700,
                )),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                    "Kategoriyi sildiğinizde bununla ilgili tüm notlar da silinecektir.\n\nEmin Misiniz ?"),
                ButtonBar(
                  children: <Widget>[
                    OutlinedButton(
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(color: Color(0xff8f250C)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Vazgeç",
                        style: TextStyle(
                            color: Color(0xff8f250C),
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    OutlinedButton(
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(color: Color(0xff8f250C)),
                      ),
                      onPressed: () {
                        databaseHelper
                            .kategoriSil(kategoriID)
                            .then((silinenKategori) {
                          if (silinenKategori != 0) {
                            setState(() {
                              kategoriListesiniGuncelle();
                              Navigator.pop(context);
                            });
                          }
                        });
                      },
                      child: const Text(
                        "Sil",
                        style: TextStyle(
                            color: Color(0xff8f250C),
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  _kategoriGuncelle(Kategori guncellenecekKategori, BuildContext c) {
    kategoriGuncelleDialog(c, guncellenecekKategori);
  }

  void kategoriGuncelleDialog(
      BuildContext myContext, Kategori guncellenekKategori) {
    var formKey = GlobalKey<FormState>();
    String? guncellenecekKategoriAdi;

    showDialog(
        barrierDismissible: false,
        context: myContext,
        builder: (context) {
          return SimpleDialog(
            title: const Text(
              "Kategori Güncelle",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w700,
                  color: Colors.blueGrey),
            ),
            children: <Widget>[
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: guncellenekKategori.kategoriBaslik,
                    onSaved: (yeniDeger) {
                      guncellenecekKategoriAdi = yeniDeger!;
                    },
                    decoration: const InputDecoration(
                      labelText: "Kategori Adı",
                      border: OutlineInputBorder(),
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
                  OutlinedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xff8f250C), // background
                      onPrimary: Colors.amber, // foreground
                    ),
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
                  OutlinedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();

                        databaseHelper
                            .kategoriGuncelle(Kategori?.withID(
                                guncellenekKategori.kategoriID,
                                guncellenecekKategoriAdi!))
                            .then((katID) {
                          if (katID != 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Kategori Güncellendi"),
                                duration: Duration(seconds: 1),
                              ),
                            );
                            kategoriListesiniGuncelle();
                            Navigator.of(context).pop();
                          }
                        });
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(width: 2, color: Color(0xff8f250C)),
                    ),
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
}