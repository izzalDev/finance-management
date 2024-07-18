import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_management/model/transaction.dart' as model;
import 'package:firebase_auth/firebase_auth.dart';

class TransactionRepository {
  static final TransactionRepository _instance =
      TransactionRepository._internal();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;

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
              model.Transaction transaction = model.Transaction.fromJson(doc.data());
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

  Future<bool> update(String id, model.Transaction transaction) async {
    try {
      String uid = auth.currentUser!.uid;
      await firestore
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .doc(id)
          .update(transaction.toJson());
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
