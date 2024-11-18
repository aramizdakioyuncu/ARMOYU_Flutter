import 'package:ARMOYU/app/Core/API.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:image_picker/image_picker.dart';

class PostsAPI {
  final User currentUser;
  PostsAPI({required this.currentUser});

  Future<Map<String, dynamic>> like({
    required int postID,
  }) async {
    return await API.service.postsServices.like(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      postID: postID,
    );
  }

  Future<Map<String, dynamic>> unlike({
    required int postID,
  }) async {
    return await API.service.postsServices.unlike(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      postID: postID,
    );
  }

  Future<Map<String, dynamic>> commentlike({
    required int commentID,
  }) async {
    return await API.service.postsServices.commentlike(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      commentID: commentID,
    );
  }

  Future<Map<String, dynamic>> commentunlike({
    required int commentID,
  }) async {
    return await API.service.postsServices.commentunlike(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      commentID: commentID,
    );
  }

  Future<Map<String, dynamic>> share({
    required String text,
    required List<XFile> files,
    required String? location,
  }) async {
    return await API.service.postsServices.share(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      text: text,
      files: files,
      location: location,
    );
  }

  Future<Map<String, dynamic>> remove({
    required int postID,
  }) async {
    return await API.service.postsServices.remove(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      postID: postID,
    );
  }

  Future<Map<String, dynamic>> removecomment({
    required int commentID,
  }) async {
    return await API.service.postsServices.removecomment(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      commentID: commentID,
    );
  }

  Future<Map<String, dynamic>> getPosts({
    required int page,
  }) async {
    return await API.service.postsServices.getPosts(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      page: page,
    );
  }

  Future<Map<String, dynamic>> detailfetch({
    int? postID,
    String? category,
    int? categoryDetail,
  }) async {
    return await API.service.postsServices.detailfetch(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      postID: postID,
      category: category,
      categoryDetail: categoryDetail,
    );
  }

  Future<Map<String, dynamic>> commentsfetch({
    required int postID,
  }) async {
    return await API.service.postsServices.commentsfetch(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      postID: postID,
    );
  }

  Future<Map<String, dynamic>> createcomment({
    required int postID,
    required String text,
  }) async {
    return await API.service.postsServices.createcomment(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      postID: postID,
      text: text,
    );
  }

  Future<Map<String, dynamic>> postlikeslist({
    required int postID,
  }) async {
    return await API.service.postsServices.postlikeslist(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      postID: postID,
    );
  }
}
