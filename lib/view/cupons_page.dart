import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:menu_vizinho_mobile/view/cardapio_page.dart';
import 'package:menu_vizinho_mobile/view/home_page.dart';
import 'package:menu_vizinho_mobile/view/ofertas_page.dart';
import 'package:menu_vizinho_mobile/view/politica_page.dart';

class CuponsPage extends StatefulWidget {
  const CuponsPage({super.key});

  @override
  State<CuponsPage> createState() => _CuponsPageState();
}

class _CuponsPageState extends State<CuponsPage> {
  List<dynamic> cupons = [];

  bool isLoading = true;
  int _selectedIndex = 2; // Índice inicial do item selecionado (cupons)

  Future<void> listaCupons() async {
    try {
      final response =
          // await http.get(Uri.parse('http://10.56.46.42/public/api/cupom'));
      await http.get(Uri.parse('http://192.168.0.5/public/api/cupom'));
      if (response.statusCode == 200) {
        setState(() {
          cupons = json.decode(response.body);
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
  void initState() {
    super.initState();
    listaCupons();
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
          : cupons.isEmpty
              ? const Center(child: Text('Você não possui cupons disponíveis'))
              : ListView.builder(
                  itemCount: cupons.length,
                  itemBuilder: (context, index) {
                    final cupom = cupons[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset('assets/images/cupom-carrinho.png',
                                  width: 60),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cupom[0]['nome_cupom'],
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff8c6342)),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(cupom[0]['descricao_cupom']),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Acaba em ${cupom[0]['horas_restantes']}h',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 8),
                                  TextButton(
                                    onPressed: () {
                                      // Navegação para a página de regras
                                      Navigator.pushNamed(context, '/regras');
                                    },
                                    child: const Text(
                                      'Regras',
                                      style:
                                          TextStyle(color: Color(0xff8c6342)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
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
