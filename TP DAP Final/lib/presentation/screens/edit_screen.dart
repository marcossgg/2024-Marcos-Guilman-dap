import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/providers/List_provider.dart';
import 'package:myapp/entities/Post.dart';

class EditScreen extends ConsumerWidget {
  const EditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(listProvider);
    final pressed = ref.watch(pressedProvider);
    String title;
    String imagesrc;
    late TextEditingController title_controller;
    late TextEditingController description_controller;
    late TextEditingController text_controller;
    late TextEditingController imgsrc_controller;

    title = '';
    imagesrc = '';

    if (pressed == -1) {
      title = 'Nuevo Post';
      title_controller = TextEditingController();
      description_controller = TextEditingController();
      text_controller = TextEditingController();
      imgsrc_controller = TextEditingController();
      imagesrc =
          'https://st3.depositphotos.com/1000260/16789/i/450/depositphotos_167894700-stock-photo-fat-man-eating-fast-food.jpg';
    } else {
      listAsync.when(
        data: (list) {
          title = list[pressed].title;
          title_controller = TextEditingController(text: list[pressed].title);
          description_controller =
              TextEditingController(text: list[pressed].description);
          text_controller = TextEditingController(text: list[pressed].text);
          imgsrc_controller =
              TextEditingController(text: list[pressed].imagesrc);
          imagesrc = list[pressed].imagesrc;
        },
        loading: () => const CircularProgressIndicator(),
        error: (error, stackTrace) => Text('Error: $error'),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  imagesrc,
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: title_controller,
                  decoration: const InputDecoration(
                    labelText: "Comida",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: description_controller,
                  decoration: const InputDecoration(
                    labelText: "Origen",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: text_controller,
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: "Descripcion",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: imgsrc_controller,
                  decoration: const InputDecoration(
                    labelText: "Direccion de la Imagen",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      listAsync.when(
                        data: (list) {
                          if (pressed != -1) {
                            list[pressed].title = title_controller.text;
                            list[pressed].description =
                                description_controller.text;
                            list[pressed].text = text_controller.text;
                            list[pressed].imagesrc = imgsrc_controller.text;
                            ref.read(listaddProvider).addMovie(list);
                            context.go('/home');
                          } else {
                            if (title_controller.text == '' ||
                                description_controller.text == '' ||
                                text_controller.text == '' ||
                                imgsrc_controller.text == '') {
                              SnackBar snackBar = const SnackBar(
                                content:
                                    Text("Todos los campos son obligatorios"),
                                duration: Duration(seconds: 3),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              list.add(Post(
                                  title: title_controller.text,
                                  description: description_controller.text,
                                  text: text_controller.text,
                                  imagesrc: imgsrc_controller.text));
                              ref.read(listaddProvider).addMovie(list);
                              context.push('/home');
                            }
                          }
                        },
                        loading: () => const CircularProgressIndicator(),
                        error: (error, stackTrace) => Text('Error: $error'),
                      );
                    },
                    child: const Text("Guardar")),
                    
              ],
            ),
          ),
        ));
  }
}
