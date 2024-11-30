import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CardapioPage extends StatefulWidget {
  const CardapioPage({super.key});

  @override
  State<CardapioPage> createState() => _CardapioPageState();
}

class _CardapioPageState extends State<CardapioPage> {
  List<dynamic> produtos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    listaProdutos();
  }

  Future<void> listaProdutos() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.56.45.27/public/api/produtos'));
      if (response.statusCode == 200) {
        setState(() {
          produtos = json.decode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      mostrarError('Erro: $e');
    }
  }

  void mostrarError(String mensagem) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensagem)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            // mainAxis é usado em Row (agrupa na horizontal, e é tipo o jusify content do flex)
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //logo no canto esquerdo
              Image.asset(
                'bua3.png',
                height: 40, // altura da logo
              ),
              const Icon(Icons.shopping_bag)
            ],
          ),
          // definindo cor de fundo da appBar (basicamente a navbar daqui)
          backgroundColor: const Color(0xff8c6342),
        ),
        // coloca as três barrinhas no canto superior esquerdo, permitindo um menu lateral (basicamente um menu lateral)
        drawer: Drawer(
          // child é um elemento filho de drawer
          // ListVIew é basicamente uma lista ul do html
          child: ListView(
            // elementos filhos da nossa lista
            children: const [
              // drawerHeader é basicamente o cabeçalho do menu lateral, o que aparecerá no topo
              SizedBox(
                height: 100,
                child: DrawerHeader(
                    decoration: BoxDecoration(color: Colors.orange),
                    padding: EdgeInsets.symmetric(vertical: 28, horizontal: 16),
                    child: Text(
                      "Olá, Gabriel Lindão",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    )),
              ),
              // listTitle para tópico de lista
              ListTile(
                // leading posiciona do lado esquerdo, e está posicionado um icone no lado esquerdo
                leading: Icon(Icons.login),
                // este posiciona no lado direito
                // trailing: Icon(Icons.login),
                title: Text("Login"),
              ),
              ListTile(
                leading: Icon(Icons.list),
                title: Text("Serviços"),
              ),
              ListTile(
                leading: Icon(Icons.help),
                title: Text("Dúvidas"),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.info),
                title: Text("Sobre o BookMeNow"),
              ),
            ],
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: produtos.length,
                itemBuilder: (context, index) {
                  // Cada produto será armazenado na variável produto enquanto produtos é percorrido
                  final produto = produtos[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    color: const Color(0xFFfcfcfc),
                    child: Row(
                      children: [
                        // vai ter uma imagem da internet, pois o campo 'imagem' do meu objeto servicos, contém um link da internet que manda para uma imagem
                        Image.network(
                          produto['imagem'],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                produto['nome'],
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.start,
                              )
                            ],
                          ),
                        ))
                      ],
                    ),
                  );
                }));
  }
}
