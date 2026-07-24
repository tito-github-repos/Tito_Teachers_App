import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tito_teachers_app/constants/firebase_collections.dart';

import '../models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class AuthRepository {
  AuthRepository._();

  static final AuthRepository instance = AuthRepository._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseAuth get auth => _auth;

  FirebaseFirestore get firestore => _firestore;

  User? get currentUser => _auth.currentUser;

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_getFirebaseAuthMessage(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserCredential> register({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_getFirebaseAuthMessage(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> saveUser(UserModel user) async {
    try {
      await _firestore
          .collection(FirestoreCollections.users)
          .doc(user.uid)
          .set(user.toJson());
    } catch (e) {
      throw Exception("Failed to save user : $e");
    }
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _firestore
          .collection(FirestoreCollections.users)
          .doc(uid)
          .get();

      if (!doc.exists) return null;

      return UserModel.fromJson(doc.data()!);
    } catch (e) {
      throw Exception("Failed to fetch user : $e");
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore
          .collection(FirestoreCollections.users)
          .doc(user.uid)
          .update(user.toJson());
    } catch (e) {
      throw Exception("Failed to update user : $e");
    }
  }

  Future<void> deleteUser(String uid) async {
    try {
      await _firestore
          .collection(FirestoreCollections.users)
          .doc(uid)
          .delete();
    } catch (e) {
      throw Exception("Failed to delete user : $e");
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_getFirebaseAuthMessage(e));
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  String _getFirebaseAuthMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Invalid email address';

      case 'user-disabled':
        return 'User account disabled';

      case 'user-not-found':
        return 'User not found';

      case 'wrong-password':
        return 'Incorrect password';

      case 'email-already-in-use':
        return 'Email already exists';

      case 'weak-password':
        return 'Password is too weak';

      case 'network-request-failed':
        return 'No internet connection';

      case 'invalid-credential':
        return 'Invalid email or password';

      default:
        return e.message ?? 'Authentication failed';
    }
  }
}