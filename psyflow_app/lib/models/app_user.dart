class AppUser {
  final String id;
  final String email;
  final String role;
  final String? fullName;
  final String? workspaceId;

  AppUser({
    required this.id,
    required this.email,
    required this.role,
    this.fullName,
    this.workspaceId,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'],
      email: map['email'] ?? '',
      role: map['role'] ?? '',
      fullName: map['full_name'],
      workspaceId: map['workspace_id'],
    );
  }
}