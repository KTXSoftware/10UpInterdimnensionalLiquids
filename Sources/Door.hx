package;

import kha.Animation;
import kha.Loader;
import kha.Sprite;

class Door extends Sprite {
	public function new(x: Float, y: Float) {
		super(Loader.the.getImage('door'), Std.int(128 * 2 / 4), 64 * 2, 0);
		this.x = x;
		this.y = y;
	}
	
	override public function hit(sprite: Sprite): Void {
		super.hit(sprite);
		setAnimation(Animation.create(1));
	}
}
