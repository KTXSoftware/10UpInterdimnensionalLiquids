package;

import kha.Loader;
import kha.Sprite;
import kha.Rectangle;

class Theke extends Sprite {
	public function new(x: Float, y: Float) {
		super(Loader.the.getImage('theke'));
		this.x = x;
		this.y = y;
		collider = new Rectangle( -20, -20, 64 * 2 + 40, 33 * 2 + 20);
	}
}