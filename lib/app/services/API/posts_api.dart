import 'package:ARMOYU/app/Core/API.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:image_picker/image_picker.dart';

class PostsAPI {
  final User currentUser;
  PostsAPI({required this.currentUser});

  Future<PostLikeResponse> like({required int postID}) async {
    return await API.service.postsServices.like(postID: postID);
  }

  Future<PostUnLikeResponse> unlike({required int postID}) async {
    return await API.service.postsServices.unlike(postID: postID);
  }

  Future<PostCommentLikeResponse> commentlike({required int commentID}) async {
    return await API.service.postsServices.commentlike(commentID: commentID);
  }

  Future<PostCommentUnLikeResponse> commentunlike(
      {required int commentID}) async {
    return await API.service.postsServices.commentunlike(commentID: commentID);
  }

  Future<PostShareResponse> share({
    required String text,
    required List<XFile> files,
    required String? location,
  }) async {
    return await API.service.postsServices.share(
      text: text,
      files: files,
      location: location,
    );
  }

  Future<PostRemoveResponse> remove({required int postID}) async {
    return await API.service.postsServices.remove(postID: postID);
  }

  Future<PostRemoveCommentResponse> removecomment(
      {required int commentID}) async {
    return await API.service.postsServices.removecomment(commentID: commentID);
  }

  Future<PostFetchListResponse> getPosts({required int page}) async {
    return await API.service.postsServices.getPosts(page: page);
  }

  Future<PostFetchResponse> detailfetch({
    int? postID,
    String? category,
    int? categoryDetail,
  }) async {
    return await API.service.postsServices.detailfetch(
      postID: postID,
      category: category,
      categoryDetail: categoryDetail,
    );
  }

  Future<PostCommentsFetchResponse> commentsfetch({required int postID}) async {
    return await API.service.postsServices.commentsfetch(postID: postID);
  }

  Future<PostCreateCommentResponse> createcomment(
      {required int postID, required String text}) async {
    return await API.service.postsServices.createcomment(
      postID: postID,
      text: text,
    );
  }

  Future<PostLikesListResponse> postlikeslist({required int postID}) async {
    return await API.service.postsServices.postlikeslist(postID: postID);
  }
}
