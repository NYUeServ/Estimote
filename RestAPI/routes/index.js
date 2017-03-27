var express = require('express');
var router = express.Router();
//require('dotenv').config({ path: '../.env' });

var db = require('../database/models');

// send sticker status from IOS to database.
router.post('/saveToDB', function(req, res) {
    console.log(req.headers);
    res.jsonp("Good");
});

// get sticker status from database
router.get('/getFromDB', function(req, res) {
    var id = null;
    var start = null;
    var end = null;
    if (req.query.id != null) id = req.query.id;
    if (req.query.start != null) start = req.query.start;
    if (req.query.end != null) end = req.query.end;
    db.getEvent(id, start, end, function(err, events) {
        if (err) {
            console.log('[ERROR] ' + err);
            res.jsonp(null);
        } else {
            res.jsonp(events);
        }
    });
});

module.exports = router;
