const express = require('express')
const IpptTraining = require('../models/ippt');
const ipptTrainingRouter = express.Router();


ipptTrainingRouter.post('/api/exercise/createIpptTraining', async (req, res) => {
    try {
        const {name, email, age, runTiming, pushupReps, situpReps, score} = req.body;  

        let ippt_training = new IpptTraining({       
            name,
            email,
            age,
            runTiming,
            pushupReps,
            situpReps,
            score,
            dateTime: new Date(),
        });

        ippt_training = await ippt_training.save(); 
        res.json(true);

    } catch (e) {
        res.status(500).json({error: e.message});
    }
})

ipptTrainingRouter.post('/api/exercise/getIpptTraining', async (req, res) => {
    try {
        const {email} = req.body;  
        const ippt_training = await IpptTraining.find({email});
        res.json(ippt_training);  

    } catch (e) {
        res.status(500).json({error: e.message});
    }
})

ipptTrainingRouter.post('/api/exercise/removeIpptTraining', async (req, res) => {
    try {
        const {id} = req.body;  
        await IpptTraining.deleteOne({ _id: id});
        res.json(true);

    } catch (e) {
        res.status(500).json({error: e.message});
    }
})


module.exports = ipptTrainingRouter;