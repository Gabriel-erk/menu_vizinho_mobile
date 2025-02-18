import 'package:flutter/material.dart';
import 'package:menu_vizinho_mobile/controller/autenticacao_controller.dart';
import 'package:menu_vizinho_mobile/ofertas_page.dart';
import 'package:provider/provider.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginEstado();
}

class _TelaLoginEstado extends State<TelaLogin> {
  // váriaveis que terão os valores que serão passados para os campos do formulário
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  // váriavel responsável por controlar o formulário (irá ficar olhando para ver o formulário quando o usuário digitar algo)
  final GlobalKey<FormState> _chaveFormulario = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final autenticacaoController = Provider.of<AutenticacaoController>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // formulário
        child: Form(
          key: _chaveFormulario,
          // column me permite organizar os widgets em colunas, e vários por conta do children
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // todo textFormField tem um controller
              TextFormField(
                controller: _emailController,
                // decoração, o que aparece no campo quando está vazio (placeholder basicamente)
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                ),
                keyboardType: TextInputType.emailAddress,
                // validação do campo com função anônima, onde (valor! nunca será nullo, uso ! para dizer isso), se valor!.isEmpty (ou seja, se a váriavel valor for nulla) mostra o texto "informe um e-mail valido" se não, retorna nullo, ou seja, não mostra msg nenhuma
                validator: (valor) =>
                    valor!.isEmpty ? "Informe um e-mail válido" : null,
              ),
              TextFormField(
                controller: _senhaController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true, // esconde a senha
                validator: (valor) =>
                    valor!.isEmpty ? "Informe uma senha válida" : null,
              ),
              const SizedBox(
                height: 30,
              ),
              // se estiver carregando chama circularprogress (mostra um circulo enquanto carrega), se não chama o botão
              autenticacaoController.carregando
                  ? const LinearProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        //currentState!.validate() vai olhar todos os meus campos com validação e se todos estiverem válidos, ele não vai fazer nada, se algum campo não estiver válido , ele vai mostrar a msg de erro presente no validator de cada textFormField (chamando eles no onPressed pois não quero que consulte minha API para verificar se possue um registro com e-mail e senha vazios, q não é possivel, então se estiver assim nem olha minha api)
                        if (_chaveFormulario.currentState!.validate()) {
                          bool sucesso = await autenticacaoController.acessar(
                              _emailController.text, _senhaController.text);

                          if (sucesso) {
                            // push chama uma nova tela (pop volta)
                            // context é o contexto da minha tela, é a tela que estou agora (telaLogin), context é o context de 'buildCOntext' no parametro widget build lá no topo do código
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const OfertasPage()),
                            );
                          } else {
                            // se não der para logar (caso digite um e-mail e senha que não existam), aparece uma mini barra (tipo um alert) dizendo que "erro ao fazer o login"
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("E-mail ou senha inválido"),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text("Entrar"),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
