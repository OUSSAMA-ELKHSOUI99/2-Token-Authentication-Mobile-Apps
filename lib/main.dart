import 'package:authentication/features/presentation/ui/auth_wrapper.dart';
import 'package:authentication/features/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// TODO: Import your specific files based on your folder structure
// import 'package:my_starter_project/features/auth/presentation/ui/auth_wrapper.dart';
// import 'package:my_starter_project/core/providers/database_provider.dart';

void main() async {
  // 1. Ensure Flutter is ready before doing async work like opening a database
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize your local SQLite database
  final dbPath = await getDatabasesPath();
  final database = await openDatabase(
    join(dbPath, 'indie_core.db'),
    onCreate: (db, version) {
      // Create the users table the first time the app is installed
      return db.execute(
        'CREATE TABLE users(id TEXT PRIMARY KEY, email TEXT, name TEXT, password_hash TEXT)',
      );
    },
    version: 1,
  );

  // 3. Wrap the app in ProviderScope
  runApp(
    ProviderScope(
      overrides: [
        // Inject the initialized database into Riverpod right at startup
        localDbProvider.overrideWithValue(database),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Indie Starter App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // 4. Point the app to the AuthWrapper to handle routing based on session state
      home: const AuthWrapper(), 
    );
  }
}
