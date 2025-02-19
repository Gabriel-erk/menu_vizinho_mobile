import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProdutoPage extends StatefulWidget {
  final Map<String, dynamic> produto;

  const ProdutoPage({super.key, required this.produto});

  @override
  State<ProdutoPage> createState() => _ProdutoPageState();
}

class _ProdutoPageState extends State<ProdutoPage> {
  List<dynamic> _adicionaisCategorias = [];
  List<dynamic> _adicionaisSubCategorias = [];

  @override
  void initState() {
    super.initState();
    _fetchAdicionais();
  }

  Future<void> _fetchAdicionais() async {
  try {
    final response = await http.get(
      Uri.parse('http://10.56.46.42/public/api/produtos/produto/${widget.produto['id']}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (mounted) {
        setState(() {
          _adicionaisCategorias = data[1]; // Lista de adicionais por categoria
          _adicionaisSubCategorias = data[2]; // Lista de adicionais por subcategoria
        });
      }
    } else {
      throw Exception("Erro ao carregar adicionais");
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao carregar adicionais: $e")),
      );
    }
  }
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
            ),
          ],
        ),
        backgroundColor: const Color(0xff8c6342),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 310,
              width: double.infinity,
              color: const Color(0xfff9eed9),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    widget.produto['imagem'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.produto['nome'],
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 27,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff8c6342),
                        ),
                      ),
                      Text(
                        'R\$ ${double.parse(widget.produto['preco']).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff8c6342),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      widget.produto['descricao'],
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xffacacac),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Seção de Informações Nutricionais
            ExpansionTile(
              title: const Text(
                "Informações Nutricionais",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff8c6342),
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.produto['info_nutricional'],
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      color: Color(0xff7c7c7c),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Seção de Adicionais (Dinâmica)
            ExpansionTile(
              title: const Text(
                "Adicionais - Escolha até 5 opções",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff8c6342),
                ),
              ),
              children: [
                if (_adicionaisCategorias.isNotEmpty || _adicionaisSubCategorias.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ..._adicionaisCategorias.take(2).map(
                          (adicional) => ListTile(
                            leading: const Icon(Icons.check_circle, color: Color(0xff8c6342)),
                            title: Text(adicional['nome']),
                          ),
                        ),
                        ..._adicionaisSubCategorias.take(2).map(
                          (adicional) => ListTile(
                            leading: const Icon(Icons.check_circle, color: Color(0xff8c6342)),
                            title: Text(adicional['nome']),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Nenhum adicional disponível",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 40),

            // Botão de Finalizar Compra
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff8c6342),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Finalizar compra',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
