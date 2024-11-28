import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/providers/User_provider.dart';

TextEditingController userController = TextEditingController();
TextEditingController passController = TextEditingController();

var logged = false;

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var usuariosAsync = ref.watch(userProvider);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Iniciar Sesión",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: userController,
                    decoration: InputDecoration(
                      labelText: 'Usuario',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      usuariosAsync.when(
                        data: (usuarios) {
                          for (var usuario in usuarios) {
                            if (usuario.email == userController.text &&
                                usuario.password == passController.text) {
                              context.go('/home');
                              logged = true;
                              ref.read(loggedProvider.notifier).state =
                                  userController.text;
                              break;
                            } else if (userController.text == '' &&
                                passController.text == '' &&
                                usuarios.last == usuario) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Usuario y Contraseña Vacíos"),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            } else if (userController.text == '' &&
                                usuarios.last == usuario) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Usuario Vacío"),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            } else if (passController.text == '' &&
                                usuarios.last == usuario) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Contraseña Vacía"),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            } else if (logged == false &&
                                usuarios.last == usuario) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Usuario o Contraseña Incorrecto"),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }
                          }
                        },
                        loading: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Cargando usuarios..."),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        },
                        error: (error, stack) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text("Error al cargar usuarios: $error"),
                              duration: Duration(seconds: 3),
                            ),
                          );
                          print(error);
                        },
                      );
                      logged = false;
                    },
                    child: const Text("Ingresar"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
