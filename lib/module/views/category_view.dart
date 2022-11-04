import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_webview/fwfh_webview.dart';
import 'package:go_router/go_router.dart';
import 'package:video_api/module/entities/category_entity.dart';

import '../controllers/category_controller.dart';

class MyWidgetFactory extends WidgetFactory with WebViewFactory {
  @override
  bool get webViewMediaPlaybackAlwaysAllow => true;
  @override
  String? get webViewUserAgent => 'My app';
}

class CategoryView extends ConsumerStatefulWidget {
  const CategoryView({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoryViewState();
}

class _CategoryViewState extends ConsumerState<CategoryView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryControllerProvider.notifier).getAllParent();
    });
  }

  @override
  Widget build(BuildContext context) {
    final parentCategories = ref.watch(categoryControllerProvider);
    final screenSize = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;

    void goToSubCategories(CategoryEntity entity) {
      context.push("/category", extra: entity);
    }

    void goToVideos(CategoryEntity entity) {
      context.push("/categoryDetails", extra: entity);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        title: SizedBox(
          height: 40,
          child: Image.asset(
            "assets/logo_small_header.png",
            fit: BoxFit.contain,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: HtmlWidget(
                  """
                  <iframe width="560" height="315" src="http://172.16.220.50/embed?m=qASeilhmB" frameborder="0" allowfullscreen></iframe>
                  """,
                  factoryBuilder: () => MyWidgetFactory(),
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
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
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Card(
                                    child: TextButton(
                                      child: Icon(Icons.category_rounded, color: colorScheme.primary),
                                      onPressed: () => goToSubCategories(categoryEntity),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
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
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Text(
                                    categoryEntity.name,
                                    style: TextStyle(color: colorScheme.onSurface, fontSize: screenSize.height * 0.02),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
