import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:menu_vizinho_mobile/produto_page.dart';

class CardapioPage extends StatefulWidget {
  const CardapioPage({super.key});

  @override
  State<CardapioPage> createState() => _CardapioPageState();
}

class _CardapioPageState extends State<CardapioPage> {
  List<dynamic> categorias = [];
  List<dynamic> subCategorias = [];
  List<dynamic> banners = [];
  bool isLoading = true;
  int _selectedIndex = 3; // Índice inicial do item selecionado (Cardápio)

  @override
  void initState() {
    super.initState();
    listaCardapio();
  }

  Future<void> listaCardapio() async {
    try {
      final response =
          // await http.get(Uri.parse('http://10.56.45.27/public/api/cardapio'));
          await http.get(Uri.parse('http://192.168.0.5/public/api/cardapio'));
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

  Future<void> listaBanners() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.0.5/public/api/banner'));
      if (response.statusCode == 200) {
        setState(() {
          banners = json.decode(response.body);
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
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.shopping_bag,
              color: Color(0xfff9eed9),
            )
          ],
        ),
        backgroundColor: const Color(0xff8c6342),
      ),
      drawer: Drawer(
        child: ListView(
          children: const [
            SizedBox(
              height: 100,
              child: DrawerHeader(
                  decoration: BoxDecoration(color: Color(0xff8c6342)),
                  padding: EdgeInsets.symmetric(vertical: 28, horizontal: 16),
                  child: Text(
                    "Olá, Gabriel Lindão",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xfff9eed9)),
                  )),
            ),
            ListTile(
              leading: Icon(Icons.login),
              title: Text("Login"),
            ),
            ListTile(
              leading: Icon(Icons.app_registration),
              title: Text("Cadastrar"),
            ),
            ListTile(
              leading: Icon(Icons.feedback),
              title: Text("FeedBacks"),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("Sobre  o Mr.Burger"),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // Listar Categorias e Subcategorias no topo
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // Exibe as Categorias
                        ...categorias.map((categoria) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                // Ação para exibir produtos da categoria
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff8c6342),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                              child: Text(
                                categoria['titulo_categoria'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        // Exibe as Subcategorias
                        ...subCategorias.map((subCategoria) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                // Ação para exibir produtos da subcategoria
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff8c6342),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                              child: Text(
                                subCategoria['titulo_sub_categoria'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),

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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            categoria['titulo_categoria'],
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff8c6342),
                            ),
                          ),
                        ),
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
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 5,
                                margin: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
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
                                                fontFamily: 'Poppins',
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xff8c6342),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              produto['descricao'],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xffacacac),
                                              ),
                                            ),
                                            const SizedBox(height: 15),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'R\$ ${double.parse(produto['preco']).toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xff8c6342),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                      Icons
                                                          .shopping_cart_outlined,
                                                      color: Color(0xff8c6342)),
                                                  onPressed: () {
                                                    // Ação do botão
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: Image.network(
                                        produto['imagem'],
                                        width: 150,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xff8c6342),
        selectedItemColor: Colors.white, // Cor do item selecionado
        unselectedItemColor: Colors.white70, // Cor dos itens não selecionados
        currentIndex: _selectedIndex, // Índice do item selecionado
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          // Ação para cada item
          switch (index) {
            case 0:
              print('Home');
              break;
            case 1:
              print('Ofertas');
              break;
            case 2:
              print('Cupons');
              break;
            case 3:
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CardapioPage(),
                    ),
                  );
                },
              );
              break;
            default:
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            label: 'Ofertas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Cupons',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Cardápio',
          ),
        ],
      ),
    );
  }
}
