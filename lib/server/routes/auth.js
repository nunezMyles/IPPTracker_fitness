const express = require('express'); // similar to 'import'

const authRouter = express.Router();

/*authRouter.get("/user", (req, res) => {
    res.json({msg:"myles"}); // Creating API Calls
});*/

authRouter.post('/api/signup', (req, res) => {
    // get email, username, password
    const {username, email, password} = req.body;


    // post data to database


    // return data to user


})

module.exports = authRouter;