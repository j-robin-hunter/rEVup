import 'package:flutter/cupertino.dart';

@immutable
class User {
  final String uid;
  final String? email;

  const User({
    required this.uid,
    this.email
  });
}