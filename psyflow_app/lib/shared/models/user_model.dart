class AppUser {
  final String id;
  final String email;
  final String role;
  final String? workspaceId;

  AppUser({
    required this.id,
    required this.email,
    required this.role,
    this.workspaceId,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'],
      email: map['email'],
      role: map['role'],
      workspaceId: map['workspace_id'],
    );
  }
}