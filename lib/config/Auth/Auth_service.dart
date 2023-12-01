import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> registerWithEmailAndPassword({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _createUserDocument(
        userCredential.user!.uid,
        username,
        email,
      );

      return userCredential.user;
    } catch (e) {
      print("Error al registrar usuario: $e");
      return null;
    }
  }

  Future<void> _createUserDocument(
    String uid,
    String username,
    String email,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .set({
            'username': username,
            'email': email,
          })
          .then((_) => print("Usuario registrado en la base de datos"))
          .catchError((error) => print("Error al registrar en la base de datos: $error"));
    } catch (e) {
      print("Error al crear el documento de usuario: $e");
    }
  }
}
