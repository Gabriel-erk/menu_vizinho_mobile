import 'package:flutter/material.dart';

class ProdutoPage extends StatelessWidget {
  final Map<String, dynamic> produto;

  const ProdutoPage({super.key, required this.produto});

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
      body: Column(
        children: [
          // Imagem com fundo colorido
          Container(
            height: 310,
            width: double.infinity,
            color: const Color(0xfff9eed9), // Cor de fundo da imagem
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image.network(
                produto['imagem'],
                fit: BoxFit.contain, // Ajusta a imagem dentro do container
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Alinha texto à esquerda
              children: [
                // envolvendo em uma row para deixa-los lado a lado
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
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 5), // Espaço entre nome e descrição
                // colocando dentro de um sizedbox para limitar até aonde vai se expandir o texto, não quero que fique até a outra borda do celular
                SizedBox(
                  width: 270, // Defiindo até aonde vai se expandir
                  child: Text(
                    produto['descricao'],
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffacacac),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              const Divider(),
              // vai servir para quando clicar em "informações nutricionais" descer uma "div" com as informações nutricionais do meu produto, leading, coloca um icone de '+' ao lado esquerdo do texto 'informações nutricionais e children é o conteúdo da "div" que vai descer
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
                // leading: const Icon(Icons.add,
                //     color: Color(0xff8c6342)),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          produto['info_nutricional'],
                          style: const TextStyle(
                              fontFamily: 'Poppins', fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(),
            ],
          ),
          Column(
            children: [
              const Divider(),
              // vai servir para quando clicar em "informações nutricionais" descer uma "div" com as informações nutricionais do meu produto, leading, coloca um icone de '+' ao lado esquerdo do texto 'informações nutricionais e children é o conteúdo da "div" que vai descer
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              produto['info_nutricional'],
                              style: const TextStyle(
                                  fontFamily: 'Poppins', fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                // style para alterar o estilo do botão
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff8c6342), // Cor de fundo
                  foregroundColor: Colors.white, // Cor do texto e icones
                  // adicionando o padding horizontal (x) e vertical (y)
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                child: const Text(
                  'Finalizar compra',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
