import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

class FirebaseFirestoreServices {
  FirebaseAuth auth;

  FirebaseFirestoreServices({required this.auth});

  Future<Map<String, dynamic>?> fetchData() async {
    final docRef = FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('RateList');
    final docSnapshot = await docRef.get();

    Map<String, dynamic>? data = docSnapshot.data();

    return data;

    // // Preprocess the data
    // List<YourModelInputType> preprocessedData = preprocessData(data);
    //
    // // Use the data with your model
    // List<YourModelOutputType> predictions = yourModel.predict(preprocessedData);
    //
    // // Perform any logical operations with the predictions
    // print(predictions);
  }

  // List<YourModelInputType> preprocessData(List<Map<String, dynamic>> data) {
  //   // Implement your own preprocessing logic here
  //   return data.map((item) => YourModelInputType.fromMap(item)).toList();
  // }

  initialData() {
    FirebaseFirestore fireStore = FirebaseFirestore.instanceFor(app: auth.app);
    final uid = auth.currentUser!.uid;

    /// it is dummy data
    fireStore.collection(uid).doc("RateList").set({
      "designs": [
        {"name": "standard", "rate": 200}
      ],
      "paper": [
        {
          "name": "paper1",
          "quality": 70,
          "size": {"width": 20, "height": 30},
          "rate": 2000
        },
        {
          "name": "paper1",
          "quality": 70,
          "size": {"width": 20, "height": 30},
          "rate": 2000
        }
      ],
      "paperCutting": [
        {"name": "standard", "rate": 50}
      ],
      "machines": [
        {
          "name": "halfRota",
          "size": {"width": 9, "height": 14},
          "plate": 200,
          "printing": 200
        },
        {
          "name": "gto",
          "size": {"width": 14, "height": 18},
          "plate": 350,
          "printing": 300
        },
        {
          "name": "solna",
          "size": {"width": 18, "height": 23},
          "plate": 500,
          "printing": 500
        }
      ],
      "bending": [
        {"name": "standard", "rate": 50}
      ],
      "numbering": [
        {"name": "standard", "rate": 50}
      ],
      "profit": [30, 40]
    });
  }
}

// {
// "designs": [
// {"name": "standard", "rate": 200}
// ],
// "paper": {
// "20X30": {
// "quality": 70,
// "size": {"width": 20, "height": 30},
// "rate": 2000
// }
// },
// "paperCutting": {"standard": 50},
// "machines": {
// "halfRota": {
// "size": {"width": 9, "height": 14},
// "plate": 200,
// "printing": 200
// },
// "gTO": {
// "size": {"width": 14, "height": 18},
// "plate": 350,
// "printing": 300
// },
// "solna": {
// "size": {"width": 18, "height": 23},
// "plate": 500,
// "printing": 500
// }
// },
// "bending": {"standard": 30},
// "numbering": {"standard": 30},
// "profit": 30
// }
