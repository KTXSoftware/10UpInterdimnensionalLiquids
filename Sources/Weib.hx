package;

import dialogue.Action;
import kha.Animation;
import kha.Loader;
import kha.Sprite;

class Weib extends Sprite {
	public function new(x: Float, y: Float) {
		super(Loader.the.getImage('ZornigeFrau'), 2 * 30, 2 * 25); // TODO!!!
		setAnimation(new Animation([0,0,1,2,1,3,4,5,6,5,4,3,1,2,7,7,2],15));
		this.x = x - 16;
		this.y = y + 5;
		accy = 0;
	}
	
	var count = 0;
	override public function hit(sprite:Sprite):Void {
		if (Std.is(sprite, Broetchen)) {
			++count;
			kha.Scene.the.removeProjectile(sprite);
			if (count >= 2)  {
				Action.finishThrow = true;
				Dialogue.next();
			}
		}
	}
}
