# Guess Number Game

Hi. My name is Rufina, and this is the introductory documentation for the Guess Number Game project. In this documentation you will find information about starting, testing and structure of the project.

## Features

-  **Game Logic:** Built using the BLoC pattern for a clean separation of UI and business logic.
-   **Customizable Settings:** Users can set the range and number of attempts for each game.
-   **Hints:** Provides hints ("higher" or "lower") after each guess.
-   **Win and Lose Scenarios:** Displays appropriate messages when the user wins or runs out of attempts.
-   **Responsive UI:** Designed to work seamlessly across multiple devices.
-   **Comprehensive Testing:** Includes unit tests for game logic and widget tests for UI validation.

## Project Structure

`lib/
├── bloc/
│     └── game_bloc.dart      # Business logic of the game (BLoC architecture)
├── main.dart                # Main entry point for the Flutter app

test/
├── bloc/
│     └── game_bloc_test.dart  # Unit tests for GameBloc
├── helpers/
│     └── fixed_random.dart    # Helper for predictable random number generation during tests
└── widget_test.dart           # Widget tests for app UI`

----------

## Getting Started

### Prerequisites

-   Install Flutter SDK: [Flutter Installation Guide](https://docs.flutter.dev/get-started/install)
-   Set up your development environment:
    -   Install [Android Studio](https://developer.android.com/studio?hl=ru) or [Visual Studio Code](https://code.visualstudio.com/) with the Flutter and Dart plugins.
    -   Set up a device emulator or connect a physical device.

### Installation

1.  **Clone the Repository:**

    `git clone <repository-url>
    cd guess-number`

3.  **Install Dependencies:**

    `flutter pub get`

4.  **Run the Application:**

    `flutter run`

5.  **Build the Application (Optional):** To build a release version for Android or iOS:
    `lutter build apk`
    or
    `flutter build ios`
----------

## Running Tests

This project includes comprehensive tests to ensure functionality and reliability.

### Test Structure

-   **Unit Tests:**

    -   Location: `test/bloc/game_bloc_test.dart`
    -   Description: Tests the business logic for managing game states and user interactions.
-   **Helpers for Testing:**

    -   Location: `test/helpers/fixed_random.dart`
    -   Description: Provides predictable random number generation for consistent test results.
-   **Widget Tests:**

    -   Location: `test/widget_test.dart`
    -   Description: Validates the application’s UI interactions and layout.

### Run All Tests

To execute all tests, run the following command:

`flutter test`

----------

## Code Highlights

### Game Logic (`game_bloc.dart`)

-   Implements the game logic using the BLoC architecture.

-   Supports the following events:

    -   `StartGame`: Starts a new game with a specified range and number of attempts.
    -   `MakeGuess`: Processes the user's guess and provides feedback.
-   Possible states:

    -   `GameInitial`: Initial state before the game starts.
    -   `GameInProgress`: Game is running; provides feedback and remaining attempts.
    -   `GameWon`: User has guessed the number correctly.
    -   `GameLost`: User has run out of attempts.

### Fixed Random Helper (`fixed_random.dart`)

-   Provides a mock implementation of the `Random` class to ensure predictable results during testing.

----------

## Troubleshooting

-   **Issue: Tests failing due to incorrect dependencies.**

    -   Solution: Run `flutter pub get` to ensure all dependencies are installed correctly.
-   **Issue: Emulator not starting or physical device not detected.**

    -   Solution: Verify that your device/emulator is connected and properly configured. Run `flutter doctor` for troubleshooting.

----------

## Notes

-   Make sure you are using the latest stable version of Flutter.
-   All tests have been verified to pass successfully. If any issues arise, refer to the troubleshooting section above.

----------
For further assistance, visit the [Flutter Documentation](https://docs.flutter.dev/) or Dart Language Guide.  
Thank you for reading the documentation to the end! If you have any questions or suggestions, feel free to contact me 😊  
📩 Telegram: [saruma15](https://t.me/saruma15)  
📸 Instagram: [saruma15](https://instagram.com/saruma15)  
💼 LinkedIn: [Saiputulina Rufina](https://www.linkedin.com/in/rufina-saiputulina-206545204/)
