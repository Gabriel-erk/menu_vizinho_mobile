import 'package:flutter/material.dart';

class ProdutoPage extends StatelessWidget {
  final Map<String, dynamic> produto;

  const ProdutoPage({super.key, required this.produto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          // mainAxis é usado em Row (agrupa na horizontal, e é tipo o jusify content do flex)
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //logo no canto esquerdo
            Image.asset(
              'assets/bua3.png',
              height: 40, // altura da logo
            ),
            const Icon(Icons.shopping_bag)
          ],
        ),
        // definindo cor de fundo da appBar (basicamente a navbar daqui)
        backgroundColor: const Color(0xff8c6342),
      ),
    );
  }
}
