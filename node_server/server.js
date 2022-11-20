// imports from packages
const express = require('express');
const mongoose = require('mongoose');

// imports from other files
const authRouter = require("./routes/auth");
const exerciseRunRouter = require("./routes/manage_runs");
const exercisePushUpRouter = require("./routes/manage_pushups");
const ipptTrainingRouter = require("./routes/manage_ippt");
const exerciseSitUpRouter = require("./routes/manage_situps");
const calendarEventRouter = require("./routes/manage_events");
const mongoURL = require("./secret");

// init
const app = express();
const PORT = process.env.PORT || 8080;  // Listen to the App Engine-specified port, or 8080 otherwise
const mongoDB_url = mongoURL;

// middleware
app.use(express.json());
app.use(authRouter);
app.use(exerciseRunRouter);
app.use(exercisePushUpRouter);
app.use(ipptTrainingRouter);
app.use(exerciseSitUpRouter);
app.use(calendarEventRouter);

// server-db config
mongoose.connect(mongoDB_url)
    .then(() => {
        console.log('connection successful');
    })
    .catch((e) => {
        console.log(e);
    });

// API test call
/*app.get('/', (req, res) => {
  res.send('Hello from App Engines!');
});*/

app.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}...`);
});
