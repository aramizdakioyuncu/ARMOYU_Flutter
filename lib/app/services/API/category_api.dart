import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/data/models/user.dart';

class CategoryAPI {
  final User currentUser;
  CategoryAPI({required this.currentUser});

  Future<Map<String, dynamic>> category({
    required String categoryID,
  }) async {
    return await API.service.categoryServices.category(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      categoryID: categoryID,
    );
  }

  Future<Map<String, dynamic>> categorydetail({
    required String categoryID,
  }) async {
    return await API.service.categoryServices.categorydetail(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      categoryID: categoryID,
    );
  }
}
