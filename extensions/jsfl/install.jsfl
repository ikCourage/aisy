var trace = function () {
	var str = '';
	for (var i = 0, l = arguments.length; i < l; i++) {
		str += arguments[i] + ' ';
	}
	fl.outputPanel.trace(str.substr(0, str.length - 1));
	str = null;
}
fl.outputPanel.clear();

var url = fl.scriptURI.replace(/[^\\\/]*$/, "");
var path = url + "jsfl/";
var path2;
var arr;

if (FLfile.exists(path)) {
	path2 = fl.configURI + "Commands/";
	if (path != path2) {
		arr = FLfile.listFolder(path + "*.jsfl", "files");
		if (arr.length) {
			for each (var i in arr) {
				if (url != path2 + i) {
					if (FLfile.exists(path2 + i)) {
						FLfile.remove(path2 + i);
					}
					trace("copy", i, FLfile.copy(path + i, path2 + i) ? "succeeded" : "failed");
				}
			}
			trace("jsfl OK");
		}
		else {
			trace("no jsfl");
		}
	}
}
else {
	trace("cannot find " + path);
}



path = url + "libs/";

if (FLfile.exists(path)) {
	path2 = fl.commonConfigURI + "ActionScript 3.0/libs/";
	if (path != path2) {
		arr = FLfile.listFolder(path + "*.swc", "files");
		if (arr.length) {
			for each (var i in arr) {
				if (url != path2 + i) {
					if (FLfile.exists(path2 + i)) {
						FLfile.remove(path2 + i);
					}
					trace("copy", i, FLfile.copy(path + i, path2 + i) ? "succeeded" : "failed");
				}
			}
			trace("swc OK");
		}
		else {
			trace("no swc");
		}
	}
}
else {
	trace("cannot find " + path);
}