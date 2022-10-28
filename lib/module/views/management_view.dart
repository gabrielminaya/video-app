import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/auth_controller.dart';

class ManagementView extends ConsumerWidget {
  const ManagementView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final screenSize = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;

    if ((authState as Authenticated).entity.id != "vmwwbvf7wie2hbe") {
      return const Center(
        child: Text("Acceso restringido."),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mantenimiento"),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 4,
          childAspectRatio: 16 / 9,
          children: [
            Card(
              color: colorScheme.primary,
              child: InkWell(
                onTap: () async {
                  try {
                    await launchUrl(Uri.parse("http://172.16.220.50/"));
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
                        child: Icon(Icons.video_call_sharp, color: colorScheme.onPrimary),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Videos",
                          style: TextStyle(color: colorScheme.onPrimary, fontSize: screenSize.height * 0.025),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              color: colorScheme.primary,
              child: InkWell(
                onTap: () async {
                  try {
                    await launchUrl(Uri.parse("http://172.16.220.50:8090/_/#/"));
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
                        child: Icon(Icons.dashboard, color: colorScheme.onPrimary),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Administración",
                          style: TextStyle(color: colorScheme.onPrimary, fontSize: screenSize.height * 0.025),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}