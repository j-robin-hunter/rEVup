import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:revup/models/install.dart';
import 'package:revup/models/lead.dart';
import 'package:revup/models/profile.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _getEnquiries() {
    return _firebaseFirestore.collection('enquiries');
  }

  CollectionReference<Map<String, dynamic>> _getProfiles() {
    return _firebaseFirestore.collection('profiles');
  }

  Future<String?> setProfile(Profile profile) async {
    DocumentReference<Map<String, dynamic>>? documentReference;
    if (profile.id != null) {
      _getProfiles().doc(profile.id).set(profile.map);
    } else {
      if (profile.email.isNotEmpty) {
        documentReference = await _getProfiles().add(profile.map);
      }
    }
    return documentReference != null ? documentReference.id : profile.id;
  }

  Future<Profile> getProfile(String email) async {
    late Profile profile;
    await _getProfiles().where('email', isEqualTo: email).get().then((event) {
      if (event.docs.isNotEmpty) {
        profile = Profile.fromJson(event.docs.first.data());
        profile.id = event.docs.first.id;
      } else {
        profile = Profile(email: email);
      }
    }).catchError((e) {
      profile = Profile(email: email);
    });
    return profile;
  }

  Stream<List<Lead>> get enquiries {
    return _getEnquiries().snapshots().map((snapshot) => snapshot.docs.map((doc) => Lead.fromMap(doc.data())).toList());
  }

  void createEnquiry(Map<String, dynamic> lead) {
    _getEnquiries().add(lead);
  }

  Stream<List<Install>> get installs {
    return _firebaseFirestore
        .collection('installs')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Install(who: doc.data()['who'])).toList());
  }
}
