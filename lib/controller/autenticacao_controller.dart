import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AutenticacaoController with ChangeNotifier {
  bool _carregando =
      false; // váriavel para indicar se a autenticação está em andamento
  String?
      _token; // por conta do _ ele é uma váriavel privada e será acessada por outra classe (servico)

  bool get carregando => _carregando;

  String? get token => _token;

  Future acessar(String email, String senha) async {
    _carregando = false;

    notifyListeners();

    final resposta = await http.post(
      Uri.parse('http://10.56.46.42/public/api/login'),
      // Uri.parse('http://192.168.0.5/public/api/login'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json', // transforma em json
      },
      body: jsonEncode(
        {
          'email': email,
          'password': senha,
        },
      ),
    );
    _carregando = false;

    notifyListeners();
    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);
      _token = dados['token'];
      notifyListeners();
      return true; // retorna verdadeiro se a autenticação deu certo
    } else {
      return false;
    }
  }
}
