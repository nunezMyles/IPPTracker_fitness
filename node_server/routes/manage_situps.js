const express = require('express')
const SitUpExercise = require('../models/situp');
const exerciseSitUpRouter = express.Router();

exerciseSitUpRouter.post('/api/exercise/createSitUp', async (req, res) => {
    try {
        const {name, email, timing, reps} = req.body;  

        let situp_exercises = new SitUpExercise({       
            name,
            email,
            timing,
            reps,
            dateTime: new Date(),
        });

        situp_exercises = await situp_exercises.save(); 
        res.json(true);

    } catch (e) {
        res.status(500).json({error: e.message});
    }
})

exerciseSitUpRouter.post('/api/exercise/removeSitUp', async (req, res) => {
    try {
        const {id} = req.body;  
        await SitUpExercise.deleteOne({ _id: id});
        res.json(true);

    } catch (e) {
        res.status(500).json({error: e.message});
    }
})

exerciseSitUpRouter.post('/api/exercise/getSitUp', async (req, res) => {
    try {
        const {email} = req.body;  
        const situp_exercises = await SitUpExercise.find({email});
        res.json(situp_exercises);  

    } catch (e) {
        res.status(500).json({error: e.message});
    }
})

module.exports = exerciseSitUpRouter;