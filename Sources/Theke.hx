package;

import kha.Loader;
import kha.Sprite;

class Theke extends Sprite {
	public function new(x: Float, y: Float) {
		super(Loader.the.getImage('theke'));
		this.x = x;
		this.y = y;
	}
}