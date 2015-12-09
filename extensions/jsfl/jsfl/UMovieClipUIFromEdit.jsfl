var trace = function () {
	var str = '';
	for (var i = 0, l = arguments.length; i < l; i++) {
		str += arguments[i] + ' ';
	}
	fl.outputPanel.trace(str.substr(0, str.length - 1));
	str = null;
}
fl.outputPanel.clear();

var dom = fl.getDocumentDOM();
if (dom) {
	var lib = dom.library;
	
	var items = dom.selection;
	if (items.length) {
		var of = function (ie) {
			var b = ie.linkageBaseClass != "org.aisy.display.UMovieClipUI";
			var b2 = !ie.linkageClassName;
			//if (ie.scalingGrid != true) ie.scalingGrid = true;
			if (ie.linkageImportForRS == true) ie.linkageImportForRS = false;
			if (ie.linkageExportForAS != true) ie.linkageExportForAS = true;
			if (ie.linkageExportInFirstFrame != true) ie.linkageExportInFirstFrame = true;
			if (b) {
				ie.linkageBaseClass = "org.aisy.display.UMovieClipUI";
				if (b2) {
					ie.linkageClassName = "UM_" + (new Date()).getTime() + "_" + Math.random().toString().substr(2);
				}
			}
		};
		var item;
		for (var i = 0, l = items.length; i < l; i++) {
			item = items[i];
			if (item.elementType == "instance") {
				item = item.libraryItem;
				if (item.itemType == "movie clip") {
					of(item);
				}
				
			}
		}
	}
	
	lib.selectNone();
}

function stringif(value, inObj) {
	if (inObj === undefined) inObj = true;
	var jStr = '';
	var oLen = 0;
	var notify = function(name, value, isLast, formObj) {
		if (typeof(name) == 'string') name = name.replace(/([\\"\\'])/g, "\\\$1");
		if (formObj == true) {
			jStr += '"' + name + '":';
		}
		if (value && value.constructor == Array) {
			jStr += '[';
			for (var i = 0; i < value.length; i++) {
				notify(i, value[i], i == value.length - 1, false);
			}
			jStr += ']';
		}
		else if (value && typeof value == 'object') {
			if (inObj == true || oLen == 0) {
				oLen++;
				jStr += '{';
				for (var key in value) notify(key, value[key], false, true);
				jStr = jStr.substr(0, jStr.length - 1) + '}';
			}
			else {
				jStr += 'null';
			}
		}
		else {
			if(typeof value == 'string') value = '"' + value.replace(/([\\"\\'])/g, "\\\$1") + '"';
			jStr += value;
		}
		if (isLast == false) {
			jStr += ',';
		}
	};
	notify('', value, true, false);
	return jStr;
}