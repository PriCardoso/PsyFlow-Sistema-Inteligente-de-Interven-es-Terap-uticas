import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {

  final supabase = Supabase.instance.client;

  Future<void> saveRole(
    String role,
  ) async {

    final user = supabase.auth.currentUser!;

    await supabase
        .from('users')
        .update({
          'role': role,
        })
        .eq(
          'id',
          user.id,
        );
  }
}