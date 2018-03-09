package;

import kha.Loader;
import kha.Sprite;

class Shot extends Sprite {
	public function new(x: Float, y: Float, speedx: Float) {
		super(Loader.the.getImage('shot'));
		this.x = x;
		this.y = y;
		this.speedx = speedx;
		accy = 0;
	}
}
