import 'package:flutter/material.dart';
import 'package:menu_vizinho_mobile/cardapio_page.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    title: "MenuVizinho",
    debugShowCheckedModeBanner: false,
    // themeMode: ThemeData(),
    home: const CardapioPage(),
  ));
}
