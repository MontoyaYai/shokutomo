import 'package:flutter/material.dart';
import 'package:shokutomo/config/background.dart';
import 'package:shokutomo/config/personalInfo.dart';
import 'package:shokutomo/config/register/register.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
TextEditingController _usernameController = TextEditingController();
TextEditingController _passwordController = TextEditingController();

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                  color: Colors.white.withOpacity(0.95),
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
                          "LOGIN",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2661FA),
                            fontSize: 36,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      Container(
                        alignment: Alignment.center,
                        child: TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: "Username",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                             return 'Please enter a username';
                          }
                            return null;
                        },

                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      Container(
                        alignment: Alignment.center,
                        child: TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: "Password",
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        child: const Text(
                          "Forgot your password?",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0XFF2661FA),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.05),
                      Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                              String username = _usernameController.text;
                              String password = _passwordController.text;

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DisplayScreen(username: username, password: password),
    ),
  );
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
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 255, 136, 34),
                                  Color.fromARGB(255, 255, 177, 41),
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.all(0),
                            child: const Text(
                              "LOGIN",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.05),
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                  },
                  child: const Text(
                    "Don't Have an Account? Sign up",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2661FA),
                    ),
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

void main() {
  runApp(const MaterialApp(
    home: LoginScreen(),
  ));
}
