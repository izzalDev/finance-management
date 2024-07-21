import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_management/model/transaction.dart' as model;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fstorage;
import 'package:path/path.dart' as path;

class TransactionRepository {
  static final TransactionRepository _instance =
      TransactionRepository._internal();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final fstorage.FirebaseStorage storage = fstorage.FirebaseStorage.instance;

  factory TransactionRepository() {
    return _instance;
  }

  TransactionRepository._internal();

  Future<bool> add(model.Transaction transaction) async {
    try {
      String uid = auth.currentUser!.uid;
      await firestore
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .add(
            transaction.toJson(),
          );
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Stream<List<model.Transaction>> getAllTransactions() {
    String uid = auth.currentUser!.uid;
    return firestore
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              model.Transaction transaction =
                  model.Transaction.fromJson(doc.data());
              transaction.id = doc.id;
              return transaction;
            }).toList());
  }

  Future<bool> delete(String id) async {
    try {
      String uid = auth.currentUser!.uid;
      await firestore
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .doc(id)
          .delete();
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> update(model.Transaction transaction) async {
    try {
      String uid = auth.currentUser!.uid;
      await firestore
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .doc(transaction.id)
          .update(transaction.toJson());
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> updatePhoto(model.Transaction transaction, File photo) async {
    try {
      String uid = auth.currentUser!.uid;
      String filename = transaction.id + path.extension(photo.path);
      await storage.ref('users/$uid/transactions').child(filename).putFile(photo);
      transaction.photo = await storage.ref('users/$uid/transactions').child(filename).getDownloadURL();
      await update(transaction);
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
