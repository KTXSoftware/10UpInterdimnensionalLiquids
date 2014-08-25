package;

import kha.Loader;
import kha.Sprite;

class Weib extends Sprite {
	public function new(x: Float, y: Float) {
		super(Loader.the.getImage('mechanic'), 64, 64); // TODO!!!
		this.x = x - 32;
		this.y = y - 5;
		accy = 0;
	}
	
	override public function hit(sprite:Sprite):Void {
		if (sprite == Cfg.broetchen) {
			kha.Scene.the.removeProjectile(sprite);
			Dialogue.next();
		}
	}
}
