import 'package:flutter/material.dart';

class SelectRolePage extends StatelessWidget {
  const SelectRolePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolha seu perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [

            ElevatedButton(
              onPressed: () {},
              child: const Text(
                'Sou Psicólogo',
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {},
              child: const Text(
                'Sou Paciente',
              ),
            ),

          ],
        ),
      ),
    );
  }
}