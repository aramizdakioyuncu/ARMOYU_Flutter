import 'package:armoyu/app/constants/api_constants.dart';
import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/armoyuwidgets.dart';

class API {
  static String apiHOST = APIConstants.apiHOST;
  static String apiPORT = APIConstants.apiPORT;
  static String apiSSL = APIConstants.apiSSL;
  static String oneSignalClientID = APIConstants.oneSignalClientID;
  static String oneSignalAPIKey = APIConstants.oneSignalKey;

  static ARMOYUServices service =
      ARMOYUServices(apiKey: APIConstants.apiKEY, usePreviousAPI: true);

  static ARMOYUWidgets widgets = ARMOYUWidgets(service: service);
}
