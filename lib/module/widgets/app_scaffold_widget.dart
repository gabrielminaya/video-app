import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_api/module/controllers/auth_controller.dart';

final pageIndexProvider = StateProvider<int>((_) {
  return 0;
});

class AppScaffoldWidget extends ConsumerWidget {
  final Widget child;
  const AppScaffoldWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = ref.watch(pageIndexProvider);

    void onDestinationSelected(int index) {
      ref.read(pageIndexProvider.notifier).update((_) => index);
      switch (index) {
        case 0:
          context.go("/category");
          break;
        case 1:
          context.go("/management");
          break;
        default:
          context.go("/category");
      }
    }

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: pageIndex,
            elevation: 4,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.video_collection_rounded),
                label: Text('Videos'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_customize),
                label: Text('Mantenimiento'),
              ),
            ],
            onDestinationSelected: onDestinationSelected,
            trailing: Column(
              children: [
                const Divider(),
                Consumer(
                  builder: (context, ref, _) {
                    return IconButton(
                      onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
                      icon: const Icon(Icons.logout_rounded),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(child: child)
        ],
      ),
    );
  }
}
