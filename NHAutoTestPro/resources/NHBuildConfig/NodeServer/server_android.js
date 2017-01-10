var http = require('http');
var url = require('url');
var util = require('util');
var fs = require('fs');
//required install user-home
var usrHome = require('user-home');
var manifestPath = usrHome+'/Desktop/AndroidStudioProjects/ssms/AndroidManifest.xml';
//to run shell should install child_process
var exec = require('child_process').exec;
var cmd = 'cd $HOME/Desktop && touch test.plist'

var xmlRwiter = require('xml-writer');
var xml2js = require('xml2js');
var parser = new xml2js.Parser(),
		xmlBuilder = new xml2js.Builder();
var host = '0.0.0.0';
var port = 9527;
/*
//restful api
var express = require('express');
var app = express();//restful api
app.get('/upgradeCode', function(req, res) {
	res.writeHead(200, {'Content-Type': 'Text/plain'});
	//parser url
	var params = url.parse(req.url, true).query;
	console.log(params);
	var androidManifest = fs.readFileSync("AndroidManifest.xml", 'utf-8');
	var m = androidManifest.match(/android:versionCode="([0-9]+)"/);
	if (m) {
		var versionCode = parseInt(m[1], 10) + 1;
		var updatedAndroidManifest = androidManifest.replace(/(android:versionCode=")([0-9]+)(")/, '$1' + versionCode + '$3');
		fs.writeFileSync("AndroidManifest.xml", updatedAndroidManifest, 'utf-8');

		console.log('Updated versionCode to ' + versionCode);
	}
	res.write('hello, world!');
	res.end();
})
var server = app.listen(port, function(){
	var host = server.address().address
	var port = server.address().port
	console.log("应用实例，访问地址：http://%s:%s", host, port)
})
//*/
//*
var server = http.createServer(function(req, res) {

	//parser url
	var params = url.parse(req.url, true).query;
	var path = url.parse(req.url, true).pathname;
	console.log(path);
	//根据不同模块写入返回值
	//主页
	if (path == '/') {
		res.write(200, {"Content-Type": "text/html"});
		res.end("Welcome to the homepage!");
	} else if (path == '/upgradeCode') {
		res.writeHead(200, {'Content-Type': 'Text/plain'});
		var androidManifest = fs.readFileSync(manifestPath, 'utf-8');
		var m = androidManifest.match(/android:versionCode="([0-9]+)"/);
		if (m) {
			var versionCode = parseInt(m[1], 10) + 1;
			var updatedAndroidManifest = androidManifest.replace(/(android:versionCode=")([0-9]+)(")/, '$1' + versionCode + '$3');
			fs.writeFileSync(manifestPath, updatedAndroidManifest, 'utf-8');

			console.log('Updated versionCode to ' + versionCode);
		}
		res.end("upgrade version code successfully!");
	} else {
		res.writeHead(404, {'Content-Type': 'Text/plain'});
		res.end("404 error! file not found!");
	}

	//异步读取
	// fs.readFile('AndroidManifest.xml', function(err, data){
		
	// });

	// 同步读取
	//var data = fs.readFileSync('AndroidManifest.xml');
	
});
server.listen(port, host)
//*/
console.log('Server running at http://' + host + ':' + port + '/');