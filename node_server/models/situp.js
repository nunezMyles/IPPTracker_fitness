const mongoose = require('mongoose');

const exerciseSitUpSchema = mongoose.Schema({
    name: {
        required: true,
        type: String,
        trim: true,
    },
    email: {    // unique identifier
        required: true,
        type: String,
    },
    timing: {
        required: true,
        type: String,
    },
    reps: {
        required: true,
        type: String,
    },
    dateTime: {
        required: true,
        type: Date,
    },
    type: {
        type: String,
        default: 'situp',
    },
});

const SitUpExercise = mongoose.model('SitUpExercise', exerciseSitUpSchema);
module.exports = SitUpExercise;