import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_api/module/controllers/auth_controller.dart';
import 'package:video_api/module/entities/category_entity.dart';
import 'package:video_api/module/views/category_by_parent_view.dart';
import 'package:video_api/module/views/category_details_view.dart';
import 'package:video_api/module/views/category_view.dart';
import 'package:video_api/module/views/management_users_view.dart';
import 'package:video_api/module/views/management_view.dart';
import 'package:video_api/module/views/sign_in_view.dart';
import 'package:video_api/module/widgets/app_scaffold_widget.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final listenable = GoRouterRefreshStream(
    ref.watch(authControllerProvider.notifier).stream,
  );

  ref.onDispose(() {
    listenable.dispose();
  });

  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: "/signIn",
    refreshListenable: listenable,
    redirect: (context, state) {
      final authState = ref.watch(authControllerProvider);

      final areWeInSignInPage = ["/signIn"].contains(state.location);

      if (authState is Unauthenticated || authState is AuthLoading) {
        return areWeInSignInPage ? null : '/signIn';
      }

      if (areWeInSignInPage) {
        return '/category';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/signIn',
        builder: (context, state) {
          return SignInView();
        },
      ),
      ShellRoute(
        builder: (context, state, child) {
          return AppScaffoldWidget(child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/category',
            pageBuilder: (context, state) {
              final entity = state.extra;

              if (entity is CategoryEntity) {
                return CustomTransitionPage(
                  child: CategoryByParentView(entity: entity),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                );
              }

              return CustomTransitionPage(
                child: const CategoryView(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              );
            },
          ),
          GoRoute(
            path: '/categoryDetails',
            pageBuilder: (context, state) {
              final entity = state.extra as CategoryEntity;

              return CustomTransitionPage(
                child: CategoryDetailsView(entity: entity),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              );
            },
          ),
          GoRoute(
              path: '/management',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  child: const ManagementView(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                );
              },
              routes: [
                GoRoute(
                  path: 'users',
                  pageBuilder: (context, state) {
                    return CustomTransitionPage(
                      child: const ManagementUserView(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    );
                  },
                )
              ]),
        ],
      ),
    ],
  );
});
