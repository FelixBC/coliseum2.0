import 'package:google_sign_in/google_sign_in.dart';
import 'package:coliseum/models/user_model.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        return null; // User cancelled the sign-in
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Create user from Google account
      final user = User(
        id: googleUser.id,
        username: googleUser.displayName ?? 'user_${googleUser.id}',
        email: googleUser.email,
        profileImageUrl: googleUser.photoUrl ?? 'https://i.pravatar.cc/150?u=${googleUser.id}',
        bio: '',
      );

      return user;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      print('Error signing out from Google: $e');
    }
  }

  Future<GoogleSignInAccount?> getCurrentUser() async {
    try {
      return await _googleSignIn.signInSilently();
    } catch (e) {
      print('Error getting current Google user: $e');
      return null;
    }
  }
} 