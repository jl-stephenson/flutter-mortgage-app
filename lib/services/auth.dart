import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String googleClientId =
      String.fromEnvironment('GOOGLE_SIGNIN_CLIENT_ID');
  final Logger logger = Logger();

  Future<UserCredential?> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        logger.e('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        logger.e('Wrong password provided for that user.');
      }
    } catch (e) {
      logger.e('Sign in with email & password failed: $e');
      return null;
    }
    return null;
  }

  Future<UserCredential?> registerWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        addUserToFirestore(user);
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        logger.e('The password is too weak');
      } else if (e.code == 'email-already-in-use') {
        logger.e('The account already exists for that email.');
      }
    } catch (e) {
      logger.e('Error in creating new user: $e');
    }
    return null;
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: googleClientId,
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Sign in unsuccessful');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Add user to Firestore
      final User? user = userCredential.user;

      if (user != null) {
        addUserToFirestore(user);
      }

      return userCredential;
    } catch (e) {
      logger.e('Error during Google Sign In: $e');
      return null;
    }
  }

  Future<void> addUserToFirestore(User user) async {
    try {
      final userDoc = _firestore.collection('users').doc(user.uid);

      await userDoc.set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName ?? '',
        'photoURL': user.photoURL ?? '',
        'createdAt': user.metadata.creationTime,
        'lastSignIn': user.metadata.lastSignInTime,
      }, SetOptions(merge: true));
    } catch (e) {
      logger.e('Error adding user to Firestore: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
