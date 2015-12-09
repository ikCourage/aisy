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
	
	if (dom.selection.length) {
		var rect = dom.getSelectionRect();
		dom.moveSelectionBy({"x": -round(rect.left), "y": -round(rect.top)});
		rect = dom.getSelectionRect();
		dom.moveSelectionBy({"x": round((rect.left - rect.right) * 0.5), "y": round((rect.top - rect.bottom) * 0.5)});
		dom.selectNone();
	}
}

function round(d) {
	if (d != parseInt(d)) {
		d = d.toString();
		var l = d.lastIndexOf(".") + 1;
		var a = parseInt(d.substr(l));
		d = parseFloat(d);
		if (a % 5 != 0) {
			a = a.toString();
			l = a.length;
			var b = 1;
			for (var i = 0; i < l; i++) {
				b *= 10;
			}
			a = Math.round(parseInt(a) * 0.1) * 10 / b;
			d = parseInt(d) + (d < 0 ? -a : a);
		}
	}
	return d;
}