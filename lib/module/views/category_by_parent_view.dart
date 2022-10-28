import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_api/module/entities/category_entity.dart';
import 'package:video_api/module/providers/category_by_parent_controller.dart';

class CategoryByParentView extends ConsumerStatefulWidget {
  final CategoryEntity entity;
  const CategoryByParentView({super.key, required this.entity});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoryByParentViewState();
}

class _CategoryByParentViewState extends ConsumerState<CategoryByParentView> {
  @override
  Widget build(BuildContext context) {
    final parentCategoriesAsync = ref.watch(categoryByParentControllerProvider(widget.entity));
    final screenSize = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;

    void goToSubCategories(CategoryEntity entity) {
      context.push("/category", extra: entity);
    }

    void goToVideos(CategoryEntity entity) {
      context.push("/categoryDetails", extra: entity);
    }

    return Scaffold(
      appBar: AppBar(title: Text("SubCategoria de: ${widget.entity.name}"), centerTitle: false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text("Atrás"),
              ),
            ),
          ),
          Expanded(
            child: parentCategoriesAsync.when(
              data: (parentCategories) {
                if (parentCategories.isEmpty) {
                  return const Center(
                    child: Text("No hay categorias."),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    childAspectRatio: 18 / 10,
                  ),
                  itemCount: parentCategories.length,
                  itemBuilder: (context, index) {
                    final categoryEntity = parentCategories.elementAt(index);

                    return Card(
                      color: colorScheme.primary,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    iconSize: 35,
                                    icon: Icon(Icons.category_rounded, color: colorScheme.onPrimary),
                                    onPressed: () => goToSubCategories(categoryEntity),
                                  ),
                                  const SizedBox(width: 10),
                                  IconButton(
                                    iconSize: 35,
                                    icon: Icon(Icons.video_file_rounded, color: colorScheme.onPrimary),
                                    onPressed: () => goToVideos(categoryEntity),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(categoryEntity.name,
                                  style: TextStyle(color: colorScheme.onPrimary, fontSize: screenSize.height * 0.02)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.category, size: 40),
                    SizedBox(height: 20),
                    Text("No hay subcategorias."),
                  ],
                ),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
