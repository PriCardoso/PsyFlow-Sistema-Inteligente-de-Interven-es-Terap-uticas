import 'package:supabase_flutter/supabase_flutter.dart';
 
class InviteService {
  final supabase = Supabase.instance.client;
 
  /// Gera um código de convite único para o psicólogo
  Future<String> generateInvite() async {
    final user = supabase.auth.currentUser!;
 
    // Gera código via função do banco
    final codeResult = await supabase.rpc('generate_invite_code');
    final code = codeResult as String;
 
    await supabase.from('invites').insert({
      'psychologist_id': user.id,
      'code': code,
    });
 
    return code;
  }
 
  /// Lista todos os convites do psicólogo
  Future<List<Map<String, dynamic>>> getMyInvites() async {
    final user = supabase.auth.currentUser!;
 
    final data = await supabase
        .from('invites')
        .select()
        .eq('psychologist_id', user.id)
        .order('created_at', ascending: false);
 
    return List<Map<String, dynamic>>.from(data);
  }
 
  /// Paciente usa o código para se vincular ao psicólogo
  Future<void> useInvite(String code) async {
    final patient = supabase.auth.currentUser!;
 
    // Busca o convite pelo código
    final invite = await supabase
        .from('invites')
        .select()
        .eq('code', code.toUpperCase().trim())
        .eq('used', false)
        .maybeSingle();
 
    if (invite == null) {
      throw Exception('Código inválido ou já utilizado.');
    }
 
    // Verifica se não expirou
    final expiresAt = DateTime.parse(invite['expires_at']);
    if (DateTime.now().isAfter(expiresAt)) {
      throw Exception('Este código expirou. Peça um novo ao seu psicólogo.');
    }
 
    // Verifica se paciente não está tentando usar o próprio convite
    if (invite['psychologist_id'] == patient.id) {
      throw Exception('Você não pode usar seu próprio convite.');
    }
 
    // Cria o vínculo
    await supabase.from('links').insert({
      'psychologist_id': invite['psychologist_id'],
      'patient_id': patient.id,
      'invite_id': invite['id'],
    });
 
    // Marca convite como usado
    await supabase.from('invites').update({
      'used': true,
      'used_by': patient.id,
    }).eq('id', invite['id']);
  }
 
  /// Lista pacientes vinculados ao psicólogo
  Future<List<Map<String, dynamic>>> getMyPatients() async {
    final user = supabase.auth.currentUser!;
 
    final data = await supabase
        .from('links')
        .select('*, patient:patient_id(id, full_name, email, bio)')
        .eq('psychologist_id', user.id)
        .eq('active', true);
 
    return List<Map<String, dynamic>>.from(data);
  }
 
  /// Retorna o psicólogo vinculado ao paciente
  Future<Map<String, dynamic>?> getMyPsychologist() async {
    final user = supabase.auth.currentUser!;
 
    final data = await supabase
        .from('links')
        .select('*, psychologist:psychologist_id(id, full_name, email, crp, bio)')
        .eq('patient_id', user.id)
        .eq('active', true)
        .maybeSingle();
 
    return data;
  }
}