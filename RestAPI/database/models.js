//require('dotenv').config({ path: '../.env' });
var mongoose = require('mongoose');
//use bluebird promise library
mongoose.Promise = require('bluebird');

var timezone = require('../tools/timezone');

mongoose.connect(process.env.DB_HOST);

//mongoose.connect('mongodb://localhost/estimotest');

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

var Status = mongoose.model('Status', {
    timestamp : Date,
    sensors : Object
});

exports.updateStatus = function(s_timestamp, s_sensors, callback) {
    Status.find({}, function(err, status_l) {
        if (status_l.length == 0) {
            var status = new Status({
                timestamp : timezone.getDateFromTimezone(s_timestamp, 'America/New_York'),
                sensors : s_sensors
            });

            status.save(function(err) {
                if (err) callback(err, null);
                else callback(null, status);
            });
        } else if (status_l.length == 1) {
            var id = status_l[0]._id;
            Status.update({ _id : id },
                { $set : {
                    timestamp : timezone.getDateFromTimezone(s_timestamp, 'America/New_York'),
                    sensors : s_sensors
                } }, function(err, status) {
                    if (err) callback(err, null);
                    else callback(null, status);
            });
        } else {
            callback("More than one status in DB!", null);
        }
    });
}

exports.getStatus = function(callback) {
    Status.find({}, function(err, status_l) {
        if (status_l.length == 0) {
            callback("No record in DB.", null);
        } else if (status_l.length == 1) {
            var date = timezone.formatDateUsingTimezone(new Date(status_l[0].timestamp), 'America/New_York');
            callback(null, {
                'date' : date.date,
                'time' : date.time,
                'sensors' : status_l[0].sensors
            });
        } else {
            callback("More than one records found.", null);
        }
    });
}

// id is a string, timestamp is a string, status is 0/1
exports.insertEvent = function(s_id, s_timestamp, s_status, callback) {
    var event = new Event({
        id : s_id,
        timestamp : timezone.getDateFromTimezone(s_timestamp, 'America/New_York'),
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
        var start = timezone.getDateFromTimezone(t_start, 'America/New_York');
        var end = timezone.getDateFromTimezone(t_end, 'America/New_York');
        if (s_id == null) {
            Event.find({
                timestamp : { $gte : start, $lte : end }
            }, callback);
        } else {
            Event.find({
                id : s_id,
                timestamp : { $gte : start, $lte : end }
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

// this.updateStatus('2017-3-24-11:40', {str:'hello'}, function(err, rs) {
//     console.log(err);
//     console.log(rs);
// });

// this.getStatus(function(err, rs) {
//     console.log(err);
//     console.log(rs);
// });
