package;

import kha.Assets;
import kha2d.Sprite;

class Shot extends Sprite {
	public function new(x: Float, y: Float, speedx: Float) {
		super(Assets.images.shot);
		this.x = x;
		this.y = y;
		this.speedx = speedx;
		accy = 0;
	}
}
