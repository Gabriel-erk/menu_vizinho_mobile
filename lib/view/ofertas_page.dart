import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// biblioteca para carrosel
import 'package:carousel_slider/carousel_slider.dart';
import 'package:menu_vizinho_mobile/view/cardapio_page.dart';
import 'package:menu_vizinho_mobile/view/cupons_page.dart';
import 'package:menu_vizinho_mobile/view/home_page.dart';
import 'package:menu_vizinho_mobile/view/oferta_page.dart';
import 'package:menu_vizinho_mobile/view/politica_page.dart';

class OfertasPage extends StatefulWidget {
  const OfertasPage({super.key});

  @override
  State<OfertasPage> createState() => _OfertasPageState();
}

class _OfertasPageState extends State<OfertasPage> {
  List<dynamic> produtos = [];
  List<dynamic> banners = [];
  List<dynamic> bannersFromApi = [];

  bool isLoading = true;
  int _selectedIndex = 1; // Índice inicial do item selecionado (ofertas)

  @override
  void initState() {
    super.initState();
    listaBanners(); // Carregar banners
    listaOfertas();
  }

  Future<void> listaOfertas() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.56.46.42/public/api/ofertas'));
      // await http.get(Uri.parse('http://192.168.0.5/public/api/ofertas'));
      if (response.statusCode == 200) {
        setState(() {
          produtos = json.decode(response.body);
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
          await http.get(Uri.parse('http://10.56.46.42/public/api/banner'));
      // await http.get(Uri.parse('http://192.168.0.5/public/api/banner'));
      if (response.statusCode == 200) {
        setState(() {
          // Decodificando a resposta JSON
          bannersFromApi = json.decode(response.body);

          // Acessando o primeiro item da lista principal
          banners =
              bannersFromApi[0]; // Aqui você acessa o primeiro array de banners

          // Agora, você pode filtrar os banners por categoria 'cardapio'
          banners = banners
              .where((banner) => banner['categoria'] == 'ofertas')
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
                    "Olá, Gabriel Lindão",
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
            const ListTile(
              leading: Icon(Icons.info),
              title: Text("Sobre o Mr.Burger"),
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

                // Listar produtos
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: produtos.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                        OfertaPage(produto: produto),
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
                                        width: 130,
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
