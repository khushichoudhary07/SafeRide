import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _google = GoogleSignIn();

  static Future<User?> signInWithGoogle() async {
    final googleUser = await _google.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential =
        await _auth.signInWithCredential(credential);

    return userCredential.user;
  }

  static Future<void> signOut() async {
    await _google.signOut();
    await _auth.signOut();
  }
}