import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/index.dart';

class LinkEventNotFoundException implements Exception {
  final int? status;
  final String? errorMessage;
  LinkEventNotFoundException({this.status, this.errorMessage});
}

class LinkException implements Exception {
  final int? status;
  final Errors? errors;
  LinkException({this.status, this.errors});
}

class LinkService {
  static Future<Link?> getLink(String linkId) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('links').doc(linkId).get();
    if (snapshot.exists) {
      return Link.fromMap(snapshot.data() as Map<String, dynamic>);
    }
    return null;
  }

  static Future<Link> generateLink(String url) async {
    final user = FirebaseAuth.instance.currentUser!;
    final String token = await user.getIdToken();
    if (token == null) {
      throw LinkEventNotFoundException(errorMessage: "invalid authenntication");
    }
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Link.fromMap(data);
    } else if (response.statusCode == 404) {
      throw LinkEventNotFoundException(
        status: response.statusCode,
        errorMessage: 'CallLink not found',
      );
    } else {
      final Map<String, dynamic> resData =
          response.body != null ? json.decode(response.body) : {};
      print('resData: $resData}');
      throw LinkException(
          status: response.statusCode, errors: Errors.fromMap(resData));
    }
  }
}
