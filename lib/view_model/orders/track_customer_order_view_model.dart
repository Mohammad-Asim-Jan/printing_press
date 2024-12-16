import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../colors/color_palette.dart';
import '../../text_styles/custom_text_styles.dart';
import '../../utils/toast_message.dart';

class TrackCustomerOrderViewModel with ChangeNotifier {
  Stream<DocumentSnapshot<Map<String, dynamic>>> getCustomerOrderData(
      int customerOrderId) {
    return FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('CustomerData')
        .collection('CustomerOrders')
        .doc('$customerOrderId')
        .snapshots();
  }

  getTitleText(String buttonText) {
    switch (buttonText) {
      case 'Cancel':
        return "Order Cancellation";
      case 'Pending':
        return "Pending Order";
      case 'Hand Over':
        return "Handover of Order";
      case 'Resume':
        return "Resumption of Order";
    }
  }

  getDescriptionText(String buttonText) {
    switch (buttonText) {
      case 'Cancel':
        return "cancel this order";
      case 'Pending':
        return "mark this order as pending";
      case 'Hand Over':
        return "handover this order";
      case 'Resume':
        return "resume this order";
    }
  }

  getTitleColor(String buttonText) {
    switch (buttonText) {
      case 'Cancel':
        return kNew8;
      case 'Pending':
        return Colors.orange;
      case 'Hand Over':
        return Colors.purple;
      case 'Resume':
        return Colors.green;
    }
  }

  void confirmation(BuildContext context, int customerOrderId, String button) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: kTitleText(getTitleText(button), null, getTitleColor(button)),
          content:
              Text("Are you sure you want to ${getDescriptionText(button)}?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: kTitleText("No", 12),
            ),
            TextButton(
              onPressed: () {
                switch (button) {
                  case 'Cancel':
                    cancelOrder(customerOrderId);
                    break;
                  case 'Pending':
                    pendingOrder(customerOrderId);
                    break;
                  case 'Hand Over':
                    handOverOrder(customerOrderId);
                    break;
                  case 'Resume':
                    resumeOrder(customerOrderId);
                    break;
                }
                Navigator.pop(context);
              },
              child: kTitleText("Confirm", null, getTitleColor(button)),
            ),
          ],
        );
      },
    );
  }

  cancelOrder(int customerOrderId) {
    FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('CustomerData')
        .collection('CustomerOrders')
        .doc('$customerOrderId')
        .update({'orderStatus': 'Cancelled'}).then(
      (value) {
        Utils.showMessage('Order Cancelled');
      },
    ).onError(
      (error, stackTrace) {
        Utils.showMessage('Error Occurred');
      },
    );
  }

  pendingOrder(int customerOrderId) {
    FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('CustomerData')
        .collection('CustomerOrders')
        .doc('$customerOrderId')
        .update({'orderStatus': 'Pending'}).then(
      (value) {
        Utils.showMessage('Order marked as Pending');
      },
    ).onError(
      (error, stackTrace) {
        Utils.showMessage('Error Occurred');
      },
    );
  }

  handOverOrder(int customerOrderId) {
    FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('CustomerData')
        .collection('CustomerOrders')
        .doc('$customerOrderId')
        .update({'orderStatus': 'Handed Over'}).then(
      (value) {
        Utils.showMessage('Order Handed Over to User');
      },
    ).onError(
      (error, stackTrace) {
        Utils.showMessage('Error Occurred');
      },
    );
  }

  resumeOrder(int customerOrderId) {
    FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('CustomerData')
        .collection('CustomerOrders')
        .doc('$customerOrderId')
        .update({
      'orderStatus': 'In Progress',
      'orderResumedDateTime': Timestamp.now()
    }).then(
      (value) {
        Utils.showMessage('Order Resumed');
      },
    ).onError(
      (error, stackTrace) {
        Utils.showMessage('Error Occurred');
      },
    );
  }
}
