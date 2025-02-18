import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// biblioteca para carrosel
import 'package:carousel_slider/carousel_slider.dart';
import 'package:menu_vizinho_mobile/view/cardapio_page.dart';
import 'package:menu_vizinho_mobile/view/cupons_page.dart';
import 'package:menu_vizinho_mobile/view/ofertas_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> produtos = [];
  List<dynamic> banners = [];
  List<dynamic> bannersFromApi = [];

  bool isLoading = true;
  int _selectedIndex = 0; // Índice inicial do item selecionado (home)

  Future<void> produtosHome() async {
    try {
      final response =
          // await http.get(Uri.parse('http://10.56.45.27/public/api/cardapio'));
          await http.get(Uri.parse('http://192.168.0.5/public/api/produtos'));
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

// diferente do restante esse pega todos os banners, tanto de cardápio quanto de ofertas
  Future<void> listaBanners() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.0.5/public/api/banner'));
      if (response.statusCode == 200) {
        setState(() {
          // Decodificando a resposta JSON
          bannersFromApi = json.decode(response.body);

          // Acessando o primeiro item da lista principal
          banners =
              bannersFromApi[0]; // Aqui você acessa o primeiro array de banners

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
  void initState() {
    super.initState();
    produtosHome();
    listaBanners();
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
              leading: Icon(Icons.verified_user_rounded),
              title: Text("Minha conta"),
            ),
            ListTile(
              leading: Icon(Icons.cast_sharp),
              title: Text("Meus pedidos"),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("Sobre o Mr.Burger"),
            ),
            ListTile(
              leading: Icon(Icons.policy),
              title: Text("Políticas do Mr.Burger"),
            ),
            Divider(),
            ListTile(
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
                // restante aqui
               Padding(
  padding: const EdgeInsets.all(10.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // Seção Ofertas Especiais
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.local_offer, color: Color(0xff8c6342)),
          SizedBox(width: 8),
          Text(
            "Ofertas Especiais",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xff8c6342)),
          ),
        ],
      ),
      SizedBox(
        height: 180,
        child: Center(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: (produtos.length > 2) ? 2 : produtos.length, 
            itemBuilder: (context, index) {
              final produto = produtos[index];
              return Container(
                width: 160,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Color(0xfff9eed9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      produto['imagem'],
                      height: 110,
                      width: 130,
                      fit: BoxFit.cover,
                    ),
                    Text(
                      produto['nome'],
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xff8c6342)),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),

      const SizedBox(height: 20),

      // Seção Pratos Populares
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.restaurant, color: Color(0xff8c6342)),
          SizedBox(width: 8),
          Text(
            "Pratos Populares",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xff8c6342)),
          ),
        ],
      ),
      SizedBox(
        height: 180,
        child: Center(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: (produtos.length > 4) ? 4 : produtos.length,
            itemBuilder: (context, index) {
              final produto = produtos[(index + 2) % produtos.length]; 
              return Container(
                width: 160,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Color(0xfff9eed9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      produto['imagem'],
                      height: 110,
                      width: 130,
                      fit: BoxFit.cover,
                    ),
                    Text(
                      produto['nome'],
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xff8c6342)),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),

      const SizedBox(height: 20),

      // Seção Sugestões
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.thumb_up, color: Color(0xff8c6342)),
          SizedBox(width: 8),
          Text(
            "Sugestões",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xff8c6342)),
          ),
        ],
      ),
      SizedBox(
        height: 180,
        child: Center(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: (produtos.length > 4) ? 4 : produtos.length,
            itemBuilder: (context, index) {
              final produto = produtos[(index + 3) % produtos.length]; 
              return Container(
                width: 160,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Color(0xfff9eed9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      produto['imagem'],
                      height: 110,
                      width: 130,
                      fit: BoxFit.cover,
                    ),
                    Text(
                      produto['nome'],
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xff8c6342)),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    ],
  ),
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
