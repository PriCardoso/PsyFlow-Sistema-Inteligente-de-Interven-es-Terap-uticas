import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = supabase.auth.currentSession;

        if (session == null) {
          return const LoginPage();
        }

        return FutureBuilder(
          future: supabase
              .from('users')
              .select()
              .eq('id', session.user.id)
              .single(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final role = snapshot.data['role'];

            if (role == 'psychologist') {
              return const PsychologistDashboard();
            }

            if (role == 'patient') {
              return const PatientDashboard();
            }

            return const Scaffold(
              body: Center(child: Text("Role inválido")),
            );
          },
        );
      },
    );
  }
}