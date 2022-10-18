// imports from packages
const express = require('express');
const mongoose = require('mongoose');

// server init
const PORT = 3000;
const server = express();
const mongoDB_url = 'mongodb+srv://myles:246810@cluster0.bkyonlz.mongodb.net/?retryWrites=true&w=majority';

// imports from other files
const authRouter = require("./routes/auth");

// middleware
server.use(express.json());
server.use(authRouter);

// connections
mongoose.connect(mongoDB_url)
    .then(() => {
        console.log('connection successful');
    })
    .catch((e) => {
        console.log(e);
    });

server.listen(PORT, "0.0.0.0", () => {  // 0.0.0.0 - localhost
    console.log(`Connected at port ${PORT}`);
})