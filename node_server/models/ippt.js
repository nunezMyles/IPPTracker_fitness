const mongoose = require('mongoose');

const ipptTrainingSchema = mongoose.Schema({
    name: {
        required: true,
        type: String,
        trim: true,
    },
    email: {    // unique identifier
        required: true,
        type: String,
    },
    age: {
        required: true,
        type: String,
    },
    runTiming: {
        required: true,
        type: String,
    },
    pushupReps: {
        required: true,
        type: String,
    },
    situpReps: {
        required: true,
        type: String,
    },
    score: {
        required: true,
        type: String,
    },
    dateTime: {
        required: true,
        type: Date,
    },
    type: {
        type: String,
        default: 'ippt',
    },
});

const IpptTraining = mongoose.model('IpptTraining', ipptTrainingSchema);
module.exports = IpptTraining;