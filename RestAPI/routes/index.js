var express = require('express');
var router = express.Router();
//require('dotenv').config({ path: '../.env' });

var db = require('../database/models');

// send sticker status from IOS to database.
// input sample:
// ["timestamp": 2017-3-24-11:30, "sensors": {
//   1a88e4f504a0c6bb = 0;
// }]
router.post('/saveToDB', function(req, res) {
    var timestamp = req.body.timestamp;
    var sensors = req.body.sensors;

    var b = false;
    for (var key in sensors) {
        if (sensors.hasOwnProperty(key)) {
            var value = sensors[key];
            // insert into database
            db.insertEvent(key, timestamp, value, function(err, event) {
                if (err) {
                    console.log(err);
                    res.jsonp('fail: ' + err);
                    b = true;
                }
            });

            if (b) break;
        }
    }
    res.jsonp('success');
});

// get sticker status from database
// /getFromDB/?id=...&start=...&end=...
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
