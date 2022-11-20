const mongoose = require('mongoose');

const calendarEventSchema = mongoose.Schema({
    eventName: {
        required: true,
        type: String,
        trim: true,
    },
    email: {    // unique identifier
        required: true,
        type: String,
    },
    from: {
        required: true,
        type: String,
    },
    to: {
        required: true,
        type: String,
    },
    background: {
        required: true,
        type: String,
    },
    isAllDay: {
        required: true,
        type: Boolean,
    },
    type: {
        type: String,
        default: 'calendar_event',
    },
});

const CalendarEvent = mongoose.model('CalendarEvent', calendarEventSchema);
module.exports = CalendarEvent;