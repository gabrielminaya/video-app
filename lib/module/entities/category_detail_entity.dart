class CategoryDetailEntity {
  final String name;
  final String url;
  final String? imageUrl;

  CategoryDetailEntity({
    required this.name,
    required this.url,
    this.imageUrl,
  });
}
