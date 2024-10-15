import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:green_heart/application/interface/post_repository.dart';
import 'package:green_heart/domain/type/post.dart';

class FirebasePostRepository implements PostRepository {
  @override
  Future<void> uploadPost(Post post) async {
    final firestore = FirebaseFirestore.instance;
    final docRef = firestore.collection('post').doc();
    await docRef.set(post.toJson());
  }

  @override
  Future<List<String>> uploadImages(String uid, List<String> paths) async {
    List<String> urls = [];
    for (final path in paths) {
      File file = File(path);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref =
          FirebaseStorage.instance.ref().child('image/post/$uid/$fileName.jpg');
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }
}
