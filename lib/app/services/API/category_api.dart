import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';

class CategoryAPI {
  final User currentUser;
  CategoryAPI({required this.currentUser});

  Future<CategoryResponse> category({required String categoryID}) async {
    return await API.service.categoryServices.category(categoryID: categoryID);
  }

  Future<CategoryResponse> categorydetail({required String categoryID}) async {
    return await API.service.categoryServices
        .categorydetail(categoryID: categoryID);
  }
}
