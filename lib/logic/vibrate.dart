import 'package:flutter/foundation.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class VibrateFeedback {
  static void feedbackLight() async {
    bool canVibrate = await Vibrate.canVibrate;

    if (!kIsWeb && canVibrate) {
      if (canVibrate) {
        Vibrate.feedback(FeedbackType.light);
      }
    }
  }
}
