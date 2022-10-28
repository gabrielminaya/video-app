import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_api/module/controllers/auth_controller.dart';
import 'package:video_api/module/entities/category_entity.dart';
import 'package:video_api/module/repositories/category_repository.dart';

final categoryControllerProvider = StateNotifierProvider<CategoryController, List<CategoryEntity>>(
  (ref) => CategoryController(ref),
);

class CategoryController extends StateNotifier<List<CategoryEntity>> {
  final Ref ref;

  CategoryController(this.ref) : super([]);

  void getAllParent() async {
    final authState = ref.watch(authControllerProvider) as Authenticated;
    state = await ref.watch(categoryRepositoryProvider).getParentCategories(authState.entity.categories);
  }

  void getAllCategoryByParent(CategoryEntity entity) async {
    state = await ref.watch(categoryRepositoryProvider).getCategoriesByParent(entity);
  }
}
