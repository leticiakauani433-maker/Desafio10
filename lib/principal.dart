import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: Principal(),
  ));
}

class Principal extends StatelessWidget {
  const Principal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Principal'),
      ),

      // Menu lateral
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text('MENU'),
            ),

            // Opção Principal
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Principal'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

             // Opção GPS
            ListTile(
              leading: const Icon(Icons.add_location),
              title: const Text('GPS'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            // Opção CNPJ
            ListTile(
              leading: const Icon(Icons.temple_buddhist),
              title: const Text('CNPJ'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

             // Opção CEP
            ListTile(
              leading: const Icon(Icons.add_location_alt_outlined),
              title: const Text('CEP'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            // Opção Logout
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      // Conteúdo da tela
      body: const Center(
        child: Text(
          'Tela Principal',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}