import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

class FirebaseFirestoreServices {
  FirebaseAuth auth;

  FirebaseFirestoreServices({required this.auth});



  // initialData() {
  //   FirebaseFirestore fireStore = FirebaseFirestore.instanceFor(app: auth.app);
  //   final uid = auth.currentUser!.uid;
  //
  //   /// it is dummy data
  //   fireStore.collection(uid).doc("RateList").set({
  //     "designs": [
  //       {"name": "standard", "rate": 200}
  //     ],
  //     "paper": [
  //       {
  //         "name": "paper1",
  //         "quality": 68,
  //         "size": {"width": 20, "height": 30},
  //         "rate": 1800
  //       },
  //       {
  //         "name": "paper2",
  //         "quality": 70,
  //         "size": {"width": 20, "height": 30},
  //         "rate": 2000
  //       }
  //     ],
  //     "news": [
  //       {
  //         "name": "paper1",
  //         "quality": 55,
  //         "size": {"width": 20, "height": 30},
  //         "rate": 1200
  //       },
  //       {
  //         "name": "paper2",
  //         "quality": 60,
  //         "size": {"width": 20, "height": 30},
  //         "rate": 1300
  //       }
  //     ],
  //     "paperCutting": [
  //       {"name": "standard", "rate": 50}
  //     ],
  //     "machines": [
  //       {
  //         "name": "halfRota",
  //         "size": {"width": 9, "height": 14},
  //         "plate": 200,
  //         "printing": 200
  //       },
  //       {
  //         "name": "gto",
  //         "size": {"width": 14, "height": 18},
  //         "plate": 350,
  //         "printing": 300
  //       },
  //       {
  //         "name": "solna",
  //         "size": {"width": 18, "height": 23},
  //         "plate": 500,
  //         "printing": 500
  //       }
  //     ],
  //     "binding": [
  //       {"name": "standard", "rate": 50}
  //     ],
  //     "numbering": [
  //       {"name": "standard", "rate": 50}
  //     ],
  //     "profit": [30, 40]
  //   });
  // }
}
