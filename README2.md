Rocket Dodge Game – Flutter Mobile App with Web Integration
This project expands a simple Django web application into an interactive mobile experience by integrating a small game built with the Flutter framework and the Flame game engine. The original web application collects a player’s name and favorite color through a form. When the player presses the play button, the Flutter mobile application receives the information and launches a mini-game.
In the game, the player controls a rocket ship and must avoid falling obstacles such as planets and a moon. The rocket is dynamically colored based on the player’s selected favorite color from the web form. The longer the player avoids obstacles, the higher their score becomes. If the rocket collides with an obstacle, the game ends and the player’s final score is displayed.
This project demonstrates how web applications and mobile applications can communicate with each other while also introducing a game framework. It also shows how game loops, sprite rendering, collision detection, and player interaction can be implemented within a Flutter application.

Instructions for Build and Use
https://youtu.be/SLYthgCkcqY

Steps to build and/or run the software:
Install Flutter (latest stable version recommended).
Install Android Studio or another Android emulator environment.
Clone the project repository from GitHub.
Navigate to the Flutter project directory.
Run the command flutter pub get to install required dependencies.
Start the application using flutter run.
Launch the Android emulator or connect a physical device.

Instructions for using the software:
Launch the mobile application.
The app loads the web interface containing the greeting form.
Enter a name and choose a rocket color.
Press the Play button to start the game.
Drag the rocket left or right to avoid falling obstacles.
Continue playing to increase the score.
If the rocket hits an obstacle, the game ends and the final score is displayed.
Press restart to begin a new game.

Development Environment
To recreate the development environment, you need the following software and/or libraries:
Flutter SDK
Dart programming language
Flame Game Engine for Flutter
Android Studio or Android Emulator
Visual Studio Code
Git and GitHub

Useful Websites to Learn More
I found these websites useful in developing this software:
https://flutter.dev/docs
https://flame-engine.org
https://docs.flutter.dev/development/ui/widgets
https://developer.android.com/studio

Future Work
The following items I plan to fix, improve, and/or add to this project in the future:
Add a cloud database to store player scores and create a leaderboard.
Improve the visual design of the game interface and game over screen.
Increase gameplay difficulty over time by adjusting obstacle speed and spawn rates.
Add additional game mechanics such as power-ups or different obstacle types.
Expand the mobile app to include multiple mini-games or additional player customization.
