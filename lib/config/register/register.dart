import 'package:flutter/material.dart';
import 'package:shokutomo/config/Auth/Auth_service.dart';
import 'package:shokutomo/config/Login/login.dart';
import 'package:shokutomo/config/background.dart';
import 'package:shokutomo/firebase/firebase_services.dart';

class RegisterScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: size.height * 0.2),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.90),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "アカウント作成",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: "メール",
                            prefixIcon: Icon(Icons.email),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !value.contains('@')) {
                              return '有効なメールを入力してください';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: size.height * 0.01),
                        TextFormField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            labelText: "ユーザー名",
                            prefixIcon: Icon(Icons.account_circle),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'ユーザー名を入力してください';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: size.height * 0.01),
                        TextFormField(
                          controller: passwordController,
                          decoration: const InputDecoration(
                            labelText: "パスワード",
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
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                      try {
                        print('regi1');
                        await AuthService().registerWithEmailAndPassword(
                          username: usernameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                        );

                        // Navigate to the login screen after successful registration
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      } catch (error) {
                        // Handle registration errors
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al registrar: $error'),
                          ),
                        );
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
                      "サインアップ",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: const Text(
                    "アカウントをお持ちですか？ サインイン",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
