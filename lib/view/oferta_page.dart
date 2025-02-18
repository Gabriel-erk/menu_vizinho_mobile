import 'package:flutter/material.dart';

class OfertaPage extends StatelessWidget {
  final Map<String, dynamic> produto;

  const OfertaPage({super.key, required this.produto});

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
        // Torna a página rolável
        child: Column(
          children: [
            // Imagem com fundo colorido e bordas arredondadas
            Container(
              height: 310,
              width: double.infinity,
              color: const Color(0xfff9eed9),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ClipRRect(
                  // Borda arredondada na imagem
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    produto['imagem'],
                    fit: BoxFit.cover, // Ajusta melhor a imagem
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 15.0), // Aumenta a margem
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        produto['nome'],
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 27,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff8c6342),
                        ),
                      ),
                      Text(
                        'R\$ ${double.parse(produto['preco']).toStringAsFixed(2)}',
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
                    width: double.infinity, // Ajusta até a borda
                    child: Text(
                      produto['descricao'],
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
                    produto['info_nutricional'],
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

            // Seção de Adicionais
            const ExpansionTile(
              title: Text(
                "Adicionais - Escolha até 5 opções",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff8c6342),
                ),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading:
                            Icon(Icons.check_circle, color: Color(0xff8c6342)),
                        title: Text("Adicional 1"),
                      ),
                      ListTile(
                        leading:
                            Icon(Icons.check_circle, color: Color(0xff8c6342)),
                        title: Text("Adicional 2"),
                      ),
                      ListTile(
                        leading:
                            Icon(Icons.check_circle, color: Color(0xff8c6342)),
                        title: Text("Adicional 3"),
                      ),
                    ],
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        // Borda arredondada no botão
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
