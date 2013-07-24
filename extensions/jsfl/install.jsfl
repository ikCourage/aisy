var trace = function () {
	var str = '';
	for (var i = 0, l = arguments.length; i < l; i++) {
		str += arguments[i] + ' ';
	}
	fl.outputPanel.trace(str.substr(0, str.length - 1));
	str = null;
}
fl.outputPanel.clear();

var url = fl.scriptURI;
var path = url.replace(/[^\\\/]*$/, "") + "jsfl/";

if (FLfile.exists(path)) {
	var cmdPath = fl.configURI + "Commands/";
	if (path != cmdPath) {
		var arr = FLfile.listFolder(path + "*.jsfl", "files");
		if (arr.length) {
			for each (var i in arr) {
				if (url != cmdPath + i) {
					if (FLfile.exists(cmdPath + i)) {
						FLfile.remove(cmdPath + i);
					}
					trace("copy", i, FLfile.copy(path + i, cmdPath + i) ? "succeeded" : "failed");
				}
			}
			trace("OK");
		}
		else {
			trace("no jsfl");
		}
	}
}
else {
	trace("cannot find " + path);
}