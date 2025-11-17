import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';

/// Biometric authentication service
/// Supports fingerprint, face recognition, and other biometric methods
@lazySingleton
class BiometricService {
  final LocalAuthentication _auth;
  final Logger _logger;

  BiometricService(this._auth, this._logger);

  /// Check if device supports biometric authentication
  Future<bool> isDeviceSupported() async {
    try {
      return await _auth.isDeviceSupported();
    } catch (e) {
      _logger.e('Error checking device support', error: e);
      return false;
    }
  }

  /// Check if biometric is available (device supports + enrolled)
  Future<bool> isBiometricAvailable() async {
    try {
      final isSupported = await _auth.isDeviceSupported();
      if (!isSupported) return false;

      final canCheckBiometrics = await _auth.canCheckBiometrics;
      return canCheckBiometrics;
    } catch (e) {
      _logger.e('Error checking biometric availability', error: e);
      return false;
    }
  }

  /// Get available biometric types on the device
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      _logger.e('Error getting available biometrics', error: e);
      return [];
    }
  }

  /// Authenticate using biometric
  /// Returns true if authentication successful, false otherwise
  Future<bool> authenticate({
    String localizedReason = 'Please authenticate to access your account',
    bool useErrorDialogs = true,
    bool stickyAuth = true,
  }) async {
    try {
      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        _logger.w('Biometric authentication not available');
        return false;
      }

      final authenticated = await _auth.authenticate(
        localizedReason: localizedReason,
        options: AuthenticationOptions(
          useErrorDialogs: useErrorDialogs,
          stickyAuth: stickyAuth,
          biometricOnly: true,
        ),
      );

      return authenticated;
    } catch (e) {
      _logger.e('Error during biometric authentication', error: e);
      return false;
    }
  }

  /// Stop ongoing authentication
  Future<void> stopAuthentication() async {
    try {
      await _auth.stopAuthentication();
    } catch (e) {
      _logger.e('Error stopping authentication', error: e);
    }
  }

  /// Get biometric type name for UI display
  String getBiometricTypeName(BiometricType type) {
    switch (type) {
      case BiometricType.face:
        return 'Face Recognition';
      case BiometricType.fingerprint:
        return 'Fingerprint';
      case BiometricType.iris:
        return 'Iris';
      case BiometricType.strong:
        return 'Strong Biometric';
      case BiometricType.weak:
        return 'Weak Biometric';
    }
  }

  /// Check if specific biometric type is available
  Future<bool> hasFingerprint() async {
    final biometrics = await getAvailableBiometrics();
    return biometrics.contains(BiometricType.fingerprint);
  }

  Future<bool> hasFaceRecognition() async {
    final biometrics = await getAvailableBiometrics();
    return biometrics.contains(BiometricType.face);
  }
}
