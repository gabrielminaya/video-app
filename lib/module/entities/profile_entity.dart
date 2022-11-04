class ProfileEntity {
  final String id;
  final bool admin;
  final List<String> categories;

  ProfileEntity({
    required this.id,
    required this.admin,
    required this.categories,
  });
}
