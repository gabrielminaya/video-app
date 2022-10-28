import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';

final pocketBaseProvider = Provider<PocketBase>(
  (_) => PocketBase('http://172.16.220.50:8090'),
);
