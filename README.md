# Weather App

A beautiful and functional weather application built with Flutter that provides real-time weather information with an intuitive user interface.

## Features

- **User Authentication**: Secure login and signup system
- **Weather Information**: Current weather conditions and forecasts
- **Beautiful UI**: Visually appealing interface with background images that change based on weather conditions
- **Responsive Design**: Works seamlessly across different screen sizes
- **Form Validation**: Input validation for email and password fields

## Screenshots
![Screenshot_20250317_080805](https://github.com/user-attachments/assets/06cc337c-35a9-4aad-995c-0d9d123403e1)
![Screenshot_20250317_080711](https://github.com/user-attachments/assets/4bc99e2b-4cf6-4c8a-b753-9348ed156ff6)

## Getting Started

### Prerequisites

- Flutter SDK (version 3.0.0 or higher)
- Dart SDK (version 2.17.0 or higher)
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/weather-app.git
   ```

2. Navigate to the project directory:
   ```
   cd weather-app
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Run the app:
   ```
   flutter run
   ```

## Project Structure

- `lib/` - Contains all the Dart code for the application
  - `main.dart` - Entry point of the application
  - `login_page.dart` - Login screen implementation
  - `signup_page.dart` - Signup screen implementation
  - `weather_pages.dart` - Weather information screens

## Usage

1. Launch the app and you'll be presented with a login screen
2. Sign in with your credentials or create a new account
3. Once authenticated, you'll see the current weather information
4. Navigate through the app to view detailed forecasts and additional information

## Customization

You can customize the app by modifying the following:

- Change background images in the `assets/images/` directory
- Adjust color schemes in the respective widget files
- Modify the validation logic in the form fields

## Dependencies

- flutter: ^3.0.0
- [Other dependencies as needed]

## Removing Debug Banner

To remove the debug banner from your app:

1. Open your `main.dart` file
2. In your MaterialApp widget, add:
   ```dart
   debugShowCheckedModeBanner: false
   ```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Weather data provided by [Weather API Provider]
- Icon designs from [Icon Source]
