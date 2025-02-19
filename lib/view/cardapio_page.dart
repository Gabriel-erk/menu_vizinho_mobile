import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// biblioteca para carrosel
import 'package:carousel_slider/carousel_slider.dart';
import 'package:menu_vizinho_mobile/view/cupons_page.dart';
import 'package:menu_vizinho_mobile/view/home_page.dart';
import 'package:menu_vizinho_mobile/view/ofertas_page.dart';
import 'package:menu_vizinho_mobile/view/politica_page.dart';

import 'package:menu_vizinho_mobile/view/produto_page.dart';
import 'package:menu_vizinho_mobile/view/sobre_page.dart';

class CardapioPage extends StatefulWidget {
  const CardapioPage({super.key});

  @override
  State<CardapioPage> createState() => _CardapioPageState();
}

class _CardapioPageState extends State<CardapioPage> {
  List<dynamic> categorias = [];
  List<dynamic> subCategorias = [];
  List<dynamic> banners = [];
  List<dynamic> bannersFromApi = [];

// Controlador de rolagem
// tentar colocar  final   ScrollController _scrollController = ScrollController(); caso de algum erro
  ScrollController _scrollController = ScrollController();

  // Função para rolar até a parte específica
  void scrollToCategory(int index, String tipo) {
    double position = 0;

    // Ajuste para categorias
    if (tipo == "categoria") {
      position = 100.0 * index; // Posição com base no índice da categoria
    }
    // Ajuste para subcategorias
    else if (tipo == "subcategoria") {
      position = 100.0 * index + 300.0; // Subcategorias começam após categorias
    }

    _scrollController.animateTo(position,
        duration: Duration(seconds: 1), curve: Curves.easeInOut);
  }

  bool isLoading = true;
  int _selectedIndex = 3; // Índice inicial do item selecionado (Cardápio)

  @override
  void initState() {
    super.initState();
    listaBanners(); // Carregar banners
    listaCardapio();
    _scrollController = ScrollController();
  }

  Future<void> listaCardapio() async {
    try {
      final response =
          // await http.get(Uri.parse('http://10.56.46.42/public/api/cardapio'));
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
          // await http.get(Uri.parse('http://10.56.46.42/public/api/banner'));
          await http.get(Uri.parse('http://192.168.0.5/public/api/banner'));
      if (response.statusCode == 200) {
        setState(() {
          // Decodificando a resposta JSON
          bannersFromApi = json.decode(response.body);

          // Acessando o primeiro item da lista principal
          banners =
              bannersFromApi[0]; // Aqui você acessa o primeiro array de banners

          // Agora, você pode filtrar os banners por categoria 'cardapio'
          banners = banners
              .where((banner) => banner['categoria'] == 'cardapio')
              .toList();

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
          children: [
            const SizedBox(
              height: 100,
              child: DrawerHeader(
                  decoration: BoxDecoration(color: Color(0xff8c6342)),
                  padding: EdgeInsets.symmetric(vertical: 28, horizontal: 16),
                  child: Text(
                    "Mr.Burger App",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xfff9eed9)),
                  )),
            ),
            const ListTile(
              leading: Icon(Icons.verified_user_rounded),
              title: Text("Minha conta"),
            ),
            const ListTile(
              leading: Icon(Icons.cast_sharp),
              title: Text("Meus pedidos"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.policy),
              title: const Text("Sobre o Mr.Burger"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SobrePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.policy),
              title: const Text("Políticas do Mr.Burger"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PoliticaPage()),
                );
              },
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.logout),
              title: Text("Sair"),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              controller: _scrollController, // Associe o controller aqui
              children: [
                // Carrossel de banners com a biblioteca carousel_slider
                if (banners.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CarouselSlider.builder(
                      itemCount: banners.length,
                      itemBuilder: (context, index, realIndex) {
                        final banner = banners[
                            index]; // banner é agora um objeto, não uma lista
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            banner[
                                'imagem']!, // Acesso correto ao valor 'imagem'
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: 200, // Ajuste a altura do carrossel
                        autoPlay: true, // Ativa a rotação automática
                        enlargeCenterPage: true, // Enlarge center item
                        aspectRatio: 16 / 9, // Ajuste a proporção das imagens
                        viewportFraction:
                            0.8, // A fração da tela que cada item ocupa
                      ),
                    ),
                  ),

                // Listar Categorias e Subcategorias no topo
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // Exibe as Categorias
                        ...categorias.map((categoria) {
                          int index = categorias.indexOf(categoria);
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                scrollToCategory(index, "categoria");
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
                          int index = subCategorias.indexOf(subCategoria);
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                scrollToCategory(index, "subcategoria");
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
                // Listar Sub categorias
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categorias.length,
                  itemBuilder: (context, index) {
                    final subCategoria = subCategorias[index];
                    final produtos = subCategoria['produtos'];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            subCategoria['titulo_sub_categoria'],
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
              break;
            case 1:
              // Navegação para a página de Ofertas
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OfertasPage(),
                ),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CuponsPage(),
                ),
              );
              break;
            case 3:
              // Navegação para a página de Cardápio
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CardapioPage(),
                ),
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
