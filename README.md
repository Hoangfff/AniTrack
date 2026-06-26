# AniTrack

AniTrack is an anime tracking and streaming application built using a package-based Micro Frontend (MFE) architecture in a Flutter Monorepo.

## Prerequisites

Ensure the following tools are installed on your system before proceeding:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Version 3.10.0 or higher recommended)
- [Dart SDK](https://dart.dev/get-dart)
- [Melos](https://melos.invertase.dev) (Used for managing the Dart/Flutter monorepo)

## Installation & Setup

1. **Install Melos globally** (if not already installed):
   ```bash
   dart pub global activate melos
   ```

2. **Bootstrap the workspace**:
   Navigate to the root directory of the project and run the bootstrap command. This command will fetch all dependencies for all packages and link them together locally.
   ```bash
   melos bootstrap
   ```
   *(Alternatively, you can use the shorthand: `melos bs`)*
   *(Note: If your system cannot find the `melos` command after installation, you can run it globally using: `dart pub global run melos bootstrap`)*

## Running the Application

To fully run AniTrack with its local backend, you need to start both the Node.js Server and the Flutter Shell App.

### 1. Start the Local Backend Server
The backend uses Node.js and SQLite to store user profiles and tracking lists locally.
```bash
cd apps/backend
npm install
node server.js
```
*(The server will start at `http://localhost:3000` and automatically create a `database.sqlite` file if it doesn't exist).*

### 2. Start the Flutter Shell App
Open a new terminal window to run the frontend application:

1. Navigate to the shell application directory:
   ```bash
   cd apps/shell_app
   ```

2. Run the application:
   - **For Web (Chrome):** *(Requires disabling web security to bypass CORS when calling local API)*
     ```bash
     flutter run -d chrome --web-browser-flag "--disable-web-security"
     ```

## Project Structure

The monorepo is structured as follows:

- **`apps/`**: Contains the main host application (`shell_app`) which integrates all MFEs.
- **`features/`**: Contains independent Micro Frontend packages:
  - `discovery_mfe`: Handles anime discovery, trending lists, and search functionalities.
  - `player_mfe`: Manages video playback and episode selection.
  - `profile_mfe`: Displays user profile and statistics.
  - `tracking_mfe`: Manages the user's personal library and custom lists.
- **`packages/`**: Contains shared foundational packages:
  - `shared_core`: Centralized network clients, APIs, local storage, and event bus mechanisms.
  - `shared_ui`: Design system, typography, colors, and reusable UI components.
