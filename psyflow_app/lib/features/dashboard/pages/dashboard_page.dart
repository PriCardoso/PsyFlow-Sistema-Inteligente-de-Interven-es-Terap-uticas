import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PsyFlow'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: const [
            DashboardCard(
              title: "Pacientes",
              icon: Icons.people,
            ),
            DashboardCard(
              title: "Tarefas",
              icon: Icons.task_alt,
            ),
            DashboardCard(
              title: "Mapa Emocional",
              icon: Icons.favorite,
            ),
            DashboardCard(
              title: "Plano Terapêutico",
              icon: Icons.route,
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50),
            const SizedBox(height: 12),
            Text(title),
          ],
        ),
      ),
    );
  }
}