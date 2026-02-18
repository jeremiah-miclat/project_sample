import 'package:crypto/crypto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient supabase;

  AuthService(this.supabase);

  String _hashPassword(String password) {
    return sha256.convert(password.codeUnits).toString();
  }

  Future<Map<String, dynamic>> getUserByEmail(String email) async {
    final response = await supabase
        .from('users_jeremiah')
        .select()
        .eq('email', email)
        .maybeSingle();

    return response ?? {};
  }

  Future<Map<String, dynamic>> getUserById(String id) async {
    final response = await supabase
        .from('users_jeremiah')
        .select()
        .eq('id', id)
        .single();

    return response;
  }

  Future<Map<String, dynamic>> register({
    required String id,
    required String email,
    required String password,
    required String displayName,
  }) async {
    final passwordHash = _hashPassword(password);

    final response = await supabase
        .from('users_jeremiah')
        .insert({
          'id': id,
          'email': email,
          'password_hash': passwordHash,
          'display_name': displayName,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .select()
        .single();

    return response;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final user = await getUserByEmail(email);

    if (user.isEmpty) {
      throw Exception('User not found');
    }

    final passwordHash = _hashPassword(password);
    if (user['password_hash'] != passwordHash) {
      throw Exception('Invalid password');
    }

    return user;
  }

  Future<void> updatePassword({
    required String userId,
    required String newPassword,
  }) async {
    final passwordHash = _hashPassword(newPassword);

    await supabase
        .from('users_jeremiah')
        .update({
          'password_hash': passwordHash,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', userId);
  }

  Future<void> updateProfile({
    required String userId,
    String? displayName,
    String? bio,
    String? avatarUrl,
  }) async {
    final updates = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (displayName != null) {
      updates['display_name'] = displayName;
    }
    if (bio != null) {
      updates['bio'] = bio;
    }
    if (avatarUrl != null) {
      updates['avatar_url'] = avatarUrl;
    }

    await supabase.from('users_jeremiah').update(updates).eq('id', userId);
  }
}
