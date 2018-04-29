//NPM Packages
const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const router = express.Router();
// const { check, oneOf, validationResult } = require('express-validator/check');
//Local Imports
const Pariticipants = require('../models/participant');
const db = 'mongodb://triggerhunter:triggerhunterteam@ds247759.mlab.com:47759/triggerhunterteam'
// Use native ES6 promises
mongoose.Promise = global.Promise;
mongoose.connect(db);


router.use(bodyParser.json());
router.use(bodyParser.urlencoded({
  extended: true
}));



router.route('/')
    .get((req, res) => {
      console.log("checking the get request in shelter.js");
    })

// Promise Example

router.route('/newUser')
    .post((req, res) => {
        Pariticipants.create(req.body, (err, participant) => {
            if(err) {
                res.send(""+err)
            } else {
                console.log(participant);
                res.send(participant);
            }
        })
    })
    .get((req, res) => {
        Pariticipants.find({}, {username: 1, _id: 0})
        .then((user) => res.send(user))
        .catch((err) => res.send(err))
      });

module.exports = router;
