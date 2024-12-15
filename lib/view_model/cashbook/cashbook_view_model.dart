import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing_press/model/cashbook_entry.dart';

class CashbookViewModel with ChangeNotifier {
  late List<CashbookEntry> allCashbookEntries;

  Stream<QuerySnapshot<Map<String, dynamic>>> getCashbookData() {
    return FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('CashbookData')
        .collection('CashbookEntry')
        .orderBy('cashbookEntryId', descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getSupplierName(
      int supplierId) {
    return FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('SuppliersData')
        .collection('Suppliers')
        .doc('SUP-$supplierId')
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getCustomerBusinessTitle(
      int customerOrderId) {
    return FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('CustomerData')
        .collection('CustomerOrders')
        .doc('$customerOrderId')
        .snapshots();
  }

  // function to convert time stamp to date
  DateTime returnDateAndTimeFormat(String time){
    var dt = DateTime.fromMicrosecondsSinceEpoch(int.parse(time.toString()));
    var originalDate = DateFormat('MM/dd/yyyy').format(dt);
    return DateTime(dt.year, dt.month , dt.day);
  }

  //function to return message time in 24 hours format AM/PM
  static String messageTime(String time){
    var dt = DateTime.fromMicrosecondsSinceEpoch(int.parse(time.toString()));
    String difference = '';
    difference = DateFormat('jm').format(dt).toString() ;
    return difference ;
  }

  // function to return date if date changes based on your local date and time
  String groupMessageDateAndTime(String time){

    var dt = DateTime.fromMicrosecondsSinceEpoch(int.parse(time.toString()));
    var originalDate = DateFormat('MM/dd/yyyy').format(dt);

    final todayDate = DateTime.now();

    final today = DateTime(todayDate.year, todayDate.month, todayDate.day);
    final yesterday = DateTime(todayDate.year, todayDate.month, todayDate.day - 1);
    String difference = '';
    final aDate = DateTime(dt.year, dt.month, dt.day);


    if(aDate == today) {
      difference = "Today" ;
    } else if(aDate == yesterday) {
      difference = "Yesterday" ;
    } else {
      difference = DateFormat.yMMMd().format(dt).toString() ;
    }

    return difference ;

  }
}
