import 'package:supabase_flutter/supabase_flutter.dart';

class BlogService {
  final SupabaseClient supabase;

  BlogService(this.supabase);

  Future<List<Map<String, dynamic>>> getPosts() async {
    final response = await supabase.rpc('get_posts_with_details') as List;

    return response.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> getPostById(String postId) async {
    final response =
        await supabase.rpc(
              'get_post_with_details',
              params: {'post_id_param': postId},
            )
            as List;

    if (response.isEmpty) {
      throw Exception('Post not found');
    }

    return response.first as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createPost({
    required String authorId,
    required String title,
    required String content,
  }) async {
    final response = await supabase
        .from('posts_jeremiah')
        .insert({
          'author_id': authorId,
          'title': title,
          'content': content,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .select()
        .single();

    return response;
  }

  Future<Map<String, dynamic>> updatePost({
    required String postId,
    required String title,
    required String content,
  }) async {
    final response = await supabase
        .from('posts_jeremiah')
        .update({
          'title': title,
          'content': content,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', postId)
        .select()
        .single();

    return response;
  }

  Future<void> deletePost(String postId) async {
    await supabase.from('posts_jeremiah').delete().eq('id', postId);
  }

  Future<List<Map<String, dynamic>>> getCommentsByPostId(String postId) async {
    final response =
        await supabase.rpc(
              'get_comments_with_details',
              params: {'post_id_param': postId},
            )
            as List;

    return response.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> createComment({
    required String postId,
    required String authorId,
    required String content,
  }) async {
    final response = await supabase
        .from('comments_jeremiah')
        .insert({
          'post_id': postId,
          'author_id': authorId,
          'content': content,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .select()
        .single();

    return response;
  }

  Future<Map<String, dynamic>> updateComment({
    required String commentId,
    required String content,
  }) async {
    final response = await supabase
        .from('comments_jeremiah')
        .update({
          'content': content,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', commentId)
        .select()
        .single();

    return response;
  }

  Future<void> deleteComment(String commentId) async {
    await supabase.from('comments_jeremiah').delete().eq('id', commentId);
  }

  Future<List<Map<String, dynamic>>> getPostImages(String postId) async {
    final response = await supabase
        .from('posts_image')
        .select()
        .eq('post_id', postId);

    return response;
  }

  Future<void> addPostImage({
    required String postId,
    required String url,
  }) async {
    await supabase.from('posts_image').insert({'post_id': postId, 'url': url});
  }

  Future<void> deletePostImage(String imageId) async {
    await supabase.from('posts_image').delete().eq('id', imageId);
  }

  Future<List<Map<String, dynamic>>> getCommentImages(String commentId) async {
    final response = await supabase
        .from('comment_images_jeremiah')
        .select()
        .eq('comment_id', commentId);

    return response;
  }

  Future<void> addCommentImage({
    required String commentId,
    required String url,
  }) async {
    await supabase.from('comment_images_jeremiah').insert({
      'comment_id': commentId,
      'url': url,
    });
  }

  Future<void> deleteCommentImage(String imageId) async {
    await supabase.from('comment_images_jeremiah').delete().eq('id', imageId);
  }
}
