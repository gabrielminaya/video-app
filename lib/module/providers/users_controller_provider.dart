import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_api/module/entities/users_entity.dart';
import 'package:video_api/module/repositories/users_repository.dart';

final getAllUsersProvider = FutureProvider<List<UserEntity>>((ref) async {
  return ref.read(usersRepositoryProvider).getAllUsers();
});
