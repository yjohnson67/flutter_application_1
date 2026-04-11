🚀 Rocket Dodge Game – Full Stack Mobile & Web Application with Analytics Dashboard

This project expands a simple Django web application into a full-stack interactive system that integrates a Flutter mobile application, a Flame-powered game, and a MongoDB-backed analytics dashboard.

The application begins with a Django web interface that collects a player’s name and preferred rocket color. This information is passed into a Flutter mobile app, where the player launches a mini-game built using the Flutter framework and the Flame game engine.

Inside the game, the player controls a rocket ship and must avoid falling obstacles such as planets and moons. The rocket is dynamically colored based on the player’s selection from the web form. As the player survives longer, their score increases. When the rocket collides with an obstacle, the game ends and the final score is sent to a Django backend API.

The backend stores player data and scores in a MongoDB database, allowing for real-time tracking and analysis.

The project also includes a web-based analytics system that displays:

A Top 10 Leaderboard
Individual Player Statistics Pages
A full Dashboard with Charts and Insights

Charts are dynamically generated using Matplotlib and rendered directly into Django templates.

This project demonstrates full-stack integration between:

Web applications (Django)
Mobile applications (Flutter)
Game development (Flame)
Database systems (MongoDB)
Data visualization (Matplotlib)
🎥 Demo Video

https://youtu.be/SpoV1vwDvKY 

🛠️ Instructions for Build and Use
Steps to Build and Run the Software
1. Install Required Software
Flutter (latest stable version)
Android Studio or another emulator
Python (3.10+ recommended)
Django
MongoDB Atlas account (or local MongoDB)
Visual Studio Code
Git
2. Clone the Repository
git clone <your-repo-url>
cd project-folder
3. Set Up Django Backend
pip install -r requirements.txt

Make sure the following dependencies are installed:

pip install django pymongo dnspython matplotlib python-dotenv

Run the server:

python manage.py runserver 0.0.0.0:8000
4. Set Up Flutter App
cd flutter_application_1
flutter pub get

Start an emulator:

flutter emulators --launch Pixel_9

Run the app:

flutter run
5. Ensure Correct API Base URL

For emulator testing:

const String baseUrl = 'http://10.0.2.2:8000';

For deployed version:

const String baseUrl = 'https://gettingtoknowyou.onrender.com';
🎮 Instructions for Using the Software
Game Flow
Launch the mobile app.
The app loads the Django web interface.
Enter:
Player name
Rocket color
Press Play
Control the rocket by moving left/right.
Avoid obstacles to increase your score.
When you crash:
Game ends
Score is saved to the database
Web Features

Users can navigate to:

Leaderboard Page
Displays Top 10 players by score
Player Stats Page
Shows:
Games played
Average score
Score history
Performance trend
Charts
Dashboard Page
Displays:
Total players
Total games
Highest score
Average score
Charts for:
Top players
Score trends over time
💻 Development Environment

To recreate the development environment, you need:

Flutter
Dart
Flame
Django
MongoDB
Matplotlib
Android Studio
Visual Studio Code
GitHub
📚 Useful Websites

These resources were helpful during development:

https://flutter.dev/docs
https://flame-engine.org
https://docs.djangoproject.com
https://www.mongodb.com/docs
https://matplotlib.org/stable/contents.html
https://developer.android.com/studio
🔮 Future Work

Planned improvements for this project include:

Improve UI/UX design across all pages
Add authentication and user accounts
Implement real-time leaderboard updates
Replace matplotlib with frontend chart libraries (e.g., Chart.js)
Add difficulty scaling in gameplay
Introduce power-ups and new obstacle types
Expand game modes or additional mini-games
Optimize performance for mobile devices
Deploy full production system with CI/CD pipeline
🏁 Summary

This project demonstrates a complete full-stack system that integrates:

Web development (Django)
Mobile app development (Flutter)
Game development (Flame)
Database design (MongoDB)
Data visualization (Matplotlib)

It highlights real-world challenges such as:

API communication
emulator networking (10.0.2.2)
deployment issues (Render)
dependency management
full-stack debugging