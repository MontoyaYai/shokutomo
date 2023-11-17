import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shokutomo/config/background.dart';
import 'package:shokutomo/config/personalInfo.dart';
import 'package:shokutomo/config/register/register.dart';
import 'package:shokutomo/config/settings_page.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: size.height * 0.05),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.90),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "ログイン",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: "ユーザーネーム",
                          hintText: "ユーザーネームを入力してください",
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'ユーザーネームを入力してください';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: size.height * 0.03),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: "パスワード",
                          hintText: "パスワードを入力してください",
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'パスワードを入力してください';
                          } else if (value.length < 6) {
                            return 'パスワードは少なくとも6文字以上である必要があります';
                          }
                          return null;
                        },
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        child: GestureDetector(
                          onTap: () {
                            // Agrega aquí la lógica para restablecer la contraseña
                          },
                          child: const Text(
                            "パスワードをお忘れですか?",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.05),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState != null &&
                              _formKey.currentState!.validate()) {
                            String username = _usernameController.text;
                            String password = _passwordController.text;

                            try {
                              // Iniciar sesión con Firebase Auth
                              UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: username,
                                password: password,
                              );

                              // Usuario autenticado correctamente
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Inicio de sesión exitoso"),
                                    content: Text("¡Bienvenido, $username!"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const SettingsPage(),
                                            ),
                                          );
                                        },
                                        child: const Text("OK"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } on FirebaseAuthException catch (e) {
                              // Manejar errores de inicio de sesión
                              if (e.code == 'user-not-found') {
                                print('No hay ningún usuario registrado con ese correo.');
                              } else if (e.code == 'wrong-password') {
                                print('Contraseña incorrecta.');
                              } else {
                                print('Error: $e');
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0),
                          ),
                          padding: const EdgeInsets.all(0),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          width: size.width * 0.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(80.0),
                          ),
                          padding: const EdgeInsets.all(0),
                          child: const Text(
                            "ログイン",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                child: const Text(
                  "アカウントを持っていない方、サインアップ",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}