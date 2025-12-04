# 🔐 Environment Variables Setup

This guide explains how to set up and use environment variables in the Resikan app to securely manage sensitive information like API keys and credentials.

## 📋 Prerequisites

- Flutter SDK installed
- Project cloned to your local machine

## 🚀 Quick Start

### 1. Copy the Example File

Copy `.env.example` to create your own `.env` file:

```bash
cp .env.example .env
```

### 2. Configure Your Environment Variables

Edit the `.env` file and replace the placeholder values with your actual credentials:

```env
# Supabase Configuration
SUPABASE_URL=your_actual_supabase_url
SUPABASE_ANON_KEY=your_actual_supabase_anon_key

# Google Sign In Configuration
GOOGLE_CLIENT_ID=your_actual_google_client_id
GOOGLE_WEB_CLIENT_ID=your_actual_google_web_client_id
```

### 3. Get Your Credentials

#### Supabase Credentials

1. Go to [Supabase Dashboard](https://app.supabase.com)
2. Select your project
3. Go to **Settings** → **API**
4. Copy:
   - **Project URL** → `SUPABASE_URL`
   - **anon/public key** → `SUPABASE_ANON_KEY`

#### Google Sign In Credentials

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Select your project or create a new one
3. Go to **APIs & Services** → **Credentials**
4. Create OAuth 2.0 Client IDs for:
   - **Android** → `GOOGLE_CLIENT_ID`
   - **Web** → `GOOGLE_WEB_CLIENT_ID`

### 4. Install Dependencies

```bash
flutter pub get
```

### 5. Run the App

```bash
flutter run
```

## 📁 File Structure

```
resikan_app/
├── .env                    # Your local environment variables (gitignored)
├── .env.example            # Template for environment variables
├── lib/
│   └── app/
│       └── config/
│           └── env_config.dart  # Environment configuration helper
└── ENV_SETUP.md           # This file
```

## 🔒 Security Best Practices

### ✅ DO

- ✅ **Keep `.env` file in `.gitignore`** - Already configured
- ✅ **Use `.env.example` as template** - Share this with your team
- ✅ **Never commit actual credentials** - The `.env` file is ignored by git
- ✅ **Use different credentials for different environments** (dev, staging, production)
- ✅ **Rotate keys regularly** - Update credentials periodically

### ❌ DON'T

- ❌ **Don't commit `.env` file** - It contains sensitive information
- ❌ **Don't share credentials in chat/email** - Use secure methods
- ❌ **Don't hardcode credentials** - Always use environment variables
- ❌ **Don't use production keys in development** - Use separate credentials

## 🛠️ Using Environment Variables

### In Code

Access environment variables through the `EnvConfig` class:

```dart
import 'package:resikan_app/app/config/env_config.dart';

// Get Supabase URL
final url = EnvConfig.supabaseUrl;

// Get Supabase Anon Key
final key = EnvConfig.supabaseAnonKey;

// Get Google Client ID
final googleId = EnvConfig.googleClientId;

// Check if all variables are configured
if (EnvConfig.isConfigured) {
  print('Environment is properly configured');
} else {
  print('Missing: ${EnvConfig.missingKeys}');
}
```

### Validation

The app automatically validates environment variables on startup. If any required variable is missing, you'll see an error message:

```
Exception: Missing environment variables: SUPABASE_URL, SUPABASE_ANON_KEY
Please check your .env file
```

## 🔧 Troubleshooting

### Error: "Missing environment variables"

**Solution:** Make sure your `.env` file exists and contains all required variables.

```bash
# Check if .env file exists
ls -la .env

# If not, copy from example
cp .env.example .env
```

### Error: ".env file not found"

**Solution:** The `.env` file should be in the root of the project:

```bash
# Correct location
resikan_app/.env

# Wrong location
resikan_app/lib/.env
```

### Environment variables not updating

**Solution:** 
1. Stop the app completely
2. Run `flutter clean`
3. Run `flutter pub get`
4. Restart the app

```bash
flutter clean
flutter pub get
flutter run
```

### Hot reload doesn't pick up .env changes

**Solution:** Environment variables are loaded at app startup. You need to **restart** the app (not just hot reload) for changes to take effect.

## 🌍 Multiple Environments

If you need different configurations for development, staging, and production:

### Create Multiple .env Files

```bash
.env.development
.env.staging
.env.production
```

### Load Different Files

Modify `main.dart` to load different files based on build flavor:

```dart
const environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');
await dotenv.load(fileName: ".env.$environment");
```

### Run with specific environment

```bash
flutter run --dart-define=ENVIRONMENT=development
flutter run --dart-define=ENVIRONMENT=staging
flutter run --dart-define=ENVIRONMENT=production
```

## 📦 Package Used

- **flutter_dotenv** (v5.1.0): Load environment variables from `.env` file
- [Package Documentation](https://pub.dev/packages/flutter_dotenv)

## 🤝 Team Collaboration

When working with a team:

1. **Share `.env.example`** - Commit this to git
2. **Document required variables** - Update this file
3. **Use a password manager** - Share actual credentials securely
4. **Environment-specific keys** - Each team member can use their own dev keys

## 📝 Adding New Environment Variables

1. Add to `.env` file:
   ```env
   NEW_API_KEY=your_new_key_here
   ```

2. Add to `.env.example`:
   ```env
   NEW_API_KEY=your_new_api_key_here
   ```

3. Add to `lib/app/config/env_config.dart`:
   ```dart
   static String get newApiKey => dotenv.env['NEW_API_KEY'] ?? '';
   ```

4. Update validation in `env_config.dart`:
   ```dart
   static bool get isConfigured {
     return supabaseUrl.isNotEmpty &&
         supabaseAnonKey.isNotEmpty &&
         googleClientId.isNotEmpty &&
         googleWebClientId.isNotEmpty &&
         newApiKey.isNotEmpty; // Add this
   }
   ```

## 📚 Additional Resources

- [Flutter Environment Variables Best Practices](https://docs.flutter.dev/deployment/flavors)
- [Supabase Documentation](https://supabase.com/docs)
- [Google Sign-In Setup](https://pub.dev/packages/google_sign_in)

## 💡 Tips

- Use descriptive names for environment variables
- Group related variables together
- Add comments in `.env.example` to explain each variable
- Keep this documentation up to date
- Consider using a CI/CD pipeline to inject environment variables during build

---

**⚠️ Important:** Never commit your `.env` file or any file containing actual credentials to version control!