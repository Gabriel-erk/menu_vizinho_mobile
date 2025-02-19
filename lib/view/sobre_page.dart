import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:menu_vizinho_mobile/view/cardapio_page.dart';
import 'dart:convert';
// páginas bottom navigator
import 'package:menu_vizinho_mobile/view/cupons_page.dart';
import 'package:menu_vizinho_mobile/view/home_page.dart';
import 'package:menu_vizinho_mobile/view/ofertas_page.dart';
import 'package:menu_vizinho_mobile/view/politica_page.dart';

class SobrePage extends StatefulWidget {
  const SobrePage({super.key});

  @override
  State<SobrePage> createState() => _SobrePageState();
}

class _SobrePageState extends State<SobrePage> {
  List<dynamic> infoLoja = [];
  var sobre = '';
  bool isLoading = true;
  int _selectedIndex =
      1; // Índice inicial do item selecionado ( não é nenhuma das opções que tenho)

  Future<void> sobreLoja() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.0.5/public/api/loja/sobre'));
      if (response.statusCode == 200) {
        setState(() {
          sobre = json.decode(
              utf8.decode(response.bodyBytes)); // Decodifica corretamente
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
          await http.get(Uri.parse('http://192.168.0.5/public/api/loja'));
      if (response.statusCode == 200) {
        setState(() {
          // Carrega o JSON na variável infoLoja
          infoLoja = json.decode(response.body);

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
    sobreLoja();
    informacoesLoja();
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(
                    infoLoja.isNotEmpty
                        ? 'http://192.168.0.5/public/${infoLoja[0]['imagem_sobre_restaurante']}'
                        : '',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported),
                  ),
                  const SizedBox(height: 20),
                  SelectableText(
                    sobre, // Exibe o texto da API
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.justify, // Mantém alinhado e legível
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Para aproveitar melhor os nossos serviços, visite o site: ',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    infoLoja.isNotEmpty
                        ? 'www.${infoLoja[0]['nome_loja']}.com'
                        : '',
                    style: const TextStyle(fontSize: 16, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                ],
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
