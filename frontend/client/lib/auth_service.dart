import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'core/network/dio_client.dart';
import 'core/storage/jwt_storage.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Dio _dio = DioClient.dio;

  /* =========================
     GOOGLE LOGIN
  ========================== */
  Future<User?> signInWithGoogle() async {
    try {
      // Pastikan session bersih
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Firebase user null');
      }

      // ⬅️ TIDAK perlu force refresh
      final idToken = await user.getIdToken();
      if (idToken == null) {
        throw Exception('Firebase ID Token null');
      }

      if (kDebugMode) {
        debugPrint('🔥 FIREBASE ID TOKEN (GOOGLE)');
        debugPrint(idToken);
      }

      await _loginToBackend(idToken);
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Google login gagal');
    }
  }

  /* =========================
    EMAIL REGISTER
  ========================== */
  Future<User?> registerWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Registrasi gagal');
    }
  }

  /* =========================
     EMAIL LOGIN
  ========================== */
  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Firebase user null');
      }

      final idToken = await user.getIdToken();
      if (idToken == null) {
        throw Exception('Firebase ID Token null');
      }

      await _loginToBackend(idToken);
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Login email gagal');
    }
  }

  /* =========================
     BACKEND LOGIN (JWT)
  ========================== */
  Future<void> _loginToBackend(String firebaseToken) async {
    try {
      final response = await _dio.post(
        '/auth-user/login',
        options: Options(
          headers: {
            'Authorization': 'Bearer $firebaseToken',
          },
        ),
      );

      final jwt = response.data?['token'];
      if (jwt == null || jwt.toString().isEmpty) {
        throw Exception('JWT backend tidak ditemukan');
      }

      await JwtStorage.saveToken(jwt);

      if (kDebugMode) {
        debugPrint('✅ JWT backend tersimpan');
      }
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? 'Login backend gagal';
      throw Exception(message);
    }
  }

  /* =========================
     GET JWT
  ========================== */
  Future<String?> getJwt() async {
    return JwtStorage.getToken();
  }

  /* =========================
    UPDATE FIREBASE EMAIL
  ========================== */
  Future<void> updateFirebaseEmail(String email) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('User belum login');
    }

    try {
      await user.verifyBeforeUpdateEmail(email);
      await user.getIdToken(true); // refresh token sah di sini
    } on FirebaseAuthException catch (e) {
      throw Exception(
        e.message ?? 'Gagal update email, silakan login ulang',
      );
    }
  }

  /* =========================
     LOGOUT
  ========================== */
  Future<void> logout() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    await JwtStorage.clearToken();
    DioClient.clearAuth();
  }
}
