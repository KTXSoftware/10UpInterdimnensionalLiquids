package;

import TenUp3.Mode;
import kha.Scene;

interface DialogueItem {
	public function execute() : Void;
	public var finished(default, null) : Bool;
}

@:access(TenUp3.mode)
class Dialogue {
	private static var items: Array<DialogueItem>;
	private static var index: Int = -1;
	public static var isActionActive(default,null): Bool = false;
	
	public static function set(items: Array<DialogueItem>): Void {
		Dialogue.items = items;
		index = -1;
		TenUp3.getInstance().mode = Mode.BlaBlaBla;
		kha.Sys.mouse.hide();
		next();
	}
	
	public static function insert(items: Array<DialogueItem>) {
		if (Dialogue.items == null) {
			set(items);
		} else if (index < 0) {
			for (item in items) {
				Dialogue.items.push(item);
			}
		} else {
			var newItems = new Array<DialogueItem>();
			newItems.push(Dialogue.items[index]);
			for (item in items) {
				newItems.push(item);
			}
			++index;
			while (index < Dialogue.items.length) {
				newItems.push(Dialogue.items[index]);
				++index;
			}
			index = 0;
			Dialogue.items = newItems;
		}
	}
	
	public static function update() : Void {
		if (index >= 0 && !items[index].finished) {
			items[index].execute();
		}
	}
	
	public static function next(): Void {
		if (index >= 0 && !items[index].finished) {
			items[index].execute();
			return;
		}
		
		++index;
		BlaBox.pointAt(null);
		BlaBox.setText(null);
		
		if (index >= items.length) {
			TenUp3.getInstance().mode = Mode.Game;
			kha.Sys.mouse.show();
			items = null;
			return;
		}
		
		items[index].execute();
	}
}
