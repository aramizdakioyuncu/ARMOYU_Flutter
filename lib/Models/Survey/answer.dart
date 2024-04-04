class SurveyAnswer {
  final int answerID;
  final String answerType;
  final String value;
  final String? answerLogo;

  SurveyAnswer({
    required this.answerID,
    required this.answerType,
    required this.value,
    this.answerLogo,
  });
}
