import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_api/module/repositories/category_repository.dart';

import '../entities/category_detail_entity.dart';
import '../entities/category_entity.dart';

final categoryDetailsControllerProvider = FutureProvider.family<List<CategoryDetailEntity>, CategoryEntity>(
  (ref, entity) async => await ref.watch(categoryRepositoryProvider).getAllCategoryDetailsByCategory(entity),
);
