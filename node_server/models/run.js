const mongoose = require('mongoose');

const exerciseRunSchema = mongoose.Schema({
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
    distance: {
        required: true,
        type: String,
    },
    dateTime: {
        required: true,
        type: Date,
    },
    type: {
        type: String,
        default: 'run',
    },
});

const RunExercise = mongoose.model('RunExercise', exerciseRunSchema);
module.exports = RunExercise;