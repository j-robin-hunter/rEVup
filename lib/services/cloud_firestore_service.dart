import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:revup/models/install.dart';
import 'package:revup/models/lead.dart';

class CloudFirestoreService {
  final FirebaseFirestore _cloudFirestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> getLeadsCollection() {
    return _cloudFirestore.collection('leads');
  }

  Stream<List<Lead>> get leads {
    return getLeadsCollection()
      .snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Lead.fromMap(doc.data())).toList());
  }

  Stream<List<Install>> get installs {
    return _cloudFirestore.collection('installs')
      .snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Install(who: doc.data()['who'])).toList());
  }
}