import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:video_api/module/entities/profile_entity.dart';
import 'package:video_api/module/providers/pocketbase_provider.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref.watch(pocketBaseProvider));
});

abstract class AuthState {
  const AuthState();
}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final ProfileEntity entity;

  const Authenticated(this.entity);
}

class Unauthenticated extends AuthState {
  final String? message;

  const Unauthenticated({this.message});
}

class AuthController extends StateNotifier<AuthState> {
  final PocketBase client;
  AuthController(this.client) : super(const Unauthenticated());

  bool isAuthenticated() => state is Authenticated;

  void signIn({required String email, required String password}) async {
    try {
      state = AuthLoading();
      final result = await client.users.authViaEmail(email, password);

      if (result.user == null) {
        state = const Unauthenticated(message: "Usuario o contraseña inválidos.");
        return;
      }

      state = Authenticated(
        ProfileEntity(
          id: result.user!.id,
          admin: result.user!.profile?.data['admin'] ?? false,
          categories: List<String>.from(result.user?.profile?.data['categories'] ?? []),
        ),
      );
    } catch (e) {
      log(e.toString());
      state = const Unauthenticated(message: "Usuario o contraseña inválidos.");
    }
  }

  void signOut() async {
    client.authStore.clear();
    state = const Unauthenticated();
  }
}
