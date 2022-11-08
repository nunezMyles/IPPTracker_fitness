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

### Server
- Hosted in Google Cloud App Engine
- Developed w/ nodeJS express

### Database
- MongoDB CRUD
- NodeJS-MongoDB configuration w/ Mongoose

### Authentication
- User authentication w/ Sign In, Sign Up APIs
- Password hashing w/ Bcrypt

### APIs
- Created RESTful APIs in server
- Use of public APIs, e.g. Google Maps, IPPT Score calculator

### Others
- Enhanced account security w/ JWT
- Session restoration: shared_preferences package
- Time tracker: stop_watch_timer package
- User location: geolocator, location package
- Calender: syncfusion_flutter_calendar package
- Spotify: spotify_sdk package


