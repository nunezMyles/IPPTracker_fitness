const express = require('express'); // similar to 'import'
const User = require('../models/user');
const bcryptjs = require('bcryptjs');
const authRouter = express.Router();

/*authRouter.get("/user", (req, res) => {
    res.json({msg:"myles"}); // Creating API Calls
});*/

authRouter.post('/api/signup', async (req, res) => {
    try {
        // get email, username, password
        const {name, email, password} = req.body;
        const existingUser = await User.findOne({email});
        if (existingUser) {
            return res.status(400).json({msg: 'User with same email already exists!'});
        }

        const hashed_password = await bcryptjs.hash(password, 8); // hash password w/ salt using bcryptJS, increased security

        let user = new User({
            name,
            email,
            password: hashed_password,
        });
        user = await user.save();
        res.json(user);

        // post data to database


        // return data to user


    } catch (e) {
        res.status(500).json({error: e.message})
    }
})

module.exports = authRouter;