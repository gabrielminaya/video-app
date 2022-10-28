import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_api/module/entities/category_entity.dart';
import 'package:video_api/module/repositories/category_repository.dart';

final categoryByParentControllerProvider = FutureProvider.family<List<CategoryEntity>, CategoryEntity>(
  (ref, entity) async => await ref.watch(categoryRepositoryProvider).getCategoriesByParent(entity),
);
