// NPM Packages
const express = require('express');
const router = express.Router();
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const { check, oneOf, validationResult } = require('express-validator/check');
//Local Imports
const participants = require('./participants');
// const db = process.env.MONGOLAB_URI;
const db = 'mongodb://triggerhunter:triggerhunterteam@ds247759.mlab.com:47759/triggerhunterteam'

// const admin = require('./admin');
mongoose.Promise = global.Promise;
mongoose.connect(db);
console.log(db);

router.use(bodyParser.json());
router.use(bodyParser.urlencoded({
  extended: true
}));


  
router.route('/')
    .get((req, res) => {
        console.log("reached the '/' ");
    })

router.use('/participants', participants);

module.exports = router;
