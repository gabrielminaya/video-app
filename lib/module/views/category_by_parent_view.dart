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
    var shortestSide = screenSize.shortestSide;
    final bool useMobileLayout = shortestSide < 600;

    void goToSubCategories(CategoryEntity entity) {
      context.push("/category", extra: entity);
    }

    void goToVideos(CategoryEntity entity) {
      context.push("/categoryDetails", extra: entity);
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.entity.name), centerTitle: false),
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
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: useMobileLayout ? 1 : 5,
                    childAspectRatio: 18 / 10,
                  ),
                  itemCount: parentCategories.length,
                  itemBuilder: (context, index) {
                    final categoryEntity = parentCategories.elementAt(index);

                    return Card(
                      color: colorScheme.primary,
                      child: InkWell(
                        onTap: () => goToSubCategories(categoryEntity),
                        child: Stack(
                          children: [
                            if (categoryEntity.imageUrl != null) ...[
                              Positioned.fill(
                                child: Image.network(
                                  categoryEntity.imageUrl!,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ],
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Card(
                                          child: TextButton(
                                            child: Icon(Icons.video_file_rounded, color: colorScheme.primary),
                                            onPressed: () => goToVideos(categoryEntity),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(categoryEntity.name,
                                        style: TextStyle(
                                            color: colorScheme.onPrimary, fontSize: screenSize.height * 0.02)),
                                  ),
                                ],
                              ),
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
