import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:menu_vizinho_mobile/view/cardapio_page.dart';
import 'dart:convert';
// páginas bottom navigator
import 'package:menu_vizinho_mobile/view/cupons_page.dart';
import 'package:menu_vizinho_mobile/view/home_page.dart';
import 'package:menu_vizinho_mobile/view/ofertas_page.dart';
import 'package:menu_vizinho_mobile/view/sobre_page.dart';

class PoliticaPage extends StatefulWidget {
  const PoliticaPage({super.key});

  @override
  State<PoliticaPage> createState() => _PoliticaPageState();
}

class _PoliticaPageState extends State<PoliticaPage> {
  List<dynamic> politica = [];
  List<dynamic> infoLoja = [];
  var updatedAt = '';
  bool isLoading = true;
  int _selectedIndex =
      1; // Índice inicial do item selecionado (10 pois não é nenhuma das opções que tenho)

  Future<void> listaPolitica() async {
    try {
      final response = await http
          // .get(Uri.parse('http://10.56.46.42/public/api/loja/politica'));
          .get(Uri.parse('http://192.168.0.5/public/api/loja/politica'));
      if (response.statusCode == 200) {
        setState(() {
          politica = json.decode(response.body);
          isLoading = false;
        });
      } else {
        mostrarError('Erro ao carregar dados');
      }
    } catch (e) {
      mostrarError('Erro: $e');
    }
  }

  Future<void> informacoesLoja() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.56.46.42/public/api/loja'));
      if (response.statusCode == 200) {
        setState(() {
          // Carrega o JSON na variável infoLoja
          infoLoja = json.decode(response.body);

          // Agora você pode acessar 'updated_at' da loja
          var loja = infoLoja[0]; // Acesse a primeira loja do array
          updatedAt = loja['updated_at']; // Acesse o 'updated_at' dessa loja

          // Imprimindo a data de atualização para debug
          // print('Data de atualização: $updatedAt');

          // Formatar a data (apenas dia, mês e ano)
          updatedAt =
              DateFormat('dd/MM/yyyy').format(DateTime.parse(updatedAt));

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
    listaPolitica();
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
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var bloco in politica)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bloco['titulo'],
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              bloco['conteudo'],
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    const Text(
                      "Ao utilizar nosso site, você concorda com esta Política de Privacidade. Se tiver dúvidas sobre nossas práticas de privacidade, entre em contato conosco.",
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Última atualização: $updatedAt",
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    )
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xff8c6342),
        selectedItemColor: Colors
            .white70, // Cor do item selecionado (deixando da mesma cor dos não selecionados, pois aqui ele não está em nenhuma opção da barra inferior, dessa forma não gera nenhum erro)
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
