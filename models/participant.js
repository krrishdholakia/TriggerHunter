//NPM Packages
var mongoose = require('mongoose');


var Schema = mongoose.Schema;

var participant = Schema({
    participant_id: {
        type: String,
        required: true
    },
    sex: {
        type: String,
        required: true
    },
    date_of_birth: {
        type: String,
        required: true
    }
}, { timestamps: true });

module.exports = mongoose.model('participants', participant);
