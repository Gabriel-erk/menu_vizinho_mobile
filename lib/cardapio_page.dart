import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:menu_vizinho_mobile/produto_page.dart';

class CardapioPage extends StatefulWidget {
  const CardapioPage({Key? key}) : super(key: key);

  @override
  State<CardapioPage> createState() => _CardapioPageState();
}

class _CardapioPageState extends State<CardapioPage> {
  List<dynamic> categorias = [];
  List<dynamic> subCategorias = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    listaCardapio();
  }

  Future<void> listaCardapio() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.56.45.27/public/api/cardapio'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          categorias = data['categorias'];
          subCategorias = data['subCategorias'];
          isLoading = false;
        });
      } else {
        mostrarError('Erro ao carregar dados');
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
              'assets/bua3.png',
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
        backgroundColor: Color(0xfff9eed9),
        // child é um elemento filho de drawer
        // ListVIew é basicamente uma lista ul do html
        child: ListView(
          // elementos filhos da nossa lista
          children: const [
            // drawerHeader é basicamente o cabeçalho do menu lateral, o que aparecerá no topo
            SizedBox(
              height: 100,
              child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.brown),
                  padding: EdgeInsets.symmetric(vertical: 28, horizontal: 16),
                  child: Text(
                    "Olá, Gabriel Lindão",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
          : ListView(
              children: [
                // Listar Categorias
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categorias.length,
                  itemBuilder: (context, index) {
                    final categoria = categorias[index];
                    final produtos = categoria['produtos'];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título da Categoria
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            categoria['titulo_categoria'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff8c6342),
                            ),
                          ),
                        ),
                        // Lista de Produtos da Categoria
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: produtos.length,
                          itemBuilder: (context, prodIndex) {
                            final produto = produtos[prodIndex];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProdutoPage(produto: produto),
                                  ),
                                );
                              },
                              child: Card(
                                margin: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    // Informações do Produto
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              produto['nome'],
                                              style: const TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff8c6342)),
                                            ),
                                            Text(
                                              produto['descricao'],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xffacacac)),
                                            ),
                                            const SizedBox(height: 20),
                                            Text(
                                              'R\$ ${double.parse(produto['preco']).toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff8c6342),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Imagem do Produto
                                    Image.network(
                                      produto['imagem'],
                                      width: 110,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),

                // Listar Subcategorias
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: subCategorias.length,
                  itemBuilder: (context, index) {
                    final subCategoria = subCategorias[index];
                    final produtos = subCategoria['produtos'];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título da Subcategoria
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            subCategoria['titulo_sub_categoria'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff8c6342),
                            ),
                          ),
                        ),
                        // Lista de Produtos da Subcategoria
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: produtos.length,
                          itemBuilder: (context, prodIndex) {
                            final produto = produtos[prodIndex];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProdutoPage(produto: produto),
                                  ),
                                );
                              },
                              child: Card(
                                margin: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    // Informações do Produto
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              produto['nome'],
                                              style: const TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff8c6342)),
                                            ),
                                            Text(
                                              produto['descricao'],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xffacacac)),
                                            ),
                                            const SizedBox(height: 20),
                                            Text(
                                              'R\$ ${double.parse(produto['preco']).toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff8c6342),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Imagem do Produto
                                    Image.network(
                                      produto['imagem'],
                                      width: 110,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
    );
  }
}
