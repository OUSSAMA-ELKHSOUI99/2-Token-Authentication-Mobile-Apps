import 'package:authentication/features/presentation/controllers/auth_controller.dart';
import 'package:authentication/features/providers/network_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home / Dashboard'),
        actions: [
          // A quick way to test your new logout logic!
          
          Consumer(
            builder: (context, ref, child) {
              return IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  ref.read(authControllerProvider.notifier).logout();
                },
              );
            },
          )
          
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 32,),
            // test the token pair
            Consumer(
            builder: (context, ref, child) {
              return ElevatedButton(
  onPressed: () async {
    try {
      // 1. Grab your Dio instance (which has the Interceptor attached!)
      final dio = ref.read(dioProvider); 
      
      // 2. Try to hit the protected route
      print('--- ATTEMPTING TO FETCH SECRET DATA ---');
      final response = await dio.get('http://127.0.0.1:8000/secret-dashboard');
      
      // 3. If it works, print the secret message!
      print('SUCCESS: ${response.data}');
      
    } catch (e) {
      print('FAILED: $e');
    }
  },
  child: const Text('Test Protected Route'),
);})
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}