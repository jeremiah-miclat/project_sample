import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/auth_service.dart';
import 'services/blog_service.dart';
import 'repositories/auth_repository.dart';
import 'repositories/blog_repository.dart';
import 'notifiers/auth_notifier.dart';
import 'notifiers/blog_notifier.dart';
import 'ui/screens/auth/login_screen.dart';
import 'ui/screens/auth/register_screen.dart';
import 'ui/screens/blog/feed_screen.dart';

// Supabase configuration
const String supabaseUrl =
    'http://study-supabase-20c378-167-88-45-173.traefik.me';
const String supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE3NzA5NTA3ODgsImV4cCI6MTg5MzQ1NjAwMCwicm9sZSI6ImFub24iLCJpc3MiOiJzdXBhYmFzZSJ9.xbUmbbWt1CBMd2JpnkL24A54Sa25OgRCjkcsB-odlh4';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final supabaseClient = Supabase.instance.client;

    return MultiProvider(
      providers: [
        // Services
        Provider<AuthService>(create: (_) => AuthService(supabaseClient)),
        Provider<BlogService>(create: (_) => BlogService(supabaseClient)),
        // Repositories
        Provider<AuthRepository>(
          create: (context) => AuthRepository(context.read<AuthService>()),
        ),
        Provider<BlogRepository>(
          create: (context) => BlogRepository(context.read<BlogService>()),
        ),
        // Notifiers
        ChangeNotifierProvider<AuthNotifier>(
          create: (context) => AuthNotifier(context.read<AuthRepository>()),
        ),
        ChangeNotifierProvider<BlogNotifier>(
          create: (context) => BlogNotifier(context.read<BlogRepository>()),
        ),
      ],
      child: MaterialApp(
        title: 'Agents App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Consumer<AuthNotifier>(
          builder: (context, authNotifier, _) {
            if (authNotifier.isLoggedIn) {
              return const FeedScreen();
            }
            return const LoginScreen();
          },
        ),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/feed': (context) => const FeedScreen(),
        },
      ),
    );
  }
}
