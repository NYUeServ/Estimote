//require('dotenv').config({ path: '../.env' });
var mongoose = require('mongoose');
//global.Promise.ES6 doesn't exist using node 6.2.2
//mongoose.Promise = global.Promise;
mongoose.connect(process.env.DB_HOST);

// check connection
var db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function() {
});

var Event = mongoose.model('Event', {
    id : String,
    timestamp : Date,
    status : Boolean
});

// id is a string, timestamp is a string, status is 0/1
exports.insertEvent = function(s_id, s_timestamp, s_status, callback) {
    var event = new Event({
        id : s_id,
        timestamp : new Date(s_timestamp),
        status : (s_status == 1 ? true : false)
    });

    event.save(function(err) {
        if (err) callback(err, null);
        else callback(null, event);
    });
}

// get events by id and time interval
// if id is null then get all events in time interval
// if time interval is null then get all events
exports.getEvent = function(s_id, t_start, t_end, callback) {
    if (t_start == null && t_end == null) {// no interval
        if (s_id == null) {
            Event.find(callback);
        } else {
            Event.find({
                id : s_id
            }, callback);
        }
    } else if (t_start != null && t_end != null) {
        if (s_id == null) {
            Event.find({
                timestamp : { $gte : t_start, $lte : t_end }
            }, callback);
        } else {
            Event.find({
                id : s_id,
                timestamp : { $gte : t_start, $lte : t_end }
            }, callback);
        }
    } else {
        callback("Wrong time interval!", null);
    }
}

/** Testing methods **/
// this.insertEvent("idididid", "2017-3-24-11:30", 1, function(err, rs) {
//     console.log(err);
//     console.log(rs);
// });

// this.getEvent(null, "2017-3-24-11:00", "2017-3-24-12:00", function(err, rs) {
//     console.log(err);
//     console.log(rs);
// });
