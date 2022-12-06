import 'package:flutter/material.dart';
import 'package:flutter_not_sepeti/not_listesi.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
       fontFamily: "Montserrat",
        primaryColor: const Color(0xff8f250C),
        backgroundColor: Colors.grey[300],
        appBarTheme: const AppBarTheme(color: Color(0xff8f250C)),
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: const Color(0xff8f250C)),
      ),
      home: const NotListesi(),
    );
  }
}
