# pixelplayapp

🎵 PixelPlay
PixelPlay is a dynamic and modern Flutter music streaming application that offers a smooth and interactive user experience. From authentication to audio playback, everything is handled with efficient state management, dependency injection, and clean UI transitions. Below are the key features and a walkthrough of the app’s flow. To make your mind clear, the app follows clean architecture 

Tech Stack
- Flutter
- Firebase
- Appwrite

Pattern Followed Clean Architecture
dependency used throughout the project
dependencies:
  appwrite: ^15.0.0
  cloud_firestore: ^5.6.5
  cupertino_icons: ^1.0.8
  dartz: ^0.10.1
  firebase_auth: ^5.5.1
  firebase_core: ^3.12.1
  flutter:
    sdk: flutter
  flutter_bloc: ^9.1.0
  flutter_screenutil: ^5.9.3
  flutter_secure_storage: ^9.2.4
  font_awesome_flutter: ^10.8.0
  get_it: ^8.0.3
  go_router: ^14.8.1
  google_fonts: ^6.2.1
  hydrated_bloc: ^10.0.0
  just_audio: ^0.9.46
  material_symbol_icons: ^0.0.1
  path_provider: ^2.1.5



🚀 Features & App Flow
✅ Initial Launch
Logo Display: The app opens with a sleek logo animation.
Splash Screen: Transitions into a splash screen, then to the Theme Selection Page.
Theme Selection: Users can choose their preferred theme (light/dark), handled efficiently using Cubit state management.

🔐 Authentication
Login / Sign Up: Users can choose to log in or register using email/password or via Google Authentication.
Secure Storage: Credentials entered manually are securely stored using Flutter Secure Storage.
Auto Login: If the credentials exist, the app auto-redirects users to the home screen without requiring repeated logins.


🏠 Home Page
The home screen is designed to be functional and user-centric:

📑 News Section
Displays current news articles.
Users can read and react (like/dislike) to each news item.
Backend operations (fetch, like, toggle like) are handled on the server side and injected via GetIt for better dependency management.


🔽 Bottom Navigation Bar
Smooth navigation between multiple pages.
3 pages currently are now present [Home, Profile, Search]
Navigation is powered by GoRouter.

📚 Tab Bar Integration
The top section includes a tabbed layout with:
News – Same as the home section.
New Release – Lists the latest songs.
Displays music covers with play icons.
First three songs are randomly selected and reshuffled on each login.
Tapping on a song navigates to the Music Player Page.
Genres – Browse songs by genre

🎧 Music Player
A powerful and sleek music player with multiple functionalities:
Powered by just_audio package to stream and control music playback.
Features an Equalizer with pre-built presets (e.g., Melody, Bass Boost) to enhance audio output based on user preference.
Music Player Controls
Shuffle: Randomly shuffles and plays music from a network-fetched list.
Play/Pause: Toggle music playback.
Music List: View available tracks and manually select your favorite.[Under Development -10/4/25]

🔍 Search Functionality
Search Songs: Type full or partial names (e.g., typing Hell for Hell or High Water will return relevant results).
Search Users: (Coming Soon) – Feature to search other users on the platform.

🧰 Tech Stack
Flutter: Frontend Framework
Cubit: State Management
GoRouter: Route Navigation
Just_Audio: Audio Playback
GetIt: Dependency Injection
Flutter Secure Storage: Secure Credential Storage
Firebase / Custom Backend: Authentication and Database Management


Pull requests are welcome! For major changes, please open an issue first to discuss your ideas.
Last Updated on 11-04-2025
