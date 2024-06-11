# Chat Application

This project is a Flutter-based chat application that uses Firebase as the backend. It provides real-time messaging functionality with features like authentication, chat rooms, and user profile management. The app is designed to be scalable, secure, and easy to use.

## Features

- **User Authentication**: Users can sign up and log in using email and password authentication.
- **Real-time Messaging**: Supports real-time text messaging.
- **Chat Rooms**: Users can create and join chat rooms.
- **User Profiles**: Users can create and update their profiles.
- **Push Notifications**: Receives notifications for new messages.

## Installation

### Prerequisites

- Flutter SDK
- Firebase account with a project set up
- Dart 2.12 or later

### Setup

1. **Clone the repository:**

    ```sh
    git clone https://github.com/your-username/your-repository.git
    cd your-repository
    ```

2. **Install dependencies:**

    ```sh
    flutter pub get
    ```

3. **Set up Firebase:**

    - Go to the [Firebase Console](https://console.firebase.google.com/).
    - Create a new project or use an existing one.
    - Add an Android app and an iOS app to the project.
    - Download the `google-services.json` file for Android and place it in the `android/app` directory.
    - Download the `GoogleService-Info.plist` file for iOS and place it in the `ios/Runner` directory.

4. **Run the application:**

    ```sh
    flutter run
    ```

## Usage

1. **Sign Up / Log In:**
    - Users can sign up using their email and password.
    - Existing users can log in with their credentials.

2. **Create / Join Chat Rooms:**
    - Users can create new chat rooms or join existing ones.

3. **Send / Receive Messages:**
    - Users can send and receive real-time messages within chat rooms.

4. **Manage Profile:**
    - Users can update their profile information.

## Contributing

Contributions are welcome! Please read the [contributing guidelines](CONTRIBUTING.md) for more details.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgements

- [Flutter](https://flutter.dev/)
- [Firebase](https://firebase.google.com/)
