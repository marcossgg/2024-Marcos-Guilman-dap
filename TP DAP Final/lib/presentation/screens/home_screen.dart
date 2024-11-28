import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/providers/List_provider.dart';
import 'package:myapp/providers/User_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var postsAsync = ref.watch(listProvider);
    String usuario = ref.watch(loggedProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Hola $usuario"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.go('/login');
              },
              child: const Text("Logout"),
            ),
            const SizedBox(height: 20),
            Expanded(
                child: postsAsync.when(
              data: (posts) {
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return Card(
                      child: ListTile(
                        title: Text(post.title),
                        subtitle: Text(post.description),
                        onTap: () {
                          ref.read(pressedProvider.notifier).state = index;
                          context.push('/card');
                        },
                      ),
                    );
                  },
                );
              },
              loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              error: (error, stack) {
                return Center(
                  child: Text("Error al cargar películas: $error"),
                );
              },
            )),
          ],
        ),
        //  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(pressedProvider.notifier).state = -1;
          context.push('/edit');
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .endFloat, // Esto lo posiciona en la esquina inferior derecha
    );
  }
}
