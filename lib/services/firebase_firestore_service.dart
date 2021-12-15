import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:revup/models/install.dart';
import 'package:revup/models/lead.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _getEnquiries() {
    return _firebaseFirestore.collection('enquiries');
  }

  Stream<List<Lead>> get enquiries {
    return _getEnquiries()
      .snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Lead.fromMap(doc.data())).toList());
  }

  void createEnquiry(Map<String, dynamic> lead) {
    _getEnquiries().add(lead);
  }

  Stream<List<Install>> get installs {
    return _firebaseFirestore.collection('installs')
      .snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Install(who: doc.data()['who'])).toList());
  }
}