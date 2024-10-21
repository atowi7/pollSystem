import 'package:firebase_auth/firebase_auth.dart';
import 'package:poll_system/models/user_model.dart';

class UserService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserModel> login(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    User user = userCredential.user!;

    return UserModel(
      id: user.uid,
      name: user.displayName ?? 'User',
      email: user.email!,
    );
  }

  Future<UserModel> signup(
      String email, String password, String displayName) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    User user = userCredential.user!;

    await user.updateDisplayName(displayName);

    await user.reload();

    user = _firebaseAuth.currentUser!;

    return UserModel(
      id: user.uid,
      name: user.displayName ?? "User",
      email: user.email!,
    );
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
