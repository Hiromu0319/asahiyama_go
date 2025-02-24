import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_client.g.dart';

@Riverpod(keepAlive: true)
FirebaseFirestore fireStoreInstance(Ref ref) {
  final firebaseFireStore = FirebaseFirestore.instance;
  return firebaseFireStore;
}

@Riverpod(keepAlive: true)
FirebaseAuth authInstance(Ref ref) {
  final firebaseAuth = FirebaseAuth.instance;
  return firebaseAuth;
}

@Riverpod(keepAlive: true)
FirebaseStorage fireStorageInstance(Ref ref) {
  final firebaseFireStorage = FirebaseStorage.instance;
  return firebaseFireStorage;
}