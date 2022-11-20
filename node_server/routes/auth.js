const express = require('express')
const User = require('../models/user');
const bcryptjs = require('bcryptjs');
const jwt = require('jsonwebtoken');

const authRouter = express.Router();
const auth = require("../middlewares/auth");

// sign up route
authRouter.post('/api/signup', async (req, res) => {
    try {
        // get email, username, password from client req
        const {name, email, password} = req.body;   

        // prevent duplicate emails (unique)
        const existingUserMail = await User.findOne({email});   
        if (existingUserMail) {
            return res.status(400).json({msg: 'User with same email already exists.'});
        }

        // add salt to password
        const hashed_password = await bcryptjs.hash(password, 8);   

        // create user object
        let user = new User({       
            name,
            email,
            password: hashed_password,
        });

        // save user object to MongoDB
        user = await user.save();   
        
        // send reponse to client with user object in json form
        res.json(user);      

    } catch (e) {
        res.status(500).json({error: e.message});
    }
})

// sign in route
authRouter.post('/api/signin', async (req, res) => {
    try {
        // get email, password from client req
        const {email, password} = req.body;

        // check if email exists
        const user = await User.findOne({email});
        if (!user) {
            return res.status(400).json({msg: "User with this email does not exist."});
        }

        // check if password is correct
        const isMatch = await bcryptjs.compare(password, user.password);
        if (!isMatch) {
            return res.status(400).json({msg: "Incorrect password."});
        }

        // use JWT to ensure that users are who they say they are, prevent hackers
        const token = jwt.sign({id: user._id}, "passwordKey") 
        res.json({token, ...user._doc});

    } catch (e) {
        res.status(500).json({error: e.message});
    }
})

authRouter.post('/tokenIsValid', async (req, res) => {
    try {
        const token = req.header('x-auth-token');
        if (!token) return res.json(false);

        const verified = jwt.verify(token, 'passwordKey');
        if (!verified) return res.json(false);

        const user = await User.findById(verified.id);
        if (!user) return res.json(false);

        res.json(true);
    } catch (e) {
        res.status(500).json({error: e.message});
    }
})

// get user data
authRouter.get('/', auth, async (req, res) => {
    const user = await User.findById(req.user);
    res.json({...user._doc, token: req.token});
})

module.exports = authRouter;