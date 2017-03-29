
var TokenGenerator = require( 'token-generator' )({
    salt: process.env.TOKEN_SALT,
    timestampMap: 'abcABC123#',
});

//var token = TokenGenerator.generate();

var isValid = function(token) {
    return TokenGenerator.isValid(token);
}

exports.validate = function(req) {
    return true;
    // if (req == null) return false;
    // else if (req.headers == null) return false;
    // else if (req.headers.token == null) return false;
    // else return isValid(req.headers.token);
}
