import 'package:flutter/material.dart';
import 'package:menu_vizinho_mobile/cardapio_page.dart';
import 'package:menu_vizinho_mobile/ofertas_page.dart';

void main(List<String> args) {
  runApp(const MaterialApp(
    title: "MenuVizinho",
    debugShowCheckedModeBanner: false,
    // themeMode: ThemeData(),
    home: OfertasPage(),
  ));
}
