import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'app/config/env_config.dart';
import 'app/data/providers/supabase_provider.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Validate environment configuration
  if (!EnvConfig.isConfigured) {
    throw Exception(
      'Missing environment variables: ${EnvConfig.missingKeys.join(", ")}\n'
      'Please check your .env file',
    );
  }

  // Initialize Supabase
  final supabaseProvider = await Get.putAsync(
    () => SupabaseProvider().init(
      url: EnvConfig.supabaseUrl,
      anonKey: EnvConfig.supabaseAnonKey,
      googleClientId: EnvConfig.googleClientId,
      googleWebClientId: EnvConfig.googleWebClientId,
    ),
  );

  // Check authentication status and set initial route
  final initialRoute = supabaseProvider.isAuthenticated
      ? Routes.NAVIGATION
      : Routes.LOGIN;

  runApp(
    GetMaterialApp(
      title: "Resikan",
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
    ),
  );
}
