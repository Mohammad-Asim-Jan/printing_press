// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class Payment {
//   final int paymentId;
//
//   /// only for customer order, for supplier this will be null or even it won't exist
//   int? customerOrderId;
//
//   /// only for supplier, for customer order this will be null or even it won't exist
//   final int? supplierId;
//
//   final int amount;
//   String? description;
//
//   /// this is either cash-in or cash-out
//   final String paymentType;
//   final String paymentMethod;
//   final Timestamp paymentDateTime;
//
//   Payment({
//     required this.paymentId,
//     this.customerOrderId,
//     this.supplierId,
//     required this.amount,
//     this.description = '...',
//     required this.paymentType,
//     required this.paymentMethod,
//     required this.paymentDateTime,
//   });
//
//   factory Payment.fromJson(Map<String, dynamic> jsonData) {
//     return Payment(
//       paymentId: jsonData['paymentId'],
//       customerOrderId: jsonData['customerOrderId'],
//       paymentDateTime: jsonData['paymentDateTime'],
//       amount: jsonData['amount'],
//       supplierId: jsonData['supplierId'],
//       description: jsonData['description'],
//       paymentType: jsonData['paymentType'],
//       paymentMethod: jsonData['paymentMethod'],
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'paymentId': paymentId,
//       'orderId': customerOrderId,
//       'paymentDateTime': paymentDateTime,
//       'amount': amount,
//       'supplierId': supplierId,
//       'description': description,
//       'paymentType': paymentType,
//       'paymentMethod': paymentMethod,
//     };
//   }
// }
