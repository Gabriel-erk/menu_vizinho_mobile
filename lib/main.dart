import 'package:menu_vizinho_mobile/controller/autenticacao_controller.dart';
import 'package:menu_vizinho_mobile/view/tela_login.dart';
import 'package:menu_vizinho_mobile/view/sobre_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    // chamando o provider que vai controlar a modificação de estado do nosso app
    MultiProvider(
      // controlador que vai faze a modificação de estado do nosso app
      providers: [
        ChangeNotifierProvider(create: (_) => AutenticacaoController())
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home:SobrePage() );
  }
}
