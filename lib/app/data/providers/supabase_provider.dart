import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SupabaseProvider extends GetxService {
  late final SupabaseClient client;
  late final GoogleSignIn _googleSignIn;

  // Singleton pattern
  static SupabaseProvider get to => Get.find();

  Future<SupabaseProvider> init({
    required String url,
    required String anonKey,
    String? googleClientId,
    String? googleWebClientId,
  }) async {
    await Supabase.initialize(url: url, anonKey: anonKey);
    client = Supabase.instance.client;

    // Initialize Google Sign In
    _googleSignIn = GoogleSignIn(
      clientId: googleClientId,
      serverClientId: googleWebClientId,
    );

    return this;
  }

  // Auth Methods
  GoTrueClient get auth => client.auth;

  User? get currentUser => client.auth.currentUser;

  Session? get currentSession => client.auth.currentSession;

  bool get isAuthenticated => currentUser != null;

  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  // Sign up with email and password
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: data,
    );
  }

  // Sign in with email and password
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  //  Sign in with Google using native Google Sign In
  Future<AuthResponse> signInWithGoogle() async {
    try {
      // Trigger Google Sign In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign in was cancelled');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;

      if (idToken == null) {
        throw Exception('No ID Token found');
      }

      // Sign in to Supabase with the Google credentials
      final AuthResponse response = await client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      return response;
    } catch (e) {
      print('Error signing in with Google: $e');
      rethrow;
    }
  }

  // Sign out from both Supabase and Google
  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
  }

  // Sign out
  Future<void> signOut() async {
    await client.auth.signOut();
    await _googleSignIn.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    await client.auth.resetPasswordForEmail(email);
  }

  // Update user data
  Future<UserResponse> updateUser({
    String? email,
    String? password,
    Map<String, dynamic>? data,
  }) async {
    return await client.auth.updateUser(
      UserAttributes(email: email, password: password, data: data),
    );
  }

  // Database Methods
  SupabaseQueryBuilder from(String table) => client.from(table);

  // Storage Methods
  SupabaseStorageClient get storage => client.storage;

  // Realtime Methods
  RealtimeClient get realtime => client.realtime;

  // Helper method to listen to table changes
  RealtimeChannel channel(String channelName) {
    return client.channel(channelName);
  }

  @override
  void onClose() {
    client.dispose();
    super.onClose();
  }
}
