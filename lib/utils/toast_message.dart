
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static void showMessage (String message) {
    Fluttertoast.showToast(msg: message);
  }
}