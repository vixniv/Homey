# Homey

Track, assign, and create a clean house with us.

## Requirements
- iOS 16+
- Xcode 15+
- Swift 5.9+

## Getting Started
1. Clone the repo
   git clone https://github.com/vixniv/Homey.git
2. Open MyApp.xcodeproj in Xcode
3. Select a simulator or device and run (⌘R)

## Architecture
MVVM with SwiftUI. Feature modules live under `/Homey`.

## Dependencies
Managed via Swift Package Manager (SPM). Xcode resolves them automatically on first build.

## Backend (Supabase)

The app runs against a Supabase project. To set it up:

1. Create a project at https://supabase.com.
2. In the SQL Editor, run the migrations in order:
   - `supabase/migrations/0001_schema.sql`
   - `supabase/migrations/0002_seed_demo.sql`
   (Or with the CLI: `supabase db push`.)
3. In Project Settings → API Keys, copy the **Project URL** and the **Publishable** (anon) key.
4. Put them in `Homey/Core/Supabase/SupabaseConfig.swift` (`SupabaseConfig.url` / `SupabaseConfig.anonKey`).

The publishable key is safe to ship in the client — access is gated by Row Level Security. **Do not** put the `service_role` / secret key or the database password in the app.

> Demo RLS is intentionally permissive (anonymous CRUD on the demo household) and is **not** production-ready. To move to a real demo user later: create a user in Authentication → Users, change `RootViewModel.signInDemo()` to call `supabase.auth.signIn(email:password:)`, and tighten the RLS policies from `to anon` to `to authenticated`.

### Hardening the key (optional)

For non-demo use, move `url`/`anonKey` into a gitignored `Secrets.xcconfig` and read them from `Info.plist` instead of hardcoding in `SupabaseConfig.swift`.

## Demo

Launch the app, tap **Start** on onboarding, then **Try Demo** on the login screen to enter "Ana's Family House" as Ana. Add, assign, grab, and complete chores — changes persist to Supabase and reload on pull-to-refresh.

## Contributing
1. Branch off `main`
2. Open a PR with a clear description
3. All tests must pass before merge

## License
MIT
