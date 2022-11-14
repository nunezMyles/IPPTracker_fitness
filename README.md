# IPPTracker - Fitness Tracker

A mobile app that records the timings and sets of User runs/situps/pushups. It includes an IPPT score calculator, activity planner, location tracker to map routes & Spotify integration.


## Frontend

### 1. App Launcher Icon
![App launcher icon](/showcase/Screenshot_20221107-213133_One%20UI%20Home.jpg)

### 2. Login/Register Screen
<img width="300" height="650" src="/showcase/Screenshot_20221108-090734.jpg" alt="login screen" /> <img width="300" height="650" src="/showcase/Screenshot_20221108-090741.jpg" alt="register screen" />


### 3. Home Screen
<img width="300" height="650" src="/showcase/Screenshot_20221107-214206.jpg" alt="home screen normal" /> <img width="300" height="650" src="/showcase/Screenshot_20221107-214218.jpg" alt="home screen add" />


### 4. Map Screen
<img width="300" height="650" src="/showcase/Screenshot_20221107-214226_Google%20Play%20services.jpg" alt="map screen off" /> <img width="300" height="650" src="/showcase/Screenshot_20221107-215143.jpg" alt="map screen on" /> <br><img width="300" height="650" src="/showcase/Screenshot_20221107-215741.jpg" alt="map screen record run" /> <img width="300" height="650" src="/showcase/Screenshot_20221107-215158.jpg" alt="map screen spotify" />


### 5. Calendar Screen
<img width="300" height="650" src="/showcase/Screenshot_20221107-215402.jpg" alt="calendar screen normal" /> <img width="300" height="650" src="/showcase/Screenshot_20221107-215355.jpg" alt="calendar screen add" />



## Backend

### Authentication
- User authentication w/ APIs
- Password hashing w/ Bcrypt

### Server
- Developed w/ Node.js Express
- Hosted in a virtual container w/ Google App Engine Cloud Service
- Includes middleware routing

### APIs
- Built RESTful APIs
- Integrated public APIs, e.g. Google Maps, IPPT score calculator
- JSON-Dart object (de)serialization

### Database
- MongoDB CRUD
- NodeJS-MongoDB connection w/ Mongoose

### Others
- Spotify w/ spotify_sdk package
- Enhanced account security w/ JWT
- Time tracker w/ stop_watch_timer package
- User location w/ geolocator, location packages
- Calender w/ syncfusion_flutter_calendar package
- User session restoration: shared_preferences package



