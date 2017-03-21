var exec = require('cordova/exec');

exports.echo = function(arg0, success, error) {
  exec(success, error, 'NavitiaAccessCordova', 'echo', [arg0]);
};

exports.SearchSchedulesViewController = function(success, error) {
	exec(success, error, 'NavitiaAccessCordova', 'SearchSchedulesViewControllerWrapper', [])
};