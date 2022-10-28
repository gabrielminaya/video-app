import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:video_api/module/providers/pocketbase_provider.dart';

import '../entities/users_entity.dart';

final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  return UsersRepository(ref.watch(pocketBaseProvider));
});

class UsersRepository {
  final PocketBase _client;

  const UsersRepository(
    this._client,
  );

  Future<List<UserEntity>> getAllUsers() async {
    return (await _client.users.getFullList()).map((user) => UserEntity(email: user.email)).toList();
  }
}
