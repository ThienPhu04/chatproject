import 'package:finalproject/features/auth/data/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> loginWithEmail(String email, String password);
  Future<UserModel> registerWithEmail(String email, String password, String name);
  Future<UserModel> loginWithGoogle();
  Future<UserModel> loginWithFacebook();
  Future<UserModel> loginWithApple();
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;

  AuthRemoteDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    FacebookAuth? facebookAuth,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _facebookAuth = facebookAuth ?? FacebookAuth.instance;

  @override
  Future<UserModel> loginWithEmail(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('Login failed');
      }

      return UserModel.fromFirebase(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('No user found with this email');
        case 'wrong-password':
          throw Exception('Wrong password');
        case 'invalid-email':
          throw Exception('Invalid email format');
        case 'user-disabled':
          throw Exception('This account has been disabled');
        default:
          throw Exception(e.message ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('An error occurred during login');
    }
  }

  @override
  Future<UserModel> registerWithEmail(
      String email, String password, String name) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('Registration failed');
      }

      // Update display name
      await userCredential.user!.updateDisplayName(name);
      await userCredential.user!.reload();

      final updatedUser = _firebaseAuth.currentUser;

      if (updatedUser == null) {
        throw Exception('Failed to get user after registration');
      }

      return UserModel.fromFirebase(updatedUser);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw Exception('Password is too weak');
        case 'email-already-in-use':
          throw Exception('An account already exists with this email');
        case 'invalid-email':
          throw Exception('Invalid email format');
        default:
          throw Exception(e.message ?? 'Registration failed');
      }
    } catch (e) {
      throw Exception('An error occurred during registration');
    }
  }

  @override
  Future<UserModel> loginWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign-in was cancelled');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      final userCredential =
      await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw Exception('Google sign-in failed');
      }

      return UserModel.fromFirebase(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Google sign-in failed');
    } catch (e) {
      throw Exception('An error occurred during Google sign-in');
    }
  }

  @override
  Future<UserModel> loginWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await _facebookAuth.login();

      if (loginResult.status != LoginStatus.success) {
        throw Exception('Facebook sign-in was cancelled or failed');
      }

      if (loginResult.accessToken == null) {
        throw Exception('Failed to get Facebook access token');
      }

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
      FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

      // Once signed in, return the UserCredential
      final userCredential =
      await _firebaseAuth.signInWithCredential(facebookAuthCredential);

      if (userCredential.user == null) {
        throw Exception('Facebook sign-in failed');
      }

      return UserModel.fromFirebase(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Facebook sign-in failed');
    } catch (e) {
      throw Exception('An error occurred during Facebook sign-in');
    }
  }

  @override
  Future<UserModel> loginWithApple() async {
    try {
      // Tạo provider cho Apple Sign In
      final appleProvider = AppleAuthProvider();
      appleProvider.addScope('email');
      appleProvider.addScope('name');

      // Sign in
      final userCredential = await _firebaseAuth.signInWithProvider(appleProvider);

      if (userCredential.user == null) {
        throw Exception('Apple sign-in failed');
      }

      return UserModel.fromFirebase(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Apple sign-in failed');
    } catch (e) {
      throw Exception('An error occurred during Apple sign-in');
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Sign out from Google
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }

      // Sign out from Facebook
      await _facebookAuth.logOut();

      // Sign out from Firebase
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('An error occurred during logout');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser != null) {
        return UserModel.fromFirebase(firebaseUser);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}