import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:coliseum/models/user_model.dart';
import 'package:coliseum/constants/google_config.dart';

class GoogleAuthService {
	late final GoogleSignIn _googleSignIn;
	
	GoogleAuthService() {
		_initializeGoogleSignIn();
	}
	
	void _initializeGoogleSignIn() {
		// On Android, google_sign_in expects serverClientId (the Web Client ID)
		if (GoogleConfig.isConfigured) {
			_googleSignIn = GoogleSignIn(
				serverClientId: GoogleConfig.getWebClientId(),
				scopes: GoogleConfig.scopes,
				signInOption: SignInOption.standard,
			);
		} else {
			_googleSignIn = GoogleSignIn(
				scopes: GoogleConfig.scopes,
				signInOption: SignInOption.standard,
			);
		}
	}

	Future<bool> isAvailable() async {
		try {
			await _googleSignIn.isSignedIn();
			return true;
		} catch (_) {
			return false;
		}
	}

	Future<User?> signIn() async {
		try {
			if (!GoogleConfig.isConfigured) {
				throw Exception('Google Sign-In is not properly configured. Please check your client IDs.');
			}
			final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
			if (googleUser == null) return null;
			await googleUser.authentication; // ensure tokens are fetched
			final String? firstName = googleUser.displayName?.split(' ').first;
			final String? lastName = (googleUser.displayName?.split(' ').length ?? 0) > 1
				? googleUser.displayName?.split(' ').skip(1).join(' ')
				: null;
			final String username = _generateUsername(googleUser.email);
			final user = User(
				id: 'google_${googleUser.id}',
				username: username,
				email: googleUser.email,
				profileImageUrl: googleUser.photoUrl ?? 'https://i.pravatar.cc/150?u=${googleUser.email}',
				bio: 'Usuario de Google',
				postCount: 0,
				followers: 0,
				following: 0,
				firstName: firstName ?? username,
				lastName: lastName ?? '',
				phoneNumber: '',
				dateOfBirth: null,
				authProvider: 'google',
				createdAt: DateTime.now(),
				lastLoginAt: DateTime.now(),
			);
			return user;
		} catch (e) {
			print('Error signing in with Google: $e');
			rethrow;
		}
	}

	Future<void> signOut() async {
		try {
			await _googleSignIn.signOut();
		} catch (e) {
			print('Error signing out from Google: $e');
		}
	}

	Future<bool> isSignedIn() async {
		try {
			return await _googleSignIn.isSignedIn();
		} catch (_) {
			return false;
		}
	}

	Future<Map<String, dynamic>?> getAdditionalProfileInfo() async {
		try {
			final GoogleSignInAccount? currentUser = _googleSignIn.currentUser;
			if (currentUser == null) return null;
			return {
				'displayName': currentUser.displayName,
				'photoUrl': currentUser.photoUrl,
				'email': currentUser.email,
				'id': currentUser.id,
			};
		} catch (e) {
			print('Error getting additional profile info: $e');
			return null;
		}
	}

	// Get current user (alias for compatibility)
	Future<User?> getCurrentUser() async {
		try {
			final GoogleSignInAccount? currentUser = _googleSignIn.currentUser;
			if (currentUser == null) return null;
			
			// Return the current user as a User object
			final String? firstName = currentUser.displayName?.split(' ').first;
			final String? lastName = (currentUser.displayName?.split(' ').length ?? 0) > 1 
					? currentUser.displayName?.split(' ').skip(1).join(' ') 
					: null;
			
			final String username = _generateUsername(currentUser.email);
			
			return User(
				id: 'google_${currentUser.id}',
				username: username,
				email: currentUser.email,
				profileImageUrl: currentUser.photoUrl ?? 'https://i.pravatar.cc/150?u=${currentUser.email}',
				bio: 'Usuario de Google',
				postCount: 0,
				followers: 0,
				following: 0,
				firstName: firstName ?? username,
				lastName: lastName ?? '',
				phoneNumber: '',
				dateOfBirth: null,
				authProvider: 'google',
				createdAt: DateTime.now(),
				lastLoginAt: DateTime.now(),
			);
		} catch (e) {
			print('Error getting current user: $e');
			return null;
		}
	}

	// Alias for signIn method (for compatibility)
	Future<User?> signInWithGoogle() async {
		return await signIn();
	}

	String _generateUsername(String email) {
		final String baseUsername = email.split('@').first;
		final String randomSuffix = Random().nextInt(999).toString().padLeft(3, '0');
		return '${baseUsername}_$randomSuffix';
	}
} 