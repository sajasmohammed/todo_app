import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class formController {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static final db = FirebaseFirestore.instance;
  static String? title;
  static String? content;
  static TextEditingController titleController = TextEditingController();
  static TextEditingController contentController = TextEditingController();

  static const emptyValid = "Field can't be empty";
}
