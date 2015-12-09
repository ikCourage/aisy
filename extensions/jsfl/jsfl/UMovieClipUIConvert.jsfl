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
	
	var name = prompt("Type in the name");
	if (null != name) {
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
		var item = dom.convertToSymbol('movie clip', name, 'top left');
		if (null != item) {
			of(item);
		}
	}
}