import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_api/module/entities/category_entity.dart';

import '../providers/category_detail_provider.dart';

class CategoryDetailsView extends ConsumerStatefulWidget {
  final CategoryEntity entity;
  const CategoryDetailsView({super.key, required this.entity});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoryDetailsViewState();
}

class _CategoryDetailsViewState extends ConsumerState<CategoryDetailsView> {
  @override
  Widget build(BuildContext context) {
    final parentCategoryDetailsAsync = ref.watch(categoryDetailsControllerProvider(widget.entity));
    final screenSize = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text("Videos de: ${widget.entity.name}"), centerTitle: false),
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
            child: parentCategoryDetailsAsync.when(
              data: (parentCategoryDetails) {
                if (parentCategoryDetails.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.category, size: 40),
                        SizedBox(height: 20),
                        Text("No hay videos."),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    childAspectRatio: 18 / 10,
                  ),
                  itemCount: parentCategoryDetails.length,
                  itemBuilder: (context, index) {
                    final categoryEntity = parentCategoryDetails.elementAt(index);

                    return Card(
                      color: Colors.red,
                      child: InkWell(
                        onTap: () async {
                          try {
                            await launchUrl(Uri.parse(categoryEntity.url));
                          } catch (e) {
                            log(e.toString());
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [Icon(Icons.video_file_rounded, color: colorScheme.onPrimary)],
                                ),
                              ),
                              const Spacer(),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  categoryEntity.name,
                                  style: TextStyle(
                                    color: colorScheme.onPrimary,
                                    fontSize: screenSize.height * 0.02,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              error: (error, stackTrace) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.category, size: 40),
                      const SizedBox(height: 20),
                      Text(error.toString()),
                    ],
                  ),
                );
              },
              loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
