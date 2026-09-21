import 'package:flutter/material.dart';


class Principal extends StatelessWidget {
  const Principal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Principal'),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tela Principal',
              style: TextStyle(fontSize: 32),
            ),

            SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Principal(),
                  ),
                );
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}