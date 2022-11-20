const mongoose = require('mongoose');

const exercisePushUpSchema = mongoose.Schema({
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
        default: 'pushup',
    },
});

const PushUpExercise = mongoose.model('PushUpExercise', exercisePushUpSchema);
module.exports = PushUpExercise;