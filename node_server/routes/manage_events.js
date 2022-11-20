const express = require('express')
const CalendarEvent = require('../models/event');
const calendarEventRouter = express.Router();


calendarEventRouter.post('/api/createEvent', async (req, res) => {
    try {
        const {eventName, email, from, to, background, isAllDay} = req.body;  

        let calendar_event = new CalendarEvent({       
            eventName,
            email,
            from,
            to,
            background,
            isAllDay,
        });

        calendar_event = await calendar_event.save(); 
        res.json(true);

    } catch (e) {
        res.status(500).json({error: e.message});
    }
})

calendarEventRouter.post('/api/getEvent', async (req, res) => {
    try {
        const {email} = req.body;  
        const calendar_event = await CalendarEvent.find({email});
        res.json(calendar_event);  

    } catch (e) {
        res.status(500).json({error: e.message});
    }
})

calendarEventRouter.post('/api/removeEvent', async (req, res) => {
    try {
        const {id} = req.body;  
        await CalendarEvent.deleteOne({ _id: id});
        res.json(true);

    } catch (e) {
        res.status(500).json({error: e.message});
    }
})


module.exports = calendarEventRouter;