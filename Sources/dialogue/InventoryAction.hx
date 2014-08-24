package dialogue;
import kha.Scene;
import kha.Sprite;

enum InventoryActionMode {
	ADD;
	PICKUP;
	DROP;
	REMOVE;
}

class InventoryAction implements Dialogue.DialogueItem
{
	var source: Sprite;
	var item: Sprite;
	var mode: InventoryActionMode;
	
	public function new(source: Sprite, item: Sprite, mode: InventoryActionMode) {
		this.source = source;
		this.item = item;
		this.mode = mode;
	}
	
	public var finished(default, null) : Bool = true;
	
	public function execute() : Void {
		switch (mode) {
			case ADD:
				Inventory.pick(item);
			case PICKUP:
				Scene.the.removeHero(item);
				Inventory.pick(item);
			case DROP:
				Scene.the.addHero(item);
				Inventory.loose(item);
				item.x = source.x + 0.5 * source.width;
				item.y = source.y;
			case REMOVE:
				Inventory.loose(item);
		}
	}
}