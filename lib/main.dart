import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const corPrincipal = Color(0xFF7B7D7D);
const corClara = Color(0xFFB2BABB);

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Inicial(),
    );
  }
}

// ================= TELA INICIAL =================

class Inicial extends StatelessWidget {
  const Inicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corPrincipal,
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const Login(),
              ),
            );
          },
          child: const Text('ENTRAR'),
        ),
      ),
    );
  }
}

// ================= LOGIN =================

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: corPrincipal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Usuário',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const Principal(),
                  ),
                );
              },
              child: const Text('ENTRAR'),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= PRINCIPAL =================

class Principal extends StatelessWidget {
  const Principal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Principal'),
        backgroundColor: corPrincipal,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: corPrincipal,
              ),
              child: Text(
                'MENU',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Consultar CEP'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const Cep(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.business),
              title: const Text('Consultar CNPJ'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const Cnpj(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.work),
              title: const Text('Trabalho'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const Trabalho(),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      body: const Center(
        child: Text(
          'Sejam Bem Vindos!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: corPrincipal,
          ),
        ),
      ),
    );
  }
}

// ================= CEP =================

class Cep extends StatefulWidget {
  const Cep({super.key});

  @override
  State<Cep> createState() => _CepState();
}

class _CepState extends State<Cep> {
  final cepController = TextEditingController();

  String logradouro = '';
  String bairro = '';
  String cidade = '';
  String estado = '';
  String cepResultado = '';
  String mensagem = '';

  Future<void> consultarCep() async {
    String numero = cepController.text.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );

    if (numero.length != 8) {
      setState(() {
        mensagem = 'Digite um CEP com 8 números.';
      });
      return;
    }

    try {
      final resposta = await http.get(
        Uri.parse(
          'https://viacep.com.br/ws/$numero/json/',
        ),
      );

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);

        if (dados['erro'] == true) {
          setState(() {
            mensagem = 'CEP não encontrado.';
            logradouro = '';
            bairro = '';
            cidade = '';
            estado = '';
            cepResultado = '';
          });
          return;
        }

        setState(() {
          logradouro =
              dados['logradouro']?.toString() ?? '';
          bairro =
              dados['bairro']?.toString() ?? '';
          cidade =
              dados['localidade']?.toString() ?? '';
          estado =
              dados['uf']?.toString() ?? '';
          cepResultado =
              dados['cep']?.toString() ?? '';
          mensagem = '';
        });
      } else {
        setState(() {
          mensagem = 'Erro ao consultar o CEP.';
        });
      }
    } catch (e) {
      setState(() {
        mensagem =
            'Não foi possível conectar com a API.';
      });
    }
  }

  @override
  void dispose() {
    cepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta de CEP'),
        backgroundColor: corPrincipal,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const Icon(
              Icons.location_on,
              size: 80,
              color: corPrincipal,
            ),

            const SizedBox(height: 20),

            TextField(
              controller: cepController,
              keyboardType: TextInputType.number,

              decoration: InputDecoration(
                labelText: 'Digite o CEP',
                hintText: '18132350',

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: consultarCep,

                style: ElevatedButton.styleFrom(
                  backgroundColor: corPrincipal,
                  foregroundColor: Colors.white,
                ),

                child: const Text('CONSULTAR CEP'),
              ),
            ),

            const SizedBox(height: 20),

            if (mensagem.isNotEmpty)
              Text(
                mensagem,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),

            if (logradouro.isNotEmpty)
              Card(
                color: corClara,

                child: Padding(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      const Text(
                        'Endereço encontrado',

                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        'Logradouro: $logradouro',
                      ),

                      Text(
                        'Bairro: $bairro',
                      ),

                      Text(
                        'Cidade: $cidade',
                      ),

                      Text(
                        'Estado: $estado',
                      ),

                      Text(
                        'CEP: $cepResultado',
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ================= CNPJ =================

class Cnpj extends StatefulWidget {
  const Cnpj({super.key});

  @override
  State<Cnpj> createState() => _CnpjState();
}

class _CnpjState extends State<Cnpj> {
  final cnpjController = TextEditingController();

  String resultado = '';
  bool carregando = false;

  Future<void> consultarCnpj() async {
    String numero = cnpjController.text.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );

    if (numero.length != 14) {
      setState(() {
        resultado =
            'Digite um CNPJ com 14 números.';
      });
      return;
    }

    setState(() {
      carregando = true;
      resultado = '';
    });

    try {
      final resposta = await http.get(
        Uri.parse(
          'https://api.opencnpj.org/$numero',
        ),
      );

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);

        setState(() {
          resultado =
              'CNPJ: ${dados['cnpj'] ?? numero}\n\n'
              'Razão Social: '
              '${dados['razao_social'] ?? 'Não informado'}\n\n'
              'Nome Fantasia: '
              '${dados['nome_fantasia'] ?? 'Não informado'}\n\n'
              'Situação: '
              '${dados['situacao_cadastral'] ?? 'Não informado'}\n\n'
              'Município: '
              '${dados['municipio'] ?? 'Não informado'}\n\n'
              'UF: '
              '${dados['uf'] ?? 'Não informado'}';
        });
      } else {
        setState(() {
          resultado = 'CNPJ não encontrado.';
        });
      }
    } catch (e) {
      setState(() {
        resultado =
            'Erro ao conectar com a API.';
      });
    } finally {
      setState(() {
        carregando = false;
      });
    }
  }

  @override
  void dispose() {
    cnpjController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta de CNPJ'),
        backgroundColor: corPrincipal,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const Icon(
              Icons.business,
              size: 80,
              color: corPrincipal,
            ),

            const SizedBox(height: 20),

            const Text(
              'Consulta de CNPJ',

              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: corPrincipal,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: cnpjController,
              keyboardType: TextInputType.number,

              decoration: InputDecoration(
                labelText: 'Digite o CNPJ',
                hintText: '03779133005670',

                prefixIcon: const Icon(
                  Icons.business,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed:
                    carregando ? null : consultarCnpj,

                style: ElevatedButton.styleFrom(
                  backgroundColor: corPrincipal,
                  foregroundColor: Colors.white,
                ),

                child: Text(
                  carregando
                      ? 'CONSULTANDO...'
                      : 'CONSULTAR CNPJ',
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (resultado.isNotEmpty)
              Card(
                color: corClara,

                child: Padding(
                  padding: const EdgeInsets.all(20),

                  child: SizedBox(
                    width: double.infinity,

                    child: Text(
                      resultado,

                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ================= TRABALHO =================

class Trabalho extends StatefulWidget {
  const Trabalho({super.key});

  @override
  State<Trabalho> createState() => _TrabalhoState();
}

class _TrabalhoState extends State<Trabalho> {
  int pagina = 0;

  final telas = const [
    Center(
      child: Text('Resumo'),
    ),

    Center(
      child: Text('Consultas'),
    ),

    Center(
      child: Text('Dólar'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trabalho'),
        backgroundColor: corPrincipal,
        foregroundColor: Colors.white,
      ),

      body: telas[pagina],

      bottomNavigationBar: NavigationBar(
        selectedIndex: pagina,

        onDestinationSelected: (index) {
          setState(() {
            pagina = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Resumo',
          ),

          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Consultas',
          ),

          NavigationDestination(
            icon: Icon(Icons.attach_money),
            label: 'Dólar',
          ),
        ],
      ),
    );
  }
}