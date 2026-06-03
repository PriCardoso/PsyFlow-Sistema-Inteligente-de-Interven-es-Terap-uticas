import 'package:supabase_flutter/supabase_flutter.dart';

class TaskService {
  final supabase = Supabase.instance.client;

  Future<void> createTask({
    required String patientId,
    required String title,
    required String description,
    required String category,
  }) async {
    final user = supabase.auth.currentUser;

    await supabase.from('tasks').insert({
      'patient_id': patientId,
      'psychologist_id': user!.id,
      'workspace_id': (await supabase.from('users')
              .select('workspace_id')
              .eq('id', user.id)
              .single())['workspace_id'],
      'title': title,
      'description': description,
      'category': category,
      'status': 'pending',
    });
  }
}

Future<List<dynamic>> getPatientTasks(String patientId) async {
  final data = await supabase
      .from('tasks')
      .select()
      .eq('patient_id', patientId)
      .order('created_at', ascending: false);

  return data;
}

Future<void> completeTask(String taskId) async {
  await supabase.from('tasks').update({
    'status': 'completed',
    'completed_at': DateTime.now().toIso8601String(),
  }).eq('id', taskId);
}

Future<void> sendResponse({
  required String taskId,
  required String response,
}) async {
  final user = supabase.auth.currentUser;

  await supabase.from('task_responses').insert({
    'task_id': taskId,
    'patient_id': user!.id,
    'response_text': response,
  });
}