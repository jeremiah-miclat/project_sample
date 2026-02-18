import '../models/post_model.dart';
import '../models/comment_model.dart';
import '../services/blog_service.dart';

class BlogRepository {
  final BlogService blogService;

  BlogRepository(this.blogService);

  Future<List<PostModel>> getPosts() async {
    final posts = await blogService.getPosts();

    return posts.map((post) {
      // Parse images from the response
      final images = <String>[];
      if (post['images'] != null) {
        images.addAll(List<String>.from(post['images'] as List));
      }

      return PostModel(
        id: post['id'] as String,
        authorId: post['author_id'] as String,
        authorName: post['author_name'] as String? ?? 'Anonymous',
        authorAvatar: post['author_avatar'] as String?,
        title: post['title'] as String,
        content: post['content'] as String,
        images: images,
        createdAt: DateTime.parse(post['created_at'] as String),
        updatedAt: DateTime.parse(post['updated_at'] as String),
      );
    }).toList();
  }

  Future<PostModel> getPostById(String postId) async {
    final post = await blogService.getPostById(postId);

    final images = <String>[];
    if (post['images'] != null) {
      images.addAll(List<String>.from(post['images'] as List));
    }

    return PostModel(
      id: post['id'] as String,
      authorId: post['author_id'] as String,
      authorName: post['author_name'] as String? ?? 'Anonymous',
      authorAvatar: post['author_avatar'] as String?,
      title: post['title'] as String,
      content: post['content'] as String,
      images: images,
      createdAt: DateTime.parse(post['created_at'] as String),
      updatedAt: DateTime.parse(post['updated_at'] as String),
    );
  }

  Future<PostModel> createPost({
    required String authorId,
    required String title,
    required String content,
  }) async {
    if (title.isEmpty || content.isEmpty) {
      throw Exception('Title and content are required');
    }

    final response = await blogService.createPost(
      authorId: authorId,
      title: title,
      content: content,
    );

    return PostModel(
      id: response['id'] as String,
      authorId: response['author_id'] as String,
      authorName: response.containsKey('author_name')
          ? response['author_name'] as String
          : 'Anonymous',
      title: response['title'] as String,
      content: response['content'] as String,
      images: [],
      createdAt: DateTime.parse(response['created_at'] as String),
      updatedAt: DateTime.parse(response['updated_at'] as String),
    );
  }

  Future<PostModel> updatePost({
    required String postId,
    required String title,
    required String content,
  }) async {
    if (title.isEmpty || content.isEmpty) {
      throw Exception('Title and content are required');
    }

    final response = await blogService.updatePost(
      postId: postId,
      title: title,
      content: content,
    );

    final images = <String>[];
    if (response['images'] != null) {
      images.addAll(List<String>.from(response['images'] as List));
    }

    return PostModel(
      id: response['id'] as String,
      authorId: response['author_id'] as String,
      authorName: response['author_name'] as String? ?? 'Anonymous',
      authorAvatar: response['author_avatar'] as String?,
      title: response['title'] as String,
      content: response['content'] as String,
      images: images,
      createdAt: DateTime.parse(response['created_at'] as String),
      updatedAt: DateTime.parse(response['updated_at'] as String),
    );
  }

  Future<void> deletePost(String postId) async {
    await blogService.deletePost(postId);
  }

  Future<List<CommentModel>> getCommentsByPostId(String postId) async {
    final comments = await blogService.getCommentsByPostId(postId);

    return comments.map((comment) {
      final images = <String>[];
      if (comment['images'] != null) {
        images.addAll(List<String>.from(comment['images'] as List));
      }

      return CommentModel(
        id: comment['id'] as String,
        postId: comment['post_id'] as String,
        authorId: comment['author_id'] as String,
        authorName: comment['author_name'] as String? ?? 'Anonymous',
        authorAvatar: comment['author_avatar'] as String?,
        content: comment['content'] as String,
        images: images,
        createdAt: DateTime.parse(comment['created_at'] as String),
        updatedAt: DateTime.parse(comment['updated_at'] as String),
      );
    }).toList();
  }

  Future<CommentModel> createComment({
    required String postId,
    required String authorId,
    required String content,
  }) async {
    if (content.isEmpty) {
      throw Exception('Comment content is required');
    }

    final response = await blogService.createComment(
      postId: postId,
      authorId: authorId,
      content: content,
    );

    return CommentModel(
      id: response['id'] as String,
      postId: response['post_id'] as String,
      authorId: response['author_id'] as String,
      authorName: response.containsKey('author_name')
          ? response['author_name'] as String
          : 'Anonymous',
      content: response['content'] as String,
      images: [],
      createdAt: DateTime.parse(response['created_at'] as String),
      updatedAt: DateTime.parse(response['updated_at'] as String),
    );
  }

  Future<CommentModel> updateComment({
    required String commentId,
    required String content,
  }) async {
    if (content.isEmpty) {
      throw Exception('Comment content is required');
    }

    final response = await blogService.updateComment(
      commentId: commentId,
      content: content,
    );

    final images = <String>[];
    if (response['images'] != null) {
      images.addAll(List<String>.from(response['images'] as List));
    }

    return CommentModel(
      id: response['id'] as String,
      postId: response['post_id'] as String,
      authorId: response['author_id'] as String,
      authorName: response['author_name'] as String? ?? 'Anonymous',
      authorAvatar: response['author_avatar'] as String?,
      content: response['content'] as String,
      images: images,
      createdAt: DateTime.parse(response['created_at'] as String),
      updatedAt: DateTime.parse(response['updated_at'] as String),
    );
  }

  Future<void> deleteComment(String commentId) async {
    await blogService.deleteComment(commentId);
  }
}
