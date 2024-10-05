import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:green_heart/application/interface/profile_repository.dart';
import 'package:green_heart/domain/type/profile.dart';

class FirebaseProfileRepository implements ProfileRepository {
  @override
  Future<Profile?> getProfile(String uid) async {
    final firestore = FirebaseFirestore.instance;
    final docRef = firestore.collection('profile').doc(uid);
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      return Profile.fromJson(docSnapshot.data()!);
    } else {
      return null;
    }
  }

  @override
  Future<void> saveProfile(String uid, Profile profile) async {
    final firestore = FirebaseFirestore.instance;
    final docRef = firestore.collection('profile').doc(uid);
    await docRef.set(profile.toJson());
  }

  @override
  Future<String> uploadImage(String path) async {
    File file = File(path);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref =
        FirebaseStorage.instance.ref().child('image/profile/$fileName.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }
}
