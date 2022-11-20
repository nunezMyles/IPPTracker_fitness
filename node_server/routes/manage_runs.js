const express = require('express')
const RunExercise = require('../models/run');
const exerciseRunRouter = express.Router();


exerciseRunRouter.post('/api/exercise/getRun', async (req, res) => {
    try {
        const {email} = req.body;  
        const run_exercises = await RunExercise.find({email});
        res.json(run_exercises);  

    } catch (e) {
        res.status(500).json({error: e.message});
    }
})

exerciseRunRouter.post('/api/exercise/removeRun', async (req, res) => {
    try {
        const {id} = req.body;  
        await RunExercise.deleteOne({ _id: id});
        res.json(true);

    } catch (e) {
        res.status(500).json({error: e.message});
    }
})

exerciseRunRouter.post('/api/exercise/createRun', async (req, res) => {
    try {
        const {name, email, timing, distance} = req.body;  

        let run_exercises1 = new RunExercise({       
            name,
            email,
            timing,
            distance,
            dateTime: new Date(),
        });

        run_exercises1 = await run_exercises1.save(); 
        res.json(true);

    } catch (e) {
        res.status(500).json({error: e.message});
    }
})

module.exports = exerciseRunRouter;