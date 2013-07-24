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
	
	dom.selectAll();
	var arr = dom.selection;
	var l = arr.length;
	if (l) {
		var rect = dom.getSelectionRect();
		dom.moveSelectionBy({"x": -round(rect.left), "y": -round(rect.top)});
		dom.selectNone();
	}
}

function round(d) {
	d = d.toString();
	var i = d.lastIndexOf(".");
	if (i != -1) {
		var a = parseInt(d.substr(++i));
		if (a % 5 != 0) {
			a = a.toString();
			i = a.length;
			d = parseInt(d);
			var b = 1;
			for (var j = 0; j < i; j++) {
				b *= 10;
			}
			a = Math.round(parseInt(a) * 0.1) * 10 / b;
			d += d < 0 ? a : -a;
			return d;
		}
	}
	return parseFloat(d);
}