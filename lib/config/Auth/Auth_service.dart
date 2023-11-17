import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ユーザーとパスワードのログイン
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("ログインにエラー発生しました $e");
      return null;
    }
  }

  // 登録
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

      // Puedes realizar acciones adicionales aquí, como almacenar información en una base de datos.

      return userCredential.user;
    } catch (e) {
      print("ユーザー作成にエラーが発生しました： $e");
      return null;
    }
  }

  // サインアウト
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
