import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();
  
  // Development mode flag
  static const bool _isDevelopmentMode = true;

  Future<bool> isAvailable() async {
    try {
      if (_isDevelopmentMode) {
        // In development mode, always return true for testing
        return true;
      }
      
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      
      return isAvailable && isDeviceSupported;
    } catch (e) {
      print('Error checking biometric availability: $e');
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      if (_isDevelopmentMode) {
        // In development mode, return common biometric types
        return [BiometricType.fingerprint, BiometricType.face];
      }
      
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      print('Error getting available biometrics: $e');
      return [];
    }
  }

  Future<bool> authenticate() async {
    try {
      if (_isDevelopmentMode) {
        // In development mode, simulate a delay and return true
        print('Development mode: Simulating biometric authentication...');
        await Future.delayed(const Duration(seconds: 1));
        print('Development mode: Biometric authentication successful!');
        return true;
      }
      
      return await _localAuth.authenticate(
        localizedReason: 'Please authenticate to continue',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print('Error during biometric authentication: $e');
      return false;
    }
  }

  String getBiometricTypeString(List<BiometricType> biometrics) {
    if (biometrics.contains(BiometricType.face)) {
      return 'Face ID';
    } else if (biometrics.contains(BiometricType.fingerprint)) {
      return 'Fingerprint';
    } else if (biometrics.contains(BiometricType.iris)) {
      return 'Iris';
    }
    return 'Biometric';
  }
} 