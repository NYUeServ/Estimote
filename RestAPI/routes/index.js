var express = require('express');
var router = express.Router();

// send sticker status from IOS to database.
router.post('/saveToDB', function(req, res) {
    console.log(req.headers);
    res.jsonp("Good");
});

// get sticker status from database
router.get('/getFromDB', function(req, res) {
    res.jsonp("get");
});

module.exports = router;
