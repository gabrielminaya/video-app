import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:video_api/module/entities/category_detail_entity.dart';
import 'package:video_api/module/entities/category_entity.dart';
import 'package:video_api/module/providers/pocketbase_provider.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository(ref.read(pocketBaseProvider));
});

class CategoryRepository {
  final PocketBase client;

  const CategoryRepository(this.client);

  Future<List<CategoryEntity>> getParentCategories(List<String> categories) async {
    try {
      final formattedCategories = categories.map((e) => "'$e'").join("|| id = ");

      final records = await client.records.getFullList(
        'categories',
        batch: 200,
        sort: '-name',
        filter: 'id = $formattedCategories',
      );

      return records.map((record) {
        String? imageUrl;
        if (record.data['image'].toString().isNotEmpty) {
          final image = client.records.getFileUrl(record, record.data['image']);
          imageUrl = "${client.baseUrl}${image.path}";
        }

        return CategoryEntity(id: record.id, name: record.data['name'], imageUrl: imageUrl);
      }).toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<List<CategoryEntity>> getCategoriesByParent(CategoryEntity parent) async {
    try {
      final records = await client.records.getFullList(
        'categories',
        batch: 200,
        sort: '-created',
        filter: 'parent_id = "${parent.id}"',
      );

      return records.map((record) {
        return CategoryEntity(id: record.id, name: record.data['name'], imageUrl: record.data['image']);
      }).toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<List<CategoryDetailEntity>> getAllCategoryDetailsByCategory(CategoryEntity parent) async {
    try {
      final records = await client.records.getFullList(
        'category_details',
        batch: 200,
        sort: '-created',
        filter: 'category_id = "${parent.id}"',
      );

      return records.map((record) {
        return CategoryDetailEntity(url: record.data['video_url'], name: record.data['name']);
      }).toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }
}
