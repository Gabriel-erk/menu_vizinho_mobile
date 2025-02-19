import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:menu_vizinho_mobile/controller/autenticacao_controller.dart';
import 'package:menu_vizinho_mobile/view/tela_login.dart';

void main() {
  runApp(
    MultiProvider(
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white70),
        ),
      ),
      // darkTheme: ThemeData(
      //   brightness: Brightness.dark,
      //   appBarTheme: const AppBarTheme(
      //     iconTheme: IconThemeData(color: Colors.white),
      //   ),
      // ),
      themeMode: ThemeMode.system, // Alterna entre claro e escuro automaticamente
      home: const TelaLogin(),
    );
  }
}
