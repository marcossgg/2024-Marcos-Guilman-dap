import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/providers/List_provider.dart';

class CardScreen extends ConsumerWidget {
  const CardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(listProvider);
    final pressed = ref.watch(pressedProvider);

    return Scaffold(
        appBar: AppBar(
          title: listAsync.when(
            data: (list) => Text(list[pressed].title),
            loading: () => const Text('Cargando'),
            error: (error, stackTrace) => Text('Error: $error'),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Expanded(
          child: Stack(
            children: [
              Center(
                  child: listAsync.when(
                data: (list) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        list[pressed].imagesrc,
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        list[pressed].title,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text(
                            list[pressed].text,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (error, stackTrace) => Text('Error: $error'),
              )),
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton(
                  onPressed: () {
                    context.push('/edit');
                  },
                  child: const Icon(Icons.edit),
                ),
              ),
              Positioned(
                bottom: 90,
                right: 16,
                child: FloatingActionButton(
                  onPressed: () {
                    listAsync.when(
                      data: (list) {
                        list.removeAt(pressed);
                        ref.read(listaddProvider).addMovie(list);
                        context.go('/home');
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stackTrace) => Text('Error: $error'),
                    );
                  },
                  child: const Icon(Icons.delete),
                ),
              ),
            ],
          ),
        ));
  }
}
