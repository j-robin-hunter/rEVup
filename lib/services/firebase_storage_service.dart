//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class FirebaseStorageService {
  static Future<Reference> uploadXFileImage(String root, String owner, XFile image) async {
    Reference ref = FirebaseStorage.instance.ref().child('images').child(root).child(owner).child(image.name);
    final metadata = SettableMetadata(
      contentType: image.mimeType,
      customMetadata: {'picked-file-path': image.path},
    );
    Future.value(ref.putData(await image.readAsBytes(), metadata));
    return ref;
  }

  static Future<Reference> uploadUint8List(String root, String owner, String key, Uint8List data) async {
    Reference ref = FirebaseStorage.instance.ref().child('images').child(root).child(owner).child(key);
    await ref.putData(data);
    return ref;
  }

  static Future<Map<String, Uint8List>> downloadUint8List(String root, String owner) async {
    Reference ref = FirebaseStorage.instance.ref().child('images').child(root).child(owner);
    ListResult result = await ref.listAll();
    Map<String, Uint8List> images = {};
    for (var item in result.items) {
      Uint8List? data = await item.getData();
      images[item.name] = data!;
    }
    return images;
  }
}
