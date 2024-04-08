import 'package:ARMOYU/Models/media.dart';

class SurveyQuestion {
  String questionValue;
  List<Media>? questionImages;

  SurveyQuestion({
    required this.questionValue,
    this.questionImages,
  });
}
