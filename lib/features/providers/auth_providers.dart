import 'package:authentication/features/auth/data/repositories/local_auth_repository.dart';
import 'package:authentication/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

// nitialize the database in main() before calling runApp(), 
//and then use ProviderScope(overrides: 
//[localDbProvider.overrideWithValue(myInitializedDb)]) 
//to inject it
final localDbProvider = Provider<Database>((ref) {
  // Return your initialized SQLite database instance here.
  throw UnimplementedError('Ensure you initialize and provide your DB instance');
});

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final storage = ref.watch(secureStorageProvider);
  final db = ref.watch(localDbProvider);
  return LocalAuthRepository(storage, db);
});