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
	
	var items = lib.getSelectedItems();
	if (items.length) {
		var of = function (ie) {
			//if (ie.scalingGrid != true) ie.scalingGrid = true;
			if (ie.linkageImportForRS == true) ie.linkageImportForRS = false;
			if (ie.linkageExportForAS != true) ie.linkageExportForAS = true;
			if (ie.linkageExportInFirstFrame != true) ie.linkageExportInFirstFrame = true;
			if (ie.linkageBaseClass != "org.aisy.button.ButtonUI") {
				ie.linkageBaseClass = "org.aisy.button.ButtonUI";
				if (!ie.linkageClassName || ie.linkageClassName == ie.name.replace(/.*[\\\/](.+)$/, "$1").replace(/\s+/g, "") || !/^[\w\d\.\_]+$/ig.test(ie.linkageClassName)) {
					ie.linkageClassName = "B_" + (new Date()).getTime() + "_" + Math.random().toString().substr(2);
				}
			}
		};
		var e;
		for (var i = 0, j = 0, l = items.length; i < l; i++) {
			item = items[i];
			if (item.itemType == "movie clip" && null != item.timeline) {
				if (item.timeline.frameCount > 1) {
					if (!lib.itemExists(item.name + "_BUTTON")) {
						j = item.timeline.layerCount - 1;
						if (item.timeline.layers[j].frameCount && item.timeline.layers[j].frames[0].elements.length && item.timeline.layers[j].name != "hitArea") {
							e = item.timeline.layers[j].frames[0].elements[0];
							if (e.elementType == "instance" && e.libraryItem.itemType == "movie clip") {
								lib.editItem(item.name);
								item.timeline.setSelectedLayers(j);
								item.timeline.addNewLayer("hitArea", "normal", false);
								item.timeline.setSelectedLayers(++j);
								lib.addItemToDocument({"x": 0, "y": 0}, e.libraryItem.name);
								e = item.timeline.layers[j].frames[0].elements[0];
								e.x = e.y = 0;
								e.blendMode = 'alpha';
								e.name = "hitA";
								item.timeline.layers[j].locked = true;
								item.timeline.layers[j].visible = false;
							}
						}
						lib.addNewItem("movie clip", item.name + "_BUTTON");
						var item2 = lib.getSelectedItems()[0];
						lib.editItem();
						lib.addItemToDocument({"x": 0, "y": 0}, item.name);
						e = item2.timeline.layers[0].frames[0].elements[0];
						e.x = e.y = 0;
						of(item2);
					}
				}
				else {
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