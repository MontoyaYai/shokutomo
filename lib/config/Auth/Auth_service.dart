import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> registerWithEmailAndPassword({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;
      await _createUserDocument(
        uid,
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
          .doc(uid)
          .set({
            'username': username,
            'email': email,
          })
          .then((_) => print("Usuario registrado en la base de datos"))
          .catchError((error) =>
              print("Error al registrar en la base de datos: $error"));
    } catch (e) {
      print("Error al crear el documento de usuario: $e");
    }
  }
}
