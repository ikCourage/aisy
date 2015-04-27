package org.aisy.queue
{
	import org.aisy.interfaces.IClear;

	/**
	 * 
	 * 队列
	 * 
	 * @author Viqu
	 * 
	 */
	public class Queue implements IClear
	{
		protected var _queue:Array;
		
		public function Queue()
		{
		}
		
		public function put(value:Object = null, delegate:Object = null, priority:int = 0):void
		{
			if (null === value) {
				if (null !== _queue) {
					if (_queue.length === 1) clear();
					else {
						_queue.reverse();
						_queue.length--;
						_queue.reverse();
						var arr:Array = _queue[0];
						value = arr[0];
						delegate = arr[1];
						arr = null;
					}
				}
			}
			else {
				if (null === _queue) _queue = [[value, delegate, priority]];
				else {
					var len:uint = _queue.length;
					_queue[len] = [value, delegate, priority];
					if (priority !== 0) quickSort(_queue, 0, len);
					value = null;
				}
			}
			if (null !== value) {
				if (delegate is Class) new (delegate as Class)(value);
				else delegate.apply(null, [value].slice(0, delegate.length));
			}
			value = null;
			delegate = null;
		}
		
		protected function quickSort(v:Array, left:uint, right:uint):void
		{
			var i:uint = left, j:uint = right, middle:int = v[(left + right) >> 1][2], t:Array;
			do {
				while (v[i][2] < middle && i < right) i++;
				while (v[j][2] > middle && j > left) j--;
				if (i <= j) {
					t = v[i];
					v[i] = v[j];
					v[j] = t;
					i++;
					if (j > 0) j--;
				}
			} while (i <= j);
			if (left < j) quickSort(v, left, j);
			if (right > i) quickSort(v, i, right);
			t = null;
			v = null;
		}
		
		public function clear():void
		{
			_queue = null;
		}
		
	}
}