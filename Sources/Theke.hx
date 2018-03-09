package;

import kha.Animation;
import kha.Loader;
import kha.Sprite;
import kha.Rectangle;

class Theke extends Sprite {
	public function new(x: Float, y: Float) {
		var i = Loader.the.getImage('theke');
		super(i, Std.int(i.width / 2));
		this.x = x - 0.3 * width;
		this.y = y;
		//collider = new Rectangle( -20, -20, 64 * 2 + 40, 33 * 2 + 20);
	}
	
	public function besetzt() {
		setAnimation(Animation.create(1));
	}
	public function frei() {
		setAnimation(Animation.create(0));
	}
}