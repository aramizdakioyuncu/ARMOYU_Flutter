import 'package:ARMOYU/Models/media.dart';

class SurveyQuestion {
  final String questionValue;
  final List<Media>? questionImages;

  SurveyQuestion({
    required this.questionValue,
    this.questionImages,
  });
}
