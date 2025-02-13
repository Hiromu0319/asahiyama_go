import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_client.g.dart';

@Riverpod(keepAlive: true)
FirebaseFirestore fireStoreInstance(Ref ref) {
  final firebaseFireStore = FirebaseFirestore.instance;
  return firebaseFireStore;
}
