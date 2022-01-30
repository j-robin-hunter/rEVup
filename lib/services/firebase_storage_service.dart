//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseStorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<UploadTask?> uploadXfileImage(String root, String owner, XFile image) async {
    Reference ref = _firebaseStorage.ref().child('images').child(root).child(owner).child(image.name);
    final metadata = SettableMetadata(
      contentType: image.mimeType,
      customMetadata: {'picked-file-path': image.path},
    );
    Future.value(ref.putData(await image.readAsBytes(), metadata));
  }
}