import 'package:cloud_firestore/cloud_firestore.dart';

class DbManager {
  static CollectionReference postCollection =
      FirebaseFirestore.instance.collection("post");
}
