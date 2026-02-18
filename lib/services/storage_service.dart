import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final SupabaseClient supabase;

  StorageService(this.supabase);

  Future<String> uploadAvatarImage(
    String userId,
    Uint8List fileBytes,
    String fileName,
  ) async {
    final path = 'avatars/$userId/$fileName';

    await supabase.storage
        .from('avatars')
        .uploadBinary(
          path,
          fileBytes,
          fileOptions: const FileOptions(upsert: true),
        );

    final publicUrl = supabase.storage.from('avatars').getPublicUrl(path);
    return publicUrl;
  }

  Future<String> uploadPostImage(
    String postId,
    Uint8List fileBytes,
    String fileName,
  ) async {
    final path = 'post-images/$postId/$fileName';

    await supabase.storage
        .from('post-images')
        .uploadBinary(
          path,
          fileBytes,
          fileOptions: const FileOptions(upsert: true),
        );

    final publicUrl = supabase.storage.from('post-images').getPublicUrl(path);
    return publicUrl;
  }

  Future<String> uploadCommentImage(
    String commentId,
    Uint8List fileBytes,
    String fileName,
  ) async {
    final path = 'comment-images/$commentId/$fileName';

    await supabase.storage
        .from('comment-images')
        .uploadBinary(
          path,
          fileBytes,
          fileOptions: const FileOptions(upsert: true),
        );

    final publicUrl = supabase.storage
        .from('comment-images')
        .getPublicUrl(path);
    return publicUrl;
  }

  Future<void> deleteAvatarImage(String userId, String fileName) async {
    final path = 'avatars/$userId/$fileName';
    await supabase.storage.from('avatars').remove([path]);
  }

  Future<void> deletePostImage(String postId, String fileName) async {
    final path = 'post-images/$postId/$fileName';
    await supabase.storage.from('post-images').remove([path]);
  }

  Future<void> deleteCommentImage(String commentId, String fileName) async {
    final path = 'comment-images/$commentId/$fileName';
    await supabase.storage.from('comment-images').remove([path]);
  }
}
