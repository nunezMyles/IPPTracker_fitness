const express = require('express')
const PushUpExercise = require('../models/pushup');
const exercisePushUpRouter = express.Router();

exercisePushUpRouter.post('/api/exercise/createPushUp', async (req, res) => {
    try {
        const {name, email, timing, reps} = req.body;  

        let pushup_exercises = new PushUpExercise({       
            name,
            email,
            timing,
            reps,
            dateTime: new Date(),
        });

        pushup_exercises = await pushup_exercises.save(); 
        res.json(true);

    } catch (e) {
        res.status(500).json({error: e.message});
    }
})

exercisePushUpRouter.post('/api/exercise/removePushUp', async (req, res) => {
    try {
        const {id} = req.body;  
        await PushUpExercise.deleteOne({ _id: id});
        res.json(true);

    } catch (e) {
        res.status(500).json({error: e.message});
    }
})

exercisePushUpRouter.post('/api/exercise/getPushUp', async (req, res) => {
    try {
        const {email} = req.body;  
        const pushup_exercises = await PushUpExercise.find({email});
        res.json(pushup_exercises);  

    } catch (e) {
        res.status(500).json({error: e.message});
    }
})

module.exports = exercisePushUpRouter;