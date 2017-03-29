var moment = require('moment-timezone');

// timezonestr - e.g. America/New_York
exports.getDateFromTimezone = function(timestr, timezonestr) {
    var s = timestr.split('-');
    var year = s[0];
    var mon = s[1];
    if (mon.length == 1) mon = '0' + mon;
    var day = s[2];
    if (day.length == 1) day = '0' + day;
    var time = s[3];
    var hour = time.split(':')[0];
    if (hour.length == 1) hour = '0' + hour;
    var min = time.split(':')[1];
    if (min.length == 1) min = '0' + min;
    var date = year+'-'+mon+'-'+day+' '+hour+':'+min;
    //console.log(date);
    return new Date(moment.tz(date, timezonestr).format());
}

exports.formatDateUsingTimezone = function(date, timezonestr) {
    var l = moment.tz(date.toString(), timezonestr).format();
    var d = l.split('T')[0];
    var t = l.split('T')[1];

    return {
        'date' : d,
        'time' : t.split('-')[0]
    };
}
