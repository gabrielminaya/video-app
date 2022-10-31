class CategoryEntity {
  final String id;
  final String name;
  final String? imageUrl;

  CategoryEntity({
    required this.id,
    required this.name,
    this.imageUrl,
  });
}
