import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_theme.dart';
import 'pages/login_page.dart';
import 'pages/complete_profile_page.dart';
import '../../dashboard/pages/psychologist_dashboard_page.dart';
import '../../dashboard/pages/patient_dashboard_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return StreamBuilder<AuthState>(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = supabase.auth.currentSession;

        // Não logado
        if (session == null) {
          return const LoginPage();
        }

        // Logado — buscar perfil para decidir a rota
        return FutureBuilder<Map<String, dynamic>?>(
          future: supabase
              .from('users')
              .select()
              .eq('id', session.user.id)
              .maybeSingle(),
          builder: (context, profileSnapshot) {
            if (profileSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                backgroundColor: AppColors.background,
                body: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              );
            }

            final profile = profileSnapshot.data;

            // Perfil não existe ou incompleto — ir para completar perfil
            if (profile == null || profile['profile_complete'] != true) {
              final role = profile?['role'] as String? ?? 'patient';
              return CompleteProfilePage(role: role);
            }

            // Redirecionar pelo role
            final role = profile['role'] as String?;

            if (role == 'psychologist') {
              return const PsychologistDashboardPage();
            }

            if (role == 'patient') {
              return const PatientDashboardPage();
            }

            // Role inválido — voltar para login
            return const LoginPage();
          },
        );
      },
    );
  }
}
