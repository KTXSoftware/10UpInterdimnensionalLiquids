package;

import kha.Image;
import kha2d.Sprite;

class DestructibleSprite extends TimeTravelSprite {
	var maxHealth : Int;
	@:noCompletion var _health : Int;
	public var health(get, set) : Int;
	public var isStucture(default, null) : Bool = false;
	public var isRepairable(default, null) : Bool = false;
	
	public function new(maxHealth : Int, image:Image, width:Int=0, height:Int=0, z:Int=1) {
		super(image, width, height, z);
		_health = maxHealth;
		this.maxHealth = maxHealth;
	}
	
	/**
		Overwrite to hanlde health loss or destruction/dying.
	**/
	@:noCompletion private function set_health(value: Int) : Int {
		if (value > maxHealth) {
			value = maxHealth;
		}
		return _health = value;
	}
	@:noCompletion private inline function get_health() : Int {
		return _health;
	}
	
	override private function saveCustomFieldsForTimeLeap(storage: Map<String, Dynamic>): Void {
		super.saveCustomFieldsForTimeLeap(storage);
		
		storage.set("health", _health);
	}
	override private function restoreCustomFieldsFromTimeLeap(storage: Map<String, Dynamic>): Void {
		super.restoreCustomFieldsFromTimeLeap(storage);
		
		_health = storage["health"];
	}
}
